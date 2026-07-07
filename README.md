# okf-matt-skills

Agent skills for [Claude Code](https://claude.com/claude-code), reworked around the
[Open Knowledge Format (OKF)](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md).

A fork of [Matt Pocock's skills](https://github.com/mattpocock/skills), re-tuned so the whole
engineering flow reads and writes an OKF knowledge bundle (`knowledge/` — a glossary and ADRs)
instead of ad-hoc docs.

## What's different from upstream

- **Ported to OKF** — domain modeling, PRDs, and the knowledge bundle all follow the OKF spec.
- **Added `reconcile`** — a closeout step that brings the OKF bundle back into
  agreement with the code that actually shipped, so knowledge doesn't drift between sessions.
- **Renamed** the skills you type most — shorter, and with no personal-name references.

### Renamed skills

| mattpocock/skills | okf-matt-skills |
|---|---|
| `ask-matt` | `which-skill` |
| `code-review` | `vet` |
| `diagnosing-bugs` | `debug` |
| `grill-me` | `grill-plain` |
| `grill-with-docs` | `grill` |
| `improve-codebase-architecture` | `improve-arch` |
| `setup-matt-pocock-skills` | `setup-okf-matt-skills` |
| `writing-great-skills` | `write-skill` |

Every other skill keeps its upstream name.

## Install

Skills are just folders — no package manager, no lockfile. Clone the repo and link the skills
into `~/.claude/skills/`:

```sh
git clone https://github.com/evist0/okf-matt-skills.git
cd okf-matt-skills
./install.sh            # symlink every skill into ~/.claude/skills (edits stay live)
# ./install.sh --copy   # copy instead, if you don't want symlinks
```

Browse the folders in this repo to see what's on offer, or once installed just ask `/which-skill`
and it will route you to the right one.

## Credits

Built on and deeply indebted to [Matt Pocock's skills](https://github.com/mattpocock/skills).
The original design — the relentless grilling interview, the idea → ship flow, the deep-module
design vocabulary — is all his. This fork only re-tunes it to OKF and trims a few names.
Thank you, Matt. MIT-licensed, same as upstream.
