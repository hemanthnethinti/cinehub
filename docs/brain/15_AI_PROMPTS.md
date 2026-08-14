# 15 - AI Prompts

> Future engineers: Copy and paste these prompts when instructing the AI.

## Implementation Prompt
```text
Implement [Feature Name] in Phase [X].
Read the docs/brain/AI_CONTEXT.md first.
Strictly follow Clean Architecture.
Do NOT modify existing unrelated code.
Output only: Files created, Files modified, Summary.
Stop after completion.
```

## Bug Fix Prompt
```text
Fix [Bug Description].
Do NOT rewrite the entire file. Use targeted `replace_file_content`.
Do NOT change the architecture to fix the bug.
Provide a summary of the fix.
```

## Documentation Prompt
```text
Update `docs/brain` to reflect the newly implemented [Feature Name].
Ensure the Changelog, Tech Stack, and Lessons Learned are updated.
Do NOT touch application code.
```
