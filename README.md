# Fintech Product Skills

**English** | [中文](./README.zh-CN.md)

A collection of [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills) for product
and engineering work, born out of real fintech / payments product practice — but written to be
**generic and reusable** on any team. Each skill is self-contained, secret-free, and configured
by editing placeholders (no API keys committed).

## Skills

| Skill | What it does |
|---|---|
| [`jira-ticket-writer`](./jira-ticket-writer) | Turns messy, mixed-language task notes into clean, structured English Jira tickets — auto-picks Story/Bug, Component, and Priority (P0/P1/P2), and files them via the Atlassian MCP. |
| [`sprint-demo-memo`](./sprint-demo-memo) | Turns a finished sprint into a company-wide demo memo — pulls Jira tickets, classifies what's demoable (excluding Compliance/TM rule changes), groups by theme, drafts in demo voice, and publishes to Confluence. |

_More skills coming — this repo is the umbrella for product/engineering agent skills._

## Install a skill

Each skill lives in its own folder. Replace `<skill-name>` with the skill you want (e.g.
`jira-ticket-writer`).

**Easiest — the install script** (clone once, then run it):

```bash
# macOS / Linux
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
cd fintech-product-skills
./install.sh                    # all skills  ·  or:  ./install.sh jira-ticket-writer
```

```powershell
# Windows (PowerShell)
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
cd fintech-product-skills
.\install.ps1                   # all skills  ·  or:  .\install.ps1 jira-ticket-writer
```

The script installs to `~/.claude/skills/` by default. For a project-level install, set the
destination: `DEST=./my-repo/.claude/skills ./install.sh` (or `-Dest` on PowerShell).

---

Prefer to do it by hand? Pick one of these:

**One skill, no git history** (needs [Node.js](https://nodejs.org)):

```bash
npx degit aminahxueyanma-ops/fintech-product-skills/<skill-name> ~/.claude/skills/<skill-name>
```

**With git — macOS / Linux:**

```bash
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
mkdir -p ~/.claude/skills
cp -r fintech-product-skills/<skill-name> ~/.claude/skills/
```

**With git — Windows (PowerShell):**

```powershell
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Copy-Item -Recurse "fintech-product-skills\<skill-name>" "$HOME\.claude\skills\"
```

> **Install all skills at once:** replace the single `<skill-name>` copy with the whole repo —
> `npx degit aminahxueyanma-ops/fintech-product-skills ~/.claude/skills-src` (then move the skill
> folders into `~/.claude/skills/`), or just `cp -r fintech-product-skills/*/ ~/.claude/skills/`
> after cloning.
>
> **Project-level instead of user-level:** swap `~/.claude/skills/` for
> `<your-repo>/.claude/skills/`.

Then follow the per-skill `README.md` and configure the placeholders in its `SKILL.md`.

## No secrets

None of these skills store credentials. Where a skill talks to an external service (e.g. Jira),
it does so through an **MCP server**, and authentication lives in that MCP layer — not in the
skill file. The values you fill into a `SKILL.md` (project keys, cloud IDs, component IDs) are
identifiers, not keys, and are safe to commit.

## License

[MIT](./LICENSE) — see each skill's README for details.

## Contributing

Issues and PRs welcome.
