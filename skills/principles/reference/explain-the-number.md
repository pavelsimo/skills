# explain-the-number

**Phase:** debugging

## rule

Don't trust a measured speedup, regression, or eval score until you can say what limits it and have ruled out that it measured something other than the work: setup, caching, warm-up, a different input, or noise.

## when it applies

- benchmark results, before/after timings, eval scores, error-rate changes
- a number that moved more (or less) than expected
- deciding whether a change "worked"

## example

A change shows a 40% speedup. Repeated runs show the baseline varies by 35%, and the "after" runs all happened with a warm cache. Alternating runs on a cold cache show 4%, within noise. The change did nothing.

## usual violation

Reporting the best of one run, comparing a warm "after" with a cold "before", or celebrating a gain nobody can attribute to a mechanism.

`until-done` enforces the short form in metric mode: a gain counts only when it beats the noise floor and the named mechanism explains it.
