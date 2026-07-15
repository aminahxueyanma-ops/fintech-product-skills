# Sprint Demo Memo — an Agent Skill

Turn a finished sprint into a polished, company-wide **demo memo** — and publish it straight to
Confluence. The skill pulls the sprint's deployed tickets from Jira, decides what's worth
demoing, groups features by theme, and drafts everything in plain, read-it-out-loud English so
the memo doubles as your live-demo script.

Built as a [Claude Agent Skill](https://docs.claude.com/en/docs/claude-code/skills). Works in
Claude Code and other agent runtimes that support skills.

## What it does

- **Pulls the sprint** — fetches Done/Deployed Story + Bug tickets from Jira via the Atlassian MCP.
- **Decides what to demo** — classifies each ticket as **Business** (show it), **Technical /
  undemoable** (Appendix only), or **Sensitive** (Compliance / transaction-monitoring rule
  changes — excluded entirely, even from the Appendix).
- **Groups by theme** and confirms the grouping with you before writing.
- **Drafts in demo voice** — short sentences, no corporate filler, acronyms spelled out, a
  human story per feature (What changed / Why it matters / FAQ).
- **Optionally writes a speaking script** — a separate read-aloud file, timed and staged, kept
  in sync with the memo.
- **Publishes to Confluence** — with an existing-page check and an explicit confirm-before-write
  step.

## Requirements

- An agent runtime that supports skills (e.g. Claude Code).
- The **Atlassian MCP** connected, with permission to read Jira and read/write Confluence.

## Authentication

**No API key lives in this skill.** It reads Jira and writes Confluence through the **Atlassian
MCP**, and authentication lives in that MCP layer (OAuth), not in the skill file. The values you
fill into `SKILL.md` — project key, cloud ID, Confluence space ID, parent page ID — are
**identifiers, not credentials**, and are safe to commit.

## Install

Copy the `sprint-demo-memo/` folder into your skills directory:

```
# Claude Code (user-level)
~/.claude/skills/sprint-demo-memo/

# or project-level
<your-repo>/.claude/skills/sprint-demo-memo/
```

## Configure (required before first use)

The skill ships with a **fintech / payments product as a worked example**. Open `SKILL.md` and
replace the placeholders with your own values:

| Placeholder | What it is |
|---|---|
| `<YOUR_PROJECT_KEY>` / `<KEY>` | Your Jira project key (e.g. `PROJ`) |
| `<YOUR_ATLASSIAN_CLOUD_ID>` | Your Atlassian site's cloud ID |
| `<YOUR_CONFLUENCE_SPACE_ID>` | The Confluence space to publish into |
| `<YOUR_PARENT_PAGE_ID>` | The parent page/folder demo memos live under |

Then tailor the **theme list**, **format standard**, and **tone rules** to your team. Full
instructions are in the "Configure this for your project" section of `SKILL.md`.

## A note on the Compliance exclusion

The skill treats **Compliance / Transaction Monitoring rule changes as never-demoable** —
excluded from the memo body *and* the Appendix, because company-wide demos aren't the place to
disclose what triggers a flag. It keeps *tooling/UX* improvements to Compliance workflows (a new
filter, an export button) while excluding the *rule logic* itself. This is a sensible default
for any regulated business; adjust the boundary in Step 2 to match your own disclosure policy.

## Usage

> the sprint is done — help me put together the demo memo for sprint 42

The skill will fetch the tickets, walk you through classification and grouping, draft the memo
(and script, if you want one), and publish to Confluence on your confirmation.

## License

[MIT](../LICENSE)
