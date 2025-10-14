# NGC Container 25.03.06-py3 Implementation Guide

**Version**: 1.0
**Date:** 2025-10-08
**Status**: Ready for Implementation

---

## Executive Summary

This document provides a comprehensive implementation guide for the NVIDIA NGC container tag `25.03.06-py3`, which will serve as the primary base container for Epic 0. The container includes TensorRT 8.x, CUDA 12.1, and Python 3.10, providing the ideal foundation for OpenVLA optimization development.

---

## 1. Container Information

### **Container Details**

```yaml
container_specifications:
  name: "nvidia/tensorrt:25.03.06-py3"
  repository: "nvcr.io/nvidia/tensorrt"
  tag: "25.03.06-py3"
  release: "March 2025"
  python_version: "3.10"
  cuda_version: "12.1"
  cudnn_version: "8.9"
  tensorrt_version: "8.6.x"
  release_type: "Production Release (PB 25h1)"
  support_lifecycle: "9 months API stability"

  key_features:
    - "TensorRT 8.x with API stability guarantee"
    - "CUDA 12.1 with cuDNN 8.9"
    - "Python 3.10 runtime"
    "Monthly security patches"
    "Enterprise-grade support"
```

### **Package Contents**

```yaml
included_packages:
  deep_learning_frameworks:
    - "PyTorch 2.0+"
    "TensorFlow 2.10+"
    "JAX 0.4+"

  cuda_libraries:
    - "CUDA Toolkit 12.1"
    "cuDNN 8.9"
    "cuBLASLt 1.1"
    "cuRAND 10.2"
    "cuSOLVER 11.6"
    "cuFFT 11.0"

  tensorrt_components:
    - "TensorRT 8.6.x"
    "TensorRT-LLM"
    "TensorRT plugins"
    "ONNX support"

  development_tools:
    - "NVIDIA Nsight Systems"
    "NVIDIA Nsight Compute"
    "cuBLASLt profiler"
    "GPU debugging tools"

  python_libraries:
    - "NumPy, SciPy, Pandas"
    "Matplotlib, Seaborn"
    "OpenCV, Pillow"
    "tqdm, wandb, tensorboard"
```

---

## 2. Access and Setup

### **Prerequisites**

```yaml
access_requirements:
  nvidia_ngc_account:
    - "Valid NVIDIA NGC account"
    - "API key or token"
    - "Access to tensorrt repository"

  local_environment:
    - "Docker installed and running"
    - "Docker version: 20.10+"
    - "Docker Engine with NVIDIA Container Toolkit"
    - "sudo access for Docker operations"

  hardware_requirements:
    - "GPU with CUDA 12.1 support"
    - "Minimum GPU memory: 8GB for testing"
    "Recommended: NVIDIA H100 for full functionality"
```

### **Installation Steps**

#### **1. Install NVIDIA Container Toolkit**

```bash
# Install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

# Verify installation
sudo docker run --rm --gpus all nvcr.io/nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
```

#### **2. Login to NVIDIA NGC**

```bash
# Login to NVIDIA NGC
docker login nvcr.io

# Enter username when prompted
# Enter API key when prompted
# Should see "Login Succeeded" message
```

#### **3. Pull the Container**

```bash
# Pull the TensorRT container
docker pull nvcr.io/nvidia/tensorrt:25.03.06-py3

# Verify the container
docker images | grep nvcr.io/tensorrt
```

#### **4. Verify Container Functionality**

```bash
# Run the container and verify components
docker run --rm --gpus all nvcr.io/nvidia/tensorrt:25.03.06-py3 bash -c "
  python3 -c \"import torch\"
  python3 -c \"import tensorrt as trt\"
  python3 -c \"print('Container verified successfully')\"
"
```

---

## 3. Development Environment Setup

### **Project Structure**

```yaml
project_structure: epic_0_workspace/
  docker/
  Dockerfile.base
  Dockerfile.dev
  docker-compose.yml
  .dockerignore

  scripts/
  setup.sh
  start_dev.sh
  run_tests.sh
  build_container.sh

  notebooks/
  tensorrt_examples/
  model_loading/
  performance_benchmarks/

  requirements/
  requirements.txt
  requirements-dev.txt

  tests/
  unit/
  integration/
  performance/

  docs/
  container_documentation.md
  setup_guide.md
  troubleshooting.md
```

### **Base Dockerfile**

```dockerfile
# docker/Dockerfile.base
FROM nvcr.io/nvidia/tensorrt:25.03.06-py3

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/workspace/src
ENV PATH=/workspace/src:$PATH

# System updates
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    cmake \
    pkg-config \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create workspace directory
RUN mkdir -p /workspace/src /workspace/notebooks /workspace/data
WORKDIR /workspace

# Copy requirements
COPY requirements.txt requirements-dev.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Copy source code (placeholder for now)
COPY src/ /workspace/src/
COPY scripts/ /workspace/scripts/
COPY notebooks/ /workspace/notebooks/

# Set permissions
RUN chmod +x /workspace/scripts/*.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD python3 -c "import torch, tensorrt as trt; print('OK')" || exit 1

# Default command
CMD ["/bin/bash"]
```

### **Development Dockerfile**

```dockerfile
# docker/Dockerfile.dev
FROM epic_0_base

# Install development tools
RUN pip3 install --no-cache-dir -r /tmp/requirements-dev.txt

# Install OpenVLA dependencies (placeholder)
# Note: This will be updated with actual OpenVLA requirements
RUN pip3 install --no-cache-dir \
    typer[all] \
    rich \
    pytest \
    pytest-asyncio \
    pytest-cov \
    black \
    isort \
    mypy \
    jupyterlab \
    ipython

# Set up development environment
ENV PYTHONPATH=/workspace/src:$PATH
ENV JUPYTER_ENABLE_LAB=yes

# Expose Jupyter port
EXPOSE 8888

# Jupyter configuration
RUN jupyter lab --generate-config
RUN echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_lab_config.py

# Development command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
```

### **Docker Compose**

```yaml
# docker-compose.yml
version: '3.8'

services:
  dev:
    build:
      context: .
      dockerfile: docker/Dockerfile.dev
    container_name: epic0-dev
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - PYTHONPATH=/workspace/src:$PATH
    ports:
      - '8888:8888' # JupyterLab
      - '8000:8000' # Development server
      - '50051:50051' # gRPC server
    volumes:
      - ./src:/workspace/src
      - ./notebooks:/workspace/notebooks
      - ./data:/workspace/data
      - ./models:/workspace/models
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    networks:
      - epic0-network

  jupyter:
    extends: dev
    container_name: epic0-jupyter
    command: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

  tests:
    extends: dev
    container_name: epic0-tests
    command: bash -c "cd /workspace && pytest tests/ -v --cov=src --cov-report=html"
    volumes:
      - ./tests:/workspace/tests
    depends_on:
      - dev

networks:
  epic0-network:
    driver: bridge
```

---

## 4. Verification and Testing

### **Container Verification Script**

```bash
#!/bin/bash
# scripts/verify_container.sh

echo "=== Container Verification ==="

# Check if container exists
echo "1. Checking if container is available..."
if docker images | grep -q "nvcr.io/nvidia/tensorrt:25.03.06-py3"; then
    echo "✅ Container found: nvcr.io/nvidia/tensorrt:25.03.06-py3"
else
    echo "❌ Container not found. Please run: docker pull nvcr.io/nvidia/tensorrt:25.03.06-py3"
    exit 1
fi

# Test container functionality
echo "2. Testing container functionality..."
docker run --rm --gpus all nvcr.io/nvidia/tensorrt:25.03.06-py3 bash -c "
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
else:
    print('⚠️  CUDA not available')
print('🚀 Container verification successful!')
"

# Check container contents
echo "3. Checking container contents..."
docker run --rm nvcr.io/nvidia/tensorrt:25.03.06-py3 bash -c "
import subprocess
import os
print('📦 Python packages:')
subprocess.run(['pip', 'list'])
"

echo "=== Verification Complete ==="
```

### **Health Check Script**

```bash
#!/bin/bash
# scripts/health_check.sh

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker."
    exit 1
fi

# Check NVIDIA Container Toolkit
if ! docker run --rm --gpus all nvcr.io/nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi &> /dev/null; then
    echo "❌ NVIDIA Container Toolkit not working."
    echo "Please install NVIDIA Container Toolkit."
    exit 1
fi

# Check NVIDIA NGC access
if ! docker login nvcr.io &> /dev/null; then
    echo "❌ NVIDIA NGC access not working."
    echo "Please login to NVIDIA NGC."
    exit 1
fi

echo "✅ All health checks passed!"
```

### **Test Suite**

```bash
#!/bin/bash
# scripts/run_tests.sh

echo "=== Running Epic 0 Test Suite ==="

# Set up environment
export PYTHONPATH=/workspace/src:$PATH

# Run unit tests
echo "Running unit tests..."
python -m pytest tests/unit/ -v --cov=src --cov-report=term-missing

# Run integration tests
echo "Running integration tests..."
python -m pytest tests/integration/ -v

# Run performance tests
echo "Running performance tests..."
python -m pytest tests/performance/ -v

echo "=== Test Suite Complete ==="
```

---

## 5. OpenVLA Integration Setup

### **OpenVLA Requirements**

```txt
# requirements.txt
# Core ML/DL frameworks
torch>=2.0.0
torchvision>=0.15.0
torchaudio>=2.0.0

# Optimization and quantization
tensorrt>=8.6.0
nvidia-tensorrt>=8.6.0
onnx>=1.12.0
onnxruntime-gpu>=1.12.0

# Data processing
numpy>=1.21.0
pandas>=1.3.0
pillow>=8.3.0

# Visualization and logging
matplotlib>=3.5.0
seaborn>=0.11.0
tensorboard>=2.8.0
wandb>=0.12.0

# Utilities
tqdm>=4.62.0
click>=8.0.0
rich>=12.0.0
pydantic>=1.8.0
```

### **Development Requirements**

```txt
# requirements-dev.txt
# Testing
pytest>=7.0.0
pytest-asyncio>=0.19.0
pytest-cov>=3.0.0
pytest-xdist>=2.4.0

# Code quality
black>=22.0.0
isort>=5.9.0
mypy>=0.910
flake8>=4.0.0

# Documentation
sphinx>=4.0.0
sphinx-rtd-theme>=1.0.0

# Development tools
jupyterlab>=3.2.0
ipython>=8.0.0
pre-commit>=2.15.0
```

### **OpenVLA Model Loading**

```python
# src/openvla/model_loader.py
import torch
import tensorrt as trt
from pathlib import Path
from typing import Optional, Dict, Any

class OpenVALoader:
    """OpenVLA model loader for TensorRT optimization"""

    def __init__(self):
        self.logger = self._setup_logging()
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    def load_pytorch_model(self, model_path: str) -> torch.nn.Module:
        """Load PyTorch OpenVLA model"""
        try:
            model = torch.load(model_path, map_location=self.device)
            self.logger.info(f"Loaded PyTorch model from {model_path}")
            return model
        except Exception as e:
            self.logger.error(f"Failed to load PyTorch model: {e}")
            raise

    def create_trt_engine(self,
                         onnx_path: str,
                         trt_engine_path: str,
                         max_batch_size: int = 1,
                         max_workspace_size: int = 1 << 30) -> trt.ICudaEngine:
        """Create TensorRT engine from ONNX model"""
        try:
            # Create TensorRT builder
            logger = trt.Logger(trt.Logger.WARNING)
            builder = trt.Builder(logger)
            network = builder.create_network(1 << int(trt.NetworkDefinitionCreationFlag.EXPLICIT_BATCH))

            # Parse ONNX model
            parser = trt.OnnxParser(network, logger)
            with open(onnx_path, "rb") as model_file:
                parser.parse(model_file.read())

            # Configure builder
            config = builder.create_builder_config()
            config.max_workspace_size = max_workspace_size

            # Build engine
            engine = builder.build_engine(network, config)

            # Save engine
            with open(trt_engine_path, "wb") as f:
                f.write(engine.serialize())

            self.logger.info(f"Created TensorRT engine: {trt_engine_path}")
            return engine

        except Exception as e:
            self.logger.error(f"Failed to create TensorRT engine: {e}")
            raise

    def load_trt_engine(self, trt_engine_path: str) -> trt.ICudaEngine:
        """Load TensorRT engine"""
        try:
            with open(trt_engine_path, "rb") as f:
                serialized_engine = f.read()

            runtime = trt.Runtime(trt.Logger.WARNING)
            engine = runtime.deserialize_cuda_engine(serialized_engine)

            self.logger.info(f"Loaded TensorRT engine: {trt_engine_path}")
            return engine

        except Exception as e:
            self.logger.error(f"Failed to load TensorRT engine: {e}")
            raise

    def validate_model(self, model: torch.nn.Module) -> Dict[str, Any]:
        """Validate model configuration"""
        try:
            # Check model architecture
            model_info = {
                "type": type(model).__name__,
                "num_parameters": sum(p.numel() for p in model.parameters()),
                "model_dtype": str(next(model.parameters()).dtype),
                "device": str(next(model.parameters()).device)
            }

            # Test forward pass with dummy input
            if hasattr(model, 'forward'):
                # Create dummy input (adjust size as needed)
                dummy_input = torch.randn(1, 3, 224, 224, device=self.device)
                try:
                    with torch.no_grad():
                        output = model(dummy_input)
                    model_info["forward_pass"] = "success"
                    model_info["output_shape"] = list(output.shape)
                except Exception as e:
                    model_info["forward_pass"] = f"failed: {e}"
            else:
                model_info["forward_pass"] = "not_implemented"

            self.logger.info(f"Model validation: {model_info}")
            return model_info

        except Exception as e:
            self.logger.error(f"Model validation failed: {e}")
            raise
```

---

## 6. Performance Optimization

### **TensorRT Optimization Script**

```python
# src/openvla/tensorrt_optimizer.py
import torch
import tensorrt as trt
from typing import List, Dict, Any
import logging

class TensorRTOptimizer:
    """TensorRT optimizer for OpenVLA models"""

    def __init__(self):
        self.logger = logging.getLogger(__name__)

    def optimize_model(self,
                        onnx_path: str,
                        output_path: str,
                        optimization_config: Dict[str, Any]) -> Dict[str, Any]:
        """Optimize model for TensorRT deployment"""

        results = {}

        try:
            # Create TensorRT engine
            engine = self._create_optimized_engine(
                onnx_path,
                output_path,
                optimization_config
            )

            # Validate engine
            validation_results = self._validate_engine(engine, optimization_config)

            # Performance profiling
            profile_results = self._profile_engine(engine, optimization_config)

            results = {
                "engine_path": output_path,
                "optimization_config": optimization_config,
                "validation": validation_results,
                "performance": profile_results,
                "success": True
            }

            self.logger.info("TensorRT optimization completed successfully")
            return results

        except Exception as e:
            self.logger.error(f"TensorRT optimization failed: {e}")
            return {"success": False, "error": str(e)}

    def _create_optimized_engine(self,
                              onnx_path: str,
                              output_path: str,
                              config: Dict[str, Any]) -> trt.ICudaEngine:
        """Create optimized TensorRT engine"""

        logger = trt.Logger(trt.Logger.WARNING)
        builder = trt.Builder(logger)
        network = builder.create_network(1 << int(trt.NetworkDefinitionCreationFlag.EXPLICIT_BATCH))

        # Parse ONNX model
        parser = trt.OnnxParser(network, logger)
        with open(onnx_path, "rb") as model_file:
            parser.parse(model_file.read())

        # Configure optimization
        builder_config = builder.create_builder_config()

        # Enable optimizations
        if config.get("enable_fp16", True):
            builder_config.set_flag(trt.BuilderFlag.FP16)
            self.logger.info("FP16 optimization enabled")

        if config.get("enable_int8", False):
            builder_config.set_flag(trt.BuilderFlag.INT8)
            self.logger.info("INT8 optimization enabled")

        # Set workspace size
        builder_config.max_workspace_size = config.get(
            "max_workspace_size",
            1 << 30  # 1GB
        )

        # Build engine
        engine = builder.build_engine(network, builder_config)

        # Save engine
        with open(output_path, "wb") as f:
            f.write(engine.serialize())

        return engine

    def _validate_engine(self, engine: trt.ICudaEngine, config: Dict[str, Any]) -> Dict[str, Any]:
        """Validate TensorRT engine"""

        validation_results = {}

        # Check engine properties
        validation_results["engine_info"] = {
            "name": engine.name,
            "max_batch_size": engine.max_batch_size,
            "max_workspace_size": engine.max_workspace_size,
            "device_memory_size": engine.device_memory_size
        }

        # Check bindings
        validation_results["bindings"] = {
            num_bindings: engine.num_bindings,
            binding_shapes: [engine.get_binding_shape(i) for i in range(engine.num_bindings)]
        }

        # Check I/O tensors
        validation_results["io_tensors"] = {
            num_io_tensors: engine.num_io_tensors,
            input_shapes: [engine.get_binding_shape(engine.get_binding_index(input_name))
                          for input_name in engine.get_input_names()],
            output_shapes: [engine.get_binding_shape(engine.get_binding_index(output_name))
                           for output_name in engine.get_output_names()]
        }

        return validation_results

    def _profile_engine(self, engine: trt.ICudaEngine, config: Dict[str, Any]) -> Dict[str, Any]:
        """Profile TensorRT engine performance"""

        profile_results = {}

        # Create execution context
        context = engine.create_execution_context()

        try:
            # Warmup
            dummy_inputs = self._create_dummy_inputs(engine)
            context.execute_v2_bindings(dummy_inputs)

            # Profile execution
            import time
            start_time = time.time()

            for i in range(10):  # Warmup + 10 runs
                context.execute_v2_bindings(dummy_inputs)

            end_time = time.time()

            execution_time = (end_time - start_time) / 10

            profile_results["execution_time_ms"] = execution_time * 1000
            profile_results["throughput_hz"] = 1.0 / execution_time

            self.logger.info(f"Engine profiling: {execution_time:.4f}s per inference, {profile_results['throughput_hz']:.2f} Hz")

        except Exception as e:
            self.logger.error(f"Engine profiling failed: {e}")
            profile_results["error"] = str(e)

        return profile_results

    def _create_dummy_inputs(self, engine: trt.ICudaEngine) -> List[torch.Tensor]:
        """Create dummy inputs for profiling"""

        dummy_inputs = []

        for binding in engine.get_input_names():
            binding_index = engine.get_binding_index(binding)
            shape = engine.get_binding_shape(binding_index)
            dtype = trt.nptype_to_torch_type(binding.dtype)

            dummy_input = torch.zeros(shape, dtype=dtype, device="cuda")
            dummy_inputs.append(dummy_input)

        return dummy_inputs
```

---

## 7. Troubleshooting Guide

### **Common Issues and Solutions**

#### **Container Pull Issues**

```bash
# Issue: Permission denied
# Solution: Check Docker group membership
sudo usermod -aG docker $USER
newgrp docker

# Issue: Image not found
# Solution: Check NVIDIA NGC access
docker login nvcr.io

# Issue: Out of memory during pull
# Solution: Increase Docker daemon memory
sudo systemctl edit docker
# Add: {"default-runtime": {"memory": "8g"}}
```

#### **GPU Access Issues**

```bash
# Issue: GPU not detected
# Solution: Check NVIDIA drivers
nvidia-smi

# Issue: CUDA version mismatch
# Solution: Check container CUDA version
docker run --rm --gpus all nvcr.io/nvidia/cuda:12.1.0-base-ubuntu22.04 bash -c "
python3 -c \"import torch; print(f'CUDA version: {torch.version.cuda}')\"
"
```

#### **TensorRT Issues**

```bash
# Issue: TensorRT import error
# Solution: Check TensorRT version in container
docker run --rm --gpus all nvcr.io/nvidia/tensorrt:25.03.06-py3 bash -c "
import tensorrt as trt
print(f'TensorRT version: {trt.__version__}')
"

# Issue: Engine building fails
# Solution: Check ONNX model compatibility
# Verify model has proper inputs/outputs
# Check tensor shapes and data types
```

---

## 8. Best Practices

### **Container Management**

```yaml
best_practices:
  image_management:
    - "Use specific tags (25.03.06-py3) not latest"
    - "Store custom images in registry"
    - "Tag images with git commit hash"
    - "Multi-stage builds to reduce size"

  resource_management:
    - "Set appropriate memory limits"
    "Monitor GPU memory usage"
    "Clean up intermediate containers"
    "Use Docker volume mounts"

  security:
    - "Scan images for vulnerabilities"
    "Use non-root user when possible"
    "Limit container capabilities"
    "Regularly update base images"
```

### **Development Workflow**

```yaml
development_workflow:
  local_development:
    - "Use Docker Compose for consistent environment"
    - "Mount source code as volume"
    - "Use .dockerignore to exclude unnecessary files"
    - "Regularly run tests and checks"

  optimization_workflow:
    - "Start with PyTorch model"
    "Convert to ONNX"
    "Create TensorRT engine"
    "Profile and validate"
    "Iterate and optimize"

  testing_workflow:
    - "Unit tests for core functionality"
    "Integration tests for end-to-end"
    "Performance tests for optimization"
    "Container health checks"
```

---

## 9. Next Steps

### **Immediate Actions (This Week)**

1. **Setup NVIDIA NGC access** for all team members
2. **Pull and verify** the 25.03.06-py3 container
3. **Set up development environment** using Docker Compose
4. **Run verification scripts** to ensure functionality

### **Epic 0 Week 1**

1. **Customize base container** for OpenVLA needs
2. **Implement development tools and utilities**
3. **Set up model loading and validation**
4. **Begin performance benchmarking framework**

### **Integration with Learning**

1. **Complete NVIDIA DLI courses** before implementation
2. **Apply learning** to container optimization
3. **Document best practices** and lessons learned
4. **Share knowledge** with team members

This implementation guide provides everything needed to successfully implement the NGC 25.03.06-py3 container as the foundation for Epic 0, ensuring a solid, production-ready base for OpenVLA optimization development.
