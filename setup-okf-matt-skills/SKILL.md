---
name: setup-okf-matt-skills
description: Configure this repo for the engineering skills — set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills.
disable-model-invocation: true
---

# Setup okf-matt-skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where the OKF knowledge bundle (`knowledge/`) lives, and the consumer rules for reading it

All three land in the **agent layer** at `knowledge/_agents/` — a reserved, `_`-prefixed
service directory inside the OKF bundle that holds agent-operational config and notes, and
is **never** a domain context (see "The agent layer" below).

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `knowledge/` — the OKF knowledge bundle at the repo root (`knowledge/glossary/`, `knowledge/adr/`, `knowledge/index.md`), including any per-context subdirectories
- `knowledge/_agents/` — does this skill's prior output already exist? (Legacy repos may have it under `knowledge/_agents/` — an earlier layout; if you find that, migrate it to `knowledge/_agents/` as part of this run.)
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use

### 2. Present findings and ask

Summarise what's present and what's missing. Then walk the user through the three decisions **one at a time** — present a section, get the user's answer, then move to the next. Don't dump all three at once.

Assume the user does not know what these terms mean. Each section starts with a short explainer (what it is, why these skills need it, what changes if they pick differently). Then show the choices and the default.

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-issues`, `triage`, `to-prd`, and `qa` read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub** — issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab** — issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown** — issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.) — ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

If — and only if — the user picked **GitHub** or **GitLab**, ask one follow-up:

> Explainer: Open-source repos often receive feature requests as pull requests, not just issues — a PR is an issue with attached code. If you turn this on, `/triage` pulls *external* PRs into the same queue and runs them through the same labels and states as issues (collaborators' in-flight PRs are left alone). Leave it off if PRs aren't a request surface for you.

- **PRs as a request surface** — yes / no (default: no). Record the answer in `knowledge/_agents/issue-tracker.md`. For local-markdown and other trackers, skip this question — there are no PRs.

**Section B — Triage label vocabulary.**

> Explainer: When the `triage` skill processes an incoming issue, it moves it through a state machine — needs evaluation, waiting on reporter, ready for an AFK agent to pick up, ready for a human, or won't fix. To do that, it needs to apply labels (or the equivalent in your issue tracker) that match strings *you've actually configured*. If your repo already uses different label names (e.g. `bug:triage` instead of `needs-triage`), map them here so the skill applies the right ones instead of creating duplicates.

The five canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready (an agent can pick it up with no human context)
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Default: each role's string equals its name. Ask the user if they want to override any. If their issue tracker has no existing labels, the defaults are fine.

**Section C — Domain docs.**

> Explainer: Some skills (`improve-arch`, `debug`, `tdd`) read the project's OKF knowledge bundle (`knowledge/`) to learn the domain language (`knowledge/glossary/`) and past architectural decisions (`knowledge/adr/`). They need to know whether the repo has one global context or multiple (e.g. a monorepo with separate frontend/backend contexts) so they look in the right place.

Confirm the layout:

- **Single-context** — one `knowledge/` bundle with `glossary/` and `adr/` at its root. Most repos are this.
- **Multi-context** — one `knowledge/` bundle whose `index.md` is a context map, with each context as a subdirectory (`knowledge/<context>/glossary/`, `knowledge/<context>/adr/`) and system-wide decisions in `knowledge/adr/` (typically a monorepo).

## The agent layer (`knowledge/_agents/`)

The three config files above are **not** domain knowledge — they describe how an agent
operates in this repo (tooling, labels, how to read the domain). They live in a dedicated
service directory inside the OKF bundle:

```
knowledge/
├── index.md              # domain context map — does NOT list _agents
├── _agents/              # the agent layer (reserved, not a domain context)
│   ├── index.md          # gatekeeper: what belongs here, what doesn't
│   ├── issue-tracker.md  # A — operational config
│   ├── triage-labels.md  # A
│   ├── domain.md         # A — consumer rules for reading the domain bundle
│   └── notes/            # B — accumulated operational knowledge, grows lazily
│       └── index.md
└── <domain contexts…>
```

**Isolation contract.** Any subdirectory of `knowledge/` whose name starts with `_` is a
reserved service directory, **never** a domain context. Domain consumers (`domain-modeling`,
`improve-arch`, `tdd`, `debug`) navigate via the context map in `knowledge/index.md` and skip
`_`-prefixed dirs — so `_agents` never pollutes the domain model. Keep `_agents` out of
`knowledge/index.md`'s context list.

**A vs B — what goes in the agent layer:**

- **A (config, fixed set):** `issue-tracker.md`, `triage-labels.md`, `domain.md`. Stable
  contracts, live at the `_agents/` root.
- **B (`notes/`, grows lazily):** operational knowledge about *this repo/tooling* that is
  neither domain nor global harness config — tooling gotchas, local conventions, "why we do
  it this way here". One file per note. Its `index.md` is the gatekeeper.

  What does **not** belong in `notes/` (redirect it):
  - Domain terms / invariants → `knowledge/<context>/glossary/`, `adr/`
  - Architectural decisions → `adr/`
  - How to build/run/test the project, global commands → `CLAUDE.md` / `AGENTS.md`

Use the light OKF regime for `_agents/`: hand-maintained `index.md` files, plain markdown,
no required frontmatter. It's a small service folder — full OKF entry frontmatter is
overkill here.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `knowledge/_agents/issue-tracker.md`, `knowledge/_agents/triage-labels.md`, `knowledge/_agents/domain.md`

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked, plus whether external PRs are a triage surface]. See `knowledge/_agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `knowledge/_agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `knowledge/_agents/domain.md`.
```

Create the `knowledge/_agents/` directory and write the config files using the seed
templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — local-markdown issue tracker
- [triage-labels.md](./triage-labels.md) — label mapping
- [domain.md](./domain.md) — domain doc consumer rules + layout
- [agents-index.md](./agents-index.md) — the `_agents/index.md` gatekeeper (what belongs, what doesn't)

Also write:

- `knowledge/_agents/index.md` — from [agents-index.md](./agents-index.md).
- `knowledge/_agents/notes/index.md` — a stub index for the (initially empty) B notes:
  a one-line heading plus "No notes yet." Notes are added lazily later.

If a legacy `docs/agents/` exists from an earlier layout, move its files into
`knowledge/_agents/` and delete `docs/agents/` (and `docs/` if it's now empty).

For "other" issue trackers, write `knowledge/_agents/issue-tracker.md` from scratch using the user's description.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `knowledge/_agents/*.md` directly later — re-running this skill is only necessary if they want to switch issue trackers or restart from scratch.
