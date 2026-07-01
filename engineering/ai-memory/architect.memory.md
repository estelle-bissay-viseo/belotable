# Architect Memory

## Fact: Layered Flutter structure
- Detail: Codebase uses layered structure (`data`, `domain`, `presentation`, `utils`) under Flutter app.
- Source: `technical-docs/reference/architecture.md`
- Last verified: 2026-07-01
- Owner: viseo-architect-assistant
- Status: Active

## Fact: Compatibility-sensitive contracts
- Detail: Route names/arguments and Drift schema are key compatibility surfaces.
- Source: `belotable/lib/main.dart`, `belotable/lib/data/database/app_database.dart`
- Last verified: 2026-07-01
- Owner: viseo-architect-assistant
- Status: Active
