# OKF ADR Format

ADRs are **Open Knowledge Format (OKF)** concepts. They live in `knowledge/adr/` inside the repo's knowledge bundle, with sequential numbering: `adr-0001-slug.md`, `adr-0002-slug.md`, etc.

Create the `knowledge/adr/` directory lazily — only when the first ADR is needed.

## Template

```md
---
type: ADR
title: ADR-0001 — Event-sourced orders
description: The write model is event-sourced; the read model is projected into Postgres.
tags: [adr, ordering]
timestamp: 2026-07-07T00:00:00Z
status: accepted
decided: 2026-07-07
superseded-by: ""
related:
  - /glossary/order.md
---

# ADR-0001 — Event-sourced orders

{1-3 sentences: what's the context, what did we decide, and why.}
```

An ADR can be a single paragraph. The value is in recording *that* a decision was made and *why* — not in filling out sections. `type: ADR` is the only field OKF *requires*; the rest of the frontmatter is recommended.

## Frontmatter

- `type` — always `ADR`.
- `title` — `ADR-NNNN — {short title}`.
- `status` — `proposed | accepted | deprecated | superseded`.
- `decided` — ISO date the decision landed.
- `superseded-by` — bundle-relative link to the ADR that replaces this one, or `""`.
- `related` — bundle-relative links (`/glossary/...`, `/adr/...`) to the concepts this decision touches. Bidirectional — mirror the link on the other concept.
- `timestamp` — ISO 8601.

## Optional body sections

Only include these when they add genuine value. Most ADRs won't need them.

- **Considered Options** — only when the rejected alternatives are worth remembering
- **Consequences** — only when non-obvious downstream effects need to be called out

## Numbering

Scan `knowledge/adr/` for the highest existing number and increment by one.

## index.md and log.md

- `knowledge/adr/index.md` — reserved, no frontmatter. Lists each ADR: `* [ADR-0001 — Event-sourced orders](adr-0001-event-sourced-orders.md) — one-line summary`.
- Append to `knowledge/log.md` (newest first, ISO date heading, bold label) whenever an ADR is created or its status changes.

## When to offer an ADR

All three of these must be true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it — you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."

### What qualifies

- **Architectural shape.** "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth provider, deployment target. Not every library — just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "We're using manual SQL instead of an ORM because X." Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code.** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **Rejected alternatives when the rejection is non-obvious.** If you considered GraphQL and picked REST for subtle reasons, record it — otherwise someone will suggest GraphQL again in six months.
