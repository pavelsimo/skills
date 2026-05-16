# humanize skill

A skill for agents that strips AI writing patterns from text and makes it sound natural and human — based on Wikipedia's "Signs of AI writing" guide.

## Usage

```
/humanize                          # humanize text in the current context
/humanize --sample <file>          # match voice from a writing sample file
```

Inline voice sample:

```
/humanize Here's a sample of my writing for voice matching: [your text]
Then humanize this: [text to humanize]
```

The assistant scans for 29 AI patterns, rewrites the text, then does a second-pass audit to catch anything that slipped through.

## What it fixes

**Content issues** — significance inflation, promotional language, vague "experts say" attributions, formulaic challenges sections, and superficial -ing constructions that fake depth.

**Language patterns** — overused AI vocabulary (testament, pivotal, delve, landscape), copula avoidance (serves as / boasts / features), synonym cycling, rule-of-three padding, false ranges, and passive-voice fragments.

**Style issues** — em dash clusters, unnecessary boldface, inline-header lists, title case headings, emojis in structure, and curly quotation marks.

**Communication artifacts** — chatbot sign-offs (I hope this helps!), knowledge-cutoff disclaimers, sycophantic openers, and signposting (Let's dive in...).

**Filler and hedging** — excessive qualifiers, generic upbeat conclusions, hyphenated word pair overuse, authority tropes (the real question is / at its core), and fragmented headers.

## Voice calibration

Provide a sample of your own writing to get a rewrite that matches your style rather than generic "clean" prose:

```
/humanize --sample ~/my-blog-post.md
```

The assistant reads the sample, notes your sentence length, word choice, punctuation habits, and transition style, then applies those patterns instead of a one-size-fits-all voice.

## Installation

<details>
<summary>Claude Code</summary>

Claude Code supports custom slash commands defined as markdown files under `.claude/commands/`. Dropping `SKILL.md` there registers a `/humanize` command in any Claude Code session inside that project.

```bash
mkdir -p .claude/commands
cp SKILL.md .claude/commands/humanize.md
```

For a global install (available in every project):

```bash
mkdir -p ~/.claude/commands
cp SKILL.md ~/.claude/commands/humanize.md
```

**invoke:** type `/humanize` in Claude Code (CLI, VS Code extension, or web).

</details>

<details>
<summary>OpenAI Codex</summary>

Codex reads `AGENTS.md` at the project root as a persistent instruction file. Reference `SKILL.md` from there so Codex follows the humanize conventions whenever you ask it to rewrite text.

```bash
cp SKILL.md SKILL.md   # keep the skill file in your repo root
```

Then add to `AGENTS.md`:

```markdown
## writing style
when rewriting or editing text, follow the rules defined in SKILL.md exactly.
```

For a global install, append the skill to your user-level instructions:

```bash
cat SKILL.md >> ~/.codex/instructions.md
```

**invoke:** `codex "humanize this text"` or ask inside a session: `remove the AI patterns from this`.

</details>

<details>
<summary>GitHub Copilot</summary>

Copilot Chat picks up repository-level custom instructions from `.github/copilot-instructions.md`. Paste the skill content there so Copilot follows the same conventions.

```bash
mkdir -p .github
cat SKILL.md >> .github/copilot-instructions.md
```

**invoke:** open Copilot Chat and say `humanize this text` or `remove the AI writing patterns from this`.

</details>

## Attribution

Based on [blader/humanizer](https://github.com/blader/humanizer) by [@blader](https://github.com/blader), which draws from Wikipedia's [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide. The pattern catalog, before/after examples, and two-pass rewriting process are adapted from that work.

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
