# type-system-discipline

**Phase:** before writing

## rule

Use the type system to make illegal states unrepresentable. Parse input into precise types once, then pass those types around instead of re-validating loose values. Avoid escape hatches (`any`, unchecked casts, stringly-typed values) in core code.

## when it applies

- defining the shape of data that crosses more than one function
- values with a restricted range: IDs, money, email addresses, enum-like strings
- every time you are about to write `as any`, `# type: ignore`, or a cast

## example

`type Payment = { status: "pending" } | { status: "paid"; paidAt: Date }` instead of `{ status: string; paidAt?: Date }`. A paid payment without a date can no longer be constructed.

## usual violation

Optional fields that are "always set when X", plain `string` for IDs of different kinds, and validation repeated in every function because the type never captured that it was already checked.
