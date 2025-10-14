# CI/CD Pipeline Strategy

**Owner:** DevOps Lead
**Status:** Approved

---

This document outlines the revised, two-track CI/CD strategy for the OpenVLA project. This approach is designed to provide fast feedback on Pull Requests while ensuring that all release artifacts are rigorously validated on physical hardware.

## Track 1: Lightweight Pull Request (PR) Checks

This pipeline runs on **every PR** targeting the `main` branch. It is designed to be fast (under 10 minutes) and to run on standard cloud-based runners.

**Required Gates:**

1.  **Linting and Static Analysis:** Enforce code style and type safety.
2.  **Unit Tests:** Execute the `pytest` suite for all components.
3.  **Environment Validation:** Verify the version-locked dependencies in the `openvla-dev` container.
4.  **CLI Smoke Test (Emulated):** Run the core `quantize` and `build` commands on a small, synthetic model within the x86_64 container. This is a functional check, not a performance test.
5.  **Build Production Container (x86_64 only):** Build the `openvla-inference` container for the cloud architecture to ensure the build process is not broken.

**Key Principle:** This pipeline **does not** run on physical Jetson hardware. Its purpose is to catch common software errors and integration issues quickly.

## Track 2: Nightly Hardware-in-the-Loop (HIL) Tests

This pipeline runs on a **nightly schedule** (e.g., 2:00 AM) on the `main` branch. It requires a dedicated, physical Jetson Orin Nano Super configured as a self-hosted GitHub Actions runner.

**Jobs:**

1.  **Build Production Container (AArch64):** Cross-compile the `openvla-inference` container for the `linux/arm64` architecture.
2.  **Deploy to Jetson:** Push the container to the on-site Jetson runner.
3.  **Run On-Target Acceptance Tests:** Execute the full ROS 2 acceptance test harness (`vla_test_pipeline.launch.py`) on the Jetson. This validates the performance NFRs (latency, VRAM, etc.).
4.  **Run On-Target CUTLASS Regression:** Execute the CUTLASS kernel regression test suite (from Epic 2) to validate custom kernel performance and correctness.
5.  **Publish Results:** Publish a report of the nightly HIL test results (pass/fail, key performance metrics) to a shared location (e.g., a GitHub Pages site or a Slack channel).

**Key Principle:** This pipeline is the **authoritative gate for Jetson regressions**. A failure in the nightly build indicates a critical issue that must be addressed with high priority. The results of the latest nightly run will be a key release criterion.
