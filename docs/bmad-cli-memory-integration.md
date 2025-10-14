# BMAD CLI Agent Memory Integration Guide

**Direct Cipher MCP Tool Usage for Claude and Gemini CLI Agents**

## **Quick Start for CLI Agents**

### **Available Cipher MCP Tools**

CLI agents have access to these Cipher MCP tools:

1. **`mcp__cipher-mcp__cipher_memory_search`** - Search memories
2. **`mcp__cipher-mcp__cipher_extract_and_operate_memory`** - Store/Update memories
3. **`mcp__cipher-mcp__cipher_bash`** - Execute commands (if needed)

## **Memory Integration for CLI Agents**

### **Step 1: Search Memories (CLI Tool Usage)**

**Tool**: `mcp__cipher-mcp__cipher_memory_search`

**Parameters**:

- `query` (required): Search query for memories
- `top_k` (optional): Number of results (default: 5)
- `similarity_threshold` (optional): Minimum similarity score (default: 0.3)
- `include_metadata` (optional): Include detailed metadata (default: true)

**Usage Examples**:

```bash
# Search for GPU optimization patterns
mcp__cipher-mcp__cipher_memory_search --query "GPU optimization attention mechanisms PagedAttention" --top_k 5 --similarity_threshold 0.7

# Search for similar story implementations
mcp__cipher-mcp__cipher_memory_search --query "stories in gpu_optimization domain with TensorRT CUDA" --top_k 3

# Search for blocker resolution patterns
mcp__cipher-mcp__cipher_memory_search --query "blocker resolution for memory issues in deep learning projects" --top_k 3
```

### **Step 2: Store/Update Memories (CLI Tool Usage)**

**Tool**: `mcp__cipher-mcp__cipher_extract_and_operate_memory`

**Parameters**:

- `interaction` (required): Raw interaction text or conversation
- `existingMemories` (optional): Array of existing memories to compare
- `knowledgeInfo` (optional): Pre-computed knowledge information
- `context` (optional): Session context information
- `options` (optional): Configuration options

**Memory Entry Structure (JSON Format)**:

```json
{
  "interaction": "Completed story: Implement Cloud-Based Model Profiling. Used PagedAttention and FlashAttention to reduce memory usage by 30%. Performance improved 2.3x.",

  "existingMemories": [
    {
      "id": "previous-memory-id",
      "text": "Previous memory text",
      "metadata": { "domain": "gpu_optimization" }
    }
  ],

  "knowledgeInfo": {
    "domain": "gpu_optimization",
    "codePattern": "attention_optimization_pagedattention_flashattention"
  },

  "context": {
    "sessionId": "bmad-session-001",
    "projectId": "openvla-optimization"
  },

  "options": {
    "similarityThreshold": 0.7,
    "enableBatchProcessing": true,
    "useLLMDecisions": true,
    "confidenceThreshold": 0.8,
    "enableDeleteOperations": false,
    "memoryMetadata": {
      "projectId": "openvla-optimization",
      "userId": "ml-engineer",
      "environment": "development",
      "source": "bmad-cli"
    }
  }
}
```

### **Step 3: CLI Agent Memory Workflow**

#### **For Story Context Enhancement:**

```bash
# 1. After BMAD story-context workflow completes
# 2. Search for relevant memories
mcp__cipher-mcp__cipher_memory_search \
  --query "similar stories in gpu_optimization domain with TensorRT profiling" \
  --top_k 5 \
  --similarity_threshold 0.7

# 3. Extract key findings from search results
# 4. Store the enhanced context as a memory
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "Enhanced story context for epic-0.story-6 with patterns from 5 similar GPU optimization stories. Key patterns: PagedAttention implementation, FlashAttention optimization, memory bandwidth analysis." \
  --knowledgeInfo '{"domain": "gpu_optimization", "codePattern": "story_context_enhancement"}' \
  --context '{"sessionId": "bmad-story-context-001", "epicId": "epic-0", "storyId": "story-6"}'
```

#### **For Story Implementation Support:**

```bash
# When developer needs guidance during implementation
mcp__cipher-mcp__cipher_memory_search \
  --query "implementation approaches for PagedAttention in PyTorch with CUDA optimization" \
  --top_k 3 \
  --similarity_threshold 0.8

# Store implementation decisions
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "During story epic-0.story-6 implementation: Chose PagedAttention over standard attention due to 30% memory reduction. Applied FlashAttention for 2.3x speedup. Used Nsight Systems for bottleneck identification." \
  --knowledgeInfo '{"domain": "gpu_optimization", "codePattern": "pagedattention_implementation"}' \
  --context '{"sessionId": "bmad-dev-session-001", "epicId": "epic-0", "storyId": "story-6"}'
```

#### **For Story Completion and Learning:**

```bash
# After story completion
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "COMPLETED STORY: epic-0.story-6 'Implement Cloud-Based Model Profiling'. Status: Done. Performance achieved: 30% memory reduction, 2.3x speedup. Lessons: A5000 validation before H200 deployment reduces costs 90%, PagedAttention critical for memory-bound decode, FlashAttention provides optimal attention throughput." \
  --existingMemories '[{"id": "epic-0.story-6-context", "text": "Initial story context with GPU optimization requirements"}]' \
  --knowledgeInfo '{"domain": "gpu_optimization", "codePattern": "cloud_model_profiling_complete"}' \
  --context '{"sessionId": "bmad-story-completion-001", "epicId": "epic-0", "storyId": "story-6"}' \
  --options '{"similarityThreshold": 0.7, "useLLMDecisions": true, "memoryMetadata": {"projectId": "openvla-optimization", "storyStatus": "Done", "completionDate": "2025-01-12"}}'
```

## **CLI Agent Integration Templates**

### **Template 1: Story Context Enhancement**

```bash
# CLI Agent can use this template for story context enhancement

# Variables to set:
# STORY_TITLE="Implement Cloud-Based Model Profiling"
# DOMAIN="gpu_optimization"
# TECHNOLOGIES="TensorRT, CUDA, PyTorch Profiler"
# EPIC_ID="epic-0"
# STORY_ID="story-6"

# Step 1: Search for similar stories
mcp__cipher-mcp__cipher_memory_search \
  --query "stories in ${DOMAIN} domain using ${TECHNOLOGIES} with profiling and optimization" \
  --top_k 5 \
  --similarity_threshold 0.7

# Step 2: Store enhanced context (replace with actual search results)
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "Enhanced story context for ${EPIC_ID}.${STORY_ID} '${STORY_TITLE}'. Found 5 similar stories with GPU optimization patterns. Key insights: Use staged GPU development (A5000 → H200), implement PagedAttention for memory efficiency, apply Nsight Systems for profiling." \
  --knowledgeInfo '{"domain": "'${DOMAIN}'", "codePattern": "story_context_enhancement"}' \
  --context '{"sessionId": "bmad-context-enhancement-'${STORY_ID}'", "epicId": "'${EPIC_ID}'", "storyId": "'${STORY_ID}'"}'
```

### **Template 2: Implementation Guidance**

```bash
# CLI Agent can use this template for implementation guidance

# Variables to set:
# TECHNICAL_CHALLENGE="PagedAttention implementation for memory optimization"
# DOMAIN="gpu_optimization"
# CURRENT_APPROACH="Standard attention mechanism causing memory issues"

# Step 1: Search for similar solutions
mcp__cipher-mcp__cipher_memory_search \
  --query "solutions for ${TECHNICAL_CHALLENGE} in ${DOMAIN} projects" \
  --top_k 3 \
  --similarity_threshold 0.8

# Step 2: Store implementation approach
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "Implementation decision for ${TECHNICAL_CHALLENGE}: Based on 3 similar solutions, implementing PagedAttention from FlashAttention library. Previous approaches show 30% memory reduction and 2.3x speedup. Current approach: ${CURRENT_APPROACH} - needs replacement." \
  --knowledgeInfo '{"domain": "'${DOMAIN}'", "codePattern": "pagedattention_implementation_decision"}' \
  --context '{"sessionId": "bmad-implementation-guidance-'$(date +%s)'", "technicalChallenge": "'${TECHNICAL_CHALLENGE}'"}'
```

### **Template 3: Story Completion**

```bash
# CLI Agent can use this template for story completion

# Variables to set:
# STORY_PATH="output/stories/story-0.6.model-profiling.md"
# COMPLETION_SUMMARY="Successfully implemented cloud-based model profiling with 30% memory reduction and 2.3x speedup"
# LESSONS_LEARNED="A5000 validation before H200 deployment reduces costs 90%, PagedAttention critical for memory-bound decode"
# REUSABLE_ARTIFACTS="profiling_templates/, attention_optimization_scripts/"

# Step 1: Store completion memory
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "STORY COMPLETED: $(basename ${STORY_PATH}) - ${COMPLETION_SUMMARY}. Key lessons: ${LESSONS_LEARNED}. Reusable artifacts: ${REUSABLE_ARTIFACTS}. Status: Done. Ready for next story." \
  --knowledgeInfo '{"domain": "gpu_optimization", "codePattern": "story_completion_model_profiling"}' \
  --context '{"sessionId": "bmad-story-completion-'$(basename ${STORY_PATH} .md)'", "storyPath": "'${STORY_PATH}'", "status": "Done"}' \
  --options '{"similarityThreshold": 0.7, "useLLMDecisions": true, "memoryMetadata": {"storyStatus": "Done", "completionDate": "'$(date -Iseconds)'"}}'
```

## **CLI Agent Workflow Integration**

### **For BMAD Scrum Master (Story Context)**

```bash
# When SM runs story-context workflow:
# 1. After BMAD generates context XML
# 2. Enhance with memory patterns

echo "Enhancing story context with memory patterns..."

# Search for similar story contexts
mcp__cipher-mcp__cipher_memory_search \
  --query "story context enhancements for gpu optimization with TensorRT profiling" \
  --top_k 5 \
  --similarity_threshold 0.7

# Store the enhancement decision
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "SM enhanced story context for epic-0.story-6 with memory patterns from 5 similar GPU optimization stories. Enhancement added PagedAttention patterns, profiling approaches, and performance optimization techniques." \
  --knowledgeInfo '{"domain": "gpu_optimization", "codePattern": "sm_story_context_enhancement"}' \
  --context '{"sessionId": "bmad-sm-context-001", "role": "scrum-master", "workflow": "story-context"}'

echo "Story context enhanced with memory patterns"
```

### **For BMAD Developer (Implementation Support)**

```bash
# When Dev needs guidance during implementation:

echo "Searching for implementation guidance..."

# Search for similar implementation approaches
mcp__cipher-mcp__cipher_memory_search \
  --query "PagedAttention implementation in PyTorch with CUDA TensorRT optimization" \
  --top_k 3 \
  --similarity_threshold 0.8

echo "Found implementation guidance from similar stories"
```

### **For BMAD Developer (Story Completion)**

```bash
# When Dev completes story implementation:

echo "Storing story completion learnings..."

STORY_FILE="story-0.6.model-profiling.md"
COMPLETION_NOTES="Implemented PagedAttention and FlashAttention for 30% memory reduction and 2.3x speedup. Used Nsight Systems for profiling. A5000 validation successful before H200 scaling."

mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "DEV COMPLETED: ${STORY_FILE}. ${COMPLETION_NOTES}. Status: Done. All acceptance criteria met. Performance targets achieved." \
  --knowledgeInfo '{"domain": "gpu_optimization", "codePattern": "dev_story_completion"}' \
  --context '{"sessionId": "bmad-dev-completion-001", "role": "developer", "storyFile": "'${STORY_FILE}'", "status": "Done"}' \
  --options '{"similarityThreshold": 0.7, "useLLMDecisions": true, "memoryMetadata": {"storyStatus": "Done", "role": "developer"}}'

echo "Story completion stored with learnings"
```

## **CLI Agent Error Handling**

### **When Memory Search Fails:**

```bash
# Try search with lower threshold
mcp__cipher-mcp__cipher_memory_search \
  --query "gpu optimization patterns" \
  --top_k 3 \
  --similarity_threshold 0.5

# If still fails, continue with BMAD standard workflow
echo "Memory search unavailable, proceeding with standard BMAD workflow"
```

### **When Memory Storage Fails:**

```bash
# Store with simpler interaction text
mcp__cipher-mcp__cipher_extract_and_operate_memory \
  --interaction "Story completed: $(basename ${STORY_PATH}). Status: Done." \
  --knowledgeInfo '{"domain": "general", "codePattern": "story_completion_simple"}'

# If storage fails, continue with BMAD workflow
echo "Memory storage unavailable, story completion still valid"
```

## **CLI Agent Best Practices**

### **Memory Search Best Practices:**

1. **Use specific queries** - Include domain and technologies
2. **Set appropriate thresholds** - 0.7 for patterns, 0.8 for solutions
3. **Limit results** - 3-5 results for focused guidance
4. **Include context** - Add epic/story information to queries

### **Memory Storage Best Practices:**

1. **Structure interaction text clearly** - Include status and outcomes
2. **Use appropriate knowledgeInfo** - Domain and code pattern
3. **Include context** - Session ID, role, workflow information
4. **Handle failures gracefully** - Continue BMAD workflow if memory fails

### **Integration Timing:**

1. **Story Context**: After BMAD story-context workflow
2. **Implementation Support**: When developer requests guidance
3. **Story Completion**: When story status changes to Done
4. **Retrospective**: During epic retrospective workflow

## **Quick Reference Commands**

```bash
# Search for patterns
mcp__cipher-mcp__cipher_memory_search --query "search query" --top_k 5 --similarity_threshold 0.7

# Store completion
mcp__cipher-mcp__cipher_extract_and_operate_memory --interaction "completion notes" --knowledgeInfo '{"domain": "domain"}'

# Error handling
# Always have fallback to standard BMAD workflow if memory tools fail
```

**CLI agents can now integrate with Cipher MCP using direct tool calls without any Python dependencies.**
