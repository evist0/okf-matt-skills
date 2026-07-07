---
name: reconcile
description: Reconcile the OKF knowledge bundle with what a code change actually built. Run in the implement closeout before committing, or after any change that lands code.
disable-model-invocation: true
---

# Reconcile

A change landed: the code moved, but the OKF bundle (`knowledge/`) may not have. **Reconcile** them — bring durable knowledge back into agreement with what was actually built, so the next session starts from a consistent bundle.

This is the *writing* discipline of the **build** phase — the mirror of `/domain-modeling`, which writes the bundle during **design**. It runs last in the `/implement` closeout, over the same diff `/vet` judged, so code and knowledge land in one commit.

## Scope

Reconcile against the diff, never the whole bundle. Fixed point is the one `/vet` used, or one the user supplies: `git diff <fixed-point>...HEAD`.

Durable knowledge is everything under `knowledge/` — `concepts/`, `architecture/`, `decisions/`, `prd/`, `processes/`, `glossary/`. Touch a concept only when the diff gives you a reason to.

## Process

### 1. Gather candidates

Two nets over the diff:

- **Referenced** — every concept whose `implements:` frontmatter or `## Implementation mapping` paths intersect a changed file. Grep the bundle for the changed paths.
- **Unrecorded ground** — code built in the diff that no concept references at all. This is where a new decision hides.

The candidate set is the union. A referenced concept the diff didn't actually affect drops out here.

### 2. Classify each divergence

Read each candidate against the diff and name its **class** — the class fixes who is authoritative and what you may write:

| Class | Authoritative | Why |
|---|---|---|
| **Referential** — a mapped path was renamed/moved/deleted, a `depends-on` link no longer resolves, a `lifecycle` flag lags reality | code | the record points at code that no longer exists as written |
| **Stale description** — the concept's prose describes behaviour the diff legitimately changed | code | the model evolved; the record is behind |
| **Unrecorded decision** — the diff commits to something hard to reverse, non-obvious, and consequential that no concept holds | the gap | a real decision was made and never written down |
| **Violated decision** — the diff contradicts an *accepted* ADR or architecture concept | knowledge | the record is a guard; the code, not the record, is the suspect |

When two classes are live for one divergence and you cannot tell which, **put it to the user**: state both readings, and what each costs if you pick wrong. Classifying by guess is the one way this skill does harm — a mislabelled violation gets laundered into the record. Leave nothing unclassified.

### 3. Act by class

- **Referential** → fix the reference inline. Batch every referential fix and report them as one summary.
- **Stale description** → show the rewritten prose for that concept, one concept at a time; write on the user's confirmation.
- **Unrecorded decision** → propose an ADR or concept, *sparingly* — only when the decision clears all three of hard-to-reverse, non-obvious, consequential. Write on confirmation. Most changes clear none and record nothing.
- **Violated decision** → leave the recorded decision exactly as written and surface it as a finding. A live contradiction with an accepted decision is a signal to fix the code or reopen the ADR deliberately — never to quietly edit the record to match the breach.

### 4. Log

Every write to the bundle appends a dated section to `knowledge/log.md` (newest first, ISO date heading) and refreshes the touched concept's `timestamp`. Auto-applied referential fixes enter the log as **one summary block**, not a line each.

## Completion

Done when:

- every **referenced** candidate is classified and actioned,
- every changed file has been checked for **unrecorded ground**,
- every bundle write is mirrored in `knowledge/log.md`, and
- every divergence you could not classify has been put to the user.

A candidate left unclassified, or a write missing from the log, means not done.
