# Corrected BMAD-METHOD Memory Schema

## Overview

This document provides the corrected memory schema aligned with BMAD-METHOD v6 Alpha's actual implementation, based on comprehensive analysis of the existing workflows and data structures.

## Core Memory Entry Structure

```yaml
bmad_memory_entry:
  # Primary Identification
  id: 'bmad-{project_id}-{epic_id}-{story_id}'
  timestamp: '2025-01-12T10:30:00Z'
  version: '6.0.0-alpha'

  # BMAD-Specific Metadata (Corrected)
  bmad_metadata:
    # Workflow State (Actual BMAD values)
    workflow_state: 'implementation' # analysis/planning/solutioning/implementation
    scale_level: 3 # 0-4 from plan-project routing decision
    project_type: 'software' # software/game/web/mobile/etc
    context_type: 'brownfield' # greenfield/brownfield from plan-project

    # Project Management
    project_workflow_file: 'project-workflow-analysis.md'
    current_epic: 'epic-0'
    current_sprint: 'sprint-2'

    # Branch Management (Actual BMAD branches)
    branch: 'v6-alpha' # v6-alpha/main/epic-0-learning-integration
    last_updated: '2025-01-12T10:30:00Z'

  # Work Item Classification (Enhanced)
  work_item:
    type: 'story' # epic/story/task
    hierarchy: 'epic-0.story-6' # BMAD naming convention
    title: 'Implement Cloud-Based Model Profiling'

    # Story Status (Actual BMAD statuses)
    status: 'Ready for Review' # Draft/ContextReadyDraft/In Progress/Ready for Review/Done/Blocked

    # Story Details
    owner: 'ML Engineer'
    priority: 'High' # Critical/High/Medium/Low
    story_points: 21 # Includes learning hours
    estimated_hours: 16
    actual_hours: 18

    # Story Context Integration
    story_context_xml: 'story-context-epic-0.story-6-20250112.xml'
    context_generated_at: '2025-01-12T09:15:00Z'
    context_enhanced_with_memory: true

  # Learning Integration (Enhanced)
  learning_component:
    # Course Integration (BMAD v6 feature)
    courses:
      [
        {
          name: 'Deep Learning Performance Optimization',
          provider: 'NVIDIA DLI',
          duration_hours: 6,
          completed_date: '2025-01-08',
          certificate_obtained: true,
          course_id: 'DLI-PERF-001',
        },
        {
          name: 'Building Transformer-Based Natural Language Processing',
          provider: 'NVIDIA DLI',
          duration_hours: 4,
          completed_date: '2025-01-10',
          certificate_obtained: true,
          course_id: 'DLI-TRANS-002',
        },
      ]

    # Learning Application
    total_learning_hours: 13
    knowledge_applied: 'PagedAttention + FlashAttention implementation'
    learning_effectiveness_rating: 4.5 # 1-5 scale
    learning_impact_description: 'Reduced memory usage by 30% through attention optimization'

  # Evidence & Verification (BMAD Reality)
  verification:
    # Acceptance Criteria (Actual BMAD format)
    acceptance_criteria_met:
      [
        'AC 5.1: Baseline Performance Established on Cloud GPU',
        'AC 5.2: Transformer Architecture Optimization Implemented',
        'AC 5.3: Learning Requirements Completed',
      ]

    # Definition of Done (BMAD checklist)
    definition_of_done_items:
      [
        'All acceptance criteria met',
        'Code reviewed and approved',
        'Tests passing',
        'Documentation updated',
        'Learning components completed',
        'Story context generated',
      ]
    definition_of_done: true

    # Evidence Collection (Realistic approach)
    evidence_links:
      [
        {
          type: 'performance_results',
          path: 'results/cloud_profiling_results.json',
          description: 'Baseline vs optimized performance comparison',
        },
        {
          type: 'code_implementations',
          path: 'src/optimization/attention_layers.py',
          description: 'PagedAttention and FlashAttention implementations',
        },
        { type: 'test_results', path: 'tests/attention_optimization_test.py', description: 'Automated tests for attention optimizations' },
        {
          type: 'learning_certificates',
          path: 'docs/certificates/dli_completion.pdf',
          description: 'NVIDIA DLI course completion certificates',
        },
      ]

    # Validation Methods
    validation_method: 'automated_tests + manual_review + performance_validation'
    validation_date: '2025-01-12T10:00:00Z'
    validated_by: 'Senior Developer + QA Engineer'

  # Technical Context (Enhanced)
  technical_context:
    # Domain Classification
    domain: 'gpu_optimization'
    subdomain: 'attention_mechanisms'
    complexity_level: 'advanced'

    # Technology Stack
    technologies:
      [
        { name: 'TensorRT', version: '10.3', purpose: 'GPU inference optimization' },
        { name: 'CUDA', version: '12.6', purpose: 'GPU programming' },
        { name: 'PyTorch Profiler', version: '2.1', purpose: 'Performance analysis' },
        { name: 'Nsight Systems', version: '2023.4', purpose: 'System profiling' },
      ]

    # Environment Information
    development_environment: 'A5000 (24 GiB VRAM)'
    testing_environment: 'H200 cluster (141 GiB VRAM)'
    target_deployment: 'Jetson Orin Nano Super'

    # Performance Targets (Actual BMAD format)
    performance_targets: { memory_reduction: '30%+', inference_speedup: '2x+', latency_improvement: '40%+', target_slos_met: true }

    # Dependencies (From story-context workflow)
    dependencies:
      {
        'python': { 'version': '3.10', 'packages': ['torch', 'tensorrt', 'cuda-python'] },
        'hardware': { 'gpu_required': true, 'vram_minimum': '24GB', 'cuda_capability': '8.6+' },
      }

  # Story Context Enhancement (BMAD Integration)
  story_context_enhancement:
    # Memory Search Results
    memory_search_performed: true
    search_timestamp: '2025-01-12T09:00:00Z'
    search_query: 'GPU optimization attention mechanisms PagedAttention'

    # Relevant Patterns Found
    relevant_patterns_found:
      [
        {
          pattern_id: 'gpu-attention-optimization-001',
          description: 'PagedAttention implementation for memory efficiency',
          source_epic: 'epic-0',
          success_rate: 0.95,
          applicability_score: 0.9,
        },
        {
          pattern_id: 'memory-bandwidth-optimization-002',
          description: 'FlashAttention for reduced memory bandwidth usage',
          source_epic: 'epic-1',
          success_rate: 0.88,
          applicability_score: 0.85,
        },
      ]

    # Context Enhancement Impact
    context_enhancement_applied: true
    enhancement_quality_rating: 4.2 # 1-5 scale
    developer_feedback: 'Memory patterns from previous stories were highly relevant and saved significant implementation time'

  # Cross-Project Learning (Enhanced)
  knowledge_transfer:
    # Patterns Identified
    patterns:
      [
        {
          name: 'staged_gpu_development_workflow',
          description: 'A5000 validation before H200 deployment',
          success_rate: 0.92,
          reuse_count: 3,
          last_used: '2025-01-10',
        },
        {
          name: 'attention_optimization_pipeline',
          description: 'PagedAttention + FlashAttention implementation sequence',
          success_rate: 0.89,
          reuse_count: 2,
          last_used: '2025-01-12',
        },
        {
          name: 'memory_bandwidth_analysis',
          description: 'Systematic GPU memory bandwidth bottleneck identification',
          success_rate: 0.94,
          reuse_count: 4,
          last_used: '2025-01-11',
        },
      ]

    # Reusable Artifacts
    reusable_artifacts:
      [
        {
          type: 'code_templates',
          path: 'templates/attention_optimization/',
          description: 'PagedAttention and FlashAttention implementation templates',
          reuse_frequency: 'high',
        },
        {
          type: 'benchmark_suites',
          path: 'benchmarks/gpu_profiling/',
          description: 'Standardized GPU performance benchmarking tools',
          reuse_frequency: 'medium',
        },
        {
          type: 'docker_configurations',
          path: 'docker/gpu_optimized/',
          description: 'GPU-optimized Docker configurations for A5000/H200',
          reuse_frequency: 'high',
        },
      ]

    # Lessons Learned (Structured)
    lessons_learned:
      [
        {
          category: 'technical',
          lesson: 'A5000 validation before H200 deployment reduces costs by 90%',
          impact: 'high',
          applicable_projects: ['all_gpu_projects'],
          evidence: 'Cost comparison data in epic-0 story-1',
        },
        {
          category: 'technical',
          lesson: 'PagedAttention critical for memory-bound decode phase',
          impact: 'high',
          applicable_projects: ['llm_optimization', 'vision_models'],
          evidence: 'Performance profiling results showing 40% memory reduction',
        },
        {
          category: 'process',
          lesson: 'Learning component integration improves story completion quality',
          impact: 'medium',
          applicable_projects: ['all_complex_projects'],
          evidence: 'Story quality scores improved from 3.8 to 4.5 average',
        },
        {
          category: 'technical',
          lesson: 'FlashAttention provides 2.3x speedup for attention layers',
          impact: 'high',
          applicable_projects: ['transformer_models', 'attention_mechanisms'],
          evidence: 'Benchmark comparisons in epic-0 story-6',
        },
      ]

  # Retrospective Integration
  retrospective_integration:
    # Epic Retrospective Status
    epic_retrospective_completed: false
    scheduled_retrospective_date: '2025-01-15'

    # Story-Level Learnings (Pre-retrospective)
    story_level_insights:
      [
        {
          insight_type: 'technical_solution',
          description: 'Combined PagedAttention + FlashAttention provides optimal balance',
          confidence_level: 0.9,
        },
        {
          insight_type: 'process_improvement',
          description: 'Learning components should be scheduled before story implementation',
          confidence_level: 0.85,
        },
        {
          insight_type: 'risk_identification',
          description: 'H200 environment access needs better advance planning',
          confidence_level: 0.8,
        },
      ]

    # Pattern Validation
    pattern_validation_results:
      [
        {
          pattern_name: 'staged_gpu_development_workflow',
          validation_result: 'successful',
          performance_improvement: 'Cost reduction of 90%',
          recommended_for_reuse: true,
        },
        {
          pattern_name: 'attention_optimization_pipeline',
          validation_result: 'successful',
          performance_improvement: '2.3x speedup',
          recommended_for_reuse: true,
        },
      ]
```

## Story Status Mapping (Corrected)

```yaml
# Actual BMAD Story Statuses
bmad_story_statuses:
  Draft:
    description: 'Story created but not yet ready for development'
    memory_applicable: false
    context_required: false

  ContextReadyDraft:
    description: 'Story has context XML generated, ready for development'
    memory_applicable: true
    context_required: true

  In Progress:
    description: 'Story currently being implemented by developer'
    memory_applicable: true
    context_required: true
    memory_access_pattern: 'during_implementation'

  Ready for Review:
    description: 'Story implementation complete, ready for review'
    memory_applicable: true
    context_required: false
    memory_access_pattern: 'review_guidance'

  Done:
    description: 'Story completed, reviewed, and accepted'
    memory_applicable: true
    context_required: false
    memory_access_pattern: 'learning_extraction'

  Blocked:
    description: 'Story blocked by dependencies or issues'
    memory_applicable: true
    context_required: false
    memory_access_pattern: 'blocker_resolution'

# Memory Status Mapping
memory_extraction_statuses:
  not_applicable: "Story type doesn't support memory extraction"
  pending: 'Memory extraction queued but not completed'
  in_progress: 'Currently extracting memory from story'
  completed: 'Memory successfully extracted and stored'
  failed: 'Memory extraction failed, requires manual intervention'
  partial: 'Some memory extracted, but incomplete'
```

## Workflow State Integration

```yaml
# BMAD Workflow States with Memory Integration
workflow_state_memory_mapping:
  analysis:
    memory_activities: ['search_similar_project_analysis', 'identify_research_patterns', 'capture_analysis_insights']
    memory_storage: false
    memory_retrieval: true

  planning:
    memory_activities: ['search_similar_planning_patterns', 'identify_estimation_patterns', 'capture_planning_insights']
    memory_storage: false
    memory_retrieval: true

  solutioning:
    memory_activities: ['search_similar_architecture_patterns', 'identify_solution_approaches', 'capture_solution_insights']
    memory_storage: true
    memory_retrieval: true

  implementation:
    memory_activities: ['enhance_story_context', 'provide_implementation_guidance', 'extract_implementation_learnings']
    memory_storage: true
    memory_retrieval: true
```

## Integration Points with BMAD Workflows

```yaml
# Enhanced Story Context Workflow Integration
story_context_memory_integration:
  input_enhancement:
    - search_relevant_patterns_from_memory
    - add_similar_solutions_to_context
    - include_reusable_artifacts

  output_enhancement:
    - add_memory_sources_to_xml
    - include_pattern_confidence_scores
    - provide_implementation_hints

# Enhanced Retrospective Workflow Integration
retrospective_memory_integration:
  analysis_enhancement:
    - search_cross_epic_patterns
    - identify_recurring_anti_patterns
    - compare_performance_against_similar_epics

  output_enhancement:
    - extract_structured_learnings
    - identify_reusable_patterns
    - store_process_improvements

# Enhanced Create Story Workflow Integration
create_story_memory_integration:
  requirement_analysis:
    - search_similar_story_patterns
    - identify_common_acceptance_criteria
    - suggest_proven_task_breakdowns

  estimation_support:
    - find_similar_story_escalation
    - identify_complexity_patterns
    - suggest_learning_components
```

## Memory Search Query Templates

```yaml
# Standardized memory search queries for BMAD workflows
memory_search_templates:
  story_context_enhancement:
    - 'stories in domain {domain} with {technology} implementation'
    - 'patterns for {story_type} in {project_type} projects'
    - 'solutions for {technical_challenge} with {constraints}'
    - 'reusable artifacts for {technology} optimization'

  retrospective_analysis:
    - 'completed epics similar to {epic_domain}'
    - 'patterns from stories with {common_characteristics}'
    - 'process improvements for {identified_issues}'
    - 'cross-project learning in {technical_domain}'

  planning_support:
    - 'story breakdowns for {feature_type} projects'
    - 'estimation patterns for {complexity_level} work'
    - 'risk identification for {technical_approach}'
    - 'resource planning for {technology_stack}'
```

## Error Handling and Fallbacks

```yaml
# Memory access error handling for BMAD integration
memory_error_handling:
  connection_failed:
    fallback: 'Use standard BMAD story-context workflow'
    log_level: 'warning'
    user_notification: 'Memory enhancement unavailable, using standard context'

  search_no_results:
    fallback: 'Continue with standard BMAD workflow'
    log_level: 'info'
    enhancement_level: 'none'

  search_partial_results:
    fallback: 'Use available memory results + standard workflow'
    log_level: 'info'
    enhancement_level: 'partial'

  memory_storage_failed:
    fallback: 'Continue workflow, log for manual intervention'
    log_level: 'error'
    retry_strategy: 'exponential_backoff'

  schema_validation_failed:
    fallback: 'Store minimal memory entry'
    log_level: 'error'
    data_loss_prevention: 'preserve_core_bmad_fields'
```

This corrected schema aligns with BMAD-METHOD's actual implementation while providing the memory enhancement capabilities needed for systematic learning and pattern reuse.
