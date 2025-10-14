# BMAD Story Status Mapping and Memory Integration

## Overview

This document provides the correct story status mapping for BMAD-METHOD v6 Alpha, including memory integration points and transition workflows.

## BMAD Story Statuses (v6 Alpha)

```yaml
bmad_story_statuses:
  Draft:
    display_name: 'Draft'
    description: 'Story created but not yet ready for development'
    position_in_workflow: 'beginning'
    memory_applicable: false
    context_required: false
    transition_to: ['ContextReadyDraft']
    transition_from: []
    workflow_triggers: []

  ContextReadyDraft:
    display_name: 'Context Ready Draft'
    description: 'Story has context XML generated, ready for development'
    position_in_workflow: 'pre-development'
    memory_applicable: true
    context_required: true
    transition_to: ['In Progress', 'Blocked']
    transition_from: ['Draft']
    workflow_triggers: ['story-context-completed']

  In Progress:
    display_name: 'In Progress'
    description: 'Story currently being implemented by developer'
    position_in_workflow: 'development'
    memory_applicable: true
    context_required: true
    transition_to: ['Ready for Review', 'Blocked']
    transition_from: ['ContextReadyDraft']
    workflow_triggers: ['dev-story-started']

  Ready for Review:
    display_name: 'Ready for Review'
    description: 'Story implementation complete, ready for review'
    position_in_workflow: 'pre-review'
    memory_applicable: true
    context_required: false
    transition_to: ['Done', 'In Progress', 'Blocked']
    transition_from: ['In Progress']
    workflow_triggers: ['dev-story-completed']

  Done:
    display_name: 'Done'
    description: 'Story completed, reviewed, and accepted'
    position_in_workflow: 'completed'
    memory_applicable: true
    context_required: false
    transition_to: []
    transition_from: ['Ready for Review']
    workflow_triggers: ['review-story-approved']

  Blocked:
    display_name: 'Blocked'
    description: 'Story blocked by dependencies or issues'
    position_in_workflow: 'blocked'
    memory_applicable: true
    context_required: false
    transition_to: ['In Progress', 'ContextReadyDraft']
    transition_from: ['ContextReadyDraft', 'In Progress', 'Ready for Review']
    workflow_triggers: ['blocker-identified', 'correct-course-applied']
```

## Memory Integration by Status

```yaml
memory_integration_by_status:
  Draft:
    memory_activities: []
    storage_activities: []
    retrieval_activities: []
    notes: 'No memory integration - story too early in lifecycle'

  ContextReadyDraft:
    memory_activities:
      - 'search_similar_story_patterns'
      - 'find_relevant_technical_solutions'
      - 'identify_reusable_artifacts'
    storage_activities:
      - 'store_story_metadata'
      - 'record_context_enhancement_applied'
    retrieval_activities:
      - 'retrieve_domain_patterns'
      - 'get_similar_solutions'
    notes: 'Memory enhances story context generation'

  In Progress:
    memory_activities:
      - 'access_implementation_patterns'
      - 'get_blocker_resolution_approaches'
      - 'find_similar_technical_challenges'
    storage_activities:
      - 'track_implementation_decisions'
      - 'record_deviations_from_plan'
    retrieval_activities:
      - 'get_solution_approaches'
      - 'access_troubleshooting_patterns'
    notes: 'Memory provides real-time implementation guidance'

  Ready for Review:
    memory_activities:
      - 'access_review_guidelines'
      - 'find_similar_acceptance_criteria_validation'
      - 'identify_common_review_issues'
    storage_activities:
      - 'record_review_findings'
      - 'store_quality_metrics'
    retrieval_activities:
      - 'get_review_checklists'
      - 'access_quality_standards'
    notes: 'Memory supports quality review process'

  Done:
    memory_activities:
      - 'extract_success_patterns'
      - 'identify_repeatable_processes'
      - 'capture_lessons_learned'
    storage_activities:
      - 'store_complete_story_pattern'
      - 'save_reusable_artifacts'
      - 'record_performance_metrics'
    retrieval_activities: []
    notes: 'Primary memory extraction point'

  Blocked:
    memory_activities:
      - 'find_blocker_resolution_patterns'
      - 'access_similar_issue_resolutions'
      - 'identify_workaround_strategies'
    storage_activities:
      - 'record_blocker_details'
      - 'store_resolution_approach'
    retrieval_activities:
      - 'get_blocker_solutions'
      - 'access_risk_mitigation_patterns'
    notes: 'Memory helps resolve blockers quickly'
```

## Status Transition Workflows

```yaml
status_transitions:
  Draft_to_ContextReadyDraft:
    trigger_workflow: 'story-context'
    conditions:
      - 'story has valid structure'
      - 'acceptance criteria defined'
      - 'tasks mapped to ACs'
    memory_integration:
      - 'enhance story context with relevant patterns'
      - 'add similar solution approaches'
      - 'include reusable artifacts'

  ContextReadyDraft_to_InProgress:
    trigger_workflow: 'dev-story'
    conditions:
      - 'story context XML exists'
      - 'developer capacity available'
      - 'dependencies resolved'
    memory_integration:
      - 'access implementation patterns'
      - 'get technical guidance'
      - 'provide solution approaches'

  InProgress_to_ReadyForReview:
    trigger_workflow: 'review-story (automatic)'
    conditions:
      - 'all acceptance criteria implemented'
      - 'tests written and passing'
      - 'documentation updated'
    memory_integration:
      - 'record implementation approach'
      - 'store technical decisions'
      - 'capture deviations from plan'

  ReadyForReview_to_Done:
    trigger_workflow: 'review-story (approval)'
    conditions:
      - 'review passed without major issues'
      - 'acceptance criteria validated'
      - 'quality standards met'
    memory_integration:
      - 'extract success patterns'
      - 'store complete solution'
      - 'record performance metrics'

  ReadyForReview_to_InProgress:
    trigger_workflow: 'correct-course'
    conditions:
      - 'review identified issues'
      - 'fixes required'
      - 'feedback actionable'
    memory_integration:
      - 'access similar fix patterns'
      - 'get troubleshooting guidance'
      - 'find resolution approaches'

  Any_to_Blocked:
    trigger_workflow: 'blocker-identification'
    conditions:
      - 'impediment identified'
      - 'progress halted'
      - 'external dependency issue'
    memory_integration:
      - 'find blocker resolution patterns'
      - 'access similar issue solutions'
      - 'identify workaround strategies'

  Blocked_to_InProgress:
    trigger_workflow: 'blocker-resolution'
    conditions:
      - 'blocker resolved'
      - 'dependencies unblocked'
      - 'work can continue'
    memory_integration:
      - 'record resolution approach'
      - 'store prevention strategies'
      - 'capture timeline impact'
```

## Memory Access Patterns by Status

```yaml
memory_access_patterns:
  ContextReadyDraft:
    search_queries:
      - 'stories with similar acceptance criteria'
      - 'technical solutions for {domain} challenges'
      - 'reusable artifacts for {technologies}'
    access_frequency: 'once per story'
    cache_duration: 'story_lifecycle'

  In Progress:
    search_queries:
      - 'implementation approaches for {technical_challenge}'
      - 'blocker resolution for {issue_type}'
      - 'similar technical decisions'
    access_frequency: 'as needed during development'
    cache_duration: 'development_session'

  Ready for Review:
    search_queries:
      - 'review guidelines for {domain}'
      - 'common issues in {technology} implementations'
      - 'quality standards for similar work'
    access_frequency: 'once per review'
    cache_duration: 'review_session'

  Done:
    search_queries: []
    access_frequency: 'none (storage only)'
    cache_duration: 'permanent'

  Blocked:
    search_queries:
      - 'resolution patterns for {blocker_type}'
      - 'workaround strategies for {issue_category}'
      - 'similar dependency issues'
    access_frequency: 'until resolution'
    cache_duration: 'blocker_resolution'
```

## Memory Storage Events

```yaml
memory_storage_events:
  story_creation:
    trigger: 'create-story workflow completion'
    data_stored:
      - 'story_metadata'
      - 'acceptance_criteria'
      - 'estimated_complexity'
    status_required: 'Draft'

  context_generation:
    trigger: 'story-context workflow completion'
    data_stored:
      - 'context_enhancement_applied'
      - 'patterns_found'
      - 'reusable_artifacts_identified'
    status_required: 'ContextReadyDraft'

  implementation_progress:
    trigger: 'periodic during dev-story workflow'
    data_stored:
      - 'implementation_decisions'
      - 'technical_challenges_encountered'
      - 'solutions_applied'
    status_required: 'In Progress'

  implementation_completion:
    trigger: 'dev-story workflow completion'
    data_stored:
      - 'final_implementation_approach'
      - 'deviation_from_plan'
      - 'actual_effort_vs_estimated'
    status_required: 'Ready for Review'

  review_completion:
    trigger: 'review-story workflow completion'
    data_stored:
      - 'review_findings'
      - 'quality_metrics'
      - 'approval_status'
    status_required: 'Done'

  story_completion:
    trigger: 'final story approval'
    data_stored:
      - 'complete_story_pattern'
      - 'lessons_learned'
      - 'reusable_artifacts_created'
      - 'performance_achieved'
    status_required: 'Done'

  blocker_occurrence:
    trigger: 'blocker identification'
    data_stored:
      - 'blocker_details'
      - 'impact_assessment'
      - 'resolution_timeline'
    status_required: 'Blocked'

  blocker_resolution:
    trigger: 'blocker resolution'
    data_stored:
      - 'resolution_approach'
      - 'prevention_strategies'
      - 'timeline_recovery'
    status_required: 'In Progress'
```

## Quality Gates and Memory Integration

```yaml
quality_gates:
  Draft_to_ContextReadyDraft:
    memory_enhancement_required: false
    validation_points:
      - 'story structure completeness'
      - 'acceptance criteria clarity'
      - 'task mapping correctness'

  ContextReadyDraft_to_InProgress:
    memory_enhancement_required: true
    validation_points:
      - 'context XML generated successfully'
      - 'memory enhancement applied'
      - 'relevant patterns identified'
    memory_quality_threshold: 0.7 # Minimum relevance score

  InProgress_to_ReadyForReview:
    memory_enhancement_required: false
    validation_points:
      - 'all acceptance criteria implemented'
      - 'tests passing'
      - 'documentation complete'
    memory_usage_tracking: true # Track how memory helped implementation

  ReadyForReview_to_Done:
    memory_enhancement_required: false
    validation_points:
      - 'review passed'
      - 'quality standards met'
      - 'stakeholder acceptance'
    memory_extraction_required: true # Must extract learnings
```

## Error Handling by Status

```yaml
error_handling_by_status:
  Draft:
    memory_errors: 'not_applicable'
    fallback_behavior: 'continue without memory'

  ContextReadyDraft:
    memory_errors:
      - 'search_failed': 'use basic context only'
      - 'schema_mismatch': 'log and continue'
      - 'connection_timeout': 'retry once, then proceed'
    fallback_behavior: 'generate context without memory enhancement'

  In Progress:
    memory_errors:
      - 'search_failed': 'continue with standard BMAD guidance'
      - 'schema_mismatch': 'log and use available data'
      - 'connection_timeout': 'retry with exponential backoff'
    fallback_behavior: 'rely on story context and developer expertise'

  Ready_for_Review:
    memory_errors:
      - 'search_failed': 'use standard review guidelines'
      - 'schema_mismatch': 'log and continue'
      - 'connection_timeout': 'proceed without memory enhancement'
    fallback_behavior: 'standard BMAD review process'

  Done:
    memory_errors:
      - 'storage_failed': 'log for manual intervention'
      - 'schema_mismatch': 'store minimal data'
      - 'connection_timeout': 'queue for retry'
    fallback_behavior: 'mark story complete, schedule memory extraction'

  Blocked:
    memory_errors:
      - 'search_failed': 'use standard blocker resolution process'
      - 'schema_mismatch': 'log and continue'
      - 'connection_timeout': 'retry with urgency'
    fallback_behavior: 'escalate blocker through standard BMAD channels'
```

## Performance Metrics

```yaml
memory_performance_metrics:
  by_status:
    ContextReadyDraft:
      - 'context_enhancement_time_ms'
      - 'patterns_found_count'
      - 'relevance_score_average'
      - 'memory_enhancement_success_rate'

    InProgress:
      - 'memory_access_frequency'
      - 'helpful_suggestions_count'
      - 'implementation_acceleration_factor'
      - 'blocker_resolution_success_rate'

    Ready_for_Review:
      - 'review_guidance_quality_score'
      - 'issue_prevention_success_rate'
      - 'quality_improvement_factor'

    Done:
      - 'pattern_extraction_success_rate'
      - 'knowledge_capture_completeness'
      - 'reuse_value_score'

    Blocked:
      - 'resolution_time_improvement'
      - 'blocker_resolution_success_rate'
      - 'workaround_effectiveness'
```

## Configuration and Customization

```yaml
memory_integration_configuration:
  status_based_settings:
    ContextReadyDraft:
      memory_search_limit: 10
      relevance_threshold: 0.7
      include_cross_project: true

    InProgress:
      memory_search_limit: 5
      relevance_threshold: 0.8
      include_cross_project: false # Focus on similar contexts

    Ready_for_Review:
      memory_search_limit: 3
      relevance_threshold: 0.9
      include_cross_project: false

    Done:
      memory_search_limit: 0 # No search, only storage
      relevance_threshold: N/A
      include_cross_project: false

    Blocked:
      memory_search_limit: 8
      relevance_threshold: 0.6
      include_cross_project: true
```

This comprehensive status mapping ensures proper integration of the memory labeling system with BMAD-METHOD's actual workflow and status management.
