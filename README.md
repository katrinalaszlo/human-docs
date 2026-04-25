# human-docs

A single HTML file that documents your product's architecture. Readable by humans and AI agents. No build step, no renderer, no framework. Open it in a browser.

![Example: Cal.com architecture doc](screenshot-example.png)

*Cal.com example: definitions, ERD, API surface, changelog, postmortems in one file.*

## Origin

I kept asking AI tools to generate structured documents. ERD visualizations, changelog tables, postmortem writeups. Each time I'd look at the output in a browser, get what I needed, and discard the file.

But the output was already organized. The tables had the data. The section headers mapped the architecture. The only waste was starting from zero every time.

So I stopped starting from zero. I made a template with section markers so I could update what changed and leave everything else intact. The file compounds over time instead of getting thrown away.

I've been using it to stay oriented while building [Tanso](https://tanso.io), and it's been useful enough to share.

## Why

- **One file.** No scattered pages, no broken links, no "where did we put that?"
- **HTML, not markdown.** Styled, navigable, with a sidebar. Opens in any browser without a renderer. Structured enough for agents to parse and update directly.
- **PM-minded sections.** Definitions (what does "customer" mean here?), postmortems (what broke and why), changelog (what shipped). Not just endpoint lists.
- **AI-generated, human-curated.** Point an AI at your codebase and this template. It fills in the sections. You decide what stays.
- **Surgical updates.** `<!-- SECTION:name -->` markers let agents update one section without regenerating everything. Like reviewing a git diff: only what actually changed.

## What's in the box

```
template.html   The empty scaffold. Fork this, fill it in.
PROMPT.md       Prompt for any AI tool to generate/update the doc.
example.html    Cal.com's architecture, fully filled in.
```

![Template scaffold](screenshot-template.png)

*The empty template: dark sidebar, section placeholders, ready to fill.*

## Usage

### First time

1. Copy `template.html` into your project (e.g., `docs/architecture.html`)
2. Open your AI tool (Claude Code, Cursor, Codex, etc.)
3. Paste the contents of `PROMPT.md` as your prompt
4. Point it at your codebase
5. Open the generated file in a browser

### Updating

Tell your AI tool which sections changed:

> "Update the changelog and postmortems sections. Here's what changed: [paste diff or describe]"

The AI finds the `<!-- SECTION:name -->` markers, edits the content between them, and leaves everything else untouched.

### Adding sections

The template ships with core sections. PROMPT.md includes optional sections you can add:

- **User Stories**: acceptance criteria tables
- **Customer Model**: for multi-tenant products
- **Board**: kanban for small teams
- **Emails**: transactional email catalog

## Sections

| Section | What it answers | Why it matters |
|---------|----------------|----------------|
| Definitions | "What does X mean in this codebase?" | Prevents the #1 source of bugs: overloaded terms |
| Data Model | "What tables exist and how do they relate?" | ERD + entity cards, grouped by domain |
| Pages & Routes | "What can users see?" | Every frontend route with its purpose |
| API Surface | "What can code call?" | Endpoints grouped by domain |
| Changelog | "What shipped?" | Filterable by type (bug, feature, perf, docs) |
| Postmortems | "What broke and how do we prevent it?" | Root cause, impact, fix, prevention rule |

## Philosophy

**Docs should be readable without context.** Hand this file to someone who just joined your team. They should understand what the product does, what the data looks like, what broke recently, and what shipped.

**Postmortems are the most valuable section.** Changelogs record what happened. Postmortems record what not to do again.

**One file is a feature, not a limitation.** The moment you split docs across files, someone stops updating one of them. One file means one place to look, one thing to update, one artifact to share.

**AI generates, humans curate.** The AI reads your codebase and fills in the template. You read the output and fix what it got wrong. Over time the doc compounds: each update adds to the changelog, each bug adds a postmortem, each migration updates the ERD.

## License

MIT
