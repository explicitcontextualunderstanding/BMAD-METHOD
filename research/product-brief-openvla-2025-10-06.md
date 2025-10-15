# Product Brief: openvla

**Date:** 2025-10-06
**Author:** User
**Status:** Version 1.0

---

> **DEPRECATION NOTICE**
>
> This Product Brief has been superseded by the **Product Requirements Document (PRD)**. The PRD is the single source of truth for all business goals, user requirements, and success metrics. Please refer to `docs/PRD-openvla.md` for the most current and authoritative information.
>
> ---

## Executive Summary

A fully optimized Vision-Language-Action (VLA) system for autonomous robotics, tuned to run in real time (≥3 Hz) on NVIDIA Jetson Orin Nano Super under JetPack 6.2.1. This project addresses deploying capable VLA models within an 8 GB VRAM and 25 W power envelope by applying quantization, structured sparsity, TensorRT optimization, and parameter-efficient fine-tuning. Targeted at robotics engineering and edge AI platform teams, it delivers reusable containers, inference engines, and automation pipelines—reducing time-to-field by 50 % and inference hardware TCO by 30 %.

The project was sparked by the evolution of LLMs into physical AI, creating a need for easier, language-based interfaces for controlling robotic hardware.

---

## Problem Statement

Modern VLA models (e.g., OpenVLA 7 B, SmolVLA 450 M) demand 15–30 GB GPU memory in standard precisions, making them unsuitable for 8 GB VRAM edge devices. This leads to significant pain points for robotics engineers:

- **Out-of-Memory (OOM) Failures:** Models frequently crash on edge hardware.
- **Latency Spikes:** Inference times are unpredictable and too slow for real-time control loops.
- **Unsupported Operators:** Key model components are not supported by optimization frameworks like TensorRT, requiring slow workarounds.
- **Accuracy Loss:** Naive compression techniques significantly degrade model performance.
- **Integration Complexity:** Integrating these models into ROS 2 pipelines is a complex and time-consuming task.

Existing approaches either offload inference to the cloud—incurring unacceptable latency—or dramatically simplify models to the point where they are no longer capable. A robust, high-performance, on-device VLA is urgently needed to unlock the potential of physical AI.

---

## Proposed Solution

An end-to-end tuning pipeline and deployment framework that adapts reference VLA models for the edge via:

1. **Baseline Profiling & Budgeting:** Establish performance and resource-use baselines.
   **FP8 Quantization as the Primary Path:** The V1.0 MVP will focus on delivering a robust and accurate FP8 quantized model. This provides a significant performance uplift while balancing development risk.
   **INT4 as a Research Spike:** Achieving high accuracy with INT4 quantization is a significant challenge. This will be treated as a formal, time-boxed research spike. If successful, it will be integrated into a future release; otherwise, the project will proceed with FP8 as the primary deliverable.
2. **2:4 Structured Sparsity:** Target supported transformer blocks for pruning.
3. **TensorRT Mixed-Precision Engines:** Create optimized engines with layer fusion.
4. **Multi-Stage Tuning:** Execute on-device LoRA rank sweeps followed by cloud full fine-tuning on rented multi-GPU nodes to reclaim accuracy.
5. **Super Mode Activation:** Utilize Jetson Orin Nano's peak performance mode.
6. **KV-Cache Management:** Implement chunked context to manage memory.
7. **Containerized Deployment:** Deliver the solution in a JetPack 6.2.1-based container.
8. **CUTLASS-Accelerated Kernels:** Use custom kernels for INT4/FP16 hotspots.
9. **Comprehensive Profiling & Stress Testing:** Ensure reliability and performance.
10. **Control Fallback Logic:** Implement a repeat-last-action safeguard when inference deadlines are missed, with diagnostics for replay counts.

---

## Target Users

### Primary User Segment

**Robotics/Autonomy Engineers:** These engineers build and maintain the perception-action loops on mobile robots. They need predictable latency, sufficient VRAM headroom for their own applications, and a simple, reliable integration path with their existing ROS 2 pipelines.

### Secondary User Segment

**Edge AI Platform Teams:** These teams manage the CI/CD pipelines, artifact registries, and fleet telemetry for deployed devices. They need versioned, reproducible inference engines and containers, along with remote monitoring capabilities to ensure fleet health.

---

## Goals and Success Metrics

### Business Objectives

- Reduce edge inference Total Cost of Ownership (TCO) by 30%.
- Cut the development-to-deployment cycle for VLA models by 50%.
- Achieve a 95%+ pass rate on 72-hour reliability stress tests.

### User Success Metrics

- Achieve a throughput of ≥3 Hz at a batch size of 1.
- Maintain peak VRAM usage at ≤6 GB (stretch goal of ≤5 GB with INT4).
- Limit accuracy drop to ≤3% on VLA benchmarks (≤4% in fallback mode).

### Key Performance Indicators (KPIs)

- **Latency:** p50 ≤250 ms, p95 ≤330 ms.
- **VRAM Headroom:** ≥1 GB of VRAM free during operation.
- **Engine Portability:** 100% success rate on target Jetson devices.
- **Robustness:** 0 fatal crashes during 24-hour stress tests.
- **CUTLASS INT4 GEMM Throughput:** ≥18 TFLOPS effective on benchmarked shapes.

---

## Strategic Alignment and Financial Impact

### Financial Impact

The primary financial impact is a significant reduction in TCO for deploying VLA models at the edge. By enabling these models to run on low-power, cost-effective hardware like the Jetson Orin Nano, the solution avoids the need for more expensive, power-hungry GPUs. This is expected to reduce inference hardware TCO by 30%.

### Company Objectives Alignment

This project aligns with the strategic objective of becoming a leader in the emerging field of physical AI by providing a critical enabling technology for robotic control.

### Strategic Initiatives

This work supports the broader company initiative to develop a platform for language-driven robotics.

---

## MVP Scope

### Core Features (Must Have)

- Quantized & mixed-precision TensorRT engines with INT8/FP16 fallback.
- Structured 2:4 sparsity integration.
- LoRA adapters for task-specific fine-tuning.
- Slim JetPack 6.2.1 container spec with CUDA 12.6, cuDNN 9.3, TensorRT 10.3.
- Super Mode & DVFS scripts for performance tuning.
- Automated benchmarking harness for latency, VRAM, power, and accuracy.

### Out of Scope for MVP

- On-device training beyond the application of LoRA adapters.
- Fleet-scale Over-The-Air (OTA) orchestration.
- Fusion with non-camera sensors.

### MVP Success Criteria

- **Fallback Mode (INT8/FP16 Only):** Peak VRAM ≤6 GB, inference latency ≤350 ms (p95), accuracy drop ≤4%, and 24-hour stability on Orin Nano Super with Super Mode enabled.
- **Stretch Goal (with INT4):** Real-world robotics scenario with ≥3 Hz inference, ≤5 GB VRAM, ≤3% accuracy drop, and 24-hour stability.

---

## Post-MVP Vision

### Phase 2 Features

- KV-efficient inference (dynamic cache chunking).
- Deployment on Triton Inference Server with model ensembles.
- Adaptive model switching based on scene complexity.

### Long-term Vision

A comprehensive catalog of edge-ready VLA variants (from 450M to 7B parameters), hardware-aware Neural Architecture Search (NAS), integrated telemetry, and fleet management capabilities.

### Expansion Opportunities

- Support for additional Jetson SKUs (Xavier NX, AGX Orin).
- A marketplace for third-party adapters and fine-tuned models.
- Automated hardware benchmarking and cost-performance modeling services.

---

## Technical Considerations

### Platform Requirements

- **Hardware:** NVIDIA Jetson Orin Nano Super (JetPack 6.2.1).
  **Staged Ampere -> Hopper Workflow:** To manage costs effectively, the project will use a staged GPU strategy. Primary development, profiling, and optimization will be conducted on cost-effective Ampere-architecture GPUs (e.g., A4000/A5000). The more powerful and expensive Hopper-architecture GPUs (e.g., H200) will be reserved for intermittent, time-boxed scale testing and final validation.
- **OS:** Ubuntu 22.04 L4T.
- **Power:** ≤25 W in Super Mode.

### Technology Preferences

- **Frameworks:** PyTorch 2.x, Torch-TensorRT 1.5, NVIDIA TAO 5.x.
- **NVIDIA Stack:** TensorRT 10.3, Triton 3.x, CUDA 12.6, cuDNN 9.3.
- **CI/CD:** GitHub Actions, Docker 20.10+, NVIDIA Container Toolkit 1.14.
- **Profiling:** Nsight Systems, context7.monitoring.
- **Kernels:** CUTLASS v4.2.1+ for custom kernel development.

### Architecture Considerations

- A monorepo structure with `training/`, `conversion/`, and `deployment/` modules.
- A microservice container exposing a ROS 2/gRPC inference API.
- SBOM generation, image signing, and version pinning for security and reproducibility.

---

## Constraints and Assumptions

### Constraints

- **Budget:** NVIDIA Jetson DevCloud, spot cloud GPU instances, and on-demand rentals of NVIDIA H100/A100 nodes for full fine-tuning.
- **Timeline:** 16 weeks to MVP, with an additional 8 weeks for Phase 2.
- **Team:** A 5-person team with expertise in ML, Embedded, DevOps, and QA.
- **Hardware:** A hard limit of 8 GB VRAM and a dependency on JetPack 6.2.1.

### Key Assumptions

- The allocated budget and timeline are sufficient for the MVP.
- The team possesses the required skills to execute the plan.
- The 8 GB VRAM limit is a realistic target for the specified VLA models.
- JetPack 6.2.1 will be stable and available throughout the project.

---

## Risks and Open Questions

### Key Risks

- **Accuracy Regression:** Compression techniques may degrade accuracy beyond acceptable limits.
- **Plugin Gaps:** Unsupported operators in TensorRT could cause CPU fallback and increase latency.
- **Thermal Throttling:** Prolonged use in Super Mode may lead to performance degradation.
- **Integration Jitter:** Real-time scheduling issues with ROS 2 could impact performance.
- **INT4 Behavioral Drift:** Prior experiments (Dusty) showed ~5% accuracy loss with INT4; allocate additional R&D time for CUTLASS kernel tuning and multi-stage fine-tuning to mitigate.

### Open Questions

- Which VLA variant (7B, 1.5B, or 450M) should be the starting point for the MVP?
- What is the availability timeline for the Super Mode firmware?
- What are the precise accuracy metrics (VQA score, instruction success rate, BLEU)?
- What are the priority target GEMM shapes for CUTLASS INT4 kernel optimization?

### Areas Needing Further Research

- Per-layer sensitivity analysis to quantization and pruning.
- Development of custom TensorRT plugin patterns for VLA operators.
- A field telemetry schema to correlate environmental factors with performance.
- Performance profiling of CUTLASS vs. TensorRT kernels across representative GEMM shapes.

---

## Appendices

### C. References

- OpenVLA: <https://arxiv.org/html/2406.09246v2>
- SmolVLA: <https://huggingface.co/blog/smolvla>
- TensorRT Best Practices: <https://docs.nvidia.com/deeplearning/tensorrt/latest/performance/best-practices.html>
- Super Mode: <https://developer.nvidia.com/blog/nvidia-jetpack-6-2-brings-super-mode-to-nvidia-jetson-orin-nano-and-jetson-orin-nx-modules/>

---
