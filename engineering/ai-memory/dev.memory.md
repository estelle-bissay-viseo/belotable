# Developer Memory

## Fact: Flutter root location
- Detail: Flutter project root is `belotable/` subdirectory, not repository root.
- Source: repository structure and `pubspec.yaml` location
- Last verified: 2026-07-01
- Owner: viseo-dev-assistant
- Status: Active

## Fact: Quality gate toolchain
- Detail: CI enforces Semgrep, Flutter analyze, unit/integration tests, and Trivy before release steps.
- Source: `.github/workflows/_shared-build-scan.yml`, `technical-docs/reference/ci-cd.md`
- Last verified: 2026-07-01
- Owner: viseo-dev-assistant
- Status: Active
