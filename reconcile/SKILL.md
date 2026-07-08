---
name: reconcile
description: Reconcile the OKF knowledge bundle (knowledge/) with what a completed code change built, over that change's diff. Use once a change has finished landing — the build closeout, just before committing — or when the user asks to reconcile knowledge against code.
---

# Reconcile

A change landed: the code moved, but the OKF bundle (`knowledge/`) may not have. **Reconcile** them — bring durable knowledge back into agreement with what was actually built, so the next session starts from a consistent bundle.

This is the *writing* discipline of the **build** phase — the mirror of `/domain-modeling`, which writes the bundle during **design**. It runs last in the `/implement` closeout, over the same diff `/vet` judged, so code and knowledge land in one commit.

## Scope

Reconcile against the diff, never the whole bundle. Fixed point is the one `/vet` used, or one the user supplies: `git diff <fixed-point>...HEAD`.

Durable knowledge is everything under `knowledge/` — the canonical categories `glossary/`, `adr/`, and `prd/`, plus any project-specific concept category registered in `knowledge/index.md`. Touch a concept only when the diff gives you a reason to.

## Process

Reconcile runs in two phases: a **sub-agent** analyses the diff and applies the mechanical fixes, then the **main context** does the judgement writes. The split keeps the heavy bundle-searching out of the main context — as `/vet` does — while leaving the consequential writes where the implementation reasoning lives.

### Phase 1 — Analysis (sub-agent)

First write a **build-rationale brief** for the sub-agent — this is what keeps its classification from being blind. Keep it to a few hundred words:

- **Pointers, not copies** — the PRD/issue reference and the commit list (`git log <fixed-point>..HEAD --oneline`). The sub-agent reads these itself; don't paste them.
- **The unwritten "why"** — a short synthesis of the non-obvious decisions made while implementing: the "chose X over Y because…" that lives in no file. This is the only input the sub-agent cannot obtain on its own, and the thing its judgement of unrecorded/violated decisions depends on.

Then spawn one `general-purpose` sub-agent, passing it: the diff command `git diff <fixed-point>...HEAD`, the brief, and the **Classes** table below. Its brief:

1. **Gather candidates** — two nets over the diff:
   - **Referenced** — every concept whose `implements:` frontmatter or `## Implementation mapping` paths intersect a changed file. Grep the bundle for the changed paths.
   - **Unrecorded ground** — code built in the diff that no concept references at all. This is where a new decision hides. (Detection is diff-derived and does not depend on the brief; the brief only informs whether the ground is consequential.)

   The candidate set is the union. A referenced concept the diff didn't actually affect drops out here.
2. **Classify** each candidate against the diff and the brief, using the Classes table. Where you cannot confidently pick one class, do not guess — flag the candidate as ambiguous, carrying both readings. Classifying by guess is the one way this skill does harm: a mislabelled violation gets laundered into the record.
3. **Apply referential fixes itself** — fix each reference inline and log them (see **Log**). This is the only class the sub-agent writes.
4. **Return a proposal** — for every contentious candidate (stale / unrecorded / violated): the class, the changed hunk(s), the relevant concept, and the evidence for the class. Do not write these.

### Classes

Each candidate's **class** fixes who is authoritative and what may be written:

| Class | Authoritative | Why |
|---|---|---|
| **Referential** — a mapped path was renamed/moved/deleted, a `depends-on` link no longer resolves, a `lifecycle` flag lags reality | code | the record points at code that no longer exists as written |
| **Stale description** — the concept's prose describes behaviour the diff legitimately changed | code | the model evolved; the record is behind |
| **Unrecorded decision** — the diff commits to something hard to reverse, non-obvious, and consequential that no concept holds | the gap | a real decision was made and never written down |
| **Violated decision** — the diff contradicts an *accepted* ADR or architecture concept | knowledge | the record is a guard; the code, not the record, is the suspect |

Act on each class:

- **Referential** → fixed in Phase 1 by the sub-agent (above).
- **Stale description** → Phase 2: show the rewritten prose for that concept, one concept at a time; write on the user's confirmation.
- **Unrecorded decision** → Phase 2: propose an ADR or concept, *sparingly* — only when the decision clears all three of hard-to-reverse, non-obvious, consequential. Write on confirmation. Most changes clear none and record nothing. If the unrecorded ground is a new *kind* of entity that fits no existing category (`glossary`, `adr`, `prd`, or a registered one), the extensibility rule applies: propose a new category, get the user's sanction, and register it in `knowledge/index.md` before writing. Default to the existing categories.
- **Violated decision** → Phase 2: leave the recorded decision exactly as written and surface it as a finding. A live contradiction with an accepted decision is a signal to fix the code or reopen the ADR deliberately — never to quietly edit the record to match the breach.

### Phase 2 — Confirm & write (main context)

Take the sub-agent's proposal and act on each contentious candidate by its class, as the bullets above specify.

For any candidate the sub-agent flagged as ambiguous, **put it to the user**: state both readings, and what each costs if you pick wrong. Leave nothing unclassified.

### Log

Every write to the bundle appends a dated section to `knowledge/log.md` (newest first, ISO date heading) and refreshes the touched concept's `timestamp`. Two writers append here: the sub-agent's auto-applied referential fixes enter as **one summary block**, not a line each; the main context's Phase 2 writes go in **after** the sub-agent returns, newest on top.

## Completion

Done when:

- every **referenced** candidate is classified and actioned,
- every changed file has been checked for **unrecorded ground**,
- every bundle write is mirrored in `knowledge/log.md`, and
- every divergence you could not classify has been put to the user.

A candidate left unclassified, or a write missing from the log, means not done.
