# laziness-protocol

**Phase:** changing code

## rule

Do the least work that fully achieves the outcome. Don't build for hypothetical future needs, extra configurability, or generality nobody asked for. Be lazy about speculation, never about correctness or verification.

## when it applies

- deciding how general a solution should be
- tempted to add a plugin system, a config option, or an interface with one implementation
- scoping a task that could grow

## example

A script needs to read one CSV format. Write the reader for that format. Don't build a pluggable reader framework for formats that don't exist yet.

## usual violation

Abstract base classes with one subclass, options with one value ever used, and "while I was in there" changes that expand the diff and its risk.
