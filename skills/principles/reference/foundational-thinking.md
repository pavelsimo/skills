# foundational-thinking

**Phase:** before writing

## rule

Get the foundation right before building on it. The data model, the core invariants, and the main abstractions decide how expensive every later feature is. Spend the thinking there first.

## when it applies

- starting a new project, module, or service
- adding a feature that needs a new kind of data or a new lifecycle
- any time several upcoming features will sit on the same piece of code

## example

Before adding "teams" to an app that only has users, decide what owns a record: a user, a team, or an account that both belong to. Picking "account" now means billing, sharing, and permissions all hang off one place later.

## usual violation

Building the feature on whatever structure is already there ("just add a `team_id` column to everything") and paying for it in every feature that follows.
