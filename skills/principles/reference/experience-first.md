# experience-first

**Phase:** before writing

## rule

Start from what the user sees and does, then work backwards to the implementation. Decide the interface, the command, the error message, or the screen first. The internals exist to serve that experience, not the other way round.

## when it applies

- new features, commands, endpoints, and settings
- error handling and empty states
- any time the implementation is pushing the interface into an awkward shape

## example

Write the CLI help text and two example invocations before writing the parser. If the examples read badly, change the design while it is still cheap.

## usual violation

Exposing the internal model directly ("pass `--strategy=2` to use the cached path") because that is how the code happened to be built.
