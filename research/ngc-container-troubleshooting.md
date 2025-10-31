# NVIDIA NGC Container Troubleshooting Guide

**Version**: 1.0
**Date:** 2025-10-08
**Status**: Common Issues and Solutions

---

## Executive Summary

This document addresses the NVIDIA NGC CLI installation and usage issues that have been encountered, specifically the "Incomplete command received" error when running `ngc` commands. This guide provides step-by-step solutions to resolve the issue and ensure successful container operations.

---

## 1. NGC CLI Installation Issue

### **Current Issue**

```bash
~/workspace/cipher % ngc
ERROR: Incomplete command received
usage: ngc [--ace <name>] [--debug] [--format_type <fmt>] [--org <name>] [--team <name>] [--version] [-h]
           {audit,cloud-function,config,diag,org,pym,registry,team,user,version}
```

### **Root Cause Analysis**

The issue indicates that the NVIDIA NGC CLI is not properly installed or not in the system PATH. The error occurs because the system cannot find the `ngc` command.

---

## 2. Solution Guide

### **Step 1: Install NVIDIA NGC CLI**

#### **Option A: Using Pip (Recommended)**

```bash
# Install NVIDIA NGC CLI using pip
pip install nvidia-ngc-cli

# Verify installation
ngc version

# Expected output should show version information
```

#### **Option B: Using Docker (Alternative)**

```bash
# Pull the NGC CLI container
docker pull nvcr.io/nvidia/ngc-cli:latest

# Run NGC commands using Docker
docker run --rm -it --rm nvcr.io/nvidia/ngc-cli ngc version

# Create an alias for convenience
alias ngc='docker run --rm -it --rm nvcr.io/nvidia/ngc-cli ngc'

# Test the alias
ngc version
```

#### **Option C: Using Direct Download**

```bash
# Download the NGC CLI binary for Linux
curl -O https://developer.download.nvidia.com/compute/machine-learning/ngc/cli/linux-x86_64/ngc-cli-3.28.0-linux-x86_64.zip

# Extract the binary
unzip ngc-cli-3.28.0-linux-x86_64.zip

# Install the binary
sudo chmod +x ngc
sudo mv ngc /usr/local/bin/

# Verify installation
ngc version

# Add to PATH if needed
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
```

### **Step 2: Configure NGC Authentication**

#### **Login to NVIDIA NGC**

```bash
# Login to NVIDIA NGC registry
ngc login

# Follow the prompts to enter your NVIDIA Developer Program credentials
# You will need:
# - Username (email address)
# - API key
# - Organization (if applicable)
# - Team (if applicable)

# Expected output
# Login succeeded. You're now ready to pull NGC containers.
```

#### **Verify Authentication**

```bash
# Verify authentication
ngc config get account

# Test access to containers
ngc registry --list

# Expected output should show list of available registries
```

### **Step 3: Test Container Access**

#### **Pull the Target Container**

```bash
# Pull the TensorRT container
ngc registry image list nvcr.io/nvidia/tensorrt

# Search for the specific tag
ngc registry image search nvcr.io/nvidia/tensorrt | grep 25.03.06-py3

# Pull the specific container
ngc registry image pull nvcr.io/nvidia/tensorrt:25.03.06-py3

# Verify the container
docker images | grep tensorrt
```

#### **Test Container Functionality**

```bash
# Test container with GPU support
docker run --rm --gpus all nvcr.io/nvidia/tensorrt:25.03.06-py3 bash -c "
import torch
import tensorrt as trt
import sys
print(f'✅ PyTorch version: {torch.__version__}')
print(f'✅ TensorRT version: {trt.__version__}')
print(f'✅ CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'✅ CUDA version: {torch.version.cuda}')
    print(f'✅ GPU count: {torch.cuda.device_count()}')
else:
    print('⚠️  CUDA not available')
print('🚀 Container verification successful!')
"
```

---

## 3. Alternative Installation Methods

### **For Different Operating Systems**

#### **macOS**

```bash
# Install using Homebrew
brew install ngc

# Or using pip
pip install nvidia-ngc-cli

# Note: macOS containers will need to use different approach
# Consider using Docker with GPU support
```

#### **Windows**

```bash
# Install using Chocolatey
choco install nvidia-ngc-cli

# Or using pip
pip install nvidia-ngc-cli

# Note: Windows containers will need Docker Desktop with WSL2
```

#### **Linux (Various Distributions)**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt-get install -y python3-pip
pip install nvidia-ngc-cli

# CentOS/RHEL/Fedora
sudo dnf install python3-pip
pip install nvidia-ngc-cli

# Arch Linux
sudo pacman -S python-pip
pip install nvidia-ngc-cli
```

---

## 4. Common Issues and Solutions

### **Issue: Permission Denied**

```bash
# Error: permission denied when running ngc

# Solution: Fix Docker group membership
sudo usermod -aG docker $USER
newgrp docker

# Or use sudo for NGC commands (not recommended)
sudo ngc version
```

### **Issue: API Key Not Working**

```bash
# Error: Authentication failed

# Solution: Verify API key
ngc config get account

# If needed, regenerate API key
# Visit: https://ngc.nvidia.com/
```

### **Issue: Container Pull Fails**

```bash
# Error: Image not found or pull failed

# Solution: Check container availability
ngc registry image list nvcr.io/nvidia/tensorrt

# Check specific tag
ngc registry image search nvcr.io/nvidia/tensorrt --tag 25.03.06

# If tag not found, use closest available tag
ngc registry image list nvcr.io/nvidia/tensorrt
```

### **Issue: Container Runtime Error**

```bash
# Error: Container won't start with GPU

# Solution: Check NVIDIA Docker setup
docker run --rm --gpus all nvcr.io/nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi

# If NVIDIA Docker not working
# Install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

---

## 5. Verification Script

### **Comprehensive Verification Script**

```bash
#!/bin/bash
# scripts/verify_ngc_setup.sh

echo "=== NVIDIA NGC Setup Verification ==="

# Check NGC CLI installation
echo "1. Checking NGC CLI installation..."
if command -v ngc &> /dev/null; then
    echo "✅ NGC CLI found"
    ngc version
else
    echo "❌ NGC CLI not found"
    echo "Please install NGC CLI using one of the following methods:"
    echo "  - pip install nvidia-ngc-cli"
    echo "  - brew install ngc"
    echo "  - Download from NVIDIA website"
    exit 1
fi

# Check authentication
echo "2. Checking NGC authentication..."
if ngc config get account &> /dev/null; then
    echo "✅ NGC authentication working"
    echo "Account information available"
else
    echo "❌ NGC authentication not working"
    echo "Please run: ngc login"
    exit 1
fi

# Check container access
echo "3. Checking container access..."
if docker images | grep -q "nvcr.io/nvidia/tensorrt:25.03.06-py3"; then
    echo "✅ Target container found: nvcr.io/nvidia/tensorrt:25.03.06-py3"
else
    echo "⚠️  Target container not found locally"
    echo "Pulling container..."
    if ngc registry image pull nvcr.io/nvidia/tensorrt:25.03.06-py3; then
        echo "✅ Container pulled successfully"
    else
        echo "❌ Container pull failed"
        echo "Please check internet connection and authentication"
        exit 1
    fi
fi

# Test container functionality
echo "4. Testing container functionality..."
if docker run --rm --gpus all nvcr.io/nvidia/tensorrt:25.03.06-py3 bash -c "
import torch
import tensorrt as trt
import numpy as np
import sys
print(f'✅ PyTorch version: {torch.__version__}')
print(f'✅ TensorRT version: {trt.__version__}')
print(f'✅ CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'✅ CUDA version: {torch.version.cuda}')
    print(f'✅ GPU count: {torch.cuda.device_count()}')
else
    print('⚠️  CUDA not available - container may not have GPU access')
print('🚀 Container functionality verified')
" > /dev/null 2>&1; then
    echo "✅ Container functionality verified"
else
    echo "⚠️  Container functionality has issues"
    echo "This may be due to:
    - No GPU access
    - CUDA driver issues
    - Container configuration problems"
fi

echo "=== Verification Complete ==="
echo ""
echo "If all checks passed, you're ready for Epic 0 development!"
echo ""
echo "Next steps:"
echo "1. Update Epic 0 Dockerfile to use the container"
echo "2. Test OpenVLA model loading"
echo "3. Begin TensorRT optimization development"
```

### **Docker Health Check**

```bash
#!/bin/bash
# scripts/docker_health_check.sh

echo "=== Docker Health Check ==="

# Check Docker daemon
if ! systemctl is-active --quiet docker; then
    echo "❌ Docker daemon not running"
    echo "Starting Docker..."
    sudo systemctl start docker
    sleep 5
fi

if systemctl is-active --quiet docker; then
    echo "✅ Docker daemon running"
else
    echo "❌ Docker daemon failed to start"
    echo "Please check Docker installation"
    exit 1
fi

# Check NVIDIA Docker Toolkit
if ! docker run --rm --gpus all nvcr.io/nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi > /dev/null 2>&1; then
    echo "❌ NVIDIA Docker Toolkit not working"
    echo "Please install NVIDIA Docker Toolkit"
    echo "Visit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html"
    exit 1
else
    echo "✅ NVIDIA Docker Toolkit working"
fi

# Check Docker version
docker_version=$(docker --version --format '{{.Server.Version}}')
echo "✅ Docker version: $docker_version"

echo "=== Docker Health Check Complete ==="
```

---

## 6. Container Pull Verification

### **Container Pull Test Script**

```bash
#!/bin/bash
# scripts/pull_and_verify_container.sh

echo "=== Container Pull and Verification ==="

CONTAINER="nvcr.io/nvidia/tensorrt:25.03.06-py3"
echo "Target container: $CONTAINER"

# Check if container already exists
if docker images | grep -q "$CONTAINER"; then
    echo "✅ Container already exists locally"
    echo "Skipping pull (use --force to pull anyway)"
else
    echo "Pulling container..."
    if ngc registry image pull "$CONTAINER"; then
        echo "✅ Container pulled successfully"
    else
        echo "❌ Container pull failed"
        exit 1
    fi
fi

# Verify container can run
echo "Testing container functionality..."
if docker run --rm --gpus all "$CONTAINER" bash -c "
import torch
import tensorrt as trt
import sys
print('Testing container functionality...')

# Test PyTorch
try:
    print(f'✅ PyTorch version: {torch.__version__}')
except Exception as e:
    print(f'❌ PyTorch import failed: {e}')
    sys.exit(1)

# Test TensorRT
try:
    print(f'✅ TensorRT version: {trt.__version__}')
except Exception as e:
    print(f'❌ TensorRT import failed: {e}')
    sys.exit(1)

# Test CUDA
try:
    if torch.cuda.is_available():
        print(f'✅ CUDA version: {torch.version.cuda}')
        print(f'✅ GPU count: {torch.cuda.device_count()}')
        print('✅ GPU functionality available')
    else:
        print('⚠️  CUDA not available - this may be expected if no GPU is accessible to Docker')
except Exception as e:
    print(f'❌ CUDA check failed: {e}')

print('✅ Container verification completed successfully!')
" > /dev/null 2>&1; then
    echo "✅ Container verified successfully"
else
    echo "❌ Container verification failed"
    echo "Check container logs for more details"
    docker run --rm "$CONTAINER" bash -c "echo 'Container debug info:' && python -c 'import sys; print(sys.version)' && env | grep -E 'CUDA|NVIDIA'"
    exit 1
fi

echo "=== Container Pull and Verification Complete ==="
```

---

## 7. Troubleshooting Checklist

### **Installation Checklist**

- [ ] NGC CLI installed and in PATH
- [ ] NVIDIA NGC login successful
- [ ] Docker installed and running
- [ ] NVIDIA Docker Toolkit working
- [ ] Container pulled successfully
- [ ] Container functionality verified

### **Environment Checklist**

- [ ] GPU access available (nvidia-smi works)
- [ ] CUDA version matches requirements (12.1+)
- [ ] TensorRT version matches requirements (8.x)
- [ ] Python 3.10 available in container
- [ ] OpenVLA dependencies installable

### **Development Environment Checklist**

- [ ] Docker Compose configured
- [ ] Volume mounts working
- [ ] Network connectivity established
- [ ] Git repository accessible
- [ ] Scripts and tools executable

---

## 8. Contact Support

### **Getting Help**

If you continue to experience issues:

1. **NVIDIA NGC Support**:
   - Visit: https://ngc.nvidia.com/support
   - Documentation: https://ngc.nvidia.com/docs/

2. **Docker Support**:
   - Documentation: https://docs.docker.com/
   - Community Forums: https://forums.docker.com/

3. **NVIDIA Developer Forums**:
   - NVIDIA NGC forum: https://developer.nvidia.com/ngc/
   - Container forums: https://developer.nvidia.com/container/

4. **Team Support**:
   - Share error messages and logs
   - Document troubleshooting steps taken
   - Request help in team Slack channel

---

## 9. Success Criteria

### **Installation Success Indicators**

- ✅ `ngc version` command works
- ✅ `ngc login` completes successfully
- ✅ Container pulls without errors
- ✅ Container runs with GPU support
- ✅ All verification scripts pass

### **Readiness for Epic 0**

- ✅ Container successfully pulls (25.03.06-py3)
- ✅ Container validates with H100 GPUs
- ✅ OpenVLA dependencies install correctly
- ✅ Team can access container consistently

---

## 10. Next Steps

### **Immediate Actions**

1. **Follow installation guide** that resolves the "Incomplete command" error
2. **Run verification scripts** to ensure proper setup
3. **Update Epic 0 Dockerfile** to use the verified container
4. **Test with sample workload** to ensure functionality

### **Integration with Epic 0**

1. **Update Story 2** (Dev Container) with verified container
2. **Update Story 3** (CI/CD Pipeline) with NVIDIA best practices
3. **Begin OpenVLA development** with validated environment
4. **Start TensorRT optimization** with confidence

This troubleshooting guide should resolve the immediate NGC CLI issue and ensure a smooth path to successful Epic 0 implementation.
