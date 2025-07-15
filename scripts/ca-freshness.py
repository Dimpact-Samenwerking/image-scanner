#!/usr/bin/env python3
# ca-freshness.py: Check CA trust store age for discovered images

import yaml
import subprocess
import sys
import os
import argparse
from datetime import datetime, timedelta
from pathlib import Path
import json

# Emoji helpers
EMOJI_OK = "✅"
EMOJI_WARN = "⚠️"
EMOJI_FAIL = "❌"
EMOJI_CLOCK = "⏰"
EMOJI_DOCKER = "🐳"
EMOJI_CERT = "🔒"
EMOJI_CLEAN = "🧹"
EMOJI_HELM = "⛵"
EMOJI_SUM = "📊"

# CA trust store paths to check
CA_PATHS = [
    "/etc/ssl/certs/ca-certificates.crt",  # Debian/Ubuntu
    "/etc/ssl/cert.pem",                   # Alpine
]

SIX_MONTHS = 180  # days

# Helper: print with emoji and line length limit
def print_emoji(msg, emoji=EMOJI_OK):
    for line in msg.splitlines():
        print(f"{emoji} {line[:76]}")

def print_separator(image):
    sep = '=' * 10
    name = f" {image} "
    total_len = 76
    pad = total_len - len(name)
    left = pad // 2
    right = pad - left
    print(f"\n{sep}{'=' * left}{name}{'=' * right}{sep}\n")

def check_dependency(cmd):
    if subprocess.call(["which", cmd], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL) != 0:
        print_emoji(f"Dependency missing: {cmd}", EMOJI_FAIL)
        sys.exit(1)

def load_yaml(path):
    with open(path, "r") as f:
        return yaml.safe_load(f)

def get_images_and_charts(yaml_data):
    images = []
    for entry in yaml_data:
        url = entry.get("url")
        version = entry.get("version")
        charts = entry.get("charts", [])
        if url and version:
            images.append({
                "image": f"{url}:{version}",
                "charts": charts
            })
    return images

def docker_pull(image):
    print_emoji(f"Pulling image {image} (x86_64)", EMOJI_DOCKER)
    result = subprocess.run([
        "docker", "pull", "--platform", "linux/amd64", image
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print_emoji(f"Failed to pull {image}", EMOJI_FAIL)
        return False
    return True

def check_ca_file(image, ca_path):
    # Run a temp container to stat the CA file (force x86_64)
    cmd = [
        "docker", "run", "--rm", "--platform", "linux/amd64",
        "--entrypoint", "/bin/sh", image,
        "-c", f"stat -c '%Y %n' {ca_path} 2>/dev/null || stat -f '%m %N' {ca_path} 2>/dev/null"
    ]
    result = subprocess.run(cmd, stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, text=True)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    # Parse output: epoch_time path
    try:
        epoch_str = result.stdout.strip().split()[0]
        dt = datetime.fromtimestamp(int(epoch_str))
        return dt
    except Exception:
        return None

def get_ca_pem(image, ca_path):
    cmd = [
        "docker", "run", "--rm", "--platform", "linux/amd64",
        "--entrypoint", "/bin/sh", image,
        "-c", f"cat {ca_path} 2>/dev/null"
    ]
    result = subprocess.run(cmd, stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, text=True)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return result.stdout

def parse_pem_certs(pem_bundle, image):
    certs = []
    current_cert = []
    in_cert = False
    for line in pem_bundle.splitlines():
        if '-----BEGIN CERTIFICATE-----' in line:
            in_cert = True
            current_cert = [line]
        elif '-----END CERTIFICATE-----' in line and in_cert:
            current_cert.append(line)
            pem = '\n'.join(current_cert) + '\n'
            # Extract details using openssl
            subject, issuer, not_before, not_after = None, None, None, None
            try:
                cmd = [
                    "docker", "run", "--rm", "--platform", "linux/amd64",
                    "alpine/openssl:latest",
                    "openssl", "x509", "-noout", "-subject", "-issuer", "-dates"
                ]
                result = subprocess.run(cmd, input=pem, text=True,
                                       stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                if result.returncode == 0:
                    for l in result.stdout.splitlines():
                        if l.startswith('subject='):
                            subject = l[len('subject='):].strip()
                        elif l.startswith('issuer='):
                            issuer = l[len('issuer='):].strip()
                        elif l.startswith('notBefore='):
                            not_before = l[len('notBefore='):].strip()
                        elif l.startswith('notAfter='):
                            not_after = l[len('notAfter='):].strip()
            except Exception:
                pass
            certs.append({
                "pem": pem,
                "subject": subject,
                "issuer": issuer,
                "not_before": not_before,
                "not_after": not_after,
                "authority_name": (subject.split('CN=')[1].split(',')[0].strip() if subject and 'CN=' in subject else None)
            })
            in_cert = False
            current_cert = []
        elif in_cert:
            current_cert.append(line)
    return certs

def print_summary(summary):
    print(f"\n{'='*30} SCAN SUMMARY {'='*30}\n")
    def show_list(title, items, emoji):
        print_emoji(f"{title}: {len(items)}", emoji)
        for img in items:
            print(f"   - {img}")
        print()
    show_list("No CA certificates", summary['no_ca'], EMOJI_FAIL)
    show_list("Failed to pull image", summary['failed_pull'], EMOJI_WARN)
    show_list(
        "CA certs > 6 months old", summary['old_ca'], EMOJI_WARN
    )
    show_list(
        "CA certs <= 6 months old", summary['fresh_ca'], EMOJI_OK
    )
    print(f"{'='*76}\n")

def main():
    parser = argparse.ArgumentParser(
        description="Check CA trust store age for discovered images"
    )
    parser.add_argument(
        "--test-mode", action="store_true",
        help="Check only the first 3 images"
    )
    parser.add_argument(
        "--yaml", default="discovered.yaml",
        help="Path to discovered.yaml (default: discovered.yaml)"
    )
    parser.add_argument(
        "--json-out", default=None,
        help="Write detailed results to a JSON file"
    )
    args = parser.parse_args()

    # Check dependencies
    for dep in ["docker", "python3", "stat"]:
        check_dependency(dep)
    try:
        import yaml as _
    except ImportError:
        print_emoji("PyYAML not installed", EMOJI_FAIL)
        sys.exit(1)

    if not Path(args.yaml).exists():
        print_emoji(f"YAML file not found: {args.yaml}", EMOJI_FAIL)
        sys.exit(1)

    data = load_yaml(args.yaml)
    images = get_images_and_charts(data)
    if args.test_mode:
        images = images[:10]
        print_emoji("Test mode: Only checking first 10 images", EMOJI_WARN)

    # Summary counters
    summary = {
        'no_ca': [],
        'failed_pull': [],
        'old_ca': [],
        'fresh_ca': []
    }
    json_records = []

    total = len(images)
    for idx, entry in enumerate(images, 1):
        image = entry["image"]
        charts = entry["charts"]
        print_separator(image)
        print_emoji(f"Scanning image {idx}/{total} ...", EMOJI_CLOCK)
        print_emoji(f"Checking {image}", EMOJI_DOCKER)
        if charts:
            chart_list = ', '.join(charts)
            print_emoji(f"Used by Helm charts: {chart_list}", EMOJI_HELM)
        else:
            print_emoji("No Helm charts found for this image", EMOJI_HELM)
        record = {
            "image": image,
            "charts": charts,
            "ca_certs": [],
            "status": None
        }
        if not docker_pull(image):
            summary['failed_pull'].append(image)
            record["status"] = "failed_pull"
            json_records.append(record)
            print_separator(image)
            print()
            continue
        found = False
        for ca_path in CA_PATHS:
            dt = check_ca_file(image, ca_path)
            if dt:
                age_days = (datetime.now() - dt).days
                pem_bundle = get_ca_pem(image, ca_path)
                certs = []
                if pem_bundle:
                    certs = parse_pem_certs(pem_bundle, image)
                cert_info = {
                    "path": ca_path,
                    "modified": dt.isoformat(),
                    "age_days": age_days,
                    "certs": certs
                }
                record["ca_certs"].append(cert_info)
                if age_days < SIX_MONTHS:
                    status = f"CA cert found < 6 months old ({age_days} days)"
                    emoji = EMOJI_OK
                    summary['fresh_ca'].append(image)
                    record["status"] = "fresh_ca"
                else:
                    status = f"CA cert found > 6 months ({age_days} days)"
                    emoji = EMOJI_WARN
                    summary['old_ca'].append(image)
                    record["status"] = "old_ca"
                print_emoji(f"{EMOJI_CERT} {ca_path} {status}", emoji)
                found = True
                break
        if not found:
            print_emoji("no CA certs found", EMOJI_FAIL)
            summary['no_ca'].append(image)
            record["status"] = "no_ca"
        json_records.append(record)
        print_separator(image)
        print()
    print_emoji("All done!", EMOJI_CLEAN)
    print_summary(summary)
    if args.json_out:
        print_emoji(f"About to write JSON output to {args.json_out}", EMOJI_SUM)
        try:
            with open(args.json_out, "w") as jf:
                json.dump(json_records, jf, indent=2)
            print_emoji(f"Wrote JSON output to {args.json_out}", EMOJI_SUM)
        except Exception as e:
            print_emoji(f"Failed to write JSON: {e}", EMOJI_FAIL)

if __name__ == "__main__":
    main() 
