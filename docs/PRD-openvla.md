# PRD: OpenVLA Edge Optimization Framework

**Date:** 2025-10-06
**Author:** User
**Status:** Version 1.0

---

## 1. Overview & Context

### 1.1. Project Description

This document outlines the requirements for the **OpenVLA Edge Optimization Framework**, a comprehensive system designed to adapt large Vision-Language-Action (VLA) models for high-performance, real-time inference on resource-constrained edge devices, specifically the NVIDIA Jetson Orin Nano Super. The project will deliver an end-to-end pipeline for model quantization, pruning, and deployment, packaged as a containerized, ROS 2-compatible service.

### 1.2. Problem Statement

Modern VLA models are transformative for robotics, but their high demand for computational resources (15-30 GB of VRAM) makes them impossible to deploy on the power-efficient, cost-effective edge hardware used in mobile robots. This creates a significant bottleneck, preventing the widespread adoption of advanced AI in physical systems. The urgency to solve this now is driven by the rapid evolution of AI from digital chatbots to physical agents. A standardized, performant, and reliable solution is needed to bridge this gap.

### 1.3. Strategic Goals

1. **Achieve Real-Time Edge Performance:** Systematically reduce the model's footprint and latency through profiling, quantization, pruning, and TensorRT tuning to meet the strict performance targets (≥3 Hz, ≤6 GB VRAM) on the Jetson Orin Nano.
1. **Ensure Production-Grade Reliability:** Deliver a robust, containerized solution that passes extensive stress testing (72-hour stability) and is supported by a full CI/CD pipeline for reproducible builds and deployments.
1. **Preserve Task-Specific Accuracy:** Utilize LoRA fine-tuning to recover any performance degradation from the optimization process, ensuring the final model maintains high accuracy (≤4% drop) on its core robotics tasks.
1. **Deliver Measurable Business Value:** Create a solution that directly reduces the Total Cost of Ownership (TCO) for customers by 30% and accelerates their development-to-deployment cycle by 50%.
1. **Establish a Scalable Optimization Framework:** Build an automated, end-to-end pipeline that is not a one-off solution but a reusable platform for efficiently optimizing and deploying future VLA models to various edge devices.

---

## 2. User Personas & Journeys

### 2.1. Key End-User Scenario

_A warehouse logistics operator needs to re-route a package. They speak into their headset: "Robbie, pick up that blue parcel from bin 7 and move it to the inspection area." A nearby robotic arm, powered by the OpenVLA model optimized with this framework, instantly swivels, identifies the correct parcel, grasps it, and smoothly transports it to the designated area. The interaction is fluid and immediate, with no perceptible lag between the command and the action._

### 2.2. Engineering User Journeys

1. **The ML Engineering Team - "End-to-End Model Optimization":** The team uses the framework's automated scripts to profile, quantize, prune, and apply LoRA adapters to a new VLA model, resulting in a validated, low-latency TensorRT engine.
2. **The Embedded Systems Engineer - "On-Target Integration and Validation":** The engineer deploys the TensorRT engine in a container on a physical Jetson device, integrates it with a ROS 2 application, and validates that the on-device performance meets the strict NFRs.
3. **The DevOps Engineer - "Automating the Release Pipeline":** The engineer configures the CI/CD pipeline to automatically build, test (with security scans and smoke tests), sign, and publish a new version of the inference container to the artifact registry.
4. **The QA Engineer - "Ensuring Production Stability":** The engineer executes the 72-hour stress test suite against a release candidate, using tools like Nsight Systems to monitor for performance regressions or stability issues before approving a production rollout.

---

## 3. Requirements

### 3.1. Functional Requirements

#### **Deliverable: Optimized OpenVLA Variants**

1. **FR-1 (Quantization):** The system shall produce an INT4 quantized version of a baseline VLA model using TensorRT + CUTLASS kernels, while also generating FP8/FP16 fallbacks when INT4 accuracy falls outside agreed thresholds.
2. **FR-2 (Sparsity):** The system shall use the NVIDIA TensorRT Model Optimizer to produce a 2:4 structured sparsity version of a baseline VLA model.
3. **FR-3 (LoRA Adaptation):** The system shall apply a specified LoRA adapter to any VLA model variant to produce a task-specific, fine-tuned version.
4. **FR-4 (Variant Combination):** The system shall be able to combine the above optimizations.

#### **Deliverable: TensorRT Engine Binaries**

1. **FR-5 (Cloud Engine):** The system shall compile any optimized model variant into a TensorRT engine compatible with a specified cloud GPU architecture.
1. **FR-6 (Jetson Engine):** The system shall compile any optimized model variant into a TensorRT engine compatible with the NVIDIA Jetson Orin Nano Super.
1. **FR-7 (Custom Kernels):** The system shall allow the integration of custom CUTLASS kernels into the TensorRT engine build process.

#### **Deliverable: Performance Reports**

1. **FR-8 (Baseline Report):** The system shall generate a baseline performance report for an unoptimized model.
1. **FR-9 (Optimization Report):** The system shall generate a comparative report detailing the performance of an optimized model variant against the baseline.
1. **FR-10 (Stress Test Report):** The system shall generate a stability report after a long-duration stress test.

#### **Deliverable: Automated Scripts and Docker Containers**

1. **FR-11 (Reproducible Pipeline):** The system shall provide a set of automated scripts that execute the end-to-end optimization pipeline.
1. **FR-12 (Inference Container):** The system shall package a specified TensorRT engine into a Docker container that exposes a ROS 2 and gRPC inference endpoint.
1. **FR-13 (Container Security):** The inference container shall include a generated SBOM and be cryptographically signed.
1. **FR-14 (CI/CD Automation):** The entire process of building, testing, and packaging the inference container shall be automated in a CI/CD pipeline.

#### **Deliverable: Deployment Guide and Integration Examples**

1. **FR-15 (Deployment Documentation):** The project shall include a comprehensive deployment guide.
1. **FR-16 (ROS 2 Example):** The project shall provide a sample ROS 2 application demonstrating integration.
1. **FR-17 (Power Management):** The documentation shall provide instructions on configuring the Jetson's "Super Mode".

### 3.2. Non-Functional Requirements

#### **Performance**

- **NFR-1 (Throughput):** The system must achieve a sustained inference throughput of at least 3 Hz.
- **NFR-2 (Latency):** The p95 inference latency must not exceed 330 ms.
- **NFR-10 (Sparsity Performance):** The application of 2:4 structured sparsity must yield a throughput gain of at least 15% over the baseline for applicable models.
- **NFR-11 (Control Fallback):** The deployment must implement a “repeat last action” safeguard when inference deadlines are missed, with telemetry for replay counts.

#### **Resource Consumption**

- **NFR-3 (VRAM Footprint):** Total VRAM usage shall not exceed 6 GB (FP8/FP16 fallback).
- **NFR-4 (Power Draw):** Nominal power consumption shall not exceed 25 W in Super Mode.
- **NFR-5 (VRAM Stretch Goal):** With INT4 optimizations (primary path), the target VRAM usage should be ≤5 GB.

#### **Accuracy**

- **NFR-6 (Accuracy Retention):** The task accuracy of the optimized model must be ≥97% of the baseline.

#### **Reliability & Stability**

- **NFR-7 (Long-Run Stability):** The system must operate without fatal crashes for a minimum of 24 hours.
- **NFR-8 (Reliability):** The system must achieve a pass rate of ≥95% on 72-hour reliability tests.

#### **Compatibility**

- **NFR-9 (Platform Compatibility):** The software stack must be validated on NVIDIA Jetson Orin Nano Super with JetPack 6.2.1.

### 3.3. Developer Experience (DX) Principles

This project will adhere to a strict set of DX principles focused on managing cognitive overload and risk, including: modular onboarding layers, declarative "tuning bundle" manifests, automated compatibility gate checks, interactive wizards, automated profiling summaries, preflight safety nets, version-locked artifacts, and risk-scored task lists.

### 3.4. Acceptance Criteria Examples

All features and stories derived from this PRD must have explicit acceptance criteria. The following format should be used:

**Example for FR-1 (Quantization):**

- **Given** a baseline VLA model and a valid TAO quantization spec file.
- **When** the `openvla-cli quantize` command is executed.
- **Then** a quantized model artifact is successfully created in the `/workspace/intermediate_models/` directory, and a report is generated in `/workspace/reports/`.

---

## 4. Scope & Phasing

### 4.1. Epic Breakdown

The project will be delivered through the following epics:

- **Epic 0: The Foundational Dev & Test Environment**
- **Epic 1: The Core Optimization Engine**
- **Epic 2: The TensorRT & CUTLASS Integration Layer**
- **Epic 3: The LoRA Adaptation & Accuracy Recovery Framework**
- **Epic 4: The Jetson Deployment & ROS 2 Integration Package**
- **Epic 5: The Automated CI/CD & Validation Pipeline**

_(Detailed stories for each epic are located in `epics.md`)_

### 4.2. Out of Scope

- On-device training beyond the application of LoRA adapters.
- Fleet-scale Over-The-Air (OTA) orchestration.
- Fusion with non-camera sensors.

---

## 5. Assumptions, Constraints, and Dependencies

### 5.1. Assumptions

- The project timeline of 16 weeks for the MVP is achievable with the specified 5-person team.
- The target VLA models are architecturally compatible with the planned optimization techniques.
- The NVIDIA JetPack 6.2.1 SDK will be stable and perform as documented.
- On-demand rental of NVIDIA H100/A100 GPUs is available for full fine-tuning stages.

### 5.2. Constraints

- **Budget/Resources:** Development and testing leverage the NVIDIA Jetson DevCloud, spot cloud GPU instances, and on-demand rentals of NVIDIA H100/A100 nodes for full fine-tuning experiments.
- **Hardware:** The primary target hardware is the NVIDIA Jetson Orin Nano Super with a hard VRAM limit of 8 GB.
- **Team Size:** The project team is fixed at 5 engineering roles.
- **R&D Investment:** Additional time is allocated to close the ~5% INT4 accuracy gap via CUTLASS kernel tuning and multi-stage fine-tuning.
- **Physical Hardware Access:** The project has two dedicated, on-site NVIDIA Jetson Orin Nano Super devices available for local development and Hardware-in-the-Loop (HIL) testing. These devices are required for tasks that cannot be performed in the Jetson DevCloud (e.g., long-duration stress testing, tasks requiring root access like `jetson_clocks`).

### 5.2. Risks

- **Jetson DevCloud Limitations:** The Jetson DevCloud environment is time-sliced and does not provide root access, making it unsuitable for certain critical validation tasks like long-run thermal/power profiling and enabling Super Mode via `jetson_clocks`. This necessitates the use of dedicated physical hardware.

---

## 6. Security

Security is a core requirement for this project. All development must adhere to the principles and checks outlined in the project's official security document.

**Reference:** [Security Checklist](./docs/security-checklist.md)

---

## Appendix A: Official Benchmarking Suite

To ensure all performance and accuracy NFRs are verifiable, the following benchmarks must be used.

### Baseline Models

| Model Name     | Checkpoint Source           |
| :------------- | :-------------------------- |
| `smolvla-450m` | Hugging Face `blog/smolvla` |
| `openvla-7b`   | `openvla/openvla-7b`        |

### Datasets

| Benchmark       | Dataset                 | Task                                                                                                                                 |
| :-------------- | :---------------------- | :----------------------------------------------------------------------------------------------------------------------------------- |
| **Accuracy**    | RoboVQA                 | Visual Question Answering for Robotics                                                                                               |
| **Accuracy**    | VLA-Bench               | A suite of common manipulation and navigation tasks                                                                                  |
| **Performance** | Internal Robotics Suite | A collection of representative, high-framerate video sequences for latency/throughput and **Model FLOPS Utilization (MFU)** testing. |

---

---

## Artifact 3: Epics

### File: `/Users/kieranlal/workspace/BMAD-METHOD/epics.md`

---

---

## Epics for OpenVLA Edge Optimization Framework

**Status:** Draft

---

This document breaks down the high-level epics for the project into more detailed user stories.

## Epic 0: The Foundational Dev & Test Environment

**Owner:** DevOps Lead
**Milestone:** Weeks 1-2
**MVP Scope:** Deliver a version-locked base container and a documented process for accessing the Jetson DevCloud. This is a blocker for all other epics.

**Goal:** To establish a stable, version-locked, and accessible development environment using the NVIDIA Jetson DevCloud and necessary cloud GPU resources.

**Stories:**
...

---

## Epic 1: The Core Optimization Engine

**Owner:** ML Lead
**Milestone:** Weeks 3-6
**MVP Scope:** Implement the `profile`, `quantize`, and `prune` CLI commands. Must support INT8 PTQ and 2:4 sparsity.

**Goal:** To build the foundational, scriptable pipeline for model profiling, quantization, and pruning.

### Stories (to be defined)

---

## Epic 2: The TensorRT & CUTLASS Integration Layer

**Owner:** ML Lead
**Milestone:** Weeks 7-10
**MVP Scope:** Implement the `build` command to generate TensorRT engines for both cloud and Jetson. **CUTLASS integration for key GEMM hotspots is a core requirement for the MVP.**

**Goal:** To compile optimized models into high-performance TensorRT engines with custom kernels.

**Stories:**

- **Story 2.1:** As an ML Engineer, I want to use the `openvla-cli build` command to compile a quantized model into a TensorRT engine so that I can create a deployable artifact.
- **Story 2.2:** As an ML Engineer, I want the build process to generate an operator compatibility matrix so that I can identify which operations require custom plugins or fallbacks.
- **Story 2.3 (CUTLASS):** As an ML Engineer, I want to build a CUTLASS autotuning harness so that I can identify the most performant kernels for our target GEMM shapes on both cloud and Jetson hardware.
- **Story 2.4 (CUTLASS):** As an ML Engineer, I want to set up a cross-compilation pipeline for the CUTLASS kernels so that I can build the AArch64 `.so` library from an x86_64 build machine.
- **Story 2.5 (CUTLASS):** As a QA Engineer, I want to create a regression test that runs on the physical Jetson hardware to verify that the integrated CUTLASS kernels are producing correct results and meeting their performance targets.

---

## Epic 3: The LoRA Adaptation & Accuracy Recovery Framework

**Owner:** ML Engineer
**Milestone:** Weeks 11-12
**MVP Scope:** Implement the `adapt` command and the accuracy evaluation harness. Must be able to apply and validate an existing LoRA adapter.

**Goal:** To provide tools for applying LoRA adapters and validating model accuracy.

### Epic 3 Stories to be defined

---

## Epic 4: The Jetson Deployment & ROS 2 Integration Package

**Owner:** Embedded Lead
**Milestone:** Weeks 13-15
**MVP Scope:** Deliver a containerized ROS 2 inference server that can be run on the Jetson. Must include the on-device acceptance test harness.

**Goal:** To create the containerized, on-device inference service and integrate it with ROS 2.

### Epic 4 Stories to be defined

---

## Epic 5: The Automated CI/CD & Validation Pipeline

**Owner:** DevOps Lead
**Milestone:** Weeks 1-16 (Ongoing)
**MVP Scope:** A CI pipeline that runs on every PR. A release pipeline that can build, test, and publish a signed container.

**Goal:** To build the end-to-end automation for building, testing, and releasing the system.

### Epic 5Stories to be defined
