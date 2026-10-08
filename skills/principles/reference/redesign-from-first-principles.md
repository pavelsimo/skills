# redesign-from-first-principles

**Phase:** before writing

## rule

When patches keep piling onto the same area, stop patching. Ask what you would build today, knowing everything you now know about the requirements, and compare that with the current design. If the gap is large, redesign instead of adding another special case.

## when it applies

- the third or fourth bug fix in the same module
- a function with flags that change its behavior for specific callers
- requirements that have shifted since the code was written

## example

A notification system grew separate code paths for email, SMS, push, and Slack, each with its own retry logic. Redesigned around one `Delivery` record with a channel adapter, three hundred lines of duplicated retry code disappear.

## usual violation

Adding `if customer == "acme"` or a seventh boolean parameter because a redesign "feels too big", while every new patch makes it bigger.
