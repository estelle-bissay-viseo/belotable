---
name: belotable-flutter
description: >
  Project layout and toolchain facts for the Belotable Flutter app.
  Use when: running flutter or dart commands; navigating the Flutter project;
  writing code in belotable/lib; adding assets, dependencies, or running tests.
  Key facts: Flutter project root is belotable/ (not repo root); always use fvm to invoke flutter/dart.
---

# Belotable Flutter — Project Facts

## Project Location

Flutter project root: `belotable/` (subdirectory of repo root).

All `flutter`/`dart` commands must be run from `belotable/`, not the repo root.

## Toolchain

Use **fvm** (Flutter Version Manager) for every flutter or dart command.

| Instead of | Use |
|------------|-----|
| `flutter <cmd>` | `fvm flutter <cmd>` |
| `dart <cmd>` | `fvm dart <cmd>` |

Examples:
```sh
cd belotable
fvm flutter pub get
fvm flutter test
fvm dart run build_runner build --delete-conflicting-outputs
```

## Common Paths

| Purpose | Path (from repo root) |
|---------|-----------------------|
| Flutter project root | `belotable/` |
| Source code | `belotable/lib/` |
| Tests | `belotable/test/` |
| Integration tests | `belotable/integration_test/` |
| Assets | `belotable/assets/` |
| pubspec | `belotable/pubspec.yaml` |

## Behaviour

- Do not care about database schemaVersion and database MigrationStrategy in app_database.dart
- Do not care about messages about line length in flutter analyze output (like `info - The line length exceeds 80-character limit`).
- Do not care about messages about imports order (level info) in flutter analyze output
- Do not care about messages about unused imports (level info) in flutter analyze output
- Do not prepare git commit at all.
- Do `fvm flutter test integration_test/all_tests.dart -d windows -r expanded` to run all integration tests.
- Do `fvm flutter test` to run other tests.