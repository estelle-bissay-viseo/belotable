## Project Context
Load `engineering/ai-assets/master-context.md` at the start of every significant task (architecture, guardrails, conventions). Apply `engineering/ai-assets/cleanup-policy.md` before any PR.

## AI Governance
- All outputs in English only.
- Mandatory human review before every merge.
- No autonomous deployment actions.
- No secrets, tokens, or PII in code, prompts, docs, or examples.
- Backward compatibility required unless a migration plan is explicitly approved.
- Mandatory MCP usage for all Work Management Platform backlog actions and all source repository remote actions.
- If required MCP capability is unavailable: stop, report blocker, and request explicit user direction.
- Traceability: Work Item -> Task -> PR -> Tests -> Validation.

## AI Agent Loading Order (Copilot Agent Mode)
- @viseo-product-assistant (orchestrator opt-in) -> `.github/agents/viseo-product-assistant.agent.md`
- @viseo-ai-steward (always active) -> `.github/agents/viseo-ai-steward.agent.md`
- @viseo-architect-assistant -> `.github/agents/viseo-architect-assistant.agent.md`
- @viseo-dev-assistant -> `.github/agents/viseo-dev-assistant.agent.md`
- @viseo-qa-assistant -> `.github/agents/viseo-qa-assistant.agent.md`
- @viseo-security-assistant -> `.github/agents/viseo-security-assistant.agent.md`
- @viseo-ux-assistant -> `.github/agents/viseo-ux-assistant.agent.md`
- @viseo-devops-assistant -> `.github/agents/viseo-devops-assistant.agent.md`

## Project-Specific Rules
- Flutter app root is `belotable/`; run Flutter commands from that directory.
- Preserve route contracts and Drift schema compatibility unless migration is approved.
- Keep CI quality and security gates active (Semgrep, analyze, tests, Trivy).
- Keep release contracts stable (`dev-latest`, `vX.Y.Z`) unless explicitly changed.
