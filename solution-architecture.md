# Solution Architecture: OpenVLA Edge Optimization Framework

**Version:** 1.0
**Date:** 2025-10-06
**Status:** Approved

---

## 1. Executive Summary

This document outlines the solution architecture for the **OpenVLA Edge Optimization Framework**. The architecture is designed to support the project's primary goal: to provide a robust, reproducible, and developer-friendly pipeline for optimizing large Vision-Language-Action (VLA) models for real-time inference on the NVIDIA Jetson Orin Nano Super.

The architecture is based on three core principles:

1.  A **Monorepo** to provide a single source of truth and simplify dependency management.
2.  An **Integrated CLI Toolkit** (`openvla-cli`) to provide a unified and guided developer experience.
3.  A strict **separation of Code, Configuration, and Artifacts** to align with NVIDIA MLOps best practices and ensure reproducibility.

The system is composed of a Python-based CLI that orchestrates a multi-stage optimization pipeline running on cloud GPUs. The final output is a self-contained, containerized inference server, built to NVIDIA Triton standards, ready for deployment on a Jetson device.

---

## 2. Architecture Principles & Decisions

This architecture is guided by the following key decisions, which are documented in detail in `docs/adrs/`:

- **ADR-001: Monorepo and Integrated CLI Toolkit:** We will use a monorepo to house all project code and build a unified CLI as the primary developer interface.
- **ADR-002: Core Technology Stack:** The project will standardize on a specific, version-locked set of technologies, including Python, PyTorch, NVIDIA TensorRT 10.3, and the NVIDIA TAO Toolkit.
- **ADR-003: Ecosystem-Aware Monorepo Structure:** The directory structure will enforce a strict separation of concerns between source code (`/src`), model data (`/models`), tool configurations (`/configs`), and generated artifacts (`/workspace`).

The design also adheres to the **Developer Experience (DX) Principles** outlined in the PRD, emphasizing automation, reproducibility, and fast feedback loops.

---

## 3. Technology Stack

| Component                    | Selection                              | Rationale                                                 |
| ---------------------------- | -------------------------------------- | --------------------------------------------------------- |
| **Primary Language**         | Python 3.8+                            | Industry standard for ML/MLOps, ecosystem support         |
| **ML Framework**             | PyTorch 2.x                            | Specified in PRD, modern VLA model support                |
| **Optimization Backend**     | NVIDIA TensorRT 10.3                   | Core project requirement for high performance             |
| **Quantization/Pruning**     | NVIDIA TensorRT Model Optimizer        | NVIDIA's official, state-of-the-art optimization library. |
| **CLI Framework**            | Typer                                  | Modern, easy-to-use, great for DX                         |
| **Containerization**         | Docker + NVIDIA Container Toolkit 1.14 | Standard for GPU-accelerated services                     |
| **CI/CD**                    | GitHub Actions                         | Specified in PRD                                          |
| **Model Serving (Post-MVP)** | NVIDIA Triton Inference Server 3.x     | Aligns with NVIDIA ecosystem, scalable                    |
| **Custom Kernels**           | CUTLASS 4.2.1+                         | High-performance, low-level kernel authoring              |

---

## 4. System Architecture Diagram

The system is composed of three distinct parts: the developer toolkit, the optimization pipeline it orchestrates, and the final deployment package.

```
+-----------------------------------------------------------------+
| Developer's Machine / CI/CD Runner                              |
|                                                                 |
|  +---------------------------+                                  |
|  |      openvla-cli          |  (Typer, Python)                  |
|  +---------------------------+                                  |
|  |                           |                                  |
|  |  1. profile()             |--> Manages the stages below      |
|  |  2. quantize()            |                                  |
|  |  3. prune()               |                                  |
|  |  4. adapt()  (LoRA)       |                                  |
|  |  5. build()  (TensorRT)   |                                  |
|  |  6. package() (Docker)    |                                  |
|  |                           |                                  |
+--|---------------------------|---------------------------------+
   |                           |
   v                           v
+--|---------------------------|---------------------------------+
|  |  Optimization Pipeline (Runs on Cloud GPU)                  |
|  +-----------------------------------------------------------+ |
|  |                                                           | |
|  | [Input VLA Model] -> [Profiling] -> [Quantization (RTMO)] ->| |
|  |   -> [Sparsity (RTMO)] -> [LoRA] -> [TensorRT Build] ->     | |
|  |   -> [CUTLASS Kernels] -> [Optimized .plan Engine]          | |
|  |                                                           | |
|  +-----------------------------------------------------------+ |
+-----------------------------------------------------------------+
   |
   v
+--|-------------------------------------------------------------+
|  |  Deployment Package (Final Output)                          |
|  +-----------------------------------------------------------+ |
|  |                                                           | |
|  |  +-----------------------------------------------------+  | |
|  |  | Docker Container (JetPack 6.2.1 Base)               |  | |
|  |  |  (Built to Triton Inference Server Standard)        |  | |
|  |  |                                                     |  | |
|  |  |  +-----------------------------------------------+  |  | |
|  |  |  | ROS 2 / gRPC Server                           |  |  | |
|  |  |  +-----------------------------------------------+  |  | |
|  |  |  |  [Optimized .plan Engine]                     |  |  | |
|  |  |  +-----------------------------------------------+  |  | |
|  |  |                                                     |  | |
|  |  +-----------------------------------------------------+  | |
|  |                                                           | |
|  +-----------------------------------------------------------+ |
+-----------------------------------------------------------------+
```

---

## 5. Component Breakdown

This section breaks down the Epics from the PRD into their logical software components.

| Epic                          | Component Name      | Description                                                                                                                | Location                               |
| :---------------------------- | :------------------ | :------------------------------------------------------------------------------------------------------------------------- | :------------------------------------- |
| **Epic 0: Environment**       | `DevContainer`      | A version-locked base Docker image with all required dependencies (CUDA, TRT, etc.).                                       | `src/deployment/base/Dockerfile`       |
|                               | `Onboarding Docs`   | Documentation for setting up and using the dev environment.                                                                | `docs/`                                |
| **Epic 1: Core Optimization** | `Profiler`          | A CLI command and backend module to measure the baseline performance of a model.                                           | `src/openvla_cli/commands/profile.py`  |
|                               | `Quantizer`         | A CLI command and backend module that uses the TensorRT Model Optimizer to apply quantization. Reads from `/configs/rtmo`. | `src/openvla_cli/commands/quantize.py` |
|                               | `Pruner`            | A CLI command and backend module that uses the TensorRT Model Optimizer to apply 2:4 sparsity. Reads from `/configs/rtmo`. | `src/openvla_cli/commands/prune.py`    |
|                               | `ReportGenerator`   | A utility that generates Markdown/HTML reports from performance data.                                                      | `src/openvla_cli/core/reporting.py`    |
| **Epic 2: TRT & CUTLASS**     | `EngineBuilder`     | A CLI command and backend module that compiles an intermediate model into a TensorRT `.plan` engine.                       | `src/openvla_cli/commands/build.py`    |
|                               | `KernelManager`     | A utility for compiling and integrating custom CUTLASS kernels into the build process.                                     | `src/openvla_cli/core/kernels.py`      |
| **Epic 3: LoRA Adaptation**   | `Adapter`           | A CLI command and backend module for applying LoRA adapters to a model.                                                    | `src/openvla_cli/commands/adapt.py`    |
|                               | `AccuracyValidator` | A utility for running the model against a benchmark dataset and measuring accuracy.                                        | `src/openvla_cli/core/validation.py`   |
| **Epic 4: Deployment**        | `InferenceServer`   | The ROS 2 / gRPC server code that loads the TensorRT engine and serves requests.                                           | `src/deployment/inference_server/`     |
|                               | `ContainerBuilder`  | A CLI command that packages the inference server and a specified engine into the final Docker image.                       | `src/openvla_cli/commands/package.py`  |
| **Epic 5: CI/CD**             | `CI Pipeline`       | The main CI workflow that runs tests, lints, and smoke tests on every commit.                                              | `.github/workflows/ci.yaml`            |
|                               | `Release Pipeline`  | The release workflow that builds, signs, and publishes the final container artifact.                                       | `.github/workflows/release.yaml`       |
|                               | `StressTester`      | The automated test suite for running long-duration stability and performance tests.                                        | `tests/stress_test/`                   |

---

## 6. Directory Structure & Source Tree

The project will be organized in a monorepo with a strict separation of concerns.

```
/openvla/
|
├── .github/
│   └── workflows/          # CI/CD pipelines (Component: CI/Release Pipeline)
|
├── configs/
│   ├── rtmo/               # Configs for Quantizer and Pruner components
│   └── triton/             # Configs for InferenceServer component
|
├── docs/
│   └── adrs/               # Architecture Decision Records
|
├── models/                 # Source models (managed with Git LFS)
|
├── src/
│   ├── openvla_cli/        # Source for all CLI commands and core logic
│   │
│   ├── deployment/
│   │   ├── base/           # Dockerfile for DevContainer component
│   │   └── inference_server/ # Source for InferenceServer component
│   │
│   └── kernels/
│       └── cutlass/        # Source for KernelManager component
|
├── workspace/              # All generated outputs (GIT-IGNORED)
|
├── tests/
│   └── stress_test/        # Source for StressTester component
|
├── .gitattributes          # Configures Git LFS for the models/ directory
├── .gitignore              # Ignores the 'workspace/' directory
├── pyproject.toml          # Manages Python dependencies for all components
└── README.md
```

This structure provides a clear and logical mapping from the software components to the physical layout of the code in the repository.

---

## 7. Observability Strategy

**Owner:** Observability Lead
**Status:** Proposed

This section outlines the strategy for telemetry, metrics, and alerting to ensure the OpenVLA framework is observable during both testing and production deployment.

### 7.1. Core Principles

- **Standardization:** All components will use the `context7.monitoring` library for metric emission.
- **Actionability:** Alerts must be specific, include a runbook link, and be routed to the responsible team.
- **User-Centric Metrics:** Dashboards will focus on the key performance indicators (KPIs) and non-functional requirements (NFRs) defined in the PRD.

### 7.2. Starter Template

The following templates will be used as a baseline for implementing observability.

#### Key Metrics to Instrument

| Metric Name                     | Type      | Description                                   | Component         |
| :------------------------------ | :-------- | :-------------------------------------------- | :---------------- |
| `vla_inference_latency_seconds` | Histogram | Latency of a single inference request.        | `InferenceServer` |
| `vla_gpu_memory_usage_bytes`    | Gauge     | Peak VRAM usage during inference.             | `InferenceServer` |
| `vla_gpu_temperature_celsius`   | Gauge     | GPU temperature.                              | `InferenceServer` |
| `vla_power_draw_watts`          | Gauge     | Power consumption of the Jetson device.       | `InferenceServer` |
| `vla_requests_total`            | Counter   | Total number of inference requests processed. | `InferenceServer` |

#### Sample Alert

```yaml
- alert: HighInferenceLatency
  expr: histogram_quantile(0.95, sum(rate(vla_inference_latency_seconds_bucket}[5m]))) > 0.330
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: 'P95 inference latency is above the 330ms SLO.'
    description: 'The inference server is responding slowly. Check for high GPU load or thermal throttling.'
    runbook_url: '/docs/runbooks/high_latency.md'
```

#### Sample Dashboard Widget

- **Type:** Time Series Graph
- **Title:** P95 Inference Latency (SLO: 330ms)
- **Query:** `histogram_quantile(0.95, sum(rate(vla_inference_latency_seconds_bucket}[5m])))`
- **Visualization:** Line graph with a static threshold line at `0.330`.
