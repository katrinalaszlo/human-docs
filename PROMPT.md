# AGENT.md

Paste this into Claude Code, Cursor, Codex, or any AI coding tool. It tells the agent how to generate and update your architecture doc.

---

## Generate a new doc

Read my codebase and fill in `template.html` to create a single-file architecture doc. Replace `PROJECT_NAME` with the actual project name and `YYYY-MM-DD` with today's date. Save the result as `docs/architecture.html` (or wherever makes sense for this project).

### Section instructions

**Definitions** — Find terms that are overloaded, ambiguous, or have a specific meaning in this codebase. Look at database columns, API fields, and comments where something is clarified. If two things share a name but mean different things, that's a definition.

**Data Model** — Generate from database migrations, schema files, or ORM models. Group tables by domain (e.g., core/auth, billing, analytics). Use the entity card HTML for each table. Include a Mermaid ERD if there are meaningful relationships. Mark columns as PK/FK using the CSS classes.

**Pages & Routes** — Read the router config or file-based routing structure. List every user-facing page with its path, component name, and what it does.

**API Surface** — Read route/controller definitions. List endpoints grouped by domain. Include method, path, and purpose.

**Changelog** — Read `git log` for the current branch. Convert commits into user-facing changes. Categorize as `feature`, `bug`, `perf`, or `docs`. Link bugs to postmortem IDs where applicable. Use `data-type` attributes on `<tr>` elements so the filter buttons work.

**Postmortems** — For each significant bug found in git history or issue tracker: document root cause, impact, fix, and prevention rule. Number them PM-1, PM-2, etc. These are the most valuable section for the team.

### Rules
- Fill in the HTML comments. Don't change the CSS or layout structure.
- Keep section markers: `<!-- SECTION:name -->` and `<!-- /SECTION:name -->`
- Use the existing CSS classes (`.entity`, `.card`, `.pm`, `.warn`, etc.)
- Every definition should reference where it lives (table, column, config key)
- Postmortem prevention rules should be actionable, not vague

---

## Update an existing doc

When asked to update specific sections:

1. Look at what changed: `git diff` or the user's description
2. Only edit content between the relevant `<!-- SECTION:name -->` markers
3. Don't touch sections that weren't affected by the change
4. Update the date in the subtitle
5. If a bug was fixed, add both a changelog entry AND a postmortem

### Section mapping

Update ALL sections affected by a change, not just the changelog. A schema migration updates the ERD and entity cards. A new endpoint updates the API surface. The changelog records what shipped, but the architecture sections must stay current too.

| What changed | Update these sections |
|---|---|
| Database migration / schema | data-model (ERD + entity cards) |
| New API endpoint | api, changelog |
| New page / route | pages, changelog |
| Bug fix | changelog, postmortems |
| New feature | changelog, and any structural sections it touches |
| Renamed or clarified a concept | definitions |
| Any change | subtitle date |

---

## Optional sections

These aren't in the default template. Add them if they fit your project:

**User Stories** — Acceptance criteria tables. Good for products still defining what "done" means.
```html
<!-- SECTION:user-stories -->
<h2 id="user-stories">User Stories</h2>
<div class="pm">
  <div class="pm-title">US-1: Story title</div>
  <table>
    <tr><th>Acceptance Criteria</th><th>Verified By</th></tr>
    <tr><td>Criteria text</td><td>How to verify</td></tr>
  </table>
</div>
<!-- /SECTION:user-stories -->
```

**Customer Model** — For multi-tenant or B2B products where "customer" is ambiguous (your customer vs. their customer).
```html
<!-- SECTION:customer-model -->
<h2 id="customer-model">Customer Model</h2>
<div class="card-grid">
  <div class="card red"><h4>Layer 1 — Your Users</h4>...</div>
  <div class="card green"><h4>Layer 2 — Their Users</h4>...</div>
</div>
<!-- /SECTION:customer-model -->
```

**Board** — Kanban view of current work. Good for small teams tracking work in the doc itself.

**Emails / Notifications** — Catalog of transactional emails or notifications the system sends.
