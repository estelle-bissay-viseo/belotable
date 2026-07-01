# Cleanup Policy

Apply this checklist after each AI-assisted change and before opening or updating a PR.

## Required cleanup steps
- Remove temporary debug code, commented blocks, and dead branches.
- Ensure generated files are updated only when expected (for example, Drift/Flutter generated outputs).
- Verify no secrets, tokens, or personal data were introduced.
- Ensure logging statements do not expose sensitive values.
- Confirm file paths, command examples, and docs reflect current project structure.

## Validation steps
- Run static analysis and fix blocking issues.
- Run unit tests for impacted modules.
- Run integration tests when UI flow or persistence behavior changed.
- Confirm CI workflow assumptions still hold for modified files.

## PR readiness checks
- Link change to a work item or issue.
- Summarize risk, rollback approach, and test evidence.
- Request human review; never self-approve AI-generated changes.
