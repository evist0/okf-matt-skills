# Agent layer (`_agents`)

Reserved service directory inside the OKF knowledge bundle. It holds **agent-operational**
material — how an agent works with *this* repo — and is **not** a domain context.

> **Isolation contract.** This directory is named with a leading `_`. Any `knowledge/`
> subdirectory whose name starts with `_` is a reserved service directory, never a domain
> context. It is intentionally absent from the context map in `knowledge/index.md`, and
> domain consumers (`domain-modeling`, `improve-arch`, `tdd`, `debug`) skip it.

## What lives here

**A — config (fixed set, at this root):**

- [issue-tracker.md](issue-tracker.md) — where issues live and how to operate on them.
- [triage-labels.md](triage-labels.md) — the five canonical triage roles → this repo's labels.
- [domain.md](domain.md) — consumer rules for reading the domain bundle.

**B — [notes/](notes/index.md) (grows lazily):** operational knowledge about this
repo/tooling that is neither domain nor global harness config — tooling gotchas, local
conventions, "why we do it this way here". One file per note.

## What does NOT belong here

Redirect it to its proper home:

| Material | Goes to |
| --- | --- |
| Domain terms, game/product invariants | `knowledge/<context>/glossary/`, `adr/` |
| Architectural decisions | `adr/` (context-specific or system-wide) |
| How to build / run / test, global commands | `CLAUDE.md` / `AGENTS.md` |

If it isn't A (config above) or B (a repo/tooling gotcha or local convention), it doesn't
belong in `_agents/`. This index is the gatekeeper — keep it honest.
