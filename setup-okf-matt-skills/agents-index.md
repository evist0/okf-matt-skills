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

## Contributing a note (protocol)

Notes accumulate as agents work. Don't wait to be asked — but don't write noise either. A
candidate qualifies only if **all four** hold:

1. **Repo/tooling** — a fact about *this* repo or its tooling, not domain (→ `glossary/`,
   `adr/`) and not global build/run (→ `CLAUDE.md` / `AGENTS.md`).
2. **Non-obvious** — not derivable from the code or `CLAUDE.md` at a glance.
3. **Durable** — it will help again, not a one-off for this task only.
4. **Not already recorded** — check `notes/index.md` first.

When a candidate qualifies, tier it by whether *not* recording it now costs the **current**
task:

- **Tier 1 — load-bearing now.** You (or a sub-agent) will hit this again before the task
  ends if it isn't written down — typically a gotcha that already cost a cycle. **Write it
  immediately**, without interrupting the flow. It lives in the working tree, uncommitted.
- **Tier 2 — useful later, not now.** Helpful to future agents but not to the task in hand.
  **Don't write it mid-flow** — hold it as a candidate.

**One confirmation point — the closeout.** Before the change is committed (or, in a skill
with no commit, at the end of your response), surface both at once: "I recorded [Tier-1
notes] to avoid re-stumbling, and I'm proposing [Tier-2 candidates] — keep all / edit / drop
which?" Nothing reaches a commit without the user's sign-off; a rejected Tier-1 note is
deleted on the spot.

Notes use the light regime: one file per note, plain markdown, no required frontmatter. For
each kept note, add a `* [title](file.md) — one-line` line to `notes/index.md`.
