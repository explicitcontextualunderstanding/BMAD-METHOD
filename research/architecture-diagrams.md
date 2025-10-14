# OpenVLA Edge Optimization Framework - Architecture Diagrams

**Version:** 1.0
**Date:** 2025-10-08
**Status**: Architecture Visualizations

---

## Overview

This document contains comprehensive architecture diagrams using Mermaid syntax to visually represent the OpenVLA Edge Optimization Framework architecture, complementing the written solution architecture documents.

---

## 1. High-Level System Architecture

```mermaid
graph TB
    subgraph "BMAD Engineering Framework (Internal)"
        BMAD[BMAD Methodology]
        Build[Build Phase]
        Measure[Measure Phase]
        Analyze[Analyze Phase]
        Decide[Decide Phase]

        BMAD --> Build
        Build --> Measure
        Measure --> Analyze
        Analyze --> Decide
        Decide --> BMAD
    end

    subgraph "OpenVLA Product Architecture"
        subgraph "Optimization Pipeline"
            Profiling[Profiling Layer]
            Quantization[Quantization Layer]
            Pruning[Pruning Layer]
            LoRA[LoRA Adaptation Layer]
            TensorRT[TensorRT Build Layer]
            Validation[Validation Layer]
            Containerization[Containerization Layer]

            Profiling --> Quantization
            Quantization --> Pruning
            Pruning --> LoRA
            LoRA --> TensorRT
            TensorRT --> Validation
            Validation --> Containerization
        end

        subgraph "Product Deliverable"
            OptimizedModel[Optimized VLA Model]
            Container[Production Container]
            ROS2[ROS 2 Interface]
            gRPC[gRPC Interface]
            Health[Health Monitoring]

            Container --> OptimizedModel
            Container --> ROS2
            Container --> gRPC
            Container --> Health
        end

        subgraph "Edge Deployment"
            Jetson[Jetson Orin Nano]
            Robot[Robot System]

            Container --> Jetson
            ROS2 --> Robot
        end
    end

    Build -.-> Profiling
    Measure -.-> Validation
    Analyze -.-> OptimizedModel
    Decide -.-> Container

    classDef bmad fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef pipeline fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef product fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef deployment fill:#fff3e0,stroke:#e65100,stroke-width:2px

    class BMAD,Build,Measure,Analyze,Decide bmad
    class Profiling,Quantization,Pruning,LoRA,TensorRT,Validation,Containerization pipeline
    class OptimizedModel,Container,ROS2,gRPC,Health product
    class Jetson,Robot deployment
```

---

## 2. Detailed Optimization Pipeline Flow

```mermaid
flowchart TD
    Start([Start Optimization]) --> LoadConfig[Load Optimization Manifest]
    LoadConfig --> ValidateConfig{Validate Configuration}

    ValidateConfig -->|Valid| LoadModel[Load Source Model]
    ValidateConfig -->|Invalid| Error[Configuration Error]

    LoadModel --> Profile[Profile Model]
    Profile --> ProfileReport{Generate Profile Report}

    ProfileReport --> ProfilingMetrics[Collect Baseline Metrics]
    ProfilingMetrics --> Quantize[Apply Quantization]

    Quantize --> QuantCheck{Quantization Quality}
    QuantCheck -->|Pass| Prune[Apply Structured Pruning]
    QuantCheck -->|Fail| FallbackPrec[Use Fallback Precision]
    FallbackPrec --> Prune

    Prune --> PruneCheck{Pruning Success}
    PruneCheck -->|Pass| LoRA[Apply LoRA Adaptation]
    PruneCheck -->|Fail| SkipPrune[Skip Pruning]
    SkipPrune --> LoRA

    LoRA --> BuildEngine[Build TensorRT Engine]
    BuildEngine --> BuildCheck{Engine Build Success}
    BuildCheck -->|Pass| ValidateFinal[Final Validation]
    BuildCheck -->|Fail| OptimizeKernels[Optimize CUTLASS Kernels]
    OptimizeKernels --> BuildEngine

    ValidateFinal --> FinalCheck{Final Validation}
    FinalCheck -->|Pass| Package[Package Container]
    FinalCheck -->|Fail| Rollback[Rollback to Previous Stage]

    Rollback --> ValidateFinal
    Package --> Success([Optimization Complete])
    Error --> End([Process Failed])
    Success --> End

    classDef process fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef decision fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef error fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef success fill:#e0f2f1,stroke:#00695c,stroke-width:2px

    class LoadConfig,LoadModel,Profile,ProfilingMetrics,Quantize,Prune,LoRA,BuildEngine,ValidateFinal,Package process
    class ValidateConfig,QuantCheck,PruneCheck,BuildCheck,FinalCheck decision
    class Error,Rollback error
    class Success success
```

---

## 3. Component Interaction Patterns

```mermaid
sequenceDiagram
    participant User as Developer/User
    participant CLI as OpenVLA CLI
    participant Pipeline as Optimization Pipeline
    participant Profiler as Profiling Layer
    participant Quantizer as Quantization Layer
    participant Builder as TensorRT Builder
    participant Validator as Validation Layer
    participant Container as Container Builder
    participant Registry as Model Registry
    participant Storage as Artifact Storage
    participant Monitoring as Monitoring System

    User->>CLI: openvla optimize --manifest config.yaml
    CLI->>Pipeline: Create pipeline from manifest
    CLI->>Registry: Load source model
    Registry-->>CLI: Return model metadata
    CLI->>Pipeline: Start optimization

    Pipeline->>Profiler: Profile model
    Profiler->>Monitoring: Record profiling metrics
    Profiler->>Storage: Store profiling results
    Storage-->>Profiler: Acknowledge
    Profiler-->>Pipeline: Return profile report

    Pipeline->>Quantizer: Quantize model
    Quantizer->>Registry: Load calibration data
    Registry-->>Quantizer: Return calibration data
    Quantizer->>Monitoring: Record quantization metrics
    Quantizer->>Storage: Store quantized model
    Storage-->>Quantizer: Acknowledge
    Quantizer-->>Pipeline: Return quantization result

    Pipeline->>Builder: Build TensorRT engine
    Builder->>Monitoring: Record build metrics
    Builder->>Storage: Store engine artifacts
    Storage-->>Builder: Acknowledge
    Builder-->>Pipeline: Return built engine

    Pipeline->>Validator: Validate optimized model
    Validator->>Monitoring: Record validation metrics
    Validator-->>Pipeline: Return validation result

    Pipeline->>Container: Create deployment package
    Container->>Storage: Store container image
    Storage-->>Container: Acknowledge
    Container-->>Pipeline: Return package info

    Pipeline-->>CLI: Return optimization result
    CLI-->>User: Report optimization status

    Note over Monitoring: Continuous metrics collection throughout process
```

---

## 4. Hardware-Aware Optimization Architecture

```mermaid
graph LR
    subgraph "Target Hardware: Jetson Orin Nano"
        GPU[NVIDIA GPU<br/>8GB VRAM<br/>Ampere Architecture]
        CPU[ARM CPU<br/>8 Cores]
        Memory[System Memory<br/>8GB]
        Power[Power Management<br/>Max 25W]
    end

    subgraph "Hardware-Aware Optimization"
        subgraph "Profiling Stage"
            HWProfile[Hardware Profile]
            MemProfile[Memory Profiling]
            ComputeProfile[Compute Profiling]
            PowerProfile[Power Profiling]
        end

        subgraph "Optimization Decisions"
            Precision[Precision Selection<br/>INT8/FP16/FP8]
            BatchSize[Batch Size<br/>1-8 samples]
            Kernels[Custom Kernels<br/>CUTLASS GEMM]
            Layout[Memory Layout<br/>Optimized for GPU]
        end

        subgraph "Validation"
            PerfTest[Performance Testing<br/>On Target Hardware]
            PowerTest[Power Validation<br/>Under Load]
            ThermalTest[Thermal Testing<br/>Sustained Load]
        end
    end

    subgraph "Optimized Output"
        TensorRT[TensorRT Engine<br/>Hardware Optimized]
        Container[Container Image<br/>Jetson-Optimized]
        Config[Configuration<br/>Hardware-Tuned]
    end

    GPU --> HWProfile
    Memory --> MemProfile
    CPU --> ComputeProfile
    Power --> PowerProfile

    HWProfile --> Precision
    MemProfile --> BatchSize
    ComputeProfile --> Kernels
    PowerProfile --> Layout

    Precision --> TensorRT
    BatchSize --> TensorRT
    Kernels --> TensorRT
    Layout --> TensorRT

    TensorRT --> PerfTest
    TensorRT --> PowerTest
    TensorRT --> ThermalTest

    PerfTest --> Container
    PowerTest --> Container
    ThermalTest --> Container

    TensorRT --> Config
    Container --> Config

    classDef hardware fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef optimization fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef output fill:#e3f2fd,stroke:#1565c0,stroke-width:2px

    class GPU,CPU,Memory,Power hardware
    class HWProfile,MemProfile,ComputeProfile,PowerProfile,Precision,BatchSize,Kernels,Layout optimization
    class PerfTest,PowerTest,ThermalTest,TensorRT,Container,Config output
```

---

## 5. Deployment and Integration Architecture

```mermaid
graph TB
    subgraph "Development/CI Environment"
        Git[Git Repository]
        CI[GitHub Actions]
        Registry[Container Registry]
        Artifacts[Artifact Storage]

        Git --> CI
        CI --> Registry
        CI --> Artifacts
    end

    subgraph "Cloud Platform (Production)"
        subgraph "Kubernetes Cluster"
            subgraph "Control Plane"
                API[API Server]
                Scheduler[Scheduler]
                Controller[Controller Manager]
            end

            subgraph "Worker Nodes"
                Pod1[Optimization Pod 1]
                Pod2[Optimization Pod 2]
                Pod3[Optimization Pod 3]

                GPU1[NVIDIA GPU]
                GPU2[NVIDIA GPU]
                GPU3[NVIDIA GPU]
            end

            subgraph "Services"
                Service[Load Balancer Service]
                Ingress[Ingress Controller]
            end
        end

        subgraph "Data Layer"
            Kafka[Apache Kafka]
            ClickHouse[ClickHouse]
            Redis[Redis Cache]
            Monitoring[Prometheus/Grafana]
        end
    end

    subgraph "Edge Deployment"
        subgraph "Jetson Orin Nano Device"
            subgraph "Container Runtime"
                OpenVLA[OpenVLA Container]
                ROS2[ROS 2 Node]
                Monitor[Health Monitor]
            end

            subgraph "Hardware"
                GPU_Jetson[GPU]
                Sensors[Camera/Sensors]
                Actuators[Robot Actuators]
            end
        end

        subgraph "Robot Integration"
            ROS2_Bridge[ROS 2 Bridge]
            Robot[Robot System]
            Dashboard[Control Dashboard]
        end
    end

    CI --> Pod1
    CI --> Pod2
    CI --> Pod3

    Pod1 --> GPU1
    Pod2 --> GPU2
    Pod3 --> GPU3

    Service --> Pod1
    Service --> Pod2
    Service --> Pod3

    Pod1 --> Kafka
    Pod2 --> Kafka
    Pod3 --> Kafka

    Pod1 --> ClickHouse
    Pod2 --> ClickHouse
    Pod3 --> ClickHouse

    Pod1 --> Redis
    Pod2 --> Redis
    Pod3 --> Redis

    Registry --> OpenVLA
    Artifacts --> OpenVLA

    OpenVLA --> GPU_Jetson
    OpenVLA --> ROS2
    OpenVLA --> Monitor

    ROS2 --> Sensors
    ROS2 --> Actuators

    ROS2 --> ROS2_Bridge
    ROS2_Bridge --> Robot
    Robot --> Dashboard

    Monitor --> Monitoring

    classDef dev fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef cloud fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef edge fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef data fill:#f3e5f5,stroke:#4a148c,stroke-width:2px

    class Git,CI,Registry,Artifacts dev
    class API,Scheduler,Controller,Pod1,Pod2,Pod3,Service,Ingress,GPU1,GPU2,GPU3 cloud
    class OpenVLA,ROS2,Monitor,GPU_Jetson,Sensors,Actuators,ROS2_Bridge,Robot,Dashboard edge
    class Kafka,ClickHouse,Redis,Monitoring data
```

---

## 6. Data Flow and State Management

```mermaid
stateDiagram-v2
    [*] --> ModelLoaded
    ModelLoaded --> Profiling: Start Optimization
    Profiling --> ProfileComplete: Profile Generated

    ProfileComplete --> Quantization: Start Quantization
    Quantization --> QuantizationSuccess: Quantization Complete
    Quantization --> FallbackToFP16: INT8 Failed
    FallbackToFP16 --> QuantizationSuccess: FP16 Complete

    QuantizationSuccess --> Pruning: Start Pruning
    Pruning --> PruningSuccess: Pruning Complete
    Pruning --> SkipPruning: Pruning Failed
    SkipPruning --> PruningSuccess: Continue without Pruning

    PruningSuccess --> LoRAAdaptation: Apply LoRA
    LoRAAdaptation --> LoRASuccess: LoRA Applied
    LoRAAdaptation --> SkipLoRA: LoRA Failed
    SkipLoRA --> LoRASuccess: Continue without LoRA

    LoRASuccess --> TensorRTBuild: Build TensorRT Engine
    TensorRTBuild --> BuildSuccess: Engine Built
    TensorRTBuild --> OptimizeKernels: Build Failed
    OptimizeKernels --> BuildSuccess: Kernels Optimized

    BuildSuccess --> Validation: Validate Model
    Validation --> ValidationSuccess: Validation Passed
    Validation --> ValidationFailed: Validation Failed
    ValidationFailed --> Rollback: Rollback to Previous State
    Rollback --> Validation: Retry Validation

    ValidationSuccess --> Packaging: Package Container
    Packaging --> PackagingComplete: Package Ready
    PackagingComplete --> Deployment: Deploy to Edge
    Deployment --> DeploymentSuccess: Deployed Successfully
    Deployment --> DeploymentFailed: Deployment Failed
    DeploymentFailed --> Deployment: Retry Deployment

    DeploymentSuccess --> Monitoring: Monitor Performance
    Monitoring --> PerformanceOK: Performance Acceptable
    Monitoring --> PerformanceIssue: Performance Degraded
    PerformanceIssue --> Reoptimization: Trigger Reoptimization
    Reoptimization --> Profiling: Start New Optimization Cycle
    PerformanceOK --> Monitoring: Continue Monitoring

    state ModelLoaded {
        [*] --> LoadSourceModel
        LoadSourceModel --> ModelValidated
        ModelValidated --> [*]
    }

    state Profiling {
        [*] --> InitializeProfiler
        InitializeProfiler --> AnalyzeArchitecture
        AnalyzeArchitecture --> MeasureBaseline
        MeasureBaseline --> GenerateProfile
        GenerateProfile --> [*]
    }

    state Monitoring {
        [*] --> CollectMetrics
        CollectMetrics --> AnalyzePerformance
        AnalyzePerformance --> CheckThresholds
        CheckThresholds --> UpdateDashboard
        UpdateDashboard --> [*]
    }
```

---

## 7. Plugin and Extension Architecture

```mermaid
graph TD
    subgraph "Core System"
        Core[OpenVLA Core]
        Registry[Plugin Registry]
        Loader[Plugin Loader]
        Manager[Plugin Manager]
    end

    subgraph "Plugin Interfaces"
        OptInterface[OptimizationPlugin Interface]
        KernelInterface[KernelPlugin Interface]
        ValidatorInterface[ValidatorPlugin Interface]
        MonitorInterface[MonitorPlugin Interface]
    end

    subgraph "Built-in Plugins"
        QuantPlugin[Quantization Plugin]
        PrunePlugin[Pruning Plugin]
        TRTPlugin[TensorRT Plugin]
        ROS2Plugin[ROS 2 Plugin]
    end

    subgraph "Custom Extensions"
        CustomKernel[Custom CUTLASS Kernel]
        CustomOptimizer[Custom Optimizer]
        CustomValidator[Custom Validator]
        CustomMonitor[Custom Monitor]
    end

    subgraph "Plugin Discovery"
        Config[Plugin Config]
        Directory[Plugin Directory]
        AutoDiscovery[Auto-Discovery]
    end

    Core --> Registry
    Registry --> Loader
    Loader --> Manager

    Manager --> OptInterface
    Manager --> KernelInterface
    Manager --> ValidatorInterface
    Manager --> MonitorInterface

    OptInterface --> QuantPlugin
    OptInterface --> CustomOptimizer

    KernelInterface --> CustomKernel
    KernelInterface --> TRTPlugin

    ValidatorInterface --> CustomValidator
    ValidatorInterface --> ROS2Plugin

    MonitorInterface --> CustomMonitor

    Config --> AutoDiscovery
    Directory --> AutoDiscovery
    AutoDiscovery --> Registry

    classDef core fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef interface fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef builtin fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef custom fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef discovery fill:#fce4ec,stroke:#ad1457,stroke-width:2px

    class Core,Registry,Loader,Manager core
    class OptInterface,KernelInterface,ValidatorInterface,MonitorInterface interface
    class QuantPlugin,PrunePlugin,TRTPlugin,ROS2Plugin builtin
    class CustomKernel,CustomOptimizer,CustomValidator,CustomMonitor custom
    class Config,Directory,AutoDiscovery discovery
```

---

## 8. Security Architecture

```mermaid
graph TB
    subgraph "Security Layers"
        subgraph "Application Security"
            Auth[Authentication/Authorization]
            Input[Input Validation]
            Error[Error Handling]
            Logging[Security Logging]
        end

        subgraph "Container Security"
            Image[Image Scanning]
            Runtime[Runtime Protection]
            Network[Network Policies]
            Secrets[Secret Management]
        end

        subgraph "Infrastructure Security"
            IAM[IAM Policies]
            VPC[Network Isolation]
            Encryption[Encryption at Rest]
            Backup[Secure Backups]
        end

        subgraph "Data Security"
            Transit[Encryption in Transit]
            Classification[Data Classification]
            Access[Access Controls]
            Audit[Audit Logging]
        end
    end

    subgraph "Security Controls"
        subgraph "Prevention"
            WAF[Web Application Firewall]
            RBAC[Role-Based Access Control]
            MFA[Multi-Factor Authentication]
            Scanning[Vulnerability Scanning]
        end

        subgraph "Detection"
            SIEM[SIEM Integration]
            Monitoring[Security Monitoring]
            Alerts[Security Alerts]
            Forensics[Forensic Tools]
        end

        subgraph "Response"
            Incident[Incident Response]
            Isolation[Isolation Procedures]
            Recovery[Recovery Plans]
            Communication[Communication Plan]
        end
    end

    Auth --> RBAC
    Input --> WAF
    Image --> Scanning
    Runtime --> Monitoring
    IAM --> MFA
    VPC --> SIEM
    Encryption --> Backup
    Transit --> Access
    Classification --> Audit
    Network --> Alerts
    Secrets --> Forensics
    Error --> Incident
    Logging --> Isolation

    classDef layer fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef control fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef prevention fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef detection fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef response fill:#ffebee,stroke:#c62828,stroke-width:2px

    class Auth,Input,Error,Logging,Image,Runtime,Network,Secrets,IAM,VPC,Encryption,Backup,Transit,Classification,Access,Audit layer
    class WAF,RBAC,MFA,Scanning,SIEM,Monitoring,Alerts,Forensics,Incident,Isolation,Recovery,Communication control
    class WAF,RBAC,MFA,Scanning prevention
    class SIEM,Monitoring,Alerts,Forensics detection
    class Incident,Isolation,Recovery,Communication response
```

---

## 9. Performance Monitoring and Observability

```mermaid
graph LR
    subgraph "Application Metrics"
        OptMetrics[Optimization Metrics]
        PerfMetrics[Performance Metrics]
        ErrorMetrics[Error Metrics]
        ResourceMetrics[Resource Metrics]
    end

    subgraph "System Metrics"
        CPUMetrics[CPU Utilization]
        GPUMetrics[GPU Utilization]
        MemoryMetrics[Memory Usage]
        NetworkMetrics[Network I/O]
        DiskMetrics[Disk I/O]
    end

    subgraph "Business Metrics"
        ModelAccuracy[Model Accuracy]
        Throughput[Inference Throughput]
        Latency[Response Latency]
        SuccessRate[Success Rate]
    end

    subgraph "Collection Layer"
        Prometheus[Prometheus]
        Grafana[Grafana]
        Jaeger[Jaeger Tracing]
        Loki[Log Aggregation]
    end

    subgraph "Alerting Layer"
        AlertManager[AlertManager]
        PagerDuty[PagerDuty]
        Slack[Slack Notifications]
        Email[Email Alerts]
    end

    subgraph "Visualization Layer"
        Dashboards[Performance Dashboards]
        Reports[Automated Reports]
        SLA[SLA Monitoring]
        Trends[Trend Analysis]
    end

    OptMetrics --> Prometheus
    PerfMetrics --> Prometheus
    ErrorMetrics --> Prometheus
    ResourceMetrics --> Prometheus

    CPUMetrics --> Prometheus
    GPUMetrics --> Prometheus
    MemoryMetrics --> Prometheus
    NetworkMetrics --> Prometheus
    DiskMetrics --> Prometheus

    ModelAccuracy --> Prometheus
    Throughput --> Prometheus
    Latency --> Prometheus
    SuccessRate --> Prometheus

    Prometheus --> Grafana
    Prometheus --> AlertManager
    Prometheus --> Jaeger

    AlertManager --> PagerDuty
    AlertManager --> Slack
    AlertManager --> Email

    Grafana --> Dashboards
    Grafana --> Reports
    Grafana --> SLA
    Grafana --> Trends

    Jaeger --> Dashboards
    Loki --> Reports

    classDef metrics fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef system fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef business fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef collection fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef alerting fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef viz fill:#e0f2f1,stroke:#00695c,stroke-width:2px

    class OptMetrics,PerfMetrics,ErrorMetrics,ResourceMetrics metrics
    class CPUMetrics,GPUMetrics,MemoryMetrics,NetworkMetrics,DiskMetrics system
    class ModelAccuracy,Throughput,Latency,SuccessRate business
    class Prometheus,Grafana,Jaeger,Loki collection
    class AlertManager,PagerDuty,Slack,Email alerting
    class Dashboards,Reports,SLA,Trends viz
```

---

## 10. Test Architecture and Quality Assurance

```mermaid
graph TB
    subgraph "Test Pyramid"
        subgraph "Unit Tests (70%)"
            TestUnit1[Component Tests]
            TestUnit2[Function Tests]
            TestUnit3[Method Tests]
            TestUnit4[Mock Tests]
        end

        subgraph "Integration Tests (20%)"
            TestInt1[Service Integration]
            TestInt2[Database Integration]
            TestInt3[API Integration]
            TestInt4[Pipeline Integration]
        end

        subgraph "E2E Tests (10%)"
            TestE2E1[Full Pipeline]
            TestE2E2[User Scenarios]
            TestE2E3[Performance Tests]
            TestE2E4[Security Tests]
        end
    end

    subgraph "Test Infrastructure"
        TestFramework[Pytest Framework]
        TestData[Test Data Management]
        MockServices[Mock Services]
        TestEnv[Test Environments]
    end

    subgraph "Quality Gates"
        CodeCoverage[Code Coverage > 80%]
        PerformanceSLA[Performance SLA]
        SecurityScan[Security Scanning]
        QualityGate[Quality Gate]
    end

    subgraph "CI/CD Integration"
        PRTests[PR Pipeline Tests]
        MergeTests[Merge Pipeline Tests]
        ReleaseTests[Release Pipeline Tests]
        ProdValidation[Production Validation]
    end

    TestUnit1 --> TestFramework
    TestUnit2 --> TestFramework
    TestUnit3 --> TestFramework
    TestUnit4 --> MockServices

    TestInt1 --> TestData
    TestInt2 --> TestData
    TestInt3 --> MockServices
    TestInt4 --> TestEnv

    TestE2E1 --> TestEnv
    TestE2E2 --> TestEnv
    TestE2E3 --> TestEnv
    TestE2E4 --> TestEnv

    TestFramework --> CodeCoverage
    TestData --> PerformanceSLA
    MockServices --> SecurityScan
    TestEnv --> QualityGate

    CodeCoverage --> PRTests
    PerformanceSLA --> MergeTests
    SecurityScan --> ReleaseTests
    QualityGate --> ProdValidation

    classDef unit fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef integration fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef e2e fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef infra fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef gates fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef cicd fill:#e0f2f1,stroke:#00695c,stroke-width:2px

    class TestUnit1,TestUnit2,TestUnit3,TestUnit4 unit
    class TestInt1,TestInt2,TestInt3,TestInt4 integration
    class TestE2E1,TestE2E2,TestE2E3,TestE2E4 e2e
    class TestFramework,TestData,MockServices,TestEnv infra
    class CodeCoverage,PerformanceSLA,SecurityScan,QualityGate gates
    class PRTests,MergeTests,ReleaseTests,ProdValidation cicd
```

---

## Usage Instructions

These Mermaid diagrams can be rendered in various Markdown viewers that support Mermaid, including:

1. **GitHub**: Native support in Markdown files
2. **GitLab**: Built-in Mermaid support
3. **VS Code**: With Mermaid preview extensions
4. **Obsidian**: Built-in Mermaid support
5. **Typora**: Mermaid plugin support
6. **Mark Text**: Built-in Mermaid support

### Online Mermaid Editors:

- [Mermaid Live Editor](https://mermaid.live)
- [Mermaid Diagram Editor](https://mermaid-js.github.io/mermaid-live-editor)

### Integration with Documentation:

These diagrams complement the written architecture documents by providing visual representations of:

- System architecture and component relationships
- Data flow and process flows
- Deployment and infrastructure patterns
- Security and monitoring architectures
- Testing and quality assurance structures

The diagrams follow consistent styling and color-coding to enhance readability and maintain architectural clarity across all visualizations.
