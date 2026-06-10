---
name: read-feature
description: 'Analyze feature requests from markdown files to extract business requirements, data model impacts, UI changes, and acceptance criteria. Use when: reviewing feature requirements, understanding implementation scope, planning technical design, preparing acceptance tests. Generates structured analysis report saved to .github/feature_analyze/YYYYMMDD_hhmm_analysis.md.'
argument-hint: 'Path to feature request markdown file'
---

# Feature Request Analysis Skill

## When to Use

- **Analyze complete feature requests**: Understand what to implement, why, and what changes needed
- **Validate technical impact**: Before development, identify scope and data model changes
- **Prepare design**: Extract use cases and UI modifications
- **Prepare tests**: List acceptance criteria

## Feature Request File Format

Markdown file should contain:

```markdown
# Feature Title

## Description
Context and motivation.

## Use Cases
1. **Use case 1**: New expected behavior
2. **Use case 2**: New expected behavior

## Deprecated Behaviors (optional)
- Old behavior 1
- Old behavior 2

## Expected Changes (optional)

### Data Model (optional)
- Details of changes (new tables, new fields, etc.)

### User Interface (optional)
- Details of screen modifications

## Acceptance Criteria (optional)
- [ ] Criterion 1
- [ ] Criterion 2
```

## Analysis Procedure

1. **Load and parse feature markdown**
   - Read provided file
   - Extract each section (use cases, deprecated behaviors, etc.)

2. **Analyze data model impact**
   - Identify new tables/entities needed
   - Identify new fields to add
   - Identify fields to remove or deprecate
   - Specify objective for each change (why?)
   - Create structured summary

3. **Analyze UI impact**
   - Identify new screens or components
   - Identify modifications to existing screens
   - Identify elements to remove
   - Specify nature of each change (new flow, new button, removed field, etc.)
   - Create structured summary

4. **Extract acceptance criteria**
   - Compile all testable criteria
   - Map each criterion to corresponding use case or change

5. **Generate analysis report**
   - Create file: `.github/feature_analyze/YYYYMMDD_hhmm_analysis.md`
   - Report sections:
     - **Summary**: 1-2 sentences on what feature introduces
     - **Use Cases**: List new/modified use cases
     - **Data Model**: Structured table of changes
     - **User Interface**: Structured table of screen modifications
     - **Acceptance Criteria**: List of testable criteria
     - **Risks/Dependencies**: Notes on cross-impact

## Expected Report Output

```markdown
# Analysis: [Feature Title]

## Summary
[1-2 clear sentences]

## Use Cases
- Use case 1 (NEW | MODIFIED)
- Use case 2 (NEW | MODIFIED)

## Data Model
| Entity | Change Type | Details | Objective |
|--------|------------|---------|-----------|
| users | NEW FIELD | `verification_status` (enum) | Track verification state |
| users | NEW FIELD | `verified_at` (timestamp) | Track verification date |

## User Interface
| Screen | Modification | Type | Details |
|--------|-------------|------|---------|
| User Profile | New field | NEW | Display verification status |
| Settings | Button removed | REMOVED | "Revoke verification" |

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Risks / Dependencies
- Note on potential cross-impact
```

## Key Points

- **Precision**: For each data model change, explain WHY (objective)
- **UI clarity**: Distinguish NEW (new element), MODIFIED (existing element changed), REMOVED (deleted)
- **Completeness**: Verify all use cases covered by UI and data model changes

## Chat Output

Report generated + 2-sentence summary only in chat. Full analysis in `.github/feature_analyze/YYYYMMDD_hhmm_analysis.md`.
