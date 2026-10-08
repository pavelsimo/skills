# subtract-before-you-add

**Phase:** changing code

## rule

Before adding code, look for what can be removed, reused, or simplified. The best change often deletes more than it adds. Every new line is something to read, test, and maintain.

## when it applies

- adding a helper, a config option, a dependency, or a new abstraction
- fixing a bug in code that is more complicated than the problem it solves
- any feature request that overlaps an existing feature

## example

Instead of adding a second date-formatting helper for a new report, delete both existing near-duplicates and use the standard library formatter everywhere.

## usual violation

A new `utils2.py`, a new flag next to five existing flags, or a new dependency for something the codebase already does in one place.
