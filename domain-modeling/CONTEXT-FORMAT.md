# OKF Glossary Format

The project's domain glossary lives in an **Open Knowledge Format (OKF)** knowledge bundle at `knowledge/` in the repo root. Each canonical term is its own concept file under `knowledge/glossary/`.

Create files lazily — only when a term is actually resolved.

## Where terms live

```
knowledge/
├── index.md              # bundle map (reserved: no frontmatter)
├── log.md                # change history, newest first (reserved: no frontmatter)
└── glossary/
    ├── index.md          # lists every term, one line each (reserved: no frontmatter)
    ├── order.md
    ├── invoice.md
    └── customer.md
```

## A term concept

Every glossary file is one term: OKF frontmatter (`type` is the only *required* field — every non-reserved file must carry a non-empty `type`; the rest are recommended) followed by a tight definition.

```md
---
type: Glossary Term
title: Order
description: A customer's request to purchase goods, tracked from placement to fulfilment.
tags: [ordering]
timestamp: 2026-07-07T00:00:00Z
avoid: [purchase, transaction]
related:
  - /glossary/invoice.md
  - /glossary/customer.md
---

# Order

A customer's request to purchase goods, tracked from placement to fulfilment.

_Avoid_: purchase, transaction
```

- `type` — always `Glossary Term`.
- `title` — the canonical term.
- `description` — the one-to-two-sentence definition (mirror it in the body).
- `avoid` — the synonyms this term replaces; also render them inline as `_Avoid_:` so a reader sees them.
- `related` — **bundle-relative** links (leading `/` = bundle root, e.g. `/glossary/invoice.md`) to related terms. Links are **bidirectional**: when you link A→B, add B→A.
- `timestamp` — ISO 8601.

## Rules

- **Be opinionated.** When multiple words exist for one concept, pick the best one as the term and list the rest under `avoid`.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only project-specific terms.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this unique to this project's domain, or a general programming concept? Only the former belongs.
- **Bidirectional links.** Every `related` link is mirrored on the term it points at.

## index.md and log.md (OKF discipline)

- `knowledge/glossary/index.md` — reserved, **no frontmatter**. Lists each term as `* [Term](term.md) — one-line description`. Update it whenever you add or rename a term.
- `knowledge/log.md` — reserved, **no frontmatter**. Newest entry first, under an ISO date heading, with a bold convention label:

  ```md
  ## 2026-07-07

  **Creation** — Added glossary term [Order](/glossary/order.md).
  **Update** — Sharpened [Customer](/glossary/customer.md); moved "account" to _Avoid_.
  ```

  Append to it every time knowledge changes.

## Single vs multi-context repos

**Single context (most repos):** one `knowledge/` bundle; terms live directly under `knowledge/glossary/`.

**Multiple contexts:** when a repo has multiple bounded contexts (e.g. a monorepo with separate frontend/backend domains), give each context its own subdirectory *inside the one bundle*:

```
knowledge/
├── index.md              # the context map: lists contexts and how they relate
├── log.md
├── adr/                  # system-wide decisions
├── ordering/
│   ├── glossary/
│   └── adr/              # context-specific decisions
└── billing/
    ├── glossary/
    └── adr/
```

`knowledge/index.md` is the map — it lists each context, where it lives, and the relationships between them. Infer which context the current topic belongs to; if unclear, ask.

## Reserved service directories (`_`-prefix)

Any `knowledge/` subdirectory whose name starts with `_` is a **reserved service directory**, not a domain context — for example `knowledge/_agents/` (agent-operational config and notes). These directories:

- are **never** listed in the `knowledge/index.md` context map;
- are **never** treated as a context by domain skills — don't read them as glossary/ADR sources, don't infer domain terms from them, don't put domain terms into them;
- are off-limits to `/domain-modeling` — it only ever creates/edits real contexts.

When you enumerate contexts, skip `_`-prefixed directories. When creating a new context, never start its name with `_`.
