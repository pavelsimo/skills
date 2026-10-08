# exhaust-the-design-space

**Phase:** before writing

## rule

Before committing to a design, write down at least two or three genuinely different approaches and compare them on the criteria that matter for this problem. Pick one on purpose, and say why the others lost.

## when it applies

- any change that is expensive to undo: schemas, public APIs, protocols, file formats
- when the first idea came quickly and nobody has challenged it
- when a design review would ask "did you consider…?"

## example

Syncing data to a partner: (a) nightly batch export, (b) webhooks on change, (c) the partner polls an API with a cursor. Compared on latency, failure recovery, and who carries the operational load, (c) wins because missed calls recover on their own.

## usual violation

Going with the first approach that could work, then defending it after it is built. "Alternatives considered" written afterwards to justify the choice.
