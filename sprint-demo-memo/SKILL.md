---
name: sprint-demo-memo
description: "Generate a sprint demo memo in Confluence format, following a consistent internal demo style (theme-grouped sections with What changed / Why it matters / FAQ per feature, plus Overview table and Appendix ticket list). Trigger this skill whenever the user asks to prepare, write up, organise, or output demo content for a sprint — for example: 'help me prepare the demo', 'put together the demo memo', 'sprint demo content', 'the sprint is done, generate the demo', or any mention of a sprint number together with a request for demo or release content. The request may be in English or Chinese; trigger on intent, not exact wording — any phrasing with the same meaning counts. This skill runs the full workflow: fetch Jira tickets, classify features, group by theme, draft the full memo in conversational tone, publish to Confluence, and optionally produce a speaking script alongside the memo."
---

# Sprint Demo Memo Generator

> **This is a template.** It ships with a fintech / payments product as a worked example so the
> structure is easy to follow. Before using it, replace the placeholders (`<...>`) with the
> values from **your own** Jira/Confluence instance. See "Configure this for your project" at
> the bottom.

This skill automates the end-to-end workflow for preparing an internal sprint demo memo after
each sprint ends. The output follows the format standard defined in full in Step 5 below — the
skill is self-contained and does not depend on reading any external wiki page. It is written in
plain, conversational English so the memo doubles as a script the presenter can read out loud
during the live demo.

**Core principle:** The audience is the whole company — Sales, Compliance, Settlement, Support,
Treasury, Tech. They are smart people with no time, and most are non-technical. Write like
you're explaining your work to a colleague over coffee, not like you're writing a spec.

---

## Step 1: Fetch Deployed Tickets from the Sprint

Use `searchJiraIssuesUsingJql` with:
- cloudId: `<YOUR_ATLASSIAN_CLOUD_ID>`
- JQL: `project = <YOUR_PROJECT_KEY> AND issuetype in (Story, Bug) AND sprint = "{sprint number}" AND status in (Done, Deployed, Resolved, Closed) ORDER BY created DESC`
- fields: `summary`, `description`, `issuetype`, `status`
- maxResults: 50

If the user doesn't specify a sprint number, use `sprint in openSprints()` instead.

If no tickets are found, tell the user and stop.

---

## Step 2: Classify Each Ticket as BUSINESS, TECHNICAL, or SENSITIVE

- **BUSINESS**: direct visible impact on users or operations — new features, UX improvements, payment flows, client-facing changes, operational process improvements.
- **TECHNICAL**: purely internal, no user-facing impact — database migrations, automated tests, API/Swagger docs, code refactoring, infrastructure, base image updates, data warehouse tasks, enum cleanup.
- **SENSITIVE**: anything that updates Compliance Transaction Monitoring (TM) rules or compliance rule logic — see the dedicated rule below.

### 🔒 SENSITIVE: Compliance / Transaction Monitoring rule changes are NEVER demo'd

The sprint demo is shared company-wide (Sales, Support, Settlement, Treasury, everyone). Compliance Transaction Monitoring rule details are **not** information that should be shared at that scope. So any ticket whose substance is a **change to the rules themselves** must be excluded entirely — **not in the main body, and NOT in the Appendix either**, because the Appendix is visible to the whole company too.

This is stricter than the softer "describe the behaviour, not the rule" guidance. For TM/compliance *rule* work, the whole feature comes out of the demo, full stop.

**The boundary — exclude the rule, keep the tool.** Judge by substance, not by which team or label is attached:

- ❌ **Exclude** (the rule itself): new or changed TM rules, rule logic, thresholds, trigger conditions, scoring, watchlist/sanctions list additions or changes, screening criteria, what makes something get flagged.
- ✅ **Keep — this is demoable** (the tool around it): improvements to the *tools and interfaces* Compliance staff use, as long as they don't reveal rule logic. E.g. a new column on the case review page, a filter on the suspicious-case list, a KYB form tidy-up, an export button, a UX improvement to an alert queue. These are "the Compliance team's tools got better to use" — fine to show.

Rule of thumb: **"what the rule is" → exclude; "the Compliance team's workflow/tooling got nicer" → keep.** If a ticket mixes both, demo only the tooling part and say nothing about the rule change underneath. If you're unsure which side a ticket falls on, treat it as SENSITIVE and ask the user.

### Undemoable Stories

A ticket can be a Story and still be undemoable. Pure backend or performance work — even when it technically improves the user experience — often has *nothing a non-technical audience can see or care about*. Example: a ticket like "reduce first-screen load time by returning the logo as a signed URL" is a real improvement, but there's no way to demo it to Sales or Compliance. Treat these like technical tickets: keep them out of the main body but still list them in the Appendix. Flag any such ticket to the user rather than silently deciding.

### Confirmation prompt

Present the excluded tickets to the user, keeping the two exclusion reasons clearly separated:

```
A) TECHNICAL or undemoable — excluded from main body, still listed in Appendix:
  [1] <KEY>-XXXX — ticket summary
  [2] <KEY>-XXXX — ticket summary

B) 🔒 SENSITIVE (Compliance / TM rule change) — excluded from demo ENTIRELY,
   including the Appendix (not shareable company-wide):
  [3] <KEY>-XXXX — ticket summary

For group A, enter any numbers you want to KEEP in the main body (or Enter to exclude all).
For group B, confirm full exclusion, or tell me if any is actually a tooling change I can keep.
```

Wait for the user's reply before continuing.

---

## Step 3: Decide How to Handle Bug Fixes

Bug fixes are usually NOT demo'd in the live presentation — in past sprints they were glossed over or skipped entirely. Ask the user:

```
Found {N} bug fix ticket(s) in this sprint. How should we handle them?

  [1] Include in main body (full What changed / Why it matters / FAQ)
  [2] List in Appendix only (recommended — bug fixes usually aren't demo'd)
  [3] Exclude entirely

Default is [2]. Reply with your choice:
```

Default to option 2 unless the user says otherwise.

---

## Step 4: Group Features by Theme

Group the remaining demoable BUSINESS tickets into themes. **Use as many themes as the content naturally needs — do NOT pad to hit a number.** A light sprint might end up with just 3 themes because that's what the work was. Common themes (example set for a fintech/payments product):

- **Credit Risk & FX** — high-risk review, conversions, FX orders, derivatives
- **Client Experience** — UX, copy changes, client portal improvements, decimal/format fixes
- **Payment Operations** — payment channels, settlement, authorisation, beneficiary
- **Compliance & Risk** — AML, KYB, TM-related (but never expose TM rule names — see Step 7 rules)
- **Reporting & Statements** — regulatory reports, statements, exports

(Note: a "Platform Performance" theme is tempting but usually backfires — most performance work is undemoable per Step 2 and belongs in the Appendix.)

Present the proposed grouping to the user for confirmation:

```
Proposed theme grouping:

🔹 Theme A ({count} items)
  - <KEY>-XXXX — summary

🔹 Theme B ({count} items)
  - <KEY>-XXXX — summary

Confirm grouping, or tell me what to change:
```

Wait for confirmation before moving on.

---

## Step 5: Apply the Format Standard

The full format standard is defined below. It is self-contained — do NOT open or depend on any Confluence page to confirm it. Apply it directly.

### Current format standard

**Page-level elements:**
- Header line: `**Date:** {Month Year} | **Audience:** All Staff | **Format:** Live Product Demo`
- **Overview** section: one short sentence naming the themes (e.g. "This sprint we shipped six things across 3 areas: ..."), followed by a Category / Items / Status table. The "areas" count must match the number of themes actually in the body.
- A short **Closing transition paragraph** right before the Appendix — signals the client-facing part is done and explains what's being skipped. (See Step 7.)
- **Appendix** at the end: `### Appendix — Full Ticket List`, a full table (Story + Bug + Technical) with Ticket / Type / Title / Status columns. **Exception: SENSITIVE Compliance/TM rule tickets (Step 2) are omitted even here** — the Appendix is company-wide visible, so they must not be listed at all.
- Footer: `*Sprint XXXX · Product Demo Document · {Month Year} · Internal use only*`

**Theme + feature structure:**
- `## N. Theme Name`
- For each feature under the theme: `` ### N.M Feature Name `<KEY>-XXXX` ``

**Per-feature structure:**
1. **Meta line** (right after the heading):
   `` **Portals:** {Admin Portal | Client Portal | All Portals | All} | **Priority:** — | **Status:** {status lozenge: Deployed} ``
2. `#### What changed` — plain-English explanation (use a `####` heading, not bold text)
3. Screenshots inserted at logical points. In draft form use placeholders: `> 📷 **[INSERT SCREENSHOT: {description}]**`. (The user replaces these with real images before/at demo time.)
4. `#### Why it matters` — **ONE SHORT PARAGRAPH ONLY, never bullets.** This section gets glossed over in live demos, so keep it tight (1–3 sentences).
5. `#### FAQ` — **0 to 4 Q&A pairs, as needed.** Small display-only changes can have NO FAQ at all. Only include questions a real audience member would actually ask. Each pair is a blockquote:
   ```
   > **Q1: question?**
   >
   > A: answer.
   ```

**Feature title style: conversational, outcome-oriented.** Titles should say what the user *gets*, not echo the Jira ticket name. Prefer "One Page to See Every Pending Approval" over "Cross-Tenant Aggregated Approval View". Keep this consistent across all features in the memo.

**If a feature has follow-up planned in a future sprint**, ask the user whether to add a `**What's coming next:**` paragraph at the end of the "What changed" section to tease the next phase.

---

## Step 6: Ask Whether to Also Produce a Speaking Script

**Before drafting anything**, ask the user whether they want a read-aloud speaking script generated alongside the memo:

```
Before I draft — do you want a speaking script generated alongside the memo,
so you have something to read from during the live demo?

  [1] Yes — memo + speaking script
  [2] Just the memo

Reply with your choice:
```

Remember the answer. If they chose [1], you will produce BOTH deliverables together in the drafting step, and keep them in sync through every later edit. If they chose [2], skip the script entirely and don't bring it up again.

### Speaking script format (use when the user opted in)

Produce it as a **standalone Markdown file** and share it with the user as a separate deliverable from the memo:

- One section per feature, in demo order, each opened with an emoji-numbered heading (🎬 Opening, 1️⃣, 2️⃣, … , 🎬 Closing & Q&A).
- Put estimated minutes next to each heading.
- Write the actual words to say, in first person, inside blockquotes — conversational, contractions, short sentences.
- Mark screen changes inline with `*[switch to screen: …]*` so the presenter knows when to switch slides.
- Spell out acronyms on first mention, same as the memo.
- End each major feature with a natural pause / "any questions on this one?" beat.
- Close with a **Speaking Tips** section (pacing, pausing 2s after each feature, what to say before switching screens, how to handle questions you can't answer, how to handle bug-fix questions).
- Footer: `*Sprint XXXX · Speaking Script · {Month Year} · Internal use only*`

---

## Step 7: Draft the Demo Memo — Tone & Content Rules

**If the user opted into a speaking script in Step 6, produce it together with the memo in this step**, using the format spec from Step 6. The script's wording must track the memo exactly — if the memo wording changes during iteration (Step 8), update the script to match.

### Tone (this is the most important part)

Write like a human explaining their work to a friend. The memo will be read OUT LOUD during the demo, so:

- **Short sentences win.** If a sentence has two clauses you could split, split them.
- **Use everyday words.** "Before this sprint, X was painful" beats "Previously, X represented an operational inefficiency." Prefer "shows" over "indicates", "situation" over "circumstances".
- **Lead with the human story.** What was annoying? Who was annoyed? What changes for them now? ("That's a lot of clicking." "Quiet little inconsistency, finally cleaned up.")
- **Concrete over abstract.** "Treasury had to click through 30+ tenants" beats "Treasury faced multi-tenant navigation overhead."
- **Spell out acronyms on first use.** The audience is non-technical. First time a term appears, expand it: "Know Your Business — KYB". Don't assume everyone knows the jargon.
- **Light personality is fine.** Mild humour, the occasional rhetorical question, casual transitions ("Here's the thing:", "So what changed?", "Quick one:").
- **Cut corporate filler.** No "leverage", "synergy", "going forward", "robust", "seamless", "best-in-class". If you wouldn't say it out loud to a colleague, don't write it.

### Content rules (learned from past demos)

- **Compliance / TM rule changes are excluded entirely — see Step 2.** Any feature whose substance is a TM or compliance *rule* change does not appear in the demo at all (not the body, not the Appendix). Don't try to "sanitise and include" it. The only Compliance-related things that may appear are *tooling/UX* improvements that reveal no rule logic (per the Step 2 boundary).
- **Even for the tooling that IS included**: never mention specific TM rule names, IDs, thresholds, or logic. Describe behaviour from the user's point of view only — e.g. "the system flags the transaction for Compliance review", never which rule fired or why.
- **Accuracy**: Only describe what was actually built. If a picker supports 30-minute intervals, say "30-minute intervals" — don't over-claim. If unsure of a detail, write `Please confirm with the dev team` rather than guess.
- **Navigation paths**: For Admin Portal features, include the menu path (e.g., "Admin Portal → Payment Management → Payment Authorisation").
- **Screenshots**: Place placeholders only where a visual genuinely helps. Usually 1–2 per feature.

### Section-by-section guidance

**What changed**
- Open with the problem from the user's point of view (often one sentence).
- Then say what the team built and how it works.
- For multi-part features, use bold inline labels like `**1. Thing renamed.**` to break it up.
- Add a "Who uses it" or "Where to find it" line near the end where relevant.

**Why it matters**
- ONE PARAGRAPH. One to three sentences. This is the skippable bit in a live demo, so keep it short.
- Focus on the human / operational benefit, not the implementation.

**FAQ**
- 0–4 pairs, only real questions. Skip entirely for trivial display changes.
- Cover: access/permissions, edge cases, impact on existing data, reversibility, scope limits, "what's next" if a phase 2 exists.
- One or two sentences per answer.

### Closing transition paragraph

Before the Appendix, write a short sign-off that (1) marks the end of the client-facing part, (2) explains what's being skipped and why, (3) hands over to Q&A. Example pattern:

> That's everything client-facing from this sprint.
>
> There's also a stack of work that won't get a demo today — bug fixes, a portal load-time improvement, and some backend service work the engineering team has been chipping away at. Full list is in the Appendix below for anyone who wants to browse.

---

## Step 8: Present the Draft & Iterate

Output the full memo as clean Markdown. At the end, summarise:

```
✅ Draft complete
   • {N} features included, grouped into {T} themes
   • {M} bug fixes ({B} in main body, {A} in appendix only)
   • {K} technical / undemoable tickets in appendix only
   • Screenshot placeholders: {total count}
```

Then ask: **"Anything to adjust before I publish — order, wording, theme grouping, screenshot spots?"**

Iterate until the user is happy.

---

## Step 9: (Optional) Generate the Demo Agenda

Offer an agenda table after the memo is finalised:

```
Want me to draft a demo agenda too? It'll cover themes, time-per-feature, and owner.
```

If yes:

```
| # | Topic | Owner | Time |
|---|-------|-------|------|
| 0 | Opening & Sprint Overview | {presenter} | 2 min |
| 1 | **Theme A** | | |
|   | Feature 1.1 | {presenter} | X min |
| ... |
| N | Q&A | All | 5 min |
```

Time heuristic:
- Major new feature with screenshots → 5–6 min
- Medium feature → 3–4 min
- Small change / rename / config update → 2–3 min
- Opening + Q&A buffer: ~7 min total

---

## Step 10: Publish to Confluence

**⚠️ Write-operation safety rule: never create/edit/update/delete on Confluence or Jira without showing the content and getting explicit confirmation first.** Ask plainly: "Confirm publish to Confluence?"

Once confirmed:

### 10a. Check if a page with the title already exists

Use `searchConfluenceUsingCql`:
- cloudId: `<YOUR_ATLASSIAN_CLOUD_ID>`
- CQL: `title = "Sprint {XXXX} Demo Memo" AND type = page`

### 10b. If the page exists

```
Found existing page: Sprint {XXXX} Demo Memo (last updated {date})
URL: {webui link}

  [1] Update this page (replace content)
  [2] Create a new page with a different title

Which?
```

If [1]: `updateConfluencePage` with the `pageId` from the search result (the tool may need loading via tool_search first — confirm parameter names).
If [2]: ask for the new title, then `createConfluencePage`.

### 10c. If the page does not exist

`createConfluencePage` with:
- cloudId: `<YOUR_ATLASSIAN_CLOUD_ID>`
- spaceId: `<YOUR_CONFLUENCE_SPACE_ID>`
- parentId: `<YOUR_PARENT_PAGE_ID>` (the folder where demo memos live)
- title: `Sprint {XXXX} Demo Memo`
- contentFormat: `html`
- body: the memo converted to HTML

### 10d. HTML conversion notes

- `---` horizontal rules → `<hr/>`
- `#### What changed` etc. → `<h4>What changed</h4>`
- `## N. Theme` → `<h2>`, `### N.M Feature` → `<h3>`; ticket key in `<code><KEY>-XXXX</code>`
- FAQ blockquotes → `<blockquote><p>...</p></blockquote>`
- Status lozenge → `<span data-type="status" data-color="green">Deployed</span>`
- Screenshot placeholder → `<div data-type="panel-info"><p>📷 <strong>[...]</strong></p></div>`
- Tables → standard `<table>/<thead>/<tbody>/<tr>/<th>/<td>`
- Escape `&` as `&amp;` (especially in labels like "Cancellation P&L")

After publishing, share the page URL and remind the user to swap in real screenshots before the demo. If a speaking script was produced (Step 6/7), make sure its final wording still matches the published memo. That completes the workflow.

---

## Configure this for your project

Before first use, replace these placeholders throughout this file:

| Placeholder | What it is | How to find it |
|---|---|---|
| `<YOUR_PROJECT_KEY>` | Your Jira project key (e.g. `PROJ`) | Jira → Project settings → Details, or the prefix of any issue key |
| `<KEY>` | Same project key, used in ticket references (`<KEY>-1234`) | Same as above |
| `<YOUR_ATLASSIAN_CLOUD_ID>` | Your Atlassian site's cloud ID | Ask the Atlassian MCP for `getAccessibleAtlassianResources`, or visit `https://<your-domain>.atlassian.net/_edge/tenant_info` |
| `<YOUR_CONFLUENCE_SPACE_ID>` | The Confluence space to publish into | Atlassian MCP `getConfluenceSpaces`, or the space's URL/settings |
| `<YOUR_PARENT_PAGE_ID>` | The parent page/folder demo memos live under | Open the parent page in Confluence; the page ID is in the URL / page details |

You can also tailor the **theme list** (Step 4), the **format standard** (Step 5), and the
**tone rules** (Step 7) to match your own product, team, and house style. The SENSITIVE /
Compliance-exclusion logic (Step 2) is a good default for any company that shares demos widely,
but adjust the boundary to fit your own disclosure policy.

---

## Notes

- If the user provides supplementary materials (PDF user guides, Figma links, screenshots), fold them into the relevant feature's "What changed" section.
- If a feature has a clear future-sprint follow-up, proactively offer a "What's coming next" teaser.
