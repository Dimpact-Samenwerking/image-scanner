FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install yq from official source
RUN curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create app directory
WORKDIR /app

# Copy scanner script
COPY scripts/dimpact-image-scanner.sh /app/
RUN chmod +x /app/dimpact-image-scanner.sh

# Create directories for results and cache
RUN mkdir -p /app/results /root/.cache/trivy /root/.cache/grype

# Set environment variables
ENV TRIVY_VERSION=aquasec/trivy:latest
ENV GRYPE_VERSION=anchore/grype:latest
ENV SYFT_VERSION=anchore/syft:latest
ENV YQ_VERSION=mikefarah/yq:latest
ENV PERFORMANCE_MODE=max
ENV SEVERITY_THRESHOLD=MEDIUM
ENV OUTPUT_DIR=/app/results

# Default command (can be overridden by docker-compose)
CMD ["/app/dimpact-image-scanner.sh"] 
