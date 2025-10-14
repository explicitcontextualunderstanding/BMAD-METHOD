# Validation Checklist for store-memory Workflow

## Purpose

This checklist ensures the `store-memory` workflow is correctly configured and ready for use.

## Checklist

- [ ] **`workflow.yaml` is present and correctly configured.**
  - [ ] `name` is `store-memory`.
  - [ ] `description` is clear and accurate.
  - [ ] `installed_path` points to the correct directory.
  - [ ] `instructions` path is correct.
  - [ ] `required_tools` section correctly lists `mcp__cipher-mcp__cipher_extract_and_operate_memory`.
  - [ ] `inputs` section defines `interaction`, `knowledgeInfo`, `context`, and `options`.

- [ ] **`instructions.md` is present and correct.**
  - [ ] It contains a single step.
  - [ ] It correctly uses the `<execute_tool>` tag.
  - [ ] The tool call to `mcp__cipher-mcp__cipher_extract_and_operate_memory` is syntactically correct.
  - [ ] It correctly references the input variables (e.g., `{{interaction}}`).

- [ ] **`README.md` is present and provides a clear explanation.**
  - [ ] The overview is accurate.
  - [ ] The inputs are correctly documented.
  - [ ] The example usage is clear and correct.

- [ ] **Functionality**
  - [ ] The workflow can be successfully invoked.
  - [ ] The workflow correctly passes parameters to the `mcp__cipher-mcp__cipher_extract_and_operate_memory` tool.
  - [ ] The workflow successfully stores a memory entry when provided with valid inputs.
