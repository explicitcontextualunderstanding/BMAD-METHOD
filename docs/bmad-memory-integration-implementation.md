# BMAD-METHOD Memory Integration Implementation Guide

## Single Reference Document for BMAD Agents to Apply Memory Enhancement

## **Quick Start for BMAD Agents**

### **Step 1: Memory Schema (Use This Structure)**

```yaml
# Every memory entry must follow this exact structure
memory_entry:
  id: 'bmad-{project_id}-{epic_id}-{story_id}'
  timestamp: '2025-01-12T10:30:00Z'

  # BMAD Metadata (Required)
  bmad_metadata:
    workflow_state: 'implementation' # analysis/planning/solutioning/implementation
    scale_level: 3 # 0-4 from plan-project routing
    project_type: 'software' # software/game/web/mobile/etc
    context_type: 'brownfield' # greenfield/brownfield
    project_workflow_file: 'project-workflow-analysis.md'
    current_epic: 'epic-0'
    branch: 'v6-alpha' # v6-alpha/main/epic-0-learning-integration

  # Work Item (Required)
  work_item:
    type: 'story' # epic/story/task
    hierarchy: 'epic-0.story-6' # BMAD naming convention
    title: 'Implement Cloud-Based Model Profiling'
    status: 'Ready for Review' # Draft/ContextReadyDraft/In Progress/Ready for Review/Done/Blocked
    owner: 'ML Engineer'
    priority: 'High' # Critical/High/Medium/Low
    story_points: 21
    story_context_xml: 'story-context-epic-0.story-6-20250112.xml'
    context_enhanced_with_memory: true

  # Learning Component (Optional but recommended)
  learning_component:
    courses:
      [
        {
          name: 'Deep Learning Performance Optimization',
          provider: 'NVIDIA DLI',
          duration_hours: 6,
          completed_date: '2025-01-08',
          certificate_obtained: true,
        },
      ]
    total_learning_hours: 13
    knowledge_applied: 'PagedAttention + FlashAttention implementation'

  # Verification (Required for completed stories)
  verification:
    acceptance_criteria_met: ['AC 5.1', 'AC 5.2', 'AC 5.3']
    definition_of_done_items: ['All acceptance criteria met', 'Code reviewed and approved', 'Tests passing', 'Documentation updated']
    definition_of_done: true
    evidence_links:
      [
        {
          type: 'performance_results',
          path: 'results/cloud_profiling_results.json',
          description: 'Baseline vs optimized performance comparison',
        },
      ]
    validation_method: 'automated_tests + manual_review'
    validation_date: '2025-01-12T10:00:00Z'

  # Technical Context (Required)
  technical_context:
    domain: 'gpu_optimization'
    technologies: ['TensorRT', 'CUDA', 'PyTorch Profiler', 'Nsight Systems']
    development_environment: 'A5000 (24 GiB VRAM)'
    testing_environment: 'H200 cluster (141 GiB VRAM)'
    performance_targets: { memory_reduction: '30%+', inference_speedup: '2x+', latency_improvement: '40%+' }

  # Knowledge Transfer (Required for completed stories)
  knowledge_transfer:
    patterns: ['staged_gpu_development_workflow', 'attention_optimization_pipeline', 'memory_bandwidth_analysis']
    reusable_artifacts: ['profiling_templates/', 'attention_optimization_scripts/', 'benchmark_suites/']
    lessons_learned:
      [
        'A5000 validation before H200 deployment reduces costs by 90%',
        'PagedAttention critical for memory-bound decode phase',
        'FlashAttention provides 2.3x speedup for attention layers',
      ]

  # Story Context Enhancement (For enhanced stories)
  story_context_enhancement:
    memory_search_performed: true
    search_timestamp: '2025-01-12T09:00:00Z'
    relevant_patterns_found:
      [
        {
          pattern_id: 'gpu-attention-optimization-001',
          description: 'PagedAttention implementation for memory efficiency',
          source_epic: 'epic-0',
          success_rate: 0.95,
          applicability_score: 0.9,
        },
      ]
    context_enhancement_applied: true
    enhancement_quality_rating: 4.2 # 1-5 scale
```

### **Step 2: Memory Integration Points (When to Use Memory)**

```yaml
# BMAD Workflow Integration Points
integration_points:
  # Story Context Generation (After BMAD story-context workflow)
  story_context_enhancement:
    trigger: 'After story-context workflow completes'
    action: 'Enhance generated XML with memory data'
    search_query: 'Similar stories in {domain} with {technologies}'

  # Story Implementation (During dev-story workflow)
  implementation_support:
    trigger: 'When developer needs guidance'
    action: 'Search memory for similar solutions'
    search_query: 'Implementation patterns for {technical_challenge}'

  # Story Completion (After dev-story workflow)
  learning_extraction:
    trigger: 'When story status changes to Done'
    action: 'Extract and store learnings'
    storage_format: 'Use memory schema above'

  # Epic Retrospective (During retrospective workflow)
  pattern_extraction:
    trigger: 'When retrospective runs'
    action: 'Extract cross-story patterns'
    storage_format: 'Epic-level memory entries'
```

### **Step 3: Memory Search Queries (Use These MCP Tool Templates)**

#### **For Story Context Enhancement:**

```javascript
// Search for similar stories with matching domain and technologies
mcp__cipher -
  mcp__cipher_memory_search(
    (query = 'stories in {domain} domain with similar acceptance criteria'),
    (top_k = 5),
    (similarity_threshold = 0.7),
  );

// Search for implementations using specific technologies
mcp__cipher -
  mcp__cipher_memory_search(
    (query = 'implementations using {technologies} in {project_type} projects'),
    (top_k = 3),
    (similarity_threshold = 0.8),
  );

// Search for solutions with specific constraints
mcp__cipher -
  mcp__cipher_memory_search((query = 'solutions for {technical_challenge} with {constraints}'), (top_k = 3), (similarity_threshold = 0.8));

// Search for reusable artifacts
mcp__cipher -
  mcp__cipher_memory_search((query = 'reusable artifacts for {technology_stack} optimization'), (top_k = 5), (similarity_threshold = 0.6));
```

#### **For Implementation Support:**

```javascript
// Search for blocker resolution patterns
mcp__cipher -
  mcp__cipher_memory_search((query = 'blocker resolution for {issue_type} in {domain}'), (top_k = 3), (similarity_threshold = 0.8));

// Search for similar technical decisions
mcp__cipher -
  mcp__cipher_memory_search((query = 'similar technical decisions in {technology} projects'), (top_k = 3), (similarity_threshold = 0.7));

// Search for performance optimization patterns
mcp__cipher -
  mcp__cipher_memory_search((query = 'performance optimization patterns for {challenge_type}'), (top_k = 5), (similarity_threshold = 0.7));

// Search for testing approaches
mcp__cipher -
  mcp__cipher_memory_search((query = 'testing approaches for {component_type} implementations'), (top_k = 3), (similarity_threshold = 0.6));
```

#### **For Pattern Extraction:**

```javascript
// Search for successful patterns across projects
mcp__cipher -
  mcp__cipher_memory_search((query = 'successful patterns across {domain} projects'), (top_k = 10), (similarity_threshold = 0.6));

// Search for reusable solutions
mcp__cipher - mcp__cipher_memory_search((query = 'reusable solutions for {common_problem}'), (top_k = 5), (similarity_threshold = 0.7));

// Search for cross-project learning
mcp__cipher - mcp__cipher_memory_search((query = 'cross-project learning in {technical_area}'), (top_k = 8), (similarity_threshold = 0.6));

// Search for proven approaches
mcp__cipher -
  mcp__cipher_memory_search((query = 'proven approaches for {project_complexity} work'), (top_k = 5), (similarity_threshold = 0.7));
```

#### **Query Templates for Quick Use:**

```javascript
// Template: Story Context Enhancement
// Replace {domain}, {technologies}, {project_type}, {technical_challenge}, {constraints}, {technology_stack}
mcp__cipher -
  mcp__cipher_memory_search(
    (query = 'stories in gpu_optimization domain using TensorRT CUDA with profiling optimization'),
    (top_k = 5),
    (similarity_threshold = 0.7),
  );

// Template: Implementation Support
// Replace {issue_type}, {domain}, {technology}, {challenge_type}, {component_type}
mcp__cipher -
  mcp__cipher_memory_search(
    (query = 'blocker resolution for memory issues in gpu_optimization projects'),
    (top_k = 3),
    (similarity_threshold = 0.8),
  );

// Template: Pattern Extraction
// Replace {domain}, {common_problem}, {technical_area}, {project_complexity}
mcp__cipher -
  mcp__cipher_memory_search(
    (query = 'successful patterns across gpu_optimization projects with PagedAttention implementation'),
    (top_k = 10),
    (similarity_threshold = 0.6),
  );
```

### **Step 4: BMAD Story Status Mapping (Use This for Memory Decisions)**

```yaml
# BMAD Story Statuses and Memory Actions
story_status_memory_actions:
  Draft:
    memory_action: 'none'
    reason: 'Story too early for memory integration'

  ContextReadyDraft:
    memory_action: 'enhance_context'
    trigger: 'After story-context XML generated'
    search_focus: 'Similar stories and patterns'

  InProgress:
    memory_action: 'provide_guidance'
    trigger: 'When developer needs help'
    search_focus: 'Implementation solutions and blocker resolution'

  Ready for Review:
    memory_action: 'review_guidance'
    trigger: 'Before review starts'
    search_focus: 'Similar review criteria and quality standards'

  Done:
    memory_action: 'extract_and_store'
    trigger: 'When story marked complete'
    search_focus: 'Extract patterns, lessons, and artifacts'

  Blocked:
    memory_action: 'blocker_resolution'
    trigger: 'When blocker identified'
    search_focus: 'Similar blocker resolution patterns'
```

### **Step 5: BMAD CLI Agent Implementation (Cipher MCP Tools)**

**For CLI Agents (Claude/Gemini) using Cipher MCP Tools:**

#### **Available Tools:**

- `mcp__cipher-mcp__cipher_memory_search` - Search memories
- `mcp__cipher-mcp__cipher_extract_and_operate_memory` - Store/update memories

#### **BMAD Story Context Enhancement:**

```javascript
// Variables to extract from story:
// STORY_TITLE="Implement Cloud-Based Model Profiling"
// DOMAIN="gpu_optimization"
// TECHNOLOGIES="TensorRT, CUDA, PyTorch Profiler"
// EPIC_ID="epic-0"
// STORY_ID="story-6"

// 1. Search for similar patterns
mcp__cipher -
  mcp__cipher_memory_search(
    (query = `stories in ${DOMAIN} domain using ${TECHNOLOGIES} with profiling optimization`),
    (top_k = 5),
    (similarity_threshold = 0.7),
  );

// 2. Store enhanced context memory
mcp__cipher -
  mcp__cipher_extract_and_operate_memory(
    (interaction = `Enhanced story context for ${EPIC_ID}.${STORY_ID} '${STORY_TITLE}'. Found patterns from 5 similar GPU optimization stories. Key insights: Use staged GPU development (A5000 → H200), implement PagedAttention for memory efficiency, apply Nsight Systems for profiling.`),
    (knowledgeInfo = `{"domain": "${DOMAIN}", "codePattern": "story_context_enhancement"}`),
    (context = `{"sessionId": "bmad-context-enhancement-${STORY_ID}", "epicId": "${EPIC_ID}", "storyId": "${STORY_ID}"}`),
    (options = `{"similarityThreshold": 0.7, "useLLMDecisions": true, "memoryMetadata": {"projectId": "bmad-project", "workflow": "story-context"}}`),
  );
```

#### **BMAD Implementation Support:**

```javascript
// When developer needs guidance during implementation:
// TECHNICAL_CHALLENGE="PagedAttention implementation for memory optimization"

// Search for similar solutions
mcp__cipher -
  mcp__cipher_memory_search(
    (query = `solutions for ${TECHNICAL_CHALLENGE} in gpu_optimization projects`),
    (top_k = 3),
    (similarity_threshold = 0.8),
  );

// Store implementation decision
mcp__cipher -
  mcp__cipher_extract_and_operate_memory(
    (interaction = `Implementation decision for ${TECHNICAL_CHALLENGE}: Based on 3 similar solutions, implementing PagedAttention from FlashAttention library. Previous approaches show 30% memory reduction and 2.3x speedup.`),
    (knowledgeInfo = `{"domain": "gpu_optimization", "codePattern": "pagedattention_implementation"}`),
    (context = `{"sessionId": "bmad-implementation-guidance-${Date.now()}", "technicalChallenge": "${TECHNICAL_CHALLENGE}"}`),
    (options = `{"similarityThreshold": 0.8, "useLLMDecisions": true, "memoryMetadata": {"workflow": "implementation-guidance"}}`),
  );
```

#### **BMAD Story Completion:**

```javascript
// When story is completed:
// STORY_STATUS="Done"
// COMPLETION_SUMMARY="Successfully implemented cloud-based model profiling with 30% memory reduction and 2.3x speedup"
// LESSONS_LEARNED="A5000 validation before H200 deployment reduces costs 90%, PagedAttention critical for memory-bound decode"
// REUSABLE_ARTIFACTS="profiling_templates/, attention_optimization_scripts/"

// Store completion memory
mcp__cipher -
  mcp__cipher_extract_and_operate_memory(
    (interaction = `STORY COMPLETED: Status: ${STORY_STATUS}. ${COMPLETION_SUMMARY}. Key lessons: ${LESSONS_LEARNED}. Reusable artifacts: ${REUSABLE_ARTIFACTS}. All acceptance criteria met.`),
    (knowledgeInfo = `{"domain": "gpu_optimization", "codePattern": "story_completion_model_profiling"}`),
    (context = `{"sessionId": "bmad-story-completion-${storyPath}", "storyStatus": "${STORY_STATUS}", "completionDate": "${new Date().toISOString()}"}`),
    (options = `{"similarityThreshold": 0.7, "useLLMDecisions": true, "memoryMetadata": {"storyStatus": "${STORY_STATUS}", "completionDate": "${new Date().toISOString()}"}}`),
  );
```

#### **BMAD Epic Retrospective:**

```javascript
// During epic retrospective:
// EPIC_ID="epic-0"
// SUCCESSFUL_PATTERNS="staged_gpu_development_workflow, attention_optimization_pipeline"
// PROCESS_IMPROVEMENTS="Learning integration should happen before story implementation"

// Store retrospective learnings
mcp__cipher -
  mcp__cipher_extract_and_operate_memory(
    (interaction = `EPIC RETROSPECTIVE COMPLETED: ${EPIC_ID}. Successful patterns: ${SUCCESSFUL_PATTERNS}. Process improvements: ${PROCESS_IMPROVEMENTS}. Cross-project learning identified for GPU optimization domain.`),
    (knowledgeInfo = `{"domain": "gpu_optimization", "codePattern": "epic_retrospective_learnings"}`),
    (context = `{"sessionId": "bmad-retrospective-${EPIC_ID}", "epicId": "${EPIC_ID}", "retrospectiveDate": "${new Date().toISOString()}"}`),
    (options = `{"similarityThreshold": 0.7, "useLLMDecisions": true, "memoryMetadata": {"workflow": "retrospective", "epicId": "${EPIC_ID}"}}`),
  );
```

#### **BMAD Domain Extraction (Helper Logic):**

```bash
# Extract domain from story content (manual logic for CLI agents)
extract_domain() {
  local content="$1"

  if echo "$content" | grep -qiE "gpu|cuda|tensorrt|optimization|profiling"; then
    echo "gpu_optimization"
  elif echo "$content" | grep -qiE "api|backend|service|server"; then
    echo "backend_development"
  elif echo "$content" | grep -qiE "ui|frontend|component|interface"; then
    echo "frontend_development"
  elif echo "$content" | grep -qiE "test|testing|quality|validation"; then
    echo "testing"
  else
    echo "general_development"
  fi
}

# Extract technologies from story content
extract_technologies() {
  local content="$1"

  echo "$content" | grep -ioE "(python|javascript|typescript|java|go|rust|react|angular|vue|node|docker|kubernetes|tensorflow|pytorch|cuda|tensorrt)" | sort | uniq | head -5
}
```

#### **BMAD Memory Integration Templates:**

```bash
# Template for BMAD Scrum Master (Story Context)
enhance_story_context() {
  local story_path="$1"
  local context_xml="$2"

  # Extract story information
  local title=$(grep "^# " "$story_path" | head -1 | sed 's/^# //')
  local owner=$(grep -i "owner:" "$story_path" | cut -d: -f2 | xargs)
  local domain=$(extract_domain "$(cat "$story_path")")
  local technologies=$(extract_technologies "$(cat "$story_path")")
  local epic_id=$(basename "$story_path" .md | cut -d. -f1)
  local story_id=$(basename "$story_path" .md | cut -d. -f2)

  # Search for similar stories
  mcp__cipher-mcp__cipher_memory_search \
    --query "stories in ${domain} domain using ${technologies}" \
    --top_k 5 \
    --similarity_threshold 0.7

  # Store enhanced context
  mcp__cipher-mcp__cipher_extract_and_operate_memory \
    --interaction "Enhanced story context for ${epic_id}.${story_id} '${title}'. Found similar patterns in ${domain} domain using ${technologies}." \
    --knowledgeInfo "{\"domain\": \"${domain}\", \"codePattern\": \"story_context_enhancement\"}" \
    --context "{\"sessionId\": \"bmad-sm-context-${story_id}\", \"epicId\": \"${epic_id}\", \"storyId\": \"${story_id}\"}" \
    --options "{\"similarityThreshold\": 0.7, \"useLLMDecisions\": true, \"memoryMetadata\": {\"role\": \"scrum-master\", \"workflow\": \"story-context\"}}"
}

# Template for BMAD Developer (Story Completion)
store_story_completion() {
  local story_path="$1"
  local status="$2"

  if [ "$status" != "Done" ]; then
    return
  fi

  # Extract story information
  local title=$(grep "^# " "$story_path" | head -1 | sed 's/^# //')
  local domain=$(extract_domain "$(cat "$story_path")")
  local story_id=$(basename "$story_path" .md)

  # Store completion memory
  mcp__cipher-mcp__cipher_extract_and_operate_memory \
    --interaction "STORY COMPLETED: ${story_id} '${title}'. Status: Done. Successfully implemented ${domain} solution with all acceptance criteria met." \
    --knowledgeInfo "{\"domain\": \"${domain}\", \"codePattern\": \"story_completion\"}" \
    --context "{\"sessionId\": \"bmad-dev-completion-${story_id}\", \"storyStatus\": \"Done\", \"storyPath\": \"${story_path}\"}" \
    --options "{\"similarityThreshold\": 0.7, \"useLLMDecisions\": true, \"memoryMetadata\": {\"storyStatus\": \"Done\", \"role\": \"developer\"}}"
}
```

### **Step 6: BMAD CLI Agent Usage Examples**

#### **Example 1: Scrum Master Story Context Enhancement**

```bash
# BMAD SM agent runs after story-context workflow
STORY_PATH="output/stories/story-0.6.model-profiling.md"
CONTEXT_XML="output/story-context-epic-0.story-6-20250112.xml"

# Extract story information
TITLE=$(grep "^# " "$STORY_PATH" | head -1 | sed 's/^# //')
DOMAIN=$(grep -qiE "gpu|cuda|tensorrt" "$STORY_PATH" && echo "gpu_optimization" || echo "general")
TECHNOLOGIES=$(grep -oE "(TensorRT|CUDA|PyTorch)" "$STORY_PATH" | tr '\n' ' ' | sed 's/ $//')
EPIC_ID="epic-0"
STORY_ID="story-6"

# Search for similar patterns
echo "Searching for similar stories in ${DOMAIN} domain..."
mcp__cipher-mcp__cipher_memory_search \
  --query "stories in ${DOMAIN} domain using ${TECHNOLOGIES} with profiling optimization" \
  --top_k 5 \
  --similarity_threshold 0.7

# Store enhanced context
echo "Storing enhanced context memory..."
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "Enhanced story context for ${EPIC_ID}.${STORY_ID} '${TITLE}'. Found patterns from similar GPU optimization stories. Key insights: Use staged GPU development (A5000 → H200), implement PagedAttention for memory efficiency." \
  --knowledgeInfo "{\"domain\": \"${DOMAIN}\", \"codePattern\": \"story_context_enhancement\"}" \
  --context "{\"sessionId\": \"bmad-sm-context-${STORY_ID}\", \"epicId\": \"${EPIC_ID}\", \"storyId\": \"${STORY_ID}\"}" \
  --options "{\"similarityThreshold\": 0.7, \"useLLMDecisions\": true, \"memoryMetadata\": {\"role\": \"scrum-master\", \"workflow\": \"story-context\"}}"

echo "Story context enhanced with memory patterns"
```

#### **Example 2: Developer Implementation Support**

```bash
# BMAD Dev agent needs guidance during implementation
TECHNICAL_CHALLENGE="PagedAttention implementation causing memory issues"
CURRENT_APPROACH="Standard attention mechanism"

echo "Searching for implementation guidance..."

# Search for similar solutions
mcp__cipher-mcp__cipher_memory_search \
  --query "solutions for ${TECHNICAL_CHALLENGE} in gpu_optimization projects" \
  --top_k 3 \
  --similarity_threshold 0.8

echo "Found implementation approaches. Storing decision..."

# Store implementation decision
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "Implementation decision for ${TECHNICAL_CHALLENGE}: Based on 3 similar solutions, switching from ${CURRENT_APPROACH} to PagedAttention. Expected 30% memory reduction and 2.3x speedup." \
  --knowledgeInfo "{\"domain\": \"gpu_optimization\", \"codePattern\": \"pagedattention_implementation_decision\"}" \
  --context "{\"sessionId\": \"bmad-dev-impl-$(date +%s)\", \"technicalChallenge\": \"${TECHNICAL_CHALLENGE}\"}" \
  --options "{\"similarityThreshold\": 0.8, \"useLLMDecisions\": true, \"memoryMetadata\": {\"role\": \"developer\", \"workflow\": \"implementation-guidance\"}}"

echo "Implementation decision stored with memory guidance"
```

#### **Example 3: Developer Story Completion**

```bash
# BMAD Dev agent completes story implementation
STORY_PATH="output/stories/story-0.6.model-profiling.md"
STORY_STATUS="Done"
COMPLETION_SUMMARY="Successfully implemented cloud-based model profiling with PagedAttention and FlashAttention"
LESSONS_LEARNED="A5000 validation before H200 deployment reduces costs 90%, PagedAttention critical for memory-bound decode"
PERFORMANCE_METRICS="30% memory reduction, 2.3x speedup achieved"

echo "Storing story completion learnings..."

# Store completion memory
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "STORY COMPLETED: $(basename ${STORY_PATH}). Status: ${STORY_STATUS}. ${COMPLETION_SUMMARY}. Performance: ${PERFORMANCE_METRICS}. Key lessons: ${LESSONS_LEARNED}. All acceptance criteria met and validated." \
  --knowledgeInfo "{\"domain\": \"gpu_optimization\", \"codePattern\": \"story_completion_model_profiling\"}" \
  --context "{\"sessionId\": \"bmad-dev-completion-$(basename ${STORY_PATH} .md)\", \"storyStatus\": \"${STORY_STATUS}\", \"storyPath\": \"${STORY_PATH}\", \"completionDate\": \"$(date -Iseconds)\"}" \
  --options "{\"similarityThreshold\": 0.7, \"useLLMDecisions\": true, \"memoryMetadata\": {\"storyStatus\": \"${STORY_STATUS}\", \"role\": \"developer\", \"performanceMetrics\": \"${PERFORMANCE_METRICS}\"}}"

echo "Story completion stored with learnings and metrics"
```

#### **Example 4: Epic Retrospective Pattern Extraction**

```bash
# BMAD SM agent runs epic retrospective
EPIC_ID="epic-0"
STORIES_COMPLETED="story-1,story-2,story-3,story-4,story-5,story-6"
SUCCESSFUL_PATTERNS="staged_gpu_development_workflow, attention_optimization_pipeline, memory_bandwidth_analysis"
PROCESS_IMPROVEMENTS="Learning integration should happen before story implementation, A5000 validation essential for cost control"
CROSS_PROJECT_INSIGHTS="GPU optimization patterns consistently show 30%+ memory improvements with PagedAttention"

echo "Extracting epic retrospective patterns..."

# Store retrospective learnings
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "EPIC RETROSPECTIVE COMPLETED: ${EPIC_ID}. Stories completed: ${STORIES_COMPLETED}. Successful patterns: ${SUCCESSFUL_PATTERNS}. Process improvements: ${PROCESS_IMPROVEMENTS}. Cross-project insights: ${CROSS_PROJECT_INSIGHTS}." \
  --knowledgeInfo "{\"domain\": \"gpu_optimization\", \"codePattern\": \"epic_retrospective_learnings\"}" \
  --context "{\"sessionId\": \"bmad-retrospective-${EPIC_ID}\", \"epicId\": \"${EPIC_ID}\", \"retrospectiveDate\": \"$(date -Iseconds)\", \"storiesCount\": \"6\"}" \
  --options "{\"similarityThreshold\": 0.7, \"useLLMDecisions\": true, \"memoryMetadata\": {\"workflow\": \"retrospective\", \"epicId\": \"${EPIC_ID}\", \"role\": \"scrum-master\"}}"

echo "Epic retrospective patterns stored for cross-project learning"
```

### **Step 7: CLI Error Handling and Fallbacks**

#### **Memory Search Error Handling:**

```bash
# Safe memory search with fallback
safe_memory_search() {
  local query="$1"
  local top_k="${2:-5}"
  local threshold="${3:-0.7}"

  # Try search with original threshold
  if mcp__cipher-mcp__cipher_memory_search --query "$query" --top_k "$top_k" --similarity_threshold "$threshold" >/dev/null 2>&1; then
    echo "Memory search successful"
    return 0
  fi

  # Fallback 1: Try with lower threshold
  echo "Memory search failed, trying with lower threshold..."
  if mcp__cipher-mcp__cipher_memory_search --query "$query" --top_k "$top_k" --similarity_threshold 0.5 >/dev/null 2>&1; then
    echo "Memory search successful with lower threshold"
    return 0
  fi

  # Fallback 2: Try simpler query
  echo "Memory search failed, trying simpler query..."
  simple_query=$(echo "$query" | cut -d' ' -f1-3)
  if mcp__cipher-mcp__cipher_memory_search --query "$simple_query" --top_k 3 --similarity_threshold 0.5 >/dev/null 2>&1; then
    echo "Memory search successful with simpler query"
    return 0
  fi

  # Fallback 3: Continue without memory
  echo "Memory search unavailable, proceeding with standard BMAD workflow"
  return 1
}

# Usage example
echo "Searching for implementation guidance..."
if safe_memory_search "PagedAttention implementation solutions" 3 0.8; then
  # Search successful, get results
  mcp__cipher-mcp__cipher_memory_search --query "PagedAttention implementation solutions" --top_k 3 --similarity_threshold 0.8
else
  echo "Using standard BMAD approach for implementation"
fi
```

#### **Memory Storage Error Handling:**

```bash
# Safe memory storage with fallback
safe_memory_store() {
  local interaction="$1"
  local knowledge_info="$2"
  local context="$3"
  local options="$4"

  # Try storage with full interaction
  if mcp__cipher-mcp__cipher_extract_and_operate_memory \
    --interaction "$interaction" \
    --knowledgeInfo "$knowledge_info" \
    --context "$context" \
    --options "$options" >/dev/null 2>&1; then
    echo "Memory stored successfully"
    return 0
  fi

  # Fallback 1: Try with simpler interaction
  echo "Memory storage failed, trying with simpler interaction..."
  simple_interaction=$(echo "$interaction" | cut -c1-200)  # First 200 chars
  if mcp__cipher-mcp__cipher_extract_and_operate_memory \
    --interaction "$simple_interaction" \
    --knowledgeInfo "$knowledge_info" >/dev/null 2>&1; then
    echo "Memory stored with simplified interaction"
    return 0
  fi

  # Fallback 2: Try minimal storage
  echo "Memory storage failed, trying minimal storage..."
  minimal_interaction="Story completed: $(basename $STORY_PATH)"
  if mcp__cipher-mcp__cipher_extract_and_operate_memory \
    --interaction "$minimal_interaction" \
    --knowledgeInfo '{"domain": "general", "codePattern": "story_completion_simple"}' >/dev/null 2>&1; then
    echo "Memory stored with minimal information"
    return 0
  fi

  # Fallback 3: Continue without memory storage
  echo "Memory storage unavailable, story completion still valid"
  return 1
}

# Usage example
echo "Storing story completion learnings..."
safe_memory_store \
  "STORY COMPLETED: story-0.6.model-profiling. Status: Done. Performance: 30% memory reduction, 2.3x speedup." \
  '{"domain": "gpu_optimization", "codePattern": "story_completion"}' \
  '{"sessionId": "bmad-dev-completion", "storyStatus": "Done"}' \
  '{"similarityThreshold": 0.7, "useLLMDecisions": true}'
```

#### **BMAD Workflow Continuity:**

```bash
# Ensure BMAD workflow continues regardless of memory availability
run_bmad_workflow_with_memory() {
  local workflow_step="$1"
  local memory_operation="$2"

  echo "Running BMAD workflow step: $workflow_step"

  # Execute memory operation if provided
  if [ -n "$memory_operation" ]; then
    echo "Attempting memory integration..."
    if ! eval "$memory_operation"; then
      echo "Memory integration failed, continuing with BMAD workflow"
    fi
  fi

  # Continue with BMAD workflow regardless of memory success
  echo "BMAD workflow step completed: $workflow_step"
}

# Example: Story completion with memory
run_bmad_workflow_with_memory "story-completion" "
  safe_memory_store \
    'STORY COMPLETED: story-0.6.model-profiling with 30% memory reduction' \
    '{\"domain\": \"gpu_optimization\"}' \
    '{\"storyStatus\": \"Done\"}'
"
```

#### **Graceful Degradation Strategies:**

```bash
# BMAD agent workflow with memory enhancement
enhanced_bmad_story_workflow() {
  local story_path="$1"
  local workflow_phase="$2"

  case "$workflow_phase" in
    "context")
      echo "Enhancing story context with memory..."
      if safe_memory_search "similar stories $(basename $story_path .md)" 5 0.7; then
        echo "Memory enhancement available for story context"
        # Store enhanced context
        safe_memory_store "Enhanced context for $(basename $story_path)" \
          '{"domain": "gpu_optimization", "codePattern": "context_enhancement"}' \
          '{"workflow": "story-context"}'
      else
        echo "Using standard BMAD story context (no memory enhancement)"
      fi
      ;;

    "implementation")
      echo "Providing implementation guidance with memory..."
      if safe_memory_search "implementation guidance for $(basename $story_path .md)" 3 0.8; then
        echo "Memory guidance available for implementation"
      else
        echo "Using standard BMAD implementation approach"
      fi
      ;;

    "completion")
      echo "Storing completion learnings with memory..."
      safe_memory_store \
        "STORY COMPLETED: $(basename $story_path). Status: Done. All acceptance criteria met." \
        '{"domain": "gpu_optimization", "codePattern": "story_completion"}' \
        '{"storyStatus": "Done"}'
      ;;

    *)
      echo "Unknown workflow phase: $workflow_phase"
      ;;
  esac
}
```

## **Quick Reference Checklist**

For BMAD CLI agents implementing memory integration:

- [ ] **Use Cipher MCP tools directly** - `mcp__cipher-mcp__cipher_memory_search` and `mcp__cipher-mcp__cipher_extract_and_operate_memory`
- [ ] **Follow integration points from Step 2** for when to use memory in BMAD workflows
- [ ] **Use search query templates from Step 3** for finding relevant memories
- [ ] **Respect story status mapping from Step 4** for memory decisions
- [ ] **Copy CLI commands from Step 5** for direct implementation
- [ ] **Use bash templates from Step 5** for automated workflows
- [ ] **Handle errors gracefully using Step 7** CLI fallback patterns
- [ ] **Always fallback to original BMAD behavior** if memory fails

## **MCP Agent Quick Commands**

```javascript
// Search memories
mcp__cipher - mcp__cipher_memory_search((query = 'search query'), (top_k = 5), (similarity_threshold = 0.7));

// Store memories
mcp__cipher - mcp__cipher_extract_and_operate_memory((interaction = 'interaction text'), (knowledgeInfo = '{"domain": "domain"}'));

// Example: Search for similar stories
mcp__cipher -
  mcp__cipher_memory_search((query = 'GPU optimization stories with TensorRT profiling'), (top_k = 5), (similarity_threshold = 0.7));

// Example: Store completion data
mcp__cipher -
  mcp__cipher_extract_and_operate_memory(
    (interaction = 'Story completed: Implemented PagedAttention with 30% memory reduction'),
    (knowledgeInfo = '{"domain": "gpu_optimization", "codePattern": "story_completion"}'),
    (context = '{"sessionId": "bmad-completion", "storyStatus": "Done"}'),
  );
```

## **Conclusion**

This single document provides everything BMAD CLI agents need to integrate with Cipher MCP memory system:

1. **Schema** - Structure for memory entries (Step 1)
2. **Integration Points** - When to use memory in BMAD workflows (Step 2)
3. **Search Query Templates** - Pre-built queries for different scenarios (Step 3)
4. **Status Mapping** - Memory actions by BMAD story status (Step 4)
5. **CLI Implementation** - Direct Cipher MCP tool usage (Step 5)
6. **Usage Examples** - Practical bash command patterns (Step 6)
7. **Error Handling** - CLI fallback strategies (Step 7)

**BMAD CLI agents (Claude/Gemini) can now directly use Cipher MCP tools to search and store memories while maintaining full compatibility with BMAD-METHOD workflows.**

No Python dependencies required - pure CLI tool integration with graceful fallbacks to ensure BMAD workflows continue even if memory services are unavailable.
