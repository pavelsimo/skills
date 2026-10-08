# encode-lessons-in-structure

**Phase:** agent conduct

## rule

When you learn a lesson, put it into structure the system enforces: a test, a type, a lint rule, a hook, a script, or a template. A rule the runtime or CI enforces beats a line of text someone (or some agent) may skip.

## when it applies

- after a bug that could happen again
- after a correction from the user or a reviewer
- when writing "remember to…" in docs or instructions

## example

After an agent twice declared work done without verifying it, the fix is a stop hook that runs `prove`, not a stronger sentence in `AGENTS.md`. The sentence stays as a fallback for runtimes without hooks.

## usual violation

A growing list of "don't forget to…" notes that nobody reads at the moment they would matter.
