# Cross-Platform Compatibility Guide

This document outlines the changes made to ensure the image scanner codebase runs seamlessly on both Ubuntu Linux and macOS Sequoia.

## Changes Made

### 1. Fixed Shell Script Shebangs
- **Fixed**: `scripts/extract_helm_images.sh` now uses `#!/usr/bin/env bash` instead of `#!/bin/bash`
- **Reason**: The portable shebang `#!/usr/bin/env bash` works on both systems, while `#!/bin/bash` assumes bash is at `/bin/bash` (which isn't true on all macOS systems with Homebrew bash)

### 2. Cross-Platform Disk Space Detection
- **Fixed**: Replaced Linux-specific `df -BG` command with portable `df -h` parsing
- **Impact**: The `check_disk_space()` function now works consistently on both platforms
- **Location**: `scripts/dimpact-image-scanner.sh`

### 3. Enhanced Memory and CPU Detection
- **Already Compatible**: The existing code properly detects system resources using:
  - Linux: `nproc` and `free -g`
  - macOS: `sysctl -n hw.ncpu` and `sysctl -n hw.memsize`
  - Fallbacks for both platforms

### 4. File Path Resolution
- **Already Compatible**: The `get_absolute_path()` function uses multiple fallbacks:
  - `realpath` (Linux)
  - Python's `os.path.abspath()` (cross-platform)
  - Perl's `abs_path` (cross-platform)
  - Basic `cd && pwd` fallback

## Platform-Specific Features Supported

### Ubuntu Linux
- Package management: `apt-get`
- System tools: `nproc`, `free`, `realpath`
- Docker: `docker.io` package

### macOS Sequoia
- Package management: Homebrew (`brew`)
- System tools: `sysctl`, BSD versions of standard tools
- Docker: Docker Desktop application

## Docker Containerization

The project uses Docker to provide consistent behavior across platforms:

- **Base Image**: Ubuntu 22.04 (consistent environment regardless of host OS)
- **Container Tools**: All scanning tools (Trivy, Grype, Syft) run in containers
- **Volume Mounts**: Host paths are properly mounted for cross-platform access

## Installation Instructions

### Dependencies Required on Host

Both platforms need:
- Docker (Docker Desktop on macOS, docker.io on Ubuntu)
- Bash 4.0+ (upgrade on macOS: `brew install bash`)
- Basic command-line tools (grep, sed, awk, curl)

### Optional Host Tools
These are helpful but not required since containerized versions are used:
- `jq` for JSON processing
- `yq` for YAML processing
- `helm` for Helm chart operations

## Testing Cross-Platform Compatibility

### Quick Compatibility Test
```bash
# Test on both platforms
./scripts/dimpact-image-scanner.sh --testmode --debug
```

### Platform-Specific Commands Verified
- ✅ `df -h` (disk space) - works on both
- ✅ `mktemp` (temporary files) - works on both
- ✅ `date -u` and `date +%s` - compatible formats
- ✅ `awk`, `sed`, `grep` - using POSIX-compatible patterns
- ✅ Docker socket paths - handled by Docker Desktop

## Troubleshooting

### macOS Specific Issues
1. **Old Bash Version**: Upgrade with `brew install bash`
2. **Missing Command Tools**: Install Xcode Command Line Tools
3. **Docker Not Running**: Start Docker Desktop application

### Ubuntu Specific Issues
1. **Docker Permissions**: Add user to docker group: `sudo usermod -aG docker $USER`
2. **Missing Packages**: Install with `sudo apt-get install docker.io curl jq`
3. **Snap Issues**: Some tools might need snap: `sudo snap install helm --classic`

## Architecture Notes

The codebase follows these cross-platform best practices:

1. **Containerized Execution**: All heavy processing happens in containers
2. **Portable Shell Scripts**: Use `#!/usr/bin/env bash` and POSIX-compatible commands
3. **Graceful Fallbacks**: Multiple detection methods for system resources
4. **Platform Detection**: Automatic detection and appropriate messaging
5. **Error Handling**: Robust error handling that works across platforms

## Future Considerations

- All new shell scripts should use `#!/usr/bin/env bash`
- Always test new functionality on both platforms
- Use containerized tools when possible to maintain consistency
- Provide clear installation instructions for both platforms 
