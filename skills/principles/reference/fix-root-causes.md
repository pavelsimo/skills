# fix-root-causes

**Phase:** debugging

## rule

A bug fix names its root cause: the specific line or decision that makes the wrong thing happen, and why. Reproduce the bug before fixing it. A guard that stops the crash without explaining it (a nil-check, a `try/except: pass`, a retry) hides the bug; it doesn't fix it.

## when it applies

- every bug fix
- any change that adds a null check, a catch-all, a retry, or a sleep to make a failure go away
- reviewing a fix whose description only restates the symptom

## example

The crash is `NoneType has no attribute 'email'`. The root cause is that `invite.accept` creates the membership before the user record commits (`invites.py:88`). Fixing the order is the fix; `if user is None: return` is not.

## usual violation

"Fixed the crash" with a guard, no repro, and no sentence explaining why the value was missing. The bug comes back somewhere else.

`prove` enforces the short form: reproduce twice before, gone twice after, root cause named, guard-only fixes are `NOT VERIFIED`.
