# Technical Specification: The TensorRT & CUTLASS Integration Layer (v2)

**Date:** 2025-10-06
**Author:** Gemini
**Epic ID:** 2
**Status:** Approved

---

## 1. Overview

This document provides the detailed technical specification for implementing Epic 2: The TensorRT & CUTLASS Integration Layer. This epic is responsible for compiling intermediate models into deployable TensorRT engines (`.plan` files). **This is an engineering guide, and its recommendations for using the native NVIDIA toolchains are authoritative.** It covers the containerized build environment, custom kernel integration, operator auditing, and automated validation.

## 2. Objectives and Scope

**In-Scope:**

- Developing the `openvla-cli build` command to compile an intermediate model into a TensorRT engine, defaulting to INT4 precision with CUTLASS kernels.
- Creating a containerized build environment based on the official NVIDIA NGC `l4t-pytorch` image.
- Developing a `KernelManager` utility for autotuning and compiling custom CUTLASS kernels using `nvidia-matmul-heuristics`.
- Developing a C++ TensorRT plugin framework for unsupported ONNX operators.
- Generating an operator compatibility matrix and a Software Bill of Materials (SBOM) for the final engine and its container layer.
- Creating an automated validation harness to test the integrity and performance of the generated engines.

**Out-of-Scope:**

- The initial quantization and pruning steps (handled in Epic 1).
- The final packaging of the engine into a production inference server (handled in Epic 4).

## 3. System Architecture Alignment

This specification implements the `EngineBuilder` and `KernelManager` components from the Solution Architecture. The implementation will be containerized and will produce the final `.plan` engine files to be stored in `/workspace/engines/`.

## 4. Detailed Design

### 4.1. Containerized Build Environment

- **Base Image:** The Dockerfile for the build environment will use the official NVIDIA NGC `nvcr.io/nvidia/l4t-pytorch:r36.2.0-py3` image as its parent to ensure alignment with the Jetson DevCloud stack.
- **Dependencies:** The Dockerfile will install TensorRT 10.3, CUTLASS 4.2.1+, CUDA Toolkit 12.6, cuDNN 9.3, `nvidia-matmul-heuristics`, and the CuTe DSL.

### 4.2. `openvla-cli build` Command

- **Interface:** `openvla-cli build --model <PATH> --target <ARCH> [--with-cutlass]`
- **Backend Logic (`src/openvla_cli/core/builder.py`):**
  1.  **ONNX Export:** Export the intermediate PyTorch model to ONNX 1.12 format.
  2.  **Operator Audit:** Parse the ONNX graph. For each operator, check against a known list of supported ops. Log any unsupported operators to the compatibility matrix. If a custom plugin exists for an unsupported op, flag it for inclusion.
  3.  **CUTLASS Autotuning (default INT4 path):**
      - Invoke the `KernelManager` to run `nvidia-matmul-heuristics` on the model's GEMM hotspots.
      - The manager will select the best-performing kernel and compile it into a shared library.
  4.  **Engine Serialization:**
      - Use the TensorRT Python API (`ICudaEngine::serialize()`) to build the `.plan` file.
      - The build process will incorporate any required custom plugins or CUTLASS kernels.
  5.  **Validation:** Invoke the automated validation harness to perform a smoke test on the newly created engine.
  6.  **SBOM Generation:** Use `Syft` to generate an SBOM for the engine and its immediate dependencies.

### 4.3. `KernelManager` and Plugin Framework

- **Location:** `src/kernels/` will contain subdirectories for `cutlass/` and `plugins/`.
- **`KernelManager` (`src/openvla_cli/core/kernels.py`):**
  - Provides a Python interface to the `nvidia-matmul-heuristics` tool.
  - Manages the compilation of C++ plugins and CUTLASS kernels into shared libraries (`.so`) using CMake with the correct architecture flags (`-DCMAKE_CUDA_ARCHITECTURES=87`).
  - If the autotuning process determines that INT4 is not viable or does not provide sufficient performance gains, the manager will produce a formal **INT4 feasibility memo** in the `/workspace/reports/` directory.
- **Plugin Development:**
  - Developers will add new plugins as C++ source files in `/src/kernels/plugins/`.
  - Each plugin must conform to the TensorRT `IPluginV2` interface.

### 4.4. Expert Recommendations

- **FP8 Future-Proofing:** To ensure forward compatibility with next-generation NVIDIA architectures (e.g., Hopper), FP8 quantization paths should be investigated as a post-MVP research item. The `EngineBuilder` should be designed with the flexibility to incorporate new precision types like FP8 in the future.

## 5. Non-Functional Requirements

| NFR ID    | Requirement                | Specification                                                                                           |
| :-------- | :------------------------- | :------------------------------------------------------------------------------------------------------ |
| **NFR-9** | **Platform Compatibility** | The build process must produce engines that are validated on both cloud (emulated) and Jetson hardware. |
| **DX-2**  | **Reproducibility**        | The entire build process must be containerized and version-locked to ensure 100% reproducibility.       |

## 6. Dependencies and Integrations

| Dependency                     | Version | Integration Point                            |
| :----------------------------- | :------ | :------------------------------------------- |
| **`trtexec` / TensorRT API**   | 10.3    | Core tool for engine compilation.            |
| **`nvidia-matmul-heuristics`** | Latest  | Used by the `KernelManager` for autotuning.  |
| **CUTLASS**                    | 4.2.1+  | Library for custom kernels.                  |
| **CMake**                      | 3.20+   | For building custom C++ plugins and kernels. |
| **Syft**                       | Latest  | For SBOM generation.                         |

## 7. Acceptance Criteria (Authoritative)

1.  **AC 2.1:** The `openvla-cli build` command successfully generates a `.plan` file in `/workspace/engines/`.
2.  **AC 2.2:** The automated validation harness (`tests/validation_harness.py`) can successfully load a generated engine, run a sample inference, and log the latency.
3.  **AC 2.3:** The `KernelManager` can successfully compile a sample CUTLASS kernel and a sample TensorRT plugin into shared libraries.
4.  **AC 2.4:** The CI pipeline includes a matrix job that runs the validation harness on both a cloud GPU and a remote Jetson device via SSH.
5.  **AC 2.5:** After a build, an operator compatibility matrix and an SBOM are saved to `/workspace/reports/`.
6.  **AC 2.6:** The default build produces an INT4 engine with associated CUTLASS kernels; when INT4 fails feasibility checks, the system emits the memo and automatically falls back to FP8/FP16 builds.

## 8. Test Strategy Summary

The test strategy is centered on the **automated validation harness**. This Python script will be the single source of truth for engine integrity. The CI pipeline will be configured to run this harness against every newly built engine on both target architectures, ensuring that no regressions are introduced.
