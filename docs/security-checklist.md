# Security Checklist

**Owner:** Security Lead
**Status:** Proposed

---

This document serves as a high-level security checklist for the OpenVLA project. It is not exhaustive but covers the critical areas that must be addressed as part of the development lifecycle.

## 1. Secrets Management

| Control                  | Requirement                                                      | Automation Hook / Verification                |
| :----------------------- | :--------------------------------------------------------------- | :-------------------------------------------- |
| **No Hardcoded Secrets** | Code must be scanned to ensure no secrets are hardcoded.         | `gitleaks` or similar scanner in CI pipeline. |
| **Secure Storage**       | All secrets required for CI/CD must be stored in GitHub Secrets. | Manual audit of CI workflows.                 |
| **Least Privilege**      | Secrets must be scoped with the minimum required permissions.    | Manual audit of secret scopes.                |

## 2. Dependency Management & Supply Chain

| Control                 | Requirement                                            | Automation Hook / Verification                                    |
| :---------------------- | :----------------------------------------------------- | :---------------------------------------------------------------- |
| **Dependency Scanning** | Scan all third-party libraries for known CVEs.         | `Trivy` or `Grype` scan job in the Release pipeline.              |
| **Pinning**             | All dependencies must be pinned to a specific version. | `pip-audit` or similar tool to check for unpinned deps.           |
| **SBOM Generation**     | An SBOM must be generated for every release artifact.  | `Syft` job in the Release pipeline.                               |
| **Image Signing**       | All released container images must be signed.          | `cosign sign` or `docker trust sign` job in the Release pipeline. |

## 3. Data Handling

| Control                 | Requirement                                   | Automation Hook / Verification         |
| :---------------------- | :-------------------------------------------- | :------------------------------------- |
| **Data Classification** | Data used for testing must be classified.     | Manual review of test data.            |
| **No Sensitive Data**   | The application must not log sensitive data.  | Static analysis rule in linter config. |
| **Secure Transport**    | Data transmitted over a network must use TLS. | N/A (Inference server is localhost).   |

## 4. Secure Development & Deployment

| Control          | Requirement                                               | Automation Hook / Verification              |
| :--------------- | :-------------------------------------------------------- | :------------------------------------------ |
| **Threat Model** | A basic threat model should be created and reviewed.      | Manual review.                              |
| **Code Review**  | All code must be reviewed by at least one other engineer. | Enforced by GitHub branch protection rules. |

## 5. Jetson-Specific Hardening

| Control                   | Requirement                                                                                                                                                        | Automation Hook / Verification                                       |
| :------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------- |
| **Limited Sudo Policy**   | The user running the profiler tools must have a limited, audited `sudo` policy that only allows access to required commands (e.g., `jetson_clocks`, `tegrastats`). | Manual configuration on the physical Jetson test hardware.           |
| **Rootless Container**    | The final `openvla-inference` container must run as a non-root user.                                                                                               | `USER` directive in the production Dockerfile. Verified by CI check. |
| **AppArmor Profile**      | A baseline AppArmor profile should be defined to restrict the container's capabilities at the kernel level.                                                        | Manual configuration on the physical Jetson test hardware.           |
| **Signed Kernel Modules** | If custom kernel modules are used, they must be signed.                                                                                                            | N/A for MVP.                                                         |
