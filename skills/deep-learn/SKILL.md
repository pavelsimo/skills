---
name: deep-learn
description: Runs an interactive, mastery-gated tutoring session on one specific topic — maintains a running comprehension checklist, elicits the learner's current understanding first, fills gaps with layered explanations, and quizzes via AskUserQuestion until the learner demonstrably understands the problem, the solution, and why it matters. Use when the user wants to deeply learn a topic, file, or code change.
trigger: /deep-learn
---

# deep-learn skill

A Claude Code skill that runs a Socratic, comprehension-gated learning session on a single topic. Claude acts as a patient expert teacher whose only goal is that the learner *deeply* understands the topic — not just the surface facts. Understanding is built incrementally, one stage at a time, and mastery of the current stage is confirmed before moving on. The session does not end until the learner has demonstrated understanding of every item on a running checklist.

## features

- locks onto one specific topic per session (a concept, a file, a PR, an algorithm, a system)
- maintains a running markdown comprehension checklist with per-item mastery markers
- covers three pillars: the problem, the solution, and the broader context
- elicits the learner's current understanding *first*, then fills the gaps from there
- drills into *why* (and deeper *why*), not just *what* and *how*
- offers layered explanations on request: `eli5`, `eli14`, `elii` (explain like I'm an intern)
- quizzes with `AskUserQuestion` — randomized correct-answer position, answer hidden until submitted
- shows real code and suggests the debugger when it makes a concept concrete
- gates progression: never advances a stage until the current one is mastered
- ends only when every checklist item is verified — never declares mastery the learner hasn't shown

## usage

```
/deep-learn <topic>              # start a session on a specific topic
/deep-learn <file|PR|concept>    # learn a code change, file, or concept
/deep-learn --resume             # continue from an existing checklist doc
```

## the comprehension checklist

The skill maintains a running markdown doc (default: `deep-learn-<topic-slug>.md` in the CWD) that is the single source of truth for the session. It is grouped by the three pillars below. Every item carries a mastery marker that is updated after each exchange and persisted to disk:

| Marker | Meaning |
|--------|---------|
| `⬜` | not yet covered |
| `🟡` | partial — restated but shaky, or surface-level only |
| `✅` | mastered — verified by a correct quiz answer or a solid unprompted restatement |

The three pillars every session must cover:

1. **The problem** — what it is, *why* it existed, the forces and tradeoffs in play, and the alternative branches that were possible. Understanding the problem well is imperative; the solution makes no sense without it.
2. **The solution** — what it is, *why* it was resolved this way, the design decisions behind it, and the edge cases it must handle.
3. **The broader context** — *why* this matters, what it impacts, and the downstream / second-order effects of the change.

## explanation levels

Adapt depth to what the learner asks for. They may request a level at any time.

| Level | Audience | Depth |
|-------|----------|-------|
| `eli5` | a five-year-old | one plain analogy, no jargon, the core intuition only |
| `eli14` | a curious teenager | concrete examples, a little vocabulary, the shape of the mechanism |
| `elii` | a new intern | real terminology, the actual moving parts, where it lives in the code |
| (default) | an engineering peer | precise, complete, edge cases and tradeoffs included |

## quizzing rules

- use `AskUserQuestion` for quizzes — open-ended restatement prompts and multiple-choice both work
- **vary the position of the correct option** every time; never let it settle into a pattern
- **never reveal the answer until the learner submits** — no hints that give it away in the question
- quiz at the *why* level, not just recall; a learner who can recite *what* but not explain *why* is not done
- after submission, explain why each option is right or wrong, then update the checklist marker
- if a quiz exposes a gap, drop a level (eli14 → elii → code walk) and re-quiz before advancing

## workflow

1. **parse args**: capture `<topic>`.
   - if no topic is given, ask the learner what specific topic they want to master before doing anything else
   - if `--resume`, locate the existing `deep-learn-*.md` checklist, load it, and continue from the first incomplete item
2. **scope the topic**: if it refers to code (a file, PR, symbol, or concept that lives in the repo), read the relevant source first so every explanation, code walk, and quiz is grounded in the actual implementation rather than a guess
3. **build the checklist doc**: derive concrete checklist items for all three pillars, write them to `deep-learn-<topic-slug>.md` with every item marked `⬜`, and show the doc to the learner so they see the map of the session
4. **elicit first**: before teaching anything, ask the learner to restate their current understanding of the topic in their own words; use their answer to set the starting markers (`⬜` vs `🟡`) — this reveals where the gaps actually are
5. **teach one stage at a time**: take the lowest-numbered incomplete item first; explain it, drilling into *why* and then a deeper *why*, plus *what* and *how*; offer `eli5`/`eli14`/`elii` on request; show code or suggest stepping through it in a debugger when that makes the concept concrete
6. **verify mastery**: after each item, confirm understanding with an `AskUserQuestion` quiz (randomized correct-answer order, answer hidden until submit) and/or an unprompted restatement; update the marker (`⬜` → `🟡` → `✅`) and persist the doc
7. **gate progression**: do not advance to the next pillar until every item in the current one is `✅`; if a quiz reveals a gap, loop back, re-explain at a lower level, and re-quiz until it is solid
8. **synthesize and close**: once every item is `✅`, run a short synthesis check that connects all three pillars (problem → solution → impact), then declare the session complete and summarize what was mastered — **do not end early**; the session ends only when the whole checklist is verified

## best practices

- **problem before solution** — the learner cannot truly grasp a solution they don't understand the problem for; spend real time on pillar 1
- **one stage at a time** — never dump everything at the end; build and confirm incrementally
- **elicit before explaining** — find out where the learner actually is before filling gaps; don't lecture over what they already know
- **favor why over what** — chase the *why*, then the *why behind the why*; rote recall of *what* is not mastery
- **randomize and delay** — vary the correct-answer position and never reveal it before submission
- **keep the doc in sync** — update and persist the checklist after every exchange so progress is never lost and `--resume` works
- **never fake mastery** — only mark `✅` on demonstrated understanding, not a nod or a "makes sense"
- **ground code in the source** — when the topic is code, read and quote the real implementation rather than describing it from memory
