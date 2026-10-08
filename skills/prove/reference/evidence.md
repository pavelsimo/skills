# evidence reference

Read this when picking a check (workflow step 3), auditing tests (step 5), or deciding how strong a piece of evidence is.

## match the check to the change

| Change | Check | Proxy that does not count |
|--------|-------|---------------------------|
| CLI | run the real command; keep stdout, stderr, and exit code | "it compiles" |
| UI | walk the changed flow in the running app as a user would | unit tests on a component |
| HTTP API | call the real endpoint on a running server; keep status, headers, body | a handler unit test with mocked I/O |
| storage | write through the app, then read the value back from a second view (a fresh query, a reload, another process) | a "saved" toast or a 200 response |
| parser / migration | replay a saved real input and diff the output against the expected output | a type check passing |
| performance | before and after on the same machine, median of several alternating runs | one fast run on a warm cache |
| refactor (no behavior change) | the existing behavior checks still pass, plus a before/after diff of observable output | "the code looks equivalent" |
| config / infra | apply it to a disposable environment and observe the effect | the config file parses |

When a change touches more than one surface, each surface needs its own check.

## the evidence ladder

Every claim states how far up the ladder it got.

| Step | Name | What it means | Enough for `VERIFIED`? |
|------|------|---------------|------------------------|
| 1 | asserted | someone said so (including the author agent) | no |
| 2 | pointed at | a real `file:line` that shows the relevant code | no |
| 3 | reasoned | the failure path was walked step by step and shown not to reach | no |
| 4 | ran it | a script or test calls the real code and fails loudly if wrong | yes |
| 5 | reproduced | observed in the running app, on the changed surface | yes |

For UI and end-to-end flows, step 5 is the target. Step 4 is enough for libraries, CLIs, and pure functions.

## test audit

A test counts as evidence only if it passes all three checks:

1. **Real call.** It calls the code the way its users do: the public function, the CLI, the endpoint. Not a private helper, and not a mock of the thing under test.
2. **Literal expected value.** It asserts a concrete expected value (`== "2026-01-31"`, `status == 404`). Not `is not None`, not "no exception", not a value recomputed with the same code under test.
3. **The "undefined" test.** Ask: would this test still pass if every function it imports returned `undefined` (or `None`, `nil`, an empty value)? If yes, it observes no behavior. It is rejected as evidence; note it in the report so it can be rewritten or deleted.

Before and after: a test written for a bug fix must fail on the old build and pass on the new one. Run it on both.

## measured numbers

A measured speedup, regression, or score is evidence only when you can say:

- what limits the number (CPU, I/O, a lock, network, a specific loop)
- why the measurement covers the work and not setup, caching, JIT warm-up, or noise
- how large the noise is (spread across repeated baseline runs), and that the change exceeds it

Otherwise mark the predicate `INCONCLUSIVE` and say which of the three is missing.
