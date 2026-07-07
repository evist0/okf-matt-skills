# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

The domain model lives in an **Open Knowledge Format (OKF)** knowledge bundle at `knowledge/` in the repo root.

## Before exploring, read these

- **`knowledge/glossary/`** — the domain glossary (one file per term). Read the terms relevant to the topic.
- **`knowledge/adr/`** — read ADRs that touch the area you're about to work in.
- **`knowledge/index.md`** — the bundle map. In multi-context repos it lists the contexts; read the glossary/ADRs of the relevant context subdirectory (`knowledge/<context>/glossary/`, `knowledge/<context>/adr/`) as well as system-wide `knowledge/adr/`.

**Reserved service dirs.** Any `knowledge/` subdirectory whose name starts with `_` (e.g.
`knowledge/_agents/`) is a service directory, **not** a domain context. It is intentionally
absent from the context map. Skip it when learning the domain — never read it as a glossary
or ADR source.

If the bundle or these directories don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The `/domain-modeling` skill (reached via `/grill` and `/improve-arch`) creates them lazily when terms or decisions actually get resolved.

## File structure

Single-context repo (most repos):

```
knowledge/
├── index.md
├── log.md
├── glossary/
│   ├── index.md
│   ├── order.md
│   └── customer.md
└── adr/
    ├── index.md
    ├── adr-0001-event-sourced-orders.md
    └── adr-0002-postgres-for-write-model.md
```

Multi-context repo (`knowledge/index.md` is the context map):

```
knowledge/
├── index.md                          ← context map
├── log.md
├── adr/                              ← system-wide decisions
├── _agents/                          ← reserved service dir — NOT a context, skip it
├── ordering/
│   ├── glossary/
│   └── adr/                          ← context-specific decisions
└── billing/
    ├── glossary/
    └── adr/
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `knowledge/glossary/`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `/domain-modeling`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
