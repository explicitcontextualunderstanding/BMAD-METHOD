# Technical Specification: The Automated CI/CD & Validation Pipeline

**Date:** 2025-10-06
**Author:** Gemini
**Epic ID:** 5
**Status:** Draft

---

## 1. Overview

This document provides the detailed technical specification for implementing Epic 5: The Automated CI/CD & Validation Pipeline. This epic is responsible for creating the end-to-end automation that builds, validates, secures, and releases the OpenVLA framework. **This is an engineering guide, and its recommendations for implementing a secure, robust, and traceable CI/CD pipeline are authoritative.** It is the capstone epic that ensures the entire project is production-ready.

## 2. Objectives and Scope

**In-Scope:**

- Developing the main CI pipeline (`.github/workflows/ci.yaml`) for continuous integration.
- Developing the Release pipeline (`.github/workflows/release.yaml`) for publishing versioned artifacts.
- Implementing automated SBOM generation and vulnerability scanning.
- Integrating Docker Content Trust (Notary) for container image signing and verification.
- Automating the execution of the on-device stress and robustness test suite (from Epic 4).
- Creating and maintaining a version-controlled artifact manifest.
- Generating security attestations (in-toto) for each release.
- Executing hardware-in-the-loop (HIL) nightly pipelines on dedicated Jetson hardware.
- Ingesting multi-stage tuning artifacts (LoRA rank sweep reports, full fine-tune summaries) and surfacing them as release evidence.

**Out-of-Scope:**

- The development of the core application logic or the test suites themselves (these are handled in other epics).
- Management of the underlying CI/CD runner infrastructure.

## 3. System Architecture Alignment

This specification implements the `CI Pipeline`, `Release Pipeline`, and `StressTester` components from the Solution Architecture. It is the automation layer that orchestrates all other components, moving code from a developer's commit to a validated, signed, and published production artifact.

## 4. Detailed Design

### 4.1. CI Pipeline (`.github/workflows/ci.yaml` - PR Checks)

- **Trigger:** On every `push` to a feature branch or `pull_request` to `main`.
- **Goal:** Provide fast feedback on software correctness (under 10 minutes).
- **Jobs:**
  1.  **Lint & Unit Test:** Run static analysis and `pytest`.
  2.  **Environment Validation:** Run `tests/test_environment.py`.
  3.  **CLI Smoke Test (Emulated):** Run a lightweight, end-to-end test of the CLI on an x86_64 runner.
  4.  **Build Production Container (x86_64):** Ensure the production container builds for the cloud architecture.

### 4.2. Nightly HIL Pipeline (`.github/workflows/nightly.yaml` - Hardware-in-the-Loop)

- **Trigger:** On a nightly schedule against the `main` branch.
- **Goal:** Provide authoritative validation of performance and correctness on real Jetson hardware.
- **Runner:** Requires a self-hosted GitHub Actions runner on a dedicated Jetson Orin Nano Super.
- **Jobs:**
  1.  **Build & Deploy:** Cross-compile the `openvla-inference` container for `linux/arm64` and deploy it to the Jetson runner.
  2.  **On-Target Acceptance Test:** Execute the ROS 2 acceptance test harness (`vla_test_pipeline.launch.py`).
  3.  **On-Target CUTLASS Regression:** Run the CUTLASS kernel regression tests.
  4.  **Multi-Stage Tuning Evidence:** Pull the latest tuning reports from `/workspace/reports/` (rank sweep, full fine-tune comparison) and attach them to the workflow summary.
  5.  **Publish Results:** Publish a report of the test results.

### 4.3. Release Pipeline (`.github/workflows/release.yaml`)

- **Trigger:** On a manual `workflow_dispatch` event with a version number.
- **Jobs:**
  1.  **Gate:** The release can only proceed if the latest nightly HIL test was successful.
  2.  **Build & Sign:** Build the multi-arch `openvla-inference` container, generate the SBOM, and sign it with Docker Content Trust.
  3.  **Publish:** Push the signed container to the artifact registry.
  4.  **Update Manifest:** Update and commit the `/configs/artifact-manifest.yaml`.
  5.  **Generate Attestations:** Create and publish the in-toto attestations for the release.

### 4.4. Artifact Manifest (`/configs/artifact-manifest.yaml`)

- A version-controlled YAML file that serves as the single source of truth for all released artifacts.
- **Schema:**
  ```yaml
  releases:
    - version: v1.2.1
      digest: sha256:...
      sbom_path: /path/to/sbom.json
      attestation_path: /path/to/attestation.json
      context7_agent_version: 1.5.0
      log_retention_policy: 7-days
  ```

### 4.4. Documentation

- **Deployment Guide (`/docs/deployment_guide.md`):** A comprehensive guide detailing host prerequisites, how to verify image signatures, and rollback procedures.
- **Troubleshooting Runbooks (`/docs/runbooks/`):** A collection of Markdown files for diagnosing common failures (e.g., `sbom_mismatches.md`, `signature_verification_failures.md`).

## 5. Non-Functional Requirements

| NFR ID    | Requirement         | Specification                                                                                                                   |
| :-------- | :------------------ | :------------------------------------------------------------------------------------------------------------------------------ |
| **DX-8**  | **Security**        | The release pipeline must enforce SBOM policy checks and signature verification. No unsigned artifact should ever be published. |
| **DX-2**  | **Reproducibility** | The entire release process must be fully automated and deterministic. A manual release is not permitted.                        |
| **NFR-8** | **Reliability**     | The on-target validation job is the final gatekeeper for this NFR.                                                              |

## 6. Dependencies and Integrations

| Dependency                      | Version   | Integration Point                                                          |
| :------------------------------ | :-------- | :------------------------------------------------------------------------- |
| **GitHub Actions**              | Latest    | The core CI/CD platform.                                                   |
| **`Syft`**                      | Latest    | For SBOM generation.                                                       |
| **`Trivy` / `Grype`**           | Latest    | For vulnerability scanning.                                                |
| **Docker Content Trust**        | Latest    | For image signing and verification.                                        |
| **`in-toto`**                   | Latest    | For generating security attestations.                                      |
| **Rented NVIDIA GPU Instances** | On-demand | For validating cloud fine-tune artifacts referenced during release gating. |

## 7. Acceptance Criteria (Authoritative)

1.  **AC 5.1:** A push to a feature branch successfully triggers the `ci.yaml` workflow, and it passes.
2.  **AC 5.2:** A manual dispatch of the `release.yaml` workflow successfully builds, tests, signs, and publishes a new versioned container image.
3.  **AC 5.3:** The release pipeline automatically fails if the vulnerability scan detects a high-severity CVE.
4.  **AC 5.4:** The release pipeline automatically fails if the on-target stress test does not meet the required performance and stability NFRs.
5.  **AC 5.5:** After a successful release, the `/configs/artifact-manifest.yaml` file is automatically updated and committed to the repository.
6.  **AC 5.6:** Nightly HIL runs publish hardware metrics and attach the latest multi-stage tuning reports; releases are blocked if the evidence is missing or stale (>7 days).

## 8. Test Strategy Summary

The test strategy for this epic is the pipeline itself. The CI pipeline acts as a regression test for the entire system on every commit. The Release pipeline is the final, comprehensive end-to-end test that validates every aspect of the project, from performance to security, before an artifact is made available to users.
