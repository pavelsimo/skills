---
name: create-html
description: Transforms any document (PDF, DOCX, PPTX, Markdown, text) into a polished self-contained HTML file by first converting to Markdown via uvx markitdown, then selecting the most appropriate template from a library of 20 purpose-built HTML formats and generating the output.
trigger: /create-html
---

# create-html skill

Convert any document into a polished, self-contained HTML file. The skill first turns your input into Markdown using `uvx markitdown`, then classifies the content and renders it with one of 20 purpose-built HTML templates drawn from the [HTML Effectiveness](https://thariqs.github.io/html-effectiveness/) library.

## features

- converts PDF, DOCX, PPTX, XLSX, HTML, images, audio, ZIP, YouTube URLs, and plain text to Markdown via `uvx markitdown` (no installation required)
- auto-classifies document content and selects the most fitting template from 20 options
- `--template <id>` flag lets you override the auto-selected template
- `--output <file>` flag controls the output filename (default: `<input-basename>.html`)
- `--list-templates` prints the full template catalog and exits without processing
- generates fully self-contained HTML files (no external CDN dependencies) that open directly in any browser
- confirmation step shows the chosen template before writing — user can accept, switch, or cancel

## usage

```bash
/create-html <file>                        # auto-select template and convert
/create-html <file> --template 09          # force a specific template by ID
/create-html <file> --output out.html      # set the output filename
/create-html <file> --template 11 --output report.html
/create-html --list-templates              # print the 20-template catalog and exit
```

## workflow

1. **parse args**: extract `<file>`, `--template <id>`, `--output <path>`, `--list-templates`
   - if `--list-templates` is set: print the template reference table (see below) and stop
   - if no `<file>` is provided: ask "which file would you like to convert?"

2. **convert to Markdown**: run `uvx markitdown <file>` and capture the output
   - if the file is already `.md` or `.txt`, skip markitdown and read it directly
   - if markitdown fails: surface the full error and stop

3. **classify content** (auto-select template):
   - headings structured like slide titles + bullet-heavy body → `09` (slide-deck)
   - `## Shipped` / `## In Progress` / dates + status words → `11` (status-report)
   - "incident", "post-mortem", "mitigation", timeline events → `12` (incident-report)
   - code diffs / `+++ ` / `--- ` diff markers, PR description → `03` (code-review-pr)
   - `flowchart` / `graph TD` / numbered process steps → `13` (flowchart-diagram)
   - milestone table / "Phase" / "Risk" columns → `16` (implementation-plan)
   - "Option A / Option B", multiple design alternatives → `02` (exploration-visual-designs)
   - side-by-side code comparisons, trade-off tables → `01` (exploration-code-approaches)
   - technical concept explanation, glossary section → `15` (research-concept-explainer)
   - feature documentation, TL;DR, FAQ section → `14` (research-feature-explainer)
   - module diagrams, entry points, call graph → `04` (code-understanding)
   - design tokens, component inventory → `05` (design-system)
   - multiple UI component states/sizes → `06` (component-variants)
   - animation specs, easing values, motion notes → `07` (prototype-animation)
   - multi-screen flow, user journey, wireframes → `08` (prototype-interaction)
   - SVG figures, diagram descriptions → `10` (svg-illustrations)
   - before/after context, reviewer notes, file tour → `17` (pr-writeup)
   - tickets, priorities, drag-and-drop ordering intent → `18` (editor-triage-board)
   - feature toggles, flag groups, config table → `19` (editor-feature-flags)
   - prompt templates, variable placeholders → `20` (editor-prompt-tuner)
   - **default** (general prose, memos, documents) → `09` (slide-deck)

4. **show selection**: print `Using template <id> — <display name>. Proceed? [yes / no / pick]`
   - **yes**: continue
   - **no**: stop without writing any file
   - **pick**: show the template reference table and ask which ID to use; loop back to step 4

5. **override**: if `--template <id>` was supplied, skip steps 3–4 and use that ID directly

6. **generate HTML**: render the Markdown content using the selected template
   - the HTML must be fully self-contained (inline CSS + JS, no external URLs)
   - preserve headings, lists, tables, code blocks, and images from the Markdown
   - apply the visual and interactive qualities appropriate for the chosen template (see template reference)

7. **write output**: save to `--output` path; default is `<input-basename>.html` in the same directory
   - if the output file already exists: ask "overwrite <filename>? [yes / no]"

8. **report**:
   ```
   ✅ Written to <output>
   Open with: open <output>
   Template: <id> — <display name>
   ```

## template reference

| ID | Display name | Best for |
|----|--------------|----------|
| 01 | Side-by-side code approaches | Comparing implementation options with trade-offs visible inline |
| 02 | Visual design directions | Showing layout, palette, or visual alternatives as rendered options |
| 03 | Annotated pull request | Presenting diffs with severity tags, jump links, and reviewer notes |
| 04 | Module map | Explaining unfamiliar code with boxes, arrows, hot paths, and entry points |
| 05 | Living design system | Rendering tokens, type scale, spacing, and component primitives as a browsable sheet |
| 06 | Component variants | Reviewing every size, state, and intent of a UI component in one place |
| 07 | Animation sandbox | Tuning motion, duration, easing, and interaction feel before implementation |
| 08 | Clickable flow | Testing a small multi-screen interaction with enough fidelity to feel the workflow |
| 09 | Arrow-key slide deck | Turning a memo or thread into a lightweight browser-native presentation |
| 10 | SVG figure sheet | Creating editable inline diagrams or illustrations for posts and docs |
| 11 | Weekly status report | Formatting shipped/slipped work, timelines, and small charts for fast scanning |
| 12 | Incident timeline | Presenting post-mortems with chronological events, logs, and follow-up checklists |
| 13 | Annotated flowchart | Showing a pipeline or process with clickable steps, timings, and failure paths |
| 14 | Feature explainer | Explaining a repo feature with TL;DR, collapsible paths, tabs, callouts, and FAQ |
| 15 | Concept explainer | Teaching an abstract concept with interactive visuals, comparison tables, and glossary |
| 16 | Implementation plan | Laying out milestones, data flow, inline mockups, risky code, and risk tables |
| 17 | PR writeup | Giving reviewers motivation, before/after context, file tour, and focus areas |
| 18 | Ticket triage board | Building a temporary drag-and-drop board that exports the resulting order |
| 19 | Feature flag editor | Editing grouped toggles with dependency warnings and copyable config diff |
| 20 | Prompt tuner | Editing prompt templates while sample inputs re-render live beside them |

## best practices

- **always confirm before writing** — show the chosen template and wait for approval; never write without user acknowledgment
- **self-contained output only** — inline all CSS and JS so the HTML file works offline and can be shared as a single file
- **preserve document structure** — headings become slide titles or section headers; tables stay tables; code blocks stay code blocks
- **markitdown first, always** — even for `.md` inputs, run through markitdown for consistency unless the file is already clean Markdown
- **lean toward slide-deck as default** — it is the most broadly useful template for prose documents; only choose a more specific template when signals are clear
- **short IDs are zero-padded two digits** — `--template 9` and `--template 09` are both valid; normalize internally
- **respect `--output` path exactly** — do not append `.html` if the user already specified an extension
- **surface markitdown errors fully** — if conversion fails, print the full error message; do not attempt HTML generation on empty or malformed Markdown
