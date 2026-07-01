# DevOps Memory

## Fact: Branch and release cadence
- Detail: `dev` handles continuous integration and pre-release; `main` drives technical release pipeline.
- Source: `.github/workflows/README.md`, `.github/workflows/ci.yml`, `.github/workflows/release.yml`
- Last verified: 2026-07-01
- Owner: viseo-devops-assistant
- Status: Active

## Fact: Shared pipeline architecture
- Detail: CI and release technical jobs are centralized in `_shared-build-scan.yml`.
- Source: `.github/workflows/_shared-build-scan.yml`, `technical-docs/reference/ci-cd.md`
- Last verified: 2026-07-01
- Owner: viseo-devops-assistant
- Status: Active
