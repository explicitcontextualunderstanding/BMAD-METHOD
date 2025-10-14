# Technical Specification: The Core Optimization Engine (v2)

**Date:** 2025-10-06
**Author:** Gemini
**Epic ID:** 1
**Status:** Approved

---

## 1. Overview

This document provides the detailed technical specification for implementing Epic 1: The Core Optimization Engine. This epic covers the creation of the foundational CLI commands and backend modules for model profiling, quantization, and pruning. **This is an engineering guide, and its recommendations for using the native JetPack and NVIDIA toolchains are authoritative.** The components built here will form the core of the `openvla-cli` tool.

## 2. Objectives and Scope

**In-Scope:**

- Developing the `openvla-cli profile` command, leveraging **Nsight Systems**, **`tegrastats`**, and **`torch.cuda.profiler`**.
- Developing the `openvla-cli quantize` command, using **TensorRT QAT with PyTorch** and **`trtexec`** for PTQ.
- Developing the `openvla-cli prune` command, using the **NVIDIA TAO Toolkit 5.x** for 2:4 structured sparsity.
- Developing a `ReportGenerator` utility to create standardized CSV and Markdown reports.
- Defining the schema for the TAO Toolkit experiment specification files located in `/configs/tao/`.

**Out-of-Scope:**

- Building the final TensorRT engine (handled in Epic 2).
- Applying LoRA adapters (handled in Epic 3).

## 3. System Architecture Alignment

This specification implements the `Profiler`, `Quantizer`, `Pruner`, and `ReportGenerator` components from the Solution Architecture. The implementation must adhere to the best practices for the Jetson DevCloud environment.

## 4. Detailed Design

### 4.1. `openvla-cli profile` Command

- **Interface:** `openvla-cli profile --model <MODEL_NAME>`
- **Backend Logic (`src/openvla_cli/core/profiler.py`):**
  1.  **Pre-computation:** Pin all random seeds (PyTorch, NumPy, CUDA).
  2.  **Set Clocks:** Execute `jetson_clocks` to fix CPU/GPU frequencies and eliminate scaling noise.
  3.  **Power Profiling:** Launch `tegrastats` as a background subprocess to log power consumption to a file.
  4.  **Latency/Memory/FLOPS Profiling:** Wrap the model inference loop using the `torch.cuda.profiler` context manager to capture kernel-level metrics. Use a library like `torch-flops` to calculate theoretical FLOPs.
  5.  **Trace Generation:** Use the Nsight Systems Python bindings to capture a system-wide trace of the inference run.
  6.  **Post-computation:** Stop the `tegrastats` subprocess.
  7.  **Report Generation:** Call the `ReportGenerator` to process the raw logs and calculate key metrics, including **Model FLOPS Utilization (MFU)**.
- **Output:**
  - A detailed performance report, including a **VRAM/power budget workbook**, **dataset manifests**, and **MFU scores**, saved to `/workspace/reports/profile-<MODEL_NAME>.csv`.
  - An Nsight Systems trace file saved to `/workspace/reports/profile-<MODEL_NAME>.nsys`.

### 4.2. `openvla-cli quantize` Command

- **Interface:** `openvla-cli quantize --model <MODEL_NAME> --spec <SPEC_FILE> [--qat]`
- **Backend Logic (`src/openvla_cli/core/quantizer.py`):**
  - **If `--qat` flag is present (QAT Workflow):**
    1.  Load the TAO spec file from `/configs/tao/`.
    2.  Use `torch.ao.quantization` observers to insert quantization nodes into the PyTorch model.
    3.  Run calibration on a representative dataset as defined in the spec file.
    4.  Compile the model using `torch_tensorrt.compile(..., quant_mode="qat_int8")`.
  - **If `--qat` flag is NOT present (PTQ Workflow):**
    1.  Export the baseline model to ONNX 1.12 format.
    2.  Execute the `trtexec` command as a subprocess with the appropriate flags (`--int8` or `--fp16`) and a path to a calibration cache.
- **Output:**
  - A quantized model saved to `/workspace/intermediate_models/`.
  - A scorecard report in `/workspace/reports/` documenting the accuracy impact.

### 4.3. `openvla-cli prune` Command

- **Interface:** `openvla-cli prune --model <MODEL_NAME> --spec <SPEC_FILE>`
- **Backend Logic (`src/openvla_cli/core/pruner.py`):**
  1.  Load the TAO spec file from `/configs/tao/`.
  2.  Use the NVIDIA TAO Toolkit 5.x pruning APIs to apply 2:4 block sparsity.
  3.  Export the pruned model checkpoint.
  4.  **Combined Workflow:** After pruning, the logic should be able to chain into the PTQ quantization workflow to create a pruned-and-quantized model; when the CLI chains workflows (e.g., prune then quantize), the implementation should include an optional step to use MiniLM-style knowledge distillation to help maintain accuracy, as recommended by NVIDIA research.
- **Output:**
  - A pruned model checkpoint saved to `/workspace/intermediate_models/`.
  - An updated artifact manifest in `/workspace/` with sparsity metadata.

## 5. Non-Functional Requirements

| NFR ID     | Requirement                   | Specification                                                                                              |
| :--------- | :---------------------------- | :--------------------------------------------------------------------------------------------------------- |
| **NFR-10** | **Sparsity Performance**      | The application of 2:4 structured sparsity must yield a throughput gain of at least 15% over the baseline. |
| **DX-1**   | **Automation**                | All steps must be executable via the CLI without manual intervention.                                      |
| **DX-3**   | **Clarity Through Reporting** | Every command must produce a clear, standardized report summarizing its outcome.                           |
| **DX-8**   | **Version-Locked Artifacts**  | All scripts must run inside the version-locked `openvla-dev` container.                                    |

### Performance Targets

| Metric                 | Target       | Measurement Method                                    |
| :--------------------- | :----------- | :---------------------------------------------------- |
| **Profiling Overhead** | < 5%         | Wall-clock time of a profiled vs. non-profiled run.   |
| **Quantization Time**  | < 10 minutes | For the baseline `smolvla-450m` model on a cloud GPU. |
| **Pruning Time**       | < 30 minutes | For the baseline `smolvla-450m` model on a cloud GPU. |

### Security

| Requirement              | Specification                                                                                                                                                                    |
| :----------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Privilege Management** | Any command requiring `sudo` (e.g., `jetson_clocks`, `tegrastats`) must be executed by a user with a limited `sudo` policy, as defined in the project's `security-checklist.md`. |

## 6. Dependencies and Integrations

| Dependency                          | Version               | Integration Point                                         |
| :---------------------------------- | :-------------------- | :-------------------------------------------------------- |
| **Nsight Systems**                  | JetPack 6.2.1 version | Used by the `Profiler` for system-wide tracing.           |
| **`tegrastats`**                    | JetPack 6.2.1 version | Used by the `Profiler` for power measurement.             |
| **NVIDIA TensorRT Model Optimizer** | Latest                | Core library for the `Quantizer` and `Pruner` components. |
| **PyTorch**                         | 2.1                   | For model loading and manipulation.                       |
| **Torch-TensorRT**                  | 1.5                   | For integration with the build process.                   |

## 7. Acceptance Criteria (Authoritative)

1.  **AC 1.1:** Running `openvla-cli profile` on the Jetson DevCloud generates a CSV report and an `.nsys` trace file in the `/workspace/reports/` directory.
2.  **AC 1.2:** Running `openvla-cli quantize` successfully produces a quantized model using the TensorRT Model Optimizer.
3.  **AC 1.3:** Running `openvla-cli prune` successfully produces a pruned model checkpoint using the TensorRT Model Optimizer.
4.  **AC 1.4:** The CLI commands provide user-friendly error messages if a specified model or config file does not exist.
5.  **AC 1.5:** A CI smoke test exists that successfully loads and runs a basic inference on a generated INT8 engine.

## 8. Traceability Mapping

| Acceptance Criterion | Spec Section(s) | Component(s)  | Test Idea                                                             |
| :------------------- | :-------------- | :------------ | :-------------------------------------------------------------------- |
| **AC 1.1**           | 4.1             | `Profiler`    | Integration test on Jetson hardware; verify output files are created. |
| **AC 1.2**           | 4.2             | `Quantizer`   | Integration test; verify quantized model is created.                  |
| **AC 1.3**           | 4.3             | `Pruner`      | Integration test; verify pruned checkpoint is created.                |
| **AC 1.4**           | 4.1, 4.2, 4.3   | CLI Interface | Unit tests for the CLI command argument parsing and error handling.   |
| **AC 1.5**           | 2               | CI/CD         | Automated test in the CI pipeline that runs on every pull request.    |

## 9. Risks, Assumptions, Open Questions

- **Risk:** The `tegrastats` output format might change in future JetPack updates, breaking the power profiling parser.
  - **Mitigation:** The parser will be written defensively, and the CI environment validation will check the JetPack version to catch this early.
- **Assumption:** The VLA models are architecturally compatible with the TensorRT Model Optimizer's algorithms.
- **Question:** What is the exact command-line syntax for invoking Nsight Systems to profile a Python script? (To be answered during implementation).

## 10. Test Strategy Summary

The test strategy will be two-fold. First, **unit tests** will be written for the core Python modules (e.g., the `ReportGenerator`) to validate their logic in isolation. Second, **integration tests** will be created for each CLI command. These tests will run the commands against a small, sample model within the test suite, check for successful execution (exit code 0), and verify that the expected output artifacts (reports, intermediate models) are created in the correct locations. All performance and accuracy validation will be conducted using the datasets and models defined in the **Official Benchmarking Suite** in the project PRD.
