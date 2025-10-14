# Technical Specification: The LoRA Adaptation & Accuracy Recovery Framework

**Date:** 2025-10-06
**Author:** Gemini
**Epic ID:** 3
**Status:** Draft

---

## 1. Overview

This document provides the detailed technical specification for implementing Epic 3: The LoRA Adaptation & Accuracy Recovery Framework. This epic is responsible for providing the tools to apply Low-Rank Adaptation (LoRA) to the optimized engines to recover any task-specific accuracy lost during compression. **This is an engineering guide, and its recommendations for using standard libraries and reproducible workflows are authoritative.**

## 2. Objectives and Scope

**In-Scope:**

- Developing the `openvla-cli adapt` command to inject LoRA adapters into a model.
- The command must be able to merge the LoRA weights into the base model for a deployable artifact.
- Creating a standardized checkpointing and manifest format for LoRA adapters.
- Developing an evaluation harness and Jupyter notebooks for generating "Accuracy Recovery Reports."
- Integrating LoRA-specific smoke tests into the CI pipeline.
- Orchestrating a multi-stage tuning workflow: Jetson-based LoRA rank sweeps (32→128), promotion of best adapters to cloud full fine-tuning on rented multi-GPU nodes (H100/A100), and publishing comparative metrics for each stage.

**Out-of-Scope:**

- The training of the LoRA adapters themselves (this is considered a research/ML task, not a core framework feature).
- The core engine build process (handled in Epic 2).

## 3. System Architecture Alignment

This specification implements the `Adapter` and `AccuracyValidator` components from the Solution Architecture. It provides the critical capability to fine-tune the optimized models, ensuring they meet the project's strict accuracy NFRs. The workflow will consume intermediate models from `/workspace/intermediate_models/` and produce new, adapted models in the same directory.

## 4. Detailed Design

### 4.1. `openvla-cli adapt` Command

- **Interface:** `openvla-cli adapt --model <MODEL_PATH> --lora <LORA_CHECKPOINT_PATH> --merge`
- **Description:** Applies a LoRA adapter to a base model and optionally merges the weights.
- **Arguments:**
  - `--model <MODEL_PATH>`: Path to the intermediate model to adapt.
  - `--lora <LORA_CHECKPOINT_PATH>`: Path to the LoRA adapter checkpoint file.
  - `--merge`: A flag that, when present, merges the LoRA weights directly into the base model's weights for a standalone, deployable artifact.
- **Backend Logic (`src/openvla_cli/core/adapter.py`):**
  1.  **Framework:** Use the Hugging Face `PEFT` (Parameter-Efficient Fine-Tuning) library as the primary framework for LoRA operations.
  2.  **Adapter Injection:** Load the base PyTorch model and use `PEFT` to inject the LoRA adapter layers.
  3.  **Weight Merging (if `--merge`):** If the merge flag is specified, call the appropriate `PEFT` function to merge the adapter weights into the base model's weights.
  4.  **Output:** Save the adapted model (either with a separate adapter or merged) to `/workspace/intermediate_models/`.

### 4.2. LoRA Checkpointing and Manifests

- **Standard:** When LoRA adapters are trained, they must be saved as a `.pt` or `.safetensors` file.
- **Manifest:** Each checkpoint file must be accompanied by a JSON manifest file (`<LORA_NAME>.json`) in the same directory.
- **Manifest Contents:** The manifest must contain:
  - `base_model_hash`: The SHA256 hash of the base model it was trained on.
  - `lora_rank`: The rank of the LoRA adapter.
  - `lora_alpha`: The alpha value of the LoRA adapter.
  - `target_task_metrics`: The accuracy metrics achieved on the target task.

### 4.3. Evaluation and Reporting

- **Evaluation Harness (`tests/accuracy_harness.py`):**
  - A Python script that takes a baseline model and a LoRA-adapted model as input.
  - It runs both models against a held-out evaluation dataset.
  - It computes the accuracy delta and measures the latency and memory overhead of the adapter.
- **Jupyter Notebooks (`/notebooks/`):**
  - Provide example notebooks that demonstrate how to use the evaluation harness.
  - The notebooks will visualize the results and generate an "Accuracy Recovery Report" in Markdown format, which will be saved to `/workspace/reports/`.

### 4.4. Expert Recommendations

- **NVIDIA NeMo Integration:** For enterprise-grade, production LoRA workflows, the official NVIDIA "Efficient Large Language Model Customization" course recommends integrating with the NVIDIA NeMo framework. This should be considered the primary upgrade path for post-MVP development.
- **Synthetic Data Generation:** NeMo's capabilities for synthetic data generation should be explored as a potential method for improving adapter training in future iterations.

### 4.5. Multi-Stage Tuning Pipeline

The tuning workflow mirrors Dusty's experience but assumes additional R&D time:

1. **Jetson LoRA Rank Sweep:** Execute `rank ∈ {32, 64, 128}` experiments on-device using the `openvla-cli adapt` command and rented cloud GPUs for calibration datasets as needed. Each run must log latency/accuracy deltas into `/workspace/reports/lora_rank_sweep.csv`.
2. **Cloud Full Fine-Tune:** Promote the best-performing LoRA configuration to full fine-tuning on rented multi-GPU instances (e.g., 8×H100) using `openvla-cli adapt --full-train`. The workflow must record wall-clock time, cost, and accuracy uplift (>5 % target).
3. **Stage Comparison Report:** Generate a Markdown summary comparing baseline, Jetson LoRA, and cloud full fine-tune results, including behavioral notes for any INT4 precision regressions.
4. **Data Pipeline Validation:** Prior to each stage, validate simulator ↔ model coordinate/action normalization by running `tests/data_pipeline_check.py`; failures block progression to the next stage.

## 5. Non-Functional Requirements

| NFR ID    | Requirement             | Specification                                                                                                                     |
| :-------- | :---------------------- | :-------------------------------------------------------------------------------------------------------------------------------- |
| **NFR-6** | **Accuracy Retention**  | The workflows and reports created in this epic are the primary means of validating this NFR. The final accuracy drop must be ≤4%. |
| **DX-5**  | **Fast Feedback Loops** | The CI smoke tests must be lightweight and run in under 5 minutes to provide quick feedback on LoRA integration.                  |

### Performance Targets

| Metric                   | Target   | Measurement Method                                                |
| :----------------------- | :------- | :---------------------------------------------------------------- |
| **p99 Latency Increase** | < 5%     | Measured by the evaluation harness (`tests/accuracy_harness.py`). |
| **Peak VRAM Increase**   | < 250 MB | Measured by the evaluation harness.                               |
| **Adapter Loading Time** | < 500 ms | Time from command invocation to model readiness.                  |

## 6. Dependencies and Integrations

| Dependency              | Version | Integration Point                                                    |
| :---------------------- | :------ | :------------------------------------------------------------------- |
| **Hugging Face `PEFT`** | Latest  | The core library for all LoRA operations in the `Adapter` component. |
| **Jupyter**             | Latest  | For the evaluation and reporting notebooks.                          |
| **`safetensors`**       | Latest  | For safe and efficient checkpoint handling.                          |

## 7. Acceptance Criteria (Authoritative)

1.  **AC 3.1:** Running `openvla-cli adapt` successfully applies a LoRA adapter to a model and saves the new artifact.
2.  **AC 3.2:** Running `openvla-cli adapt --merge` successfully merges the LoRA weights into the base model.
3.  **AC 3.3:** The evaluation harness can successfully run a baseline and an adapted model and generate a report showing the accuracy delta and performance overhead.
4.  **AC 3.4:** A LoRA-specific smoke test is integrated into the CI pipeline that loads an adapted engine and runs a sample inference.
5.  **AC 3.5:** The LoRA checkpoint manifest is automatically checked for the presence of all required fields.
6.  **AC 3.6:** The multi-stage tuning pipeline produces the rank-sweep CSV, full fine-tune summary, and comparison report, each checked into `/workspace/reports/` and referenced in the artifact manifest.
7.  **AC 3.7:** The data pipeline validation script passes before any promoted full fine-tuning run.

## 8. Test Strategy Summary

The test strategy will include integration tests for the `adapt` CLI command to ensure it functions correctly. The core of the testing for this epic, however, is the **evaluation harness**. This harness will be used in CI to run regression tests, ensuring that changes to the LoRA integration code do not negatively impact accuracy or performance.
