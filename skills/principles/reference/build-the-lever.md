# build-the-lever

**Phase:** changing code

## rule

When a task repeats, or when a manual step keeps slowing the work down, build the tool that does it: a script, a generator, a fixture, a make target. A small lever built early pays for itself many times over.

## when it applies

- the third time you do the same manual sequence
- setup steps that block every verification run
- data or fixtures that are tedious to create by hand

## example

Instead of hand-crafting test accounts for every bug repro, write `bin/seed-scenario <name>` that creates the exact state needed. Every later repro takes seconds.

## usual violation

Repeating a ten-step manual process for the twentieth time because "it's faster than writing a script this once".
