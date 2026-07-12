# Skills Review — Improvement & Simplification Report

A best-practices review of all 18 skills under `skills/`, measured against (a) the repo's
own documented standard in `AGENTS.md` and (b) the Anthropic Agent Skills conventions
(minimal frontmatter, progressive disclosure, one capability per skill).

**This is a report only** — no skill files were changed. Two scope decisions shape the
recommendations: frontmatter should be aligned to the Anthropic spec (`name` +
`description` only), and cross-skill overlap is intentionally left as-is (see
[Out of scope](#out-of-scope)).

---

## Scorecard

Line counts are actual `SKILL.md` line counts. "Standard" = follows the repo's documented
sections (`features` / `usage` / `workflow` / `best practices`) with lowercase headings.

| Skill | Lines | Standard | Highest-priority issue |
|-------|------:|:--------:|------------------------|
| changelog | 163 | ✅ | `## modes` duplicates the workflow subsections — delete it |
| commit | 106 | ⚠️ | 33-line gitmoji table inline; format section precedes workflow |
| create-cli | 234 | ❌ | `## Step N` Title Case structure; reference tables inline |
| create-docs | 161 | ✅ | Solid — minor: `## sections` table is reference-ish |
| create-html | 120 | ⚠️ | 20-template catalog inline; `.md`-input contradiction |
| create-issue | 137 | ✅ | Description is 3 sentences; gitmoji table inline |
| create-skill | 120 | ✅ | Teaches "exactly three files" + `trigger:` — now outdated |
| create-web | 208 | ❌ | Mixed heading case; `## Step N`; maintenance docs inline |
| deep-learn | 90 | ✅ | **Exemplar.** Only nit: `## the comprehension checklist` |
| humanize | 441 | ❌ | 29-pattern catalog inline; `## task`/`## process`, no features |
| markdown | 73 | ❌ | No `## features`, no `## best practices`; reads like a manual |
| mermaid | 132 | ⚠️ | Diagram-type + auto-detect tables inline; file/desc precedence |
| refine-issue | 127 | ✅ | Gitmoji table + template duplicated from create-issue |
| release | 172 | ✅ | Solid — completion-summary template could move out |
| review | 251 | ⚠️ | Many non-standard sections; output template inline |
| search-anime | 377 | ❌ | ~250 lines of inline output templates + lookup tables |
| taste | 298 | ❌ | Outlier frontmatter (`version:`, no `trigger:`); Title Case |
| ytd | 58 | ✅ | **Exemplar.** Description leaks implementation detail |

Cleanest exemplars to model the rest on: **`deep-learn`, `ytd`, `create-docs`**.

---

## Cross-cutting recommendations

These four changes fix most issues at once and are worth more than any single per-skill tweak.

### 1. Align frontmatter to the Anthropic Agent Skills spec

The official spec recognizes only `name` and `description`. The repo adds a custom
`trigger: /<name>` field to every skill, and `taste` alone adds `version: 1.1.0` while
*omitting* `trigger:` — the one real inconsistency in the set.

**Recommendation:**

- Drop `trigger: /<name>` from all 17 skills that carry it. The invocation name derives
  from `name` / the directory, so the field is redundant.
- Remove `taste`'s `version:` field (non-standard; no other skill versions this way).
- Resolve `taste`'s missing-`trigger` by *removing* trigger everywhere rather than adding
  it — this makes the whole set uniform and spec-compliant in one move.
- Confirm every `name:` matches its directory (all currently do).
- Keep the strong `Use when…` clause each `description` already has — it is the primary
  signal Claude uses to decide when to load the skill, and these are well written.

### 2. Progressive disclosure — split bloated skills into `reference/` files

This is the single biggest simplification lever. `taste/reference/` already models the
pattern (`signal-families.md`, `output-template.md`, `html-generation.md`). Large inline
catalogs and templates should move out of `SKILL.md` and be loaded on demand.

| Skill | Lines | Move to `reference/…` |
|-------|------:|------------------------|
| humanize | 441 | The 29-pattern catalog (`~72–408`) → `reference/patterns.md` |
| search-anime | 377 | Mode output templates (`~52–318`) → `reference/output-modes.md`; genre/format/score tables (`~331–378`) → `reference/reference-tables.md` |
| create-cli | 234 | Variable table (`~129–143`), output-summary examples (`~156–211`), "Default Conventions" (`~213–235`) |
| create-web | 208 | "37signals style guide reference", "adding new templates" |
| review | 251 | Output-format template block (`~140–172`) |

Smaller wins where the same idea applies: `commit` gitmoji table (`~45–78`), `mermaid`
diagram-type/auto-detect tables, `create-html` 20-template catalog, `changelog`/`release`
output-example templates. Target: keep each `SKILL.md` roughly under ~150–200 lines, with
enumerated tables/templates one hop away.

### 3. Heading and section consistency

Normalize to the repo's own documented convention: **lowercase headings**, and the four
core sections `features` / `usage` / `workflow` / `best practices`.

- **Title Case → lowercase:** `create-cli` (`## Step 1 — Clarify`, `## Do This First`),
  `taste` (`## Protocol`, `## When to Use`, `### Step N`), mixed casing in `create-web`.
- **Non-standard section names:**
  - `humanize` — `## task` → `## workflow`; `## process` folds into it; add a real
    `## features` list and a `## best practices` section.
  - `markdown` — add `## features` (a bullet list of supported formats) and
    `## best practices`; it currently reads like a CLI man page, not a skill.
  - `create-cli` / `create-web` — fold the `## Step N` headings under a single
    `## workflow` with numbered sub-steps.
- **Trivial:** `deep-learn` `## the comprehension checklist` → `## comprehension checklist`.

### 4. Update the meta-standard so the repo teaches what it now practices

Once 1–3 land, the definition of "correct" must move with them:

- **`AGENTS.md`** — replace "at minimum three files" / "exactly three" framing with
  "`SKILL.md` + `README.md` + `LICENSE`, plus optional `reference/*.md` and scripts";
  document the `reference/` progressive-disclosure pattern; drop `trigger` from the
  documented frontmatter spec.
- **`create-skill/SKILL.md`** — stop generating a `trigger:` field (`~49`, `~113–120`);
  teach splitting large reference material into `reference/<topic>.md`; soften the
  "exactly three files per skill" best-practice bullet (`~117`) since `taste` and `ytd`
  already ship more.

---

## Per-skill findings

### changelog (163)
- Delete `## modes` (`31–39`); it restates the `mode 1` / `mode 2` subsections already in
  `## workflow` (`92–153`) — pure duplication.
- Move the changelog-format template (`52–80`) into a `reference/` example to slim the file.

### commit (106)
- Move the gitmoji table (`45–78`) to `reference/gitmoji.md`.
- Fold `## commit format` (`28–43`) into the workflow step where the message is drafted, so
  the section order matches the standard (features → usage → workflow → best practices).

### create-cli (234)
- Reorganize `## Step 1–4` into a single lowercase `## workflow`; move `## Do This First`
  into usage; fold `## Default Conventions` (`213–235`) into `best practices` or a reference file.
- Extract the variable-substitution table (`129–143`) and output-summary examples
  (`156–211`) to `reference/`.

### create-docs (161)
- Cleanest of the `create-*` family. Keep `## document format requirements` inline (it
  governs output); optionally move the `## sections` table (`35–45`) to reference.

### create-html (120)
- Move the 20-template catalog (`86–109`) to `reference/templates.md`.
- Resolve the contradiction: `~38` says skip markitdown for `.md`/`.txt` input, but the
  `best practices` (`~116`) say "markitdown first, always." Pick one and state it once.

### create-issue (137)
- Tighten the 3-sentence description to one line; demote "interview mode" to a feature bullet.
- Move the gitmoji table + issue template (`33–75`) to a `reference/` file.

### create-skill (120)
- Update to teach the current standard: no `trigger:` in generated frontmatter; recommend
  `reference/` splits for large skills; drop "exactly three files."
- It defines the standard, so it must be the first file fixed once policy is set.

### create-web (208)
- Normalize heading case (all lowercase) and fold `## step N` under `## workflow`.
- Move `## 37signals style guide reference` and `## adding new templates` (maintenance
  docs, not user-facing) to `reference/` / a contributing doc.

### deep-learn (90)
- **Exemplar** — standard-compliant, well-scoped, no splitting needed.
- Only nit: `## the comprehension checklist` → drop the article for heading consistency.

### humanize (441)
- Split the 29-pattern catalog (`72–408`) into `reference/patterns.md`; `SKILL.md` keeps a
  summary list + a pointer. Biggest single length win in the repo.
- Rename `## task` → `## workflow`, add a `## features` list, add `## best practices`.

### markdown (73)
- Add `## features` (supported formats as bullets) and `## best practices` (e.g. always
  pass the type hint for stdin).
- Move the attribution line (`~9`) to a `## credits` footer or the README.

### mermaid (132)
- Move the diagram-types table (`41–51`) and auto-detection rules (`54–70`) to
  `reference/`; keep a 3–4 bullet summary inline.
- Clarify argument precedence in the workflow: how a filename is distinguished from a
  free-text description (e.g. "if the arg resolves to a file, treat as file; else description").

### refine-issue (127)
- Structurally sound. Its gitmoji table + template are duplicated verbatim from
  `create-issue`; dedup is possible but is **out of scope** per the overlap decision.

### release (172)
- Well structured. Only optional cleanup: move the completion-summary template (`150–163`)
  to a `reference/` example.

### review (251)
- Many sections beyond the standard (review contract, code-reading depth, severity, fix
  quality bar, safety rules, test handling). Comprehensive but the heaviest file — move the
  output-format template (`140–172`) to `reference/` and consider grouping the rest under
  the four standard headings as subsections.

### search-anime (377)
- Move the per-mode output templates (`52–318`) → `reference/output-modes.md` and the
  genre/format/score tables (`331–378`) → `reference/reference-tables.md`. The workflow
  should orchestrate modes, not embed their full rendered output.
- Promote `## best practices` (`320`) above the template mass.

### taste (298)
- Frontmatter outlier: remove `version: 1.1.0`; align with the rest by dropping `trigger:`
  everywhere (per the spec decision).
- Convert Title Case headings (`## Protocol`, `### Step N`, `## When to Use`) to lowercase.
- Its `reference/` split is the model the other large skills should copy.

### ytd (58)
- **Exemplar** — tightest file in the repo; `SKILL.md` cleanly wraps `ytd.py`.
- Description leaks implementation detail ("delegating all work to `ytd.py` via
  `uv run --upgrade`"); rephrase as third-person what/when.

---

## Out of scope

Per the review's scope decision, cross-skill overlap is recognized but **left untouched**:

- **create-issue ↔ refine-issue** — duplicate the gitmoji table and issue template verbatim.
- **changelog ↔ release** — `changelog --release` overlaps the standalone `release` skill.
- **markdown ↔ create-html** — both wrap `uvx markitdown` for different outputs.
- **review ↔ built-in `/code-review`** — overlapping purpose; boundary undocumented.

These are deliberate product boundaries for now; revisit only if maintenance drift (e.g. the
duplicated issue template diverging) becomes a real problem.

---

## Suggested sequencing

1. Set the standard: update `AGENTS.md` + `create-skill` (frontmatter policy, `reference/` pattern).
2. Sweep frontmatter: drop `trigger:` everywhere; fix `taste`'s `version:`.
3. Normalize headings/sections (mechanical, low-risk).
4. Progressive-disclosure splits, largest first: `humanize`, `search-anime`, `create-cli`,
   `create-web`, `review`.
5. Per-skill nits (descriptions, the `changelog` `## modes` deletion, `create-html` contradiction).
