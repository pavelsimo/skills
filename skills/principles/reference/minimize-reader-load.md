# minimize-reader-load

**Phase:** readability

## rule

Write for the next reader. Minimize what they must hold in their head to understand the code: fewer indirections, names that say what things are, related code kept together, and no layers that add nothing.

## when it applies

- adding a wrapper, an abstraction, or a level of indirection
- naming things
- splitting or merging functions and files

## example

A `get_config_value(key)` wrapper with one caller, which only calls `config[key]`, is inlined. The reader no longer jumps to another file to learn it does nothing.

## usual violation

One-caller wrappers, deep inheritance for two variants, logic split across many tiny files, and names like `handle`, `do_it`, or `data2`.
