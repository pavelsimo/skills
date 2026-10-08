# guard-the-context-window

**Phase:** agent conduct

## rule

An agent's context is a limited working memory. Keep it for what matters to the task. Read the slice of a file you need, filter command output, and hand broad searches to a sub-agent that returns only the conclusion.

## when it applies

- reading large files, logs, or generated output
- searching a big codebase
- long sessions where early details must survive

## example

Instead of printing a 20,000-line test log, run the suite with failures only (`pytest -q --no-header -rf`) or `grep` for the failing test names, then read only those tracebacks.

## usual violation

Dumping whole files, full dependency trees, or verbose logs into context, then losing track of the actual task under the noise.
