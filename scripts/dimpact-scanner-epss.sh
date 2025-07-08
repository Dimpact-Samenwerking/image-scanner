#!/usr/bin/env bash

# EPSS and SARIF enrichment functions for Dimpact image scanner

download_epss_data() {
    local epss_cache_dir="$HOME/.cache/dimpact-epss"
    local today_date=$(date +%Y-%m-%d)
    local epss_url="https://epss.empiricalsecurity.com/epss_scores-$today_date.csv.gz"
    local epss_file="$epss_cache_dir/epss_scores-$today_date.csv"
    mkdir -p "$epss_cache_dir"
    if [ -f "$epss_file" ]; then
        print_status "📁 Using cached EPSS data: $epss_file"
        return 0
    fi
    print_status "📥 Downloading EPSS master file for $today_date..."
    if command_exists curl; then
        if curl -s -f -L -o "$epss_cache_dir/epss_scores-$today_date.csv.gz" "$epss_url"; then
            if command_exists gunzip; then
                gunzip "$epss_cache_dir/epss_scores-$today_date.csv.gz"
                print_status "✅ Downloaded and extracted EPSS data: $(wc -l < "$epss_file") entries"
                return 0
            else
                print_error "gunzip not available for decompression"
                return 1
            fi
        else
            print_warning "⚠️ Failed to download today's EPSS file, trying yesterday's..."
            local yesterday_date=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d 2>/dev/null)
            local epss_url_yesterday="https://epss.empiricalsecurity.com/epss_scores-$yesterday_date.csv.gz"
            local epss_file_yesterday="$epss_cache_dir/epss_scores-$yesterday_date.csv"
            if [ ! -f "$epss_file_yesterday" ]; then
                if curl -s -f -L -o "$epss_cache_dir/epss_scores-$yesterday_date.csv.gz" "$epss_url_yesterday"; then
                    gunzip "$epss_cache_dir/epss_scores-$yesterday_date.csv.gz"
                    print_status "✅ Downloaded yesterday's EPSS data: $(wc -l < "$epss_file_yesterday") entries"
                    ln -sf "$epss_file_yesterday" "$epss_file"
                    return 0
                fi
            else
                print_status "📁 Using yesterday's cached EPSS data"
                ln -sf "$epss_file_yesterday" "$epss_file"
                return 0
            fi
        fi
    fi
    print_error "❌ Failed to download EPSS data"
    return 1
}

lookup_epss_score() {
    local cve_id="$1"
    local epss_cache_dir="$HOME/.cache/dimpact-epss"
    local today_date=$(date +%Y-%m-%d)
    local epss_file="$epss_cache_dir/epss_scores-$today_date.csv"
    if [ ! -f "$epss_file" ]; then
        echo "0.00001,0.00000"
        return 1
    fi
    local result=$(grep "^$cve_id," "$epss_file" 2>/dev/null | cut -d',' -f2,3)
    if [ -n "$result" ]; then
        echo "$result"
        return 0
    else
        echo "0.00001,0.00000"
        return 1
    fi
}

fetch_epss_scores() {
    local sarif_file="$1"
    local image_dir="$(dirname "$sarif_file")"
    local epss_output_file="$image_dir/epss-scores.json"
    if ! download_epss_data; then
        print_error "❌ Failed to obtain EPSS data, skipping EPSS enrichment"
        return 1
    fi
    print_status "🔍 Extracting CVE IDs from SARIF file..."
    local cve_list=$(jq -r '[.runs[]?.results[]? | .ruleId] | unique | .[]' "$sarif_file" 2>/dev/null | grep -E '^CVE-[0-9]{4}-[0-9]+$' | sort -u)
    if [ -z "$cve_list" ]; then
        print_warning "⚠️ No CVE IDs found in SARIF file"
        echo "[]" > "$epss_output_file"
        return 1
    fi
    local total_cves=$(echo "$cve_list" | wc -l)
    print_status "📋 Found $total_cves unique CVE IDs"
    local processed=0
    local found_scores=0
    local epss_data="["
    local first_entry=true
    print_status "🔍 Looking up EPSS scores locally..."
    while IFS= read -r cve_id; do
        if [ -n "$cve_id" ]; then
            processed=$((processed + 1))
            if [ $((processed % 100)) -eq 0 ]; then
                print_status "📈 Processed $processed/$total_cves CVEs..."
            fi
            local epss_result=$(lookup_epss_score "$cve_id")
            local epss_score=$(echo "$epss_result" | cut -d',' -f1)
            local epss_percentile=$(echo "$epss_result" | cut -d',' -f2)
            if [ "$epss_score" != "0.00001" ]; then
                found_scores=$((found_scores + 1))
            fi
            if [ "$first_entry" = true ]; then
                first_entry=false
            else
                epss_data="$epss_data,"
            fi
            # Properly quote keys and string values for valid JSON
            epss_data="$epss_data$(printf '{\"cve\":\"%s\",\"epss\":%s,\"percentile\":%s}' "$cve_id" "$epss_score" "$epss_percentile")"
        fi
    done <<< "$cve_list"
    epss_data="$epss_data]"
    echo "$epss_data" > "$epss_output_file"
    print_status "📈 Successfully retrieved EPSS scores for $found_scores/$total_cves CVE(s)"
    find "$HOME/.cache/dimpact-epss" -name "epss_scores-*.csv" -mtime +7 -delete 2>/dev/null || true
    return 0
}

enhance_sarif_with_epss() {
    local sarif_file="$1"
    local image_dir="$(dirname "$sarif_file")"
    local epss_output_file="$image_dir/epss-scores.json"
    if [ ! -f "$sarif_file" ] || [ ! -s "$sarif_file" ]; then
        print_warning "SARIF file not found or empty: $sarif_file"
        return 1
    fi
    if [ ! -f "$epss_output_file" ] || [ ! -s "$epss_output_file" ]; then
        print_warning "EPSS scores file not found or empty: $epss_output_file"
        return 1
    fi
    if ! command_exists jq; then
        print_warning "jq not available - cannot enhance SARIF with EPSS data"
        return 1
    fi
    print_status "🔧 Enhancing SARIF with EPSS exploitability scores..."
    cp "$sarif_file" "${sarif_file}.backup"
    local epss_data=$(cat "$epss_output_file")
    local high_epss_count=$(echo "$epss_data" | jq '[.[] | select((.epss | tonumber) > 0.05)] | length' 2>/dev/null || echo "0")
    local medium_epss_count=$(echo "$epss_data" | jq '[.[] | select((.epss | tonumber) > 0.01 and (.epss | tonumber) <= 0.05)] | length' 2>/dev/null || echo "0")
    local low_epss_count=$(echo "$epss_data" | jq '[.[] | select((.epss | tonumber) <= 0.01)] | length' 2>/dev/null || echo "0")
    local very_high_epss_count=$(echo "$epss_data" | jq '[.[] | select((.epss | tonumber) > 0.5)] | length' 2>/dev/null || echo "0")
    print_status "📊 EPSS Score Analysis:"
    print_status "    • High exploitability (>5%): $high_epss_count CVE(s)"
    print_status "    • Very high exploitability (>50%): $very_high_epss_count CVE(s)"
    if [ "$very_high_epss_count" -gt 0 ]; then
        print_warning "    ⚠️ Found $very_high_epss_count CVE(s) with very high exploit probability!"
    fi
    local enhancement_timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local temp_sarif="${sarif_file}.temp"
    jq --argjson epss_data "$epss_data" \
       --arg high_epss_count "$high_epss_count" \
       --arg medium_epss_count "$medium_epss_count" \
       --arg low_epss_count "$low_epss_count" \
       --arg very_high_epss_count "$very_high_epss_count" \
       --arg enhancement_timestamp "$enhancement_timestamp" \
       '.runs[0].properties += {
         "epssScores": $epss_data,
         "epssHighRiskCount": ($high_epss_count | tonumber),
         "epssMediumRiskCount": ($medium_epss_count | tonumber),
         "epssLowRiskCount": ($low_epss_count | tonumber),
         "epssVeryHighRiskCount": ($very_high_epss_count | tonumber),
         "epssEnhanced": true,
         "epssEnhancementDate": $enhancement_timestamp,
         "epssMetadataVersion": "1.0"
       }' "$sarif_file" > "$temp_sarif" 2>"${sarif_file}.jq_error.log"
    if [ $? -eq 0 ] && [ -s "$temp_sarif" ]; then
        if jq empty "$temp_sarif" 2>/dev/null; then
            mv "$temp_sarif" "$sarif_file"
            print_status "✅ Enhanced SARIF with EPSS exploitability scores"
        else
            print_warning "Enhanced SARIF file is invalid JSON - reverting to original"
            rm -f "$temp_sarif"
            return 1
        fi
    else
        print_warning "Failed to enhance SARIF with EPSS data"
        if [ -f "${sarif_file}.jq_error.log" ]; then
            print_warning "jq error output:\n$(cat "${sarif_file}.jq_error.log")"
        fi
        rm -f "$temp_sarif"
        return 1
    fi
    rm -f "${sarif_file}.backup" "${sarif_file}.jq_error.log"
} 
