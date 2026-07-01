# Master Context - belotable

## 1) Organizational Context
- Work Management Platform: GitHub
- Code Repository platform: GitHub
- Deployment model: On demand (triggered on push to `dev` and `main`, plus manual dispatch)
- Code review process: PR-based review with branch protections and quality gates before merge
- AI governance: AI assists design, code, and tests; humans validate and deploy

## 2) Application Context
- Type: Cross-platform Flutter app (desktop/web) - tournament scoring and organization for belote events
- Sensitivity: Internal (contains tournament and participant operational data; no public exposure required)
- Primary integrations: GitHub Actions, GHCR Docker image publishing, local SQLite persistence via Drift

## 3) Technical Stack
### Backend
- Framework: Dart 3.12 / Flutter app architecture (no standalone backend service)
- Database: SQLite with Drift ORM
- Key libraries: `drift`, `drift_flutter`, `flutter_riverpod`, `intl`, `pdf`, `uuid`

### Frontend
- Framework: Flutter (Material)
- Styling: Material theme with `ColorScheme.fromSeed`
- State management: Riverpod

### Infrastructure
- Cloud platform: None detected - GitHub-hosted CI/CD only
- IaC tool: None detected
- Monitoring: None detected - CI quality/security reports in GitHub Actions

## 4) Development Conventions
- Naming: Dart/Flutter conventions (`snake_case` files, `UpperCamelCase` types, `lowerCamelCase` members)
- Backend structure: Layered architecture under `data`, `domain`, `presentation`, `utils`
- Frontend structure: Route-based Flutter screens and shared widgets in `presentation/shared`
- Testing: `flutter test` + integration tests in `integration_test`; target coverage >= 70% for critical domain logic
- Logging: Structured CI logs and test/analyzer artifacts; no PII in logs
- Secrets: GitHub secrets for CI credentials; no hardcoded secrets in repository

## 5) Architecture Guardrails
- DO:
  - Keep layered boundaries clear (`presentation -> domain -> data`).
  - Enforce CI quality gates (analyze, unit tests, integration tests, security scans) before merge.
  - Link every change to a work item or issue for traceability.
  - Validate release flow through `main` and staging-like validation steps (pre-release/dev pipeline) before production release.
  - Keep all generated and hand-written docs in sync with implementation.
- DON'T:
  - Bypass quality or security gates for convenience.
  - Introduce direct DB access from UI layers.
  - Commit generated artifacts that are environment-specific unless explicitly required by release workflows.
  - Add dependencies without documenting rationale and impact.
  - Log participant-identifying data in CI/test artifacts.
- FORBIDDEN:
  - Shadow IT service introductions without team validation.
  - Production release from unvalidated feature branches.
  - PII in logs, prompts, tests, or examples.
- PRESERVE:
  - Existing route names and argument contracts in Flutter navigation.
  - Existing Drift schema compatibility unless explicit migration is documented.
  - Existing release tagging contract (`vX.Y.Z` for stable, `dev-latest` for development).

## 6) Security & Compliance
- Authentication: Repository and release operations authenticated via GitHub credentials in CI
- Authorization: Repository role-based access and PR permissions
- PII protection: No participant personal data in prompts/logs; redact sensitive values in reports
- Compliance: None formally declared; enforce secure SDLC baseline with Semgrep + Trivy

## 7) Technical Risks
- Flutter desktop/web parity risk: UI behavior may differ across platforms -> Mitigation: maintain integration tests on Windows and validate web build in CI
- Local SQLite migration risk: schema changes may break persisted tournament data -> Mitigation: require migration review and backward-compatible Drift updates
- Release automation risk: branch sync/rebase steps can fail on divergence -> Mitigation: keep branch hygiene, short-lived branches, and explicit release checks

## 8) AI Policy for This Project
- Mandatory human code review before all merges.
- No autonomous deployment.
- All outputs: English language only.
- Traceability: Work item -> Task -> PR -> Tests -> Validation.
- Mandatory MCP usage: all GitHub backlog actions and all remote repository actions must use MCP tools.
- If required MCP capability is unavailable: stop, report blocker, and ask for explicit user direction before any alternative path.
- Forbidden: hardcoded secrets, PII in examples, guessing.

## 9) Enterprise Platform Compliance
- Architecture Board approval required for: new dependencies, new services, and infrastructure-impacting changes.
- Work item traceability: every commit and PR should reference a GitHub issue/work item.
- CI/CD quality gates: Semgrep, Flutter analyze, unit tests, integration tests, Trivy scans must pass before merge.
- Staging environment: dev/pre-release pipeline validation required before stable release publication.
- Audit logging: CI workflow logs, release metadata, SARIF findings, and SBOM artifacts retained in GitHub.
- Auditability checklist: PR review evidence, linked work item, passing checks, and release artifacts availability.
