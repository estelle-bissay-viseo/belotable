# Security Memory

## Fact: Static security scanning baseline
- Detail: Semgrep and Trivy are integrated into shared CI/release workflows with quality gates.
- Source: `technical-docs/reference/ci-cd.md`, `.github/workflows/_shared-build-scan.yml`
- Last verified: 2026-07-01
- Owner: viseo-security-assistant
- Status: Active

## Fact: Trivy severity policy
- Detail: HIGH and CRITICAL vulnerabilities are treated as failing conditions.
- Source: `trivy.yaml`
- Last verified: 2026-07-01
- Owner: viseo-security-assistant
- Status: Active
