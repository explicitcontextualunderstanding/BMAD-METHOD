# Technical Specification: The Jetson Deployment & ROS 2 Integration Package

**Date:** 2025-10-06
**Author:** Gemini
**Epic ID:** 4
**Status:** Draft

---

## 1. Overview

This document provides the detailed technical specification for implementing Epic 4: The Jetson Deployment & ROS 2 Integration Package. This epic is responsible for packaging the final, optimized TensorRT engine into a production-ready, containerized inference service for the NVIDIA Jetson Orin Nano Super. **This is an engineering guide, and its recommendations for building slim containers, integrating with ROS 2, and implementing robust monitoring are authoritative.**

## 2. Objectives and Scope

**In-Scope:**

- Developing the `openvla-cli package` command to build the final inference container.
- Creating a slim, secure, and production-ready Docker image.
- Implementing a ROS 2 node and a gRPC server to expose the inference engine's functionality.
- Integrating telemetry hooks using `context7.monitoring`.
- Developing an on-device test harness (`vla_test_pipeline.launch.py`) for acceptance testing.
- Developing an automated, long-duration stress testing suite.
- Implementing container signing as part of the CI/CD release process.

**Out-of-Scope:**

- The optimization of the TensorRT engine itself (handled in Epics 1-3).
- Fleet-wide deployment orchestration (a post-MVP goal).

## 3. System Architecture Alignment

This specification implements the `InferenceServer` and `ContainerBuilder` components from the Solution Architecture. It is the final step in the pipeline, producing the deployable artifact that will be used by the primary user persona, the Robotics Engineer. It directly addresses the NFRs for performance, reliability, and observability.

## 4. Detailed Design

### 4.1. `openvla-cli package` Command

- **Interface:** `openvla-cli package --engine <ENGINE_PATH> --version <VERSION_TAG>`
- **Description:** Builds the final, slim inference container.
- **Backend Logic (`src/openvla_cli/core/packager.py`):**
  1.  **Invoke Docker Build:** The command will execute a `docker buildx build` command, targeting the Dockerfile at `/src/deployment/inference_server/Dockerfile`.
  2.  **Multi-Stage Build:** The Dockerfile **must** be a multi-stage build.
      - A `builder` stage will compile the ROS 2 workspace and gRPC server.
      - The final, slim stage will start from the minimal `nvcr.io/nvidia/l4t-base` image, copy in only the necessary compiled binaries from the `builder` stage, the specified `.plan` engine, and the required runtime libraries (CUDA, cuDNN, TensorRT).
  3.  **Tagging:** The final image will be tagged with the provided version (e.g., `openvla-inference:1.2.0`).

### 4.2. Inference Server Implementation

- **Location:** `/src/deployment/inference_server/`
- **ROS 2 Node:**
  - A C++ or Python ROS 2 node that subscribes to an input topic for inference requests.
  - It will use the TensorRT Python/C++ API to execute inference on the loaded `.plan` engine.
  - It will publish results to an output topic.
  - DDS settings will be tuned for low latency (e.g., FastRTPS).
- **gRPC Server:**
  - A Python gRPC server that exposes the same inference functionality over a localhost gRPC service.
- **Entrypoint Script (`entrypoint.sh`):**
  1.  **Enable Super Mode:** The script must execute `sudo jetson_clocks` to maximize performance.
  2.  **Launch Services:** It will then launch both the ROS 2 node and the gRPC server.

### 4.3. Control-Plane Fallback (“Repeat Last Action”)

- **Purpose:** Mitigate frame drops when inference misses the control loop deadline (as observed by Dusty).
- **Implementation:**
  - Maintain a shared memory buffer for the latest valid action.
  - If a new action is not produced within the 330 ms p95 window, re-emit the buffered action and log an `action_replay=true` telemetry event.
  - Provide configurable cap on consecutive replays (default=3) before escalating an alert via ROS 2 diagnostic topic.
- **Testing:** A unit test (`tests/repeat_action_test.py`) will simulate delayed inference to confirm fallback behavior.

### 4.4. Telemetry and Monitoring

- **Instrumentation:** The ROS 2 node will be instrumented with the `context7.monitoring` Python API.
- **Metrics:** It will expose key metrics, including GPU utilization, VRAM headroom, and inference latency.
- **Alerting:** Alert thresholds (e.g., GPU temp > 85°C) will be defined in a configuration file (`/configs/alerts.yaml`).

### 4.5. Test and Stress Harness

- **Acceptance Test (`tests/acceptance_harness.py`):**
  - A Python script that uses the ROS 2 client library to send a test request to the running container and asserts that the response is correct and within the latency budget (p95 ≤ 330ms).
- **ROS 2 Launch File (`vla_test_pipeline.launch.py`):**
  - A ROS 2 launch file that orchestrates the full on-device acceptance test.
- **Stress Test Suite (`tests/stress_test/`):**
  - A containerized application that continuously sends a high volume of inference requests to the inference server for 24-72 hours.
  - It will log all responses and any errors.
  - It will include a watchdog mechanism to detect if the inference server becomes unresponsive and trigger a container restart.

## 5. Non-Functional Requirements

| NFR ID             | Requirement     | Specification                                                                                                   |
| :----------------- | :-------------- | :-------------------------------------------------------------------------------------------------------------- |
| **NFR-1, 2, 3, 4** | **Performance** | The on-device test harness is the authoritative validator for the latency, throughput, VRAM, and power NFRs.    |
| **NFR-7, 8**       | **Reliability** | The long-duration stress test suite is the authoritative validator for the stability and reliability NFRs.      |
| **DX-8**           | **Security**    | The CI/CD pipeline must use Docker Content Trust (Notary) to sign the final container image before publication. |

## 6. Dependencies and Integrations

| Dependency                | Version | Integration Point                               |
| :------------------------ | :------ | :---------------------------------------------- |
| **ROS 2**                 | Humble  | For the primary robotics interface.             |
| **gRPC**                  | Latest  | For the secondary, language-agnostic interface. |
| **`context7.monitoring`** | Latest  | For telemetry and monitoring.                   |
| **Docker Content Trust**  | Latest  | For container image signing.                    |

## 7. Acceptance Criteria (Authoritative)

1.  **AC 4.1:** The `openvla-cli package` command successfully builds a multi-stage, slim Docker image.
2.  **AC 4.2:** When the container is run on a Jetson device, the `vla_test_pipeline.launch.py` acceptance test passes, meeting all performance NFRs.
3.  **AC 4.3:** The stress test suite can run for 24 hours without fatal errors, and the watchdog successfully restarts the container if it hangs.
4.  **AC 4.4:** The CI/CD pipeline automatically signs the container image with Notary before pushing it to the artifact registry.
5.  **AC 4.5:** GPU utilization and memory metrics are successfully pushed to the `context7.monitoring` dashboard during a test run.
6.  **AC 4.6:** The repeat-last-action fallback emits replays during induced latency overruns, respects the replay cap, and raises the corresponding diagnostic alert.

## 8. Test Strategy Summary

The test strategy for this epic is heavily focused on **on-target, end-to-end validation**. The **ROS 2 acceptance test harness** will be the primary tool for verifying functional correctness and performance. The **long-duration stress test suite** will be used to validate reliability and stability. Both of these test suites will be automated and run on the Jetson DevCloud as part of the CI/CD pipeline's release validation stage.
