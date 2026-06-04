# deep-learn skill

A skill for agents that runs an interactive, mastery-gated tutoring session on a single topic — eliciting what the learner already knows, filling the gaps with layered explanations, and quizzing until the problem, the solution, and why it matters are all genuinely understood.

## Usage

```
/deep-learn <topic>              # start a session on a specific topic
/deep-learn <file|PR|concept>    # learn a code change, file, or concept
/deep-learn --resume             # continue from an existing checklist doc
```

The assistant acts as a patient expert teacher. It builds understanding incrementally, confirms mastery of each stage before advancing, and refuses to end the session until every item on a running comprehension checklist is verified.

## How a session works

Every session is organized around three pillars:

1. **The problem** — what it is, why it existed, the tradeoffs, the alternatives.
2. **The solution** — what it is, why it was resolved this way, the design decisions, the edge cases.
3. **The broader context** — why it matters, what it impacts, the downstream effects.

These are tracked in a running markdown doc (`deep-learn-<topic-slug>.md`) where each item carries a mastery marker:

| Marker | Meaning |
|--------|---------|
| `⬜` | not yet covered |
| `🟡` | partial — restated but shaky |
| `✅` | mastered — verified by a quiz or a solid restatement |

The loop for each item is the same: **elicit** the learner's current understanding → **teach**, drilling into *why* before *what* and *how* → **quiz** with `AskUserQuestion` (randomized answer order, hidden until submitted) → **gate** progression until the item is `✅`.

Ask for any explanation level at any time:

| Level | Depth |
|-------|-------|
| `eli5` | one plain analogy, no jargon |
| `eli14` | concrete examples, a little vocabulary |
| `elii` | real terminology, the actual moving parts (explain like I'm an intern) |
| (default) | precise, complete, edge cases and tradeoffs included |

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
