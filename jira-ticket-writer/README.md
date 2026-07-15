# Jira Ticket Writer — an Agent Skill

**English** | [中文](./README.zh-CN.md)

Turn messy, half-baked task descriptions into clean, well-structured English Jira tickets —
and create them directly in Jira. Paste a rough note (English, Chinese, or a mix), and the
skill drafts a proper **Story** or **Bug**, picks the right **Component**, auto-assigns a
**Priority (P0/P1/P2)**, and files it via the Atlassian MCP.

Built as a [Claude Agent Skill](https://docs.claude.com/en/docs/claude-code/skills). Works in
Claude Code and other agent runtimes that support skills.

## What it does

- **Understands messy input** — bullet dumps, chat snippets, mixed English/Chinese, vague
  complaints. It reads intent, not just keywords.
- **Asks one clarifying question** — always confirms who raised the request (name + role) so
  the ticket has proper attribution.
- **Structures the ticket** — Background / Business Value / Objective / Additional Notes, in a
  consistent house style, always in English.
- **Auto-classifies** — Story vs. Bug, the right Component, and a Priority chosen by an
  explicit, auditable framework (no more "everything is urgent").
- **Files it for you** — creates the issue in Jira via the Atlassian MCP and returns the key +
  link.

## Requirements

- An agent runtime that supports skills (e.g. Claude Code).
- The **Atlassian MCP** connected, with permission to create issues in your project.

## Authentication

**This skill does not store or require any API key.** It never talks to the Jira REST API
directly — it creates issues through the **Atlassian MCP**, and authentication lives entirely
in that MCP layer, not in this skill.

- **The official Atlassian MCP uses OAuth.** You connect it once in your agent and authorize
  your Atlassian account in the browser — no token to paste, nothing secret to configure here.
- **The values you put in `SKILL.md`** (`<YOUR_PROJECT_KEY>`, `<YOUR_ATLASSIAN_CLOUD_ID>`,
  component/priority IDs) are **identifiers, not credentials** — they are safe to commit, even
  to a public repo. Think of them as an address, not a key.
- **If you use a third-party Jira MCP** that authenticates with an API token instead of OAuth,
  that token goes in **your MCP server's own configuration**, never in this skill file. This
  skill stays secret-free either way.

So the only setup a user needs is: (1) connect and authorize the Atlassian MCP, and
(2) fill in the identifiers below.

## Install

Copy the `jira-ticket-writer/` folder into your skills directory:

```
# Claude Code (user-level skills)
~/.claude/skills/jira-ticket-writer/SKILL.md

# or project-level
<your-repo>/.claude/skills/jira-ticket-writer/SKILL.md
```

## Configure (required before first use)

The skill ships with a **financial-trading platform as a worked example** so the structure is
easy to follow. Before using it, open `SKILL.md` and replace the placeholders with your own
project's values:

| Placeholder | What it is | How to find it |
|---|---|---|
| `<YOUR_PROJECT_KEY>` | Your Jira project key (e.g. `PROJ`) | Jira → Project settings → Details |
| `<YOUR_ATLASSIAN_CLOUD_ID>` | Your Atlassian site's cloud ID | Atlassian MCP `getAccessibleAtlassianResources`, or `https://<your-domain>.atlassian.net/_edge/tenant_info` |
| `<your-domain>` | Your Atlassian subdomain | The `xxx` in `https://xxx.atlassian.net` |
| **Component table** | Your components + IDs | `/rest/api/3/project/<KEY>/components` |
| **Priority table** | Your priority scheme IDs | `/rest/api/3/priority` |

Then tailor the **Product Context**, **Component Selection**, and **Priority Framework**
sections to match your product and team conventions. Full instructions are in the
"Configure this for your project" section at the bottom of `SKILL.md`.

## Usage

Once installed and configured, just talk to your agent:

> write a jira ticket: the contact-us form on the site doesn't show a success message, users
> keep submitting twice

The skill will ask who raised it, then draft and (on confirmation) create the ticket.

## Customizing the Priority Framework

The included P0/P1/P2 framework is opinionated on purpose — it exists to stop priority
inflation. The core rule: **P0 is only for things already broken in production or confirmed
top-priority by leadership.** Adjust the definitions in `SKILL.md` to fit how your team
actually triages.

## License

[MIT](../LICENSE)

## Contributing

Issues and PRs welcome — especially alternative Priority Frameworks, output formats, or
adapters for other issue trackers.
