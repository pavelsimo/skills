# attack-the-premise

**Phase:** debugging

## rule

When two fixes that rest on the same assumption have both failed, stop trying a third. Write the assumption down and test it directly. The bug is often in what you believe about the system, not in the code you keep changing.

## when it applies

- a second failed attempt at the same bug or the same optimization
- "this should work" moments
- a loop where each round tweaks the same area

## example

Two caching fixes failed to speed up a page. The shared assumption is "the page is slow because of the database". A profile shows 80% of the time is template rendering. The premise was wrong.

## usual violation

A fourth, fifth, and sixth variation of the same fix, each a little more elaborate, without checking the belief they all depend on.

`until-done` enforces the short form: two fails sharing one assumption means write it down and question it.
