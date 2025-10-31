# Project Workflow Analysis

**Project**: {{project_name}}
**Generated**: {{date}}
**BMAD Version**: v6 Alpha
**Branch**: {{current_branch}}

---

## Scale-Adaptive Routing Results

**Routing Decision**: Level {{scale_level}} ({{scale_level_description}})
**Project Type**: {{project_type}}
**Context**: {{project_context}} (greenfield/brownfield)
**Date Routed**: {{routing_date}}

### Scale Level Justification

{{scale_level_rationale}}

---

## Phase Progress Tracking

### Phase 1: Analysis

**Status**: {{analysis_phase_status}}
**Start Date**: {{analysis_start_date}}
**Completion Date**: {{analysis_completion_date}}

**Completed Workflows**:
{{#each analysis_workflows}}

- [x] {{this.name}} ({{this.completion_date}})
      {{/each}}

**Deliverables**:
{{#each analysis_deliverables}}

- [x] {{this.name}} - {{this.location}}
      {{/each}}

### Phase 2: Planning

**Status**: {{planning_phase_status}}
**Start Date**: {{planning_start_date}}
**Completion Date**: {{planning_completion_date}}

**Completed Workflows**:
{{#each planning_workflows}}

- [x] {{this.name}} ({{this.completion_date}})
      {{/each}}

**Deliverables**:
{{#each planning_deliverables}}

- [x] {{this.name}} - {{this.location}}
      {{/each}}

### Phase 3: Solutioning (Level 3-4 Only)

**Status**: {{solutioning_phase_status}}
**Start Date**: {{solutioning_start_date}}
**Completion Date**: {{solutioning_completion_date}}

**Completed Workflows**:
{{#each solutioning_workflows}}

- [x] {{this.name}} ({{this.completion_date}})
      {{/each}}

**Deliverables**:
{{#each solutioning_deliverables}}

- [x] {{this.name}} - {{this.location}}
      {{/each}}

### Phase 4: Implementation

**Status**: {{implementation_phase_status}}
**Start Date**: {{implementation_start_date}}
**Current Sprint**: {{current_sprint}}

---

## Epic Progress

### Current Epic: {{current_epic_number}} - {{current_epic_title}}

**Status**: {{current_epic_status}}
**Start Date**: {{epic_start_date}}
**Target Completion**: {{epic_target_completion}}

**Stories Progress**:

- Completed: {{completed_stories}}/{{total_stories}} ({{completion_percentage}}%)
- Story Points: {{actual_story_points}}/{{planned_story_points}}
- Average Velocity: {{average_velocity}} points/sprint

**Story Status Breakdown**:
{{#each story_status_breakdown}}

- {{this.status}}: {{this.count}} stories
  {{/each}}

### Epic Queue

{{#each upcoming_epics}}
**Epic {{this.number}}**: {{this.title}}

- Status: {{this.status}}
- Stories: {{this.story_count}}
- Priority: {{this.priority}}
- Dependencies: {{this.dependencies}}
  {{/each}}

---

## Memory Integration Status

### Story Context Enhancement

**Status**: {{story_context_enhancement_status}}
**Last Enhanced**: {{last_context_enhancement_date}}
**Success Rate**: {{context_enhancement_success_rate}}%

**Memory Search Performance**:

- Average Search Time: {{average_memory_search_time}}ms
- Relevant Patterns Found: {{patterns_found_per_search}} avg
- Context Enhancement Impact: {{context_enhancement_impact}}%

### Learning Capture

**Status**: {{learning_capture_status}}
**Last Capture**: {{last_learning_capture_date}}
**Patterns Extracted**: {{total_patterns_extracted}}
**Lessons Learned**: {{total_lessons_learned}}

### Cross-Project Pattern Sharing

**Status**: {{cross_project_sharing_status}}
**Active Patterns**: {{active_cross_project_patterns}}
Pattern Categories:
{{#each pattern_categories}}

- {{this.category}}: {{this.count}} patterns
  {{/each}}

---

## Workflow Performance Metrics

### Story Creation Performance

**Average Time**: {{avg_story_creation_time}} minutes
**Success Rate**: {{story_creation_success_rate}}%
**Quality Score**: {{story_quality_score}}/10

### Story Context Generation

**Average Time**: {{avg_context_generation_time}} minutes
**Relevance Score**: {{context_relevance_score}}/10
**Developer Satisfaction**: {{context_satisfaction_score}}/10

### Review Performance

**Average Review Time**: {{avg_review_time}} hours
**First-Time Pass Rate**: {{first_time_pass_rate}}%
**Review Quality Score**: {{review_quality_score}}/10

### Retrospective Effectiveness

**Action Items Created**: {{retro_action_items_created}}
**Action Items Completed**: {{retro_action_items_completed}}
**Implementation Rate**: {{retro_implementation_rate}}%

---

## Quality Indicators

### Code Quality

- Test Coverage: {{test_coverage_percentage}}%
- Critical Bugs: {{critical_bug_count}}
- Code Review Pass Rate: {{code_review_pass_rate}}%
- Technical Debt Items: {{technical_debt_count}}

### Process Quality

- On-Time Delivery: {{on_time_delivery_rate}}%
- Scope Creep: {{scope_creep_percentage}}%
- Stakeholder Satisfaction: {{stakeholder_satisfaction_score}}/10
- Team Velocity: {{team_velocity}} points/sprint

### Learning Quality

- Pattern Reuse Rate: {{pattern_reuse_rate}}%
- Knowledge Sharing: {{knowledge_sharing_score}}/10
- Innovation Index: {{innovation_index}}/10
- Process Improvements: {{process_improvement_count}}

---

## Risk Assessment

### Current Risks

{{#each current_risks}}
**{{this.severity}}**: {{this.description}}

- Impact: {{this.impact}}
- Probability: {{this.probability}}%
- Mitigation: {{this.mitigation}}
- Owner: {{this.owner}}
  {{/each}}

### Blockers

{{#each current_blockers}}

- [{{this.type}}] {{this.description}} ({{this.age}} days old)
  Impact: {{this.impact}}
  Owner: {{this.owner}}
  ETA: {{this.eta}}
  {{/each}}

---

## Dependencies

### Internal Dependencies

{{#each internal_dependencies}}

- **{{this.source}}** → **{{this.target}}** ({{this.status}})
  {{/each}}

### External Dependencies

{{#each external_dependencies}}

- **{{this.name}}** ({{this.provider}})
  - Status: {{this.status}}
  - Criticality: {{this.criticality}}
  - Next Review: {{this.next_review_date}}
    {{/each}}

---

## Team Capacity

### Current Team Composition

{{#each team_members}}

- **{{this.name}}** ({{this.role}})
  - Availability: {{this.availability}}%
  - Current Assignments: {{this.current_assignments}}
  - Specialization: {{this.specialization}}
    {{/each}}

### Capacity Planning

- **Total Available Hours**: {{total_available_hours}}/sprint
- **Committed Hours**: {{committed_hours}}/sprint
- **Available Buffer**: {{available_buffer_hours}}/sprint
- **Utilization Rate**: {{utilization_rate}}%

---

## Next Steps

### Immediate Actions (This Sprint)

{{#each immediate_actions}}

1. [ ] {{this.action}} (Owner: {{this.owner}}, Due: {{this.due_date}})
       {{/each}}

### Near-Term Planning (Next Sprint)

{{#each near_term_planning}}

1. [ ] {{this.action}} (Owner: {{this.owner}}, Priority: {{this.priority}})
       {{/each}}

### Long-Term Considerations

{{#each long_term_considerations}}

1. {{this.consideration}} (Timeline: {{this.timeline}})
   {{/each}}

---

## Configuration Settings

### BMAD Configuration

- **Project Root**: {{project_root}}
- **Output Folder**: {{output_folder}}
- **Stories Directory**: {{stories_directory}}
- **Templates Directory**: {{templates_directory}}

### Memory Integration Configuration

- **Cipher MCP Server**: {{cipher_server_url}}
- **Memory Schema**: {{memory_schema_version}}
- **Search Threshold**: {{search_similarity_threshold}}
- **Cache Duration**: {{memory_cache_duration}}

### Workflow Configuration

- **Default Branch**: {{default_branch}}
- **Auto-Run Context**: {{auto_run_context_setting}}
- **Non-Interactive Mode**: {{non_interactive_mode}}
- **Story Selection Limit**: {{story_selection_limit}}

---

## Version History

| Version | Date              | Changes                   | Author |
| ------- | ----------------- | ------------------------- | ------ |
| 1.0.0   | {{creation_date}} | Initial template creation | System |

---

**Last Updated**: {{last_updated_date}}
**Updated By**: {{updated_by}}
**Next Review**: {{next_review_date}}
