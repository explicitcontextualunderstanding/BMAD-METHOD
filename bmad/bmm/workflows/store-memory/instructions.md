# Store Information in Memory

## Goal

This workflow takes structured information and stores it in the Cipher MCP memory store using the `mcp__cipher-mcp__cipher_extract_and_operate_memory` tool.

## Instructions

### Step 1: Store Memory

Execute the Cipher MCP tool to store the provided information.

- Use the `{{interaction}}` input for the `interaction` parameter.
- Use the `{{knowledgeInfo}}` input for the `knowledgeInfo` parameter.
- If provided, use the `{{context}}` input for the `context` parameter.
- If provided, use the `{{options}}` input for the `options` parameter.

<execute_tool>
mcp**cipher-mcp**cipher_extract_and_operate_memory(
interaction="{{interaction}}",
knowledgeInfo='{{knowledgeInfo}}',
context='{{context}}',
options='{{options}}'
)
</execute_tool>
