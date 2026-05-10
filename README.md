# human-docs

A single HTML file that documents your product's architecture. Readable by humans and AI agents. No build step, no renderer, no framework. Open it in a browser.

![Example: Cal.com architecture doc](screenshot-example.png)

*Cal.com example: definitions, ERD, API surface, changelog, postmortems in one file.*

## Origin

I kept asking AI tools to generate structured documents. ERD visualizations, changelog tables, postmortem writeups. Each time I'd look at the output in a browser, get what I needed, and discard the file.

But the output was already organized. The tables had the data. The section headers mapped the architecture. The only waste was starting from zero every time.

So I stopped starting from zero. I made a template with section markers so I could update what changed and leave everything else intact. The file compounds over time instead of getting thrown away.

I've been using it to stay oriented while building [Tanso](https://tansohq.com), and it's been useful enough to share.

## Where this fits

Every project accumulates doc files. Each one serves a different audience:

| File | Who reads it | What it does |
|------|-------------|--------------|
| README.md | Someone evaluating the project on GitHub | First impression. Setup instructions. |
| CLAUDE.md / .cursorrules | AI coding agents | Machine-readable instructions. Tells the agent how to behave. |
| llms.txt | AI agents fetching context | Machine-readable site/project context. |
| OpenAPI spec | Integrators building against your API | Formal contract. Every parameter, every response shape. |
| **human-docs** | The builder. The person who needs to keep up. | Human-readable view of the system — what it looks like, what shipped, what broke. |

human-docs doesn't replace any of these. README stays your front door. CLAUDE.md stays your agent's instructions. OpenAPI stays your API contract.

human-docs is the layer underneath: the filtered, structured view that keeps the human oriented without reading the full codebase, git log, or agent context. AI agents maintain it. Humans read it.

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

Three ways to keep the doc current, from manual to automatic:

**1. Tell the agent what changed.** Lowest friction. You know what you just shipped.

> "Update the changelog and postmortems sections. Here's what changed: [paste diff or describe]"

The AI finds the `<!-- SECTION:name -->` markers, edits the content between them, and leaves everything else untouched.

**2. Run `update-doc.sh`.** The script diffs git history, maps changed files to doc sections, and tells you exactly which sections are stale.

```bash
./update-doc.sh              # changes since last doc update
./update-doc.sh HEAD~5       # changes in last 5 commits
```

It prints a prompt you can paste into your AI tool. You review the update before it's committed.

**3. Hook it into your workflow.** If you want the doc updated on every commit or PR, wire `update-doc.sh` into a git hook or CI step. The script outputs which sections need updating — your agent handles the rest.

The tradeoff: options 1 and 2 keep the human in the loop ("AI generates, humans curate"). Option 3 is fully automatic — faster, but you give up the review step. Every update is still a git commit, so you can always diff what changed.

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
