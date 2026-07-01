# AI Memory README

This folder contains verified facts used by project agents.

## Loading protocol
- Each agent loads its own `*.memory.md` file at task start.
- Only verified facts are stored.
- Outdated facts are moved to `*.memory.archive.md` files.

## Fact entry format

```markdown
## Fact: <short title>
- Detail: <verified fact>
- Source: <file path, PR, issue, or validated statement>
- Last verified: YYYY-MM-DD
- Owner: <agent-slug>
- Status: Active
```
