FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    jq \
    yq \
    git \
    docker.io \
    unzip \
    figlet \
    ansible \
    python3 \
    python3-pip \
    perl \
    skopeo \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

WORKDIR /workspace

# Create directories for results and cache
RUN mkdir -p /workspace/results /root/.cache/trivy /root/.cache/grype

# Set environment variables
ENV TRIVY_VERSION=aquasec/trivy:latest
ENV GRYPE_VERSION=anchore/grype:latest
ENV SYFT_VERSION=anchore/syft:latest
ENV YQ_VERSION=mikefarah/yq:latest
ENV PERFORMANCE_MODE=max
ENV SEVERITY_THRESHOLD=MEDIUM
ENV OUTPUT_DIR=/workspace/results

# Default command (can be overridden by docker-compose)
CMD ["/workspace/dimpact-image-scanner.sh"] 
