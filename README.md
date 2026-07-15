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

Each skill lives in its own folder. Copy the folder into your agent's skills directory:

```
# Claude Code (user-level)
~/.claude/skills/<skill-name>/

# or project-level
<your-repo>/.claude/skills/<skill-name>/
```

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
