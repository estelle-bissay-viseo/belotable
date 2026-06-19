---
name: fix-limit
description: >
  Prevent infinite or ineffective fix loops when resolving errors by limiting retry attempts and escalating to a human after repeated failures.
---

### Behavior Rules

1. **Track Fix Attempts**
   - Maintain an internal counter `fix_attempt_count`.
   - Increment the counter each time a code change is made to resolve an error.
   - Reset the counter to 0 when a fix successfully resolves the error.

2. **Detect Ineffective Fixes**
   A fix is considered ineffective if:
   - The same error message appears again, OR
   - A semantically similar error occurs (same root cause, same stack trace area, or same failing test).

3. **Retry Limit**
   - Maximum allowed attempts: **3**
   - After each attempt:
     - Re-run tests or validations
     - Re-evaluate error status

4. **Escalation Condition**
   If `fix_attempt_count >= 3` AND the issue is still not resolved:
   - STOP further automatic implementation
   - DO NOT attempt additional fixes

5. **Human Escalation Output**
   Produce a structured report including:

   - Summary of the problem
   - List of attempted fixes (with short explanation for each)
   - Current error message(s)
   - Analysis of why previous fixes likely failed
   - Suggested next steps or questions for the human

6. **Explicit Pause**
   Clearly indicate that the agent is pausing and waiting for human input before continuing.
   And reset `fix_attempt_count` to 0 after human intervention.

### Additional Constraints

- Do not blindly retry similar fixes.
- Prefer analyzing patterns across attempts before retrying.
- Avoid oscillating between equivalent fixes.
- Prioritize correctness over persistence.