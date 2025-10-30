# store-memory Workflow

## Overview

The `store-memory` workflow provides a direct interface to the Cipher MCP memory store. Its primary purpose is to allow an agent to save a piece of information (an "interaction") along with associated metadata into the shared memory.

This workflow is a foundational component for creating agents that can learn and share knowledge over time.

## Usage

This workflow is typically called by an agent that has generated some knowledge worth preserving.

### Inputs

- `interaction` (string, required): The main text content to be stored in memory. This could be a lesson learned, a user preference, a summary of a document, etc.
- `knowledgeInfo` (string, required): A JSON string containing metadata about the knowledge, such as its `domain` and any relevant `patterns`.
- `context` (string, optional): A JSON string providing context for the memory entry, like a `storyId` or `sessionId`.
- `options` (string, optional): A JSON string for additional options, such as specifying the `author_agent_role` and `target_agent_role`.

### Process

The workflow consists of a single step:

1.  It takes the provided inputs.
2.  It calls the `mcp__cipher-mcp__cipher_extract_and_operate_memory` tool, passing the inputs to the corresponding parameters.

### Output

The workflow outputs the result from the `mcp__cipher-mcp__cipher_extract_and_operate_memory` tool, which typically indicates success or failure of the memory storage operation.

## Example Invocation from an Agent

An agent would invoke this workflow with the necessary parameters:

```
*workflow store-memory --interaction "A5000 validation before H200 deployment reduces costs by 90%." --knowledgeInfo '{"domain": "gpu_optimization", "patterns": ["cost_control_validation"]}' --options '{"memoryMetadata": {"author_agent_role": "Developer", "target_agent_role": ["QA"]}}'
```
