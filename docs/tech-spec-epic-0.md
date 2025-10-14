# Technical Specification: The Foundational Dev & Test Environment (v3)

**Date:** 2025-10-06
**Author:** Gemini
**Epic ID:** 0
**Status:** Approved

---

## 1. Overview

This document provides the detailed technical specification for implementing Epic 0: The Foundational Dev & Test Environment. The primary goal of this epic is to **codify and leverage the pre-existing, version-locked software stack provided by the NVIDIA Jetson DevCloud**. Instead of building the core environment from scratch, this epic focuses on creating a thin, reproducible application layer on top of the official NVIDIA environment, ensuring a seamless and stable workflow for all developers.

## 2. Objectives and Scope

**In-Scope:**

- Provisioning and documenting access to the NVIDIA Jetson DevCloud.
- **Setting up the two dedicated, on-site NVIDIA Jetson Orin Nano Super devices for local development and HIL testing.**
- Developing a project-specific Docker image (`openvla-dev:1.0.0`) that **layers project tooling on top of an official NVIDIA NGC base image**.
- Creating an automated environment validation script that verifies the pre-installed SDK versions on the target platform against the project's explicit requirements.
- Publishing the project's Docker image to the team's artifact registry.
- Creating a comprehensive onboarding guide for developers.

**Out-of-Scope:**

- Installation and management of the core NVIDIA SDKs (CUDA, TensorRT, etc.), as these are provided by the base environment.
- The full CI/CD pipeline logic.

## 3. System Architecture Alignment

This specification implements the **`DevContainer`** and **`Onboarding Docs`** components from the Solution Architecture. The `DevContainer` is defined not as a from-scratch build, but as an extension of a standard, version-matched NVIDIA NGC container, ensuring alignment with the target Jetson DevCloud environment. This epic also covers the setup of the physical hardware required for the Nightly HIL pipeline.

## 4. Detailed Design

### 4.1. Modules and Responsibilities

| Module Name                           | Description                                                    | Key Responsibilities                                                                                                                                                                                                                                                                                                                | Owner           |
| :------------------------------------ | :------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------- |
| **Project Container (`openvla-dev`)** | A Docker image layering project tools on an official NGC base. | - Use the correct NGC base image.<br>- Install project-level dependencies (e.g., `pyproject.toml`).<br>- Copy in project source code.<br>- Be published to the artifact registry.                                                                                                                                                   | DevOps Engineer |
| **Environment Validator**             | An automated test script.                                      | - Verify that all expected SDKs exist in the environment.<br>- Check that their versions match the authoritative list in Section 6.<br>- Fail loudly if there is a mismatch.                                                                                                                                                        | QA Engineer     |
| **Physical HIL Hardware**             | Two dedicated Jetson Orin Nano Super devices.                  | - Configure both devices with JetPack 6.2.1.<br>- Designate one device as the primary HIL runner and configure it as a self-hosted GitHub Actions runner.<br>- Designate the second device for general developer access and manual testing.<br>- Configure the limited `sudo` policy on both devices as per the security checklist. | DevOps Engineer |

### 4.2. Project Container (`openvla-dev`) Specification

The Dockerfile at `/src/deployment/base/Dockerfile` must perform the following:

1.  **Use Official NGC Base Image:** The `FROM` instruction must use the official NVIDIA NGC container that matches the Jetson DevCloud environment (e.g., `nvcr.io/nvidia/l4t-pytorch:r36.2.0-pth2.1-py3`). This is the **single source of truth** for the core stack.
2.  **Install Application-Level Dependencies:** Install only the necessary tools for development, such as `git`, `vim`, and any Python packages defined in `pyproject.toml`.
3.  **Set up Workspace:** Create the user, set the working directory, and copy in the project source code.

## 5. Non-Functional Requirements

| NFR ID    | Requirement                | Specification                                                                                                                                                            |
| :-------- | :------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **NFR-9** | **Platform Compatibility** | The selected NGC base image must be compatible with both `x86_64` (for cloud dev) and `linux/arm64` (for Jetson).                                                        |
| **DX-2**  | **Reproducibility**        | The versions of all application-level packages (e.g., Python libraries) must be pinned. The core stack's reproducibility is inherited from the version-locked NGC image. |

## 6. Dependencies and Integrations (Authoritative)

### 6.1. Provided by the Base Environment (NVIDIA Jetson DevCloud / NGC Image)

The `Environment Validator` script must confirm the presence and exact versions of these components.

| Component                    | Expected Version |
| :--------------------------- | :--------------- |
| **JetPack SDK**              | 6.2.1            |
| **CUDA Toolkit**             | 12.6             |
| **cuDNN**                    | 9.3              |
| **TensorRT**                 | 10.3             |
| **TensorRT-LLM**             | 1.0              |
| **PyTorch**                  | 2.1              |
| **Torch-TensorRT**           | 1.5              |
| **NVIDIA TAO Toolkit**       | 5.0+             |
| **CUTLASS**                  | 4.2.1+           |
| **Python**                   | 3.8–3.10         |
| **Docker Engine**            | 20.10+           |
| **NVIDIA Container Toolkit** | 1.14             |

### 6.2. Installed by the `openvla-dev` Container

- All Python packages specified in `pyproject.toml`.
- System utilities like `git`, `vim`, `htop`.

## 7. Acceptance Criteria (Authoritative)

1.  **AC 0.1:** A team member can successfully SSH into the provisioned Jetson DevCloud instance and the `Environment Validator` script passes when run.
2.  **AC 0.2:** The project Docker image (`openvla-dev:1.0.0`) can be successfully pulled from the artifact registry.
3.  **AC 0.3:** The `Environment Validator` script (`tests/test_environment.py`) is integrated into the CI pipeline and runs successfully on the `openvla-dev` container, confirming that all SDK versions match the table in Section 6.1.
4.  **AC 0.4:** A new team member can follow the `onboarding_guide.md` and successfully set up their local environment to connect to all cloud resources and run the project container within 60 minutes.
5.  **AC 0.5:** The physical Jetson HIL runner is configured, accessible via SSH, and successfully runs a test job from the GitHub Actions pipeline.

## 8. Traceability Mapping

| Acceptance Criterion | Spec Section(s) | Component(s)                                 | Test Idea                                                                          |
| :------------------- | :-------------- | :------------------------------------------- | :--------------------------------------------------------------------------------- |
| **AC 0.1**           | 4.1, 6.1        | `DevCloud Instance`, `Environment Validator` | Manual SSH, then execute `python tests/test_environment.py`.                       |
| **AC 0.2**           | 4.1             | `Project Container`                          | Run `docker pull <registry>/openvla-dev:1.0.0`.                                    |
| **AC 0.3**           | 4.1, 6.1        | `Environment Validator`                      | Automated CI job that runs the test script inside the container.                   |
| **AC 0.4**           | 2               | `Onboarding Docs`                            | Manual walkthrough of the documentation by a new team member.                      |
| **AC 0.5**           | 4.1             | `Physical HIL Runner`                        | Trigger a test CI job that runs a simple `echo` command on the self-hosted runner. |

## 9. Risks, Assumptions, Open Questions

- **Risk:** The NVIDIA Jetson DevCloud base environment is updated, causing a version mismatch with our expectations.
  - **Mitigation:** The `Environment Validator` script in our CI pipeline is the primary defense. It will fail immediately if the underlying environment changes, alerting the team to the mismatch.
- **Assumption:** The NVIDIA Jetson DevCloud provides a stable, version-locked environment as documented.
- **Assumption:** An official NGC base image exists that precisely matches the DevCloud's software stack.

## 10. Test Strategy Summary

The test strategy for this epic is centered on the **`Environment Validator` script**. This automated test is the authoritative check for our foundational dependency contract. It will be run manually for initial setup and automatically in CI for every subsequent change to prevent environment drift.
