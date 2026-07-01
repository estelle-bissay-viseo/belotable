# QA Memory

## Fact: Automated test levels
- Detail: Project runs unit tests with coverage and Windows integration tests in CI.
- Source: `.github/workflows/_shared-build-scan.yml`, `technical-docs/reference/ci-cd.md`
- Last verified: 2026-07-01
- Owner: viseo-qa-assistant
- Status: Active

## Fact: Analyze quality gate
- Detail: `flutter analyze --no-fatal-infos` is enforced with non-zero exit gate.
- Source: `.github/workflows/_shared-build-scan.yml`
- Last verified: 2026-07-01
- Owner: viseo-qa-assistant
- Status: Active
