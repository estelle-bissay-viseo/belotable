---
name: doc-user
description: 'Update user-facing docs in user-docs/ from latest commit on current branch. Use when Flutter app changes were made in belotable/ and docs must stay non-technical, use-case oriented, screen-flow ordered, and PDF-ready with screenshot TODO markers.'
argument-hint: 'Optional: target page(s) in user-docs/docs, or "auto" for full detection'
---

# Update User Docs From Last Commit

## Goal

Translate latest Flutter app changes (from `belotable/` only) into user documentation updates in `user-docs/docs/`.

Output must be:
- User-oriented (no technical internals)
- Written in French
- Written as practical use-cases
- Ordered by real user journey through available screens
- Ready for PDF generation
- Prepared with screenshot TODO markers for manual completion
- Focused on nominal user journey (do not detail error cases)

## When To Use

Use this skill when:
- Last commit modified user-visible behavior in `belotable/`
- You need to update user documentation quickly and reliably
- You must keep docs synchronized with current branch HEAD

Do not use this skill for:
- Purely technical docs (use `technical-docs/` process instead)
- Infrastructure/build-only commits with no user-facing impact

## Repository Constraints

- Flutter project root is `belotable/` (not repo root).
- Analyze only app changes from the latest commit on current branch.
- Update files only in `user-docs/docs/` (and navigation references when needed).
- Keep language and structure compatible with final PDF rendering.

## Procedure

1. Identify scope from latest commit
- Inspect `HEAD` changed files.
- Keep only paths under `belotable/`.
- Ignore non-user-visible changes (refactor, tooling, tests, CI, formatting).

2. Extract user-visible deltas
- For each relevant change, answer:
  - What user can now do?
  - What user now does differently?
  - Which screen/step is affected?
  - Any removed or renamed action?
- If no user-visible delta exists, stop and report: no user-doc update required.

3. Build use-case list
- Convert deltas into user use-cases with this structure:
  - Context
  - User action
  - Expected result (nominal path only)
- Keep wording concrete and task-based.
- Remove technical terms unless users see them in UI.
- Do not document validation/error/edge cases unless explicitly requested.

4. Order by screen journey
- Sort use-cases in natural app progression:
  - Entry point/start screen
  - Main navigation
  - Feature flows
  - Completion/confirmation states
- If order is ambiguous, infer from available screens and current user flow.

5. Map to documentation pages
- Distribute updates across all relevant pages in `user-docs/docs/`.
- Create a new page when it improves clarity of a user journey or use-case group.
- Keep titles user-centric and action-oriented.

6. Insert screenshot placeholders
- For each major step or UI state, add screenshot markdown + TODO comment using this exact pattern:

```markdown
![<short user-facing alt text>](./assets/images/<file-name>.png)
<!-- SCREENSHOT_TODO Purpose: <what user should notice> -->
```

- Place block immediately after related step paragraph.
- Use deterministic file-name convention: `page-<screen>-<action>.png` in lowercase kebab-case.
- Keep purpose short and observable from UI.

7. Ensure PDF-readability
- Keep heading levels consistent and linear.
- Avoid overly wide tables.
- Keep steps concise and scannable.
- Avoid references to interactive-only behaviors that do not translate to PDF.

8. Validate output quality
- Check every documented change maps to a real user-visible change from `HEAD`.
- Check logical user journey ordering.
- Check screenshot markdown + `SCREENSHOT_TODO` comments exist for key screens/states.
- Check text avoids implementation details.
- Check content remains fully French.
- Check no detailed error-case section was added.

## Decision Rules

- If commit touches both technical and UX code:
  - Document only UX-visible outcomes.
- If one change impacts multiple screens:
  - Document primary journey first, then alternate path.
- If behavior changed but UI wording did not:
  - Describe changed outcome, not internal mechanism.
- If uncertain whether user-facing:
  - Prefer omission and ask a focused clarification question.
- Small contextual rewrite is allowed only in adjacent sections to preserve readability.

## Output Contract

Provide:
1. Updated files list in `user-docs/docs/`
2. Use-cases added/changed (ordered)
3. Screenshot blocks inserted (image path + `SCREENSHOT_TODO` purpose)
4. Short validation note confirming:
- Based on last commit only
- Flutter scope limited to `belotable/`
- User-facing language only

## Completion Checklist

- [ ] Latest commit (`HEAD`) reviewed
- [ ] Only `belotable/` app changes considered
- [ ] Non-user-visible changes ignored
- [ ] Use-cases written and ordered by screen journey
- [ ] Screenshot blocks inserted at relevant steps using image + `SCREENSHOT_TODO`
- [ ] Pages remain PDF-friendly
- [ ] No technical implementation details leaked
- [ ] Content written in French
- [ ] No detailed error/validation use-case added unless explicitly requested
