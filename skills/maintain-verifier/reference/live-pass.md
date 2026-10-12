# live pass reference

Read this in workflow step 5, before the first launch.

## launch model

The driver's Launch section decides the model, not this skill.

| App shape | Model |
|-----------|-------|
| server, web UI, desktop app | launch one instance, drive it serially, tear it down after the last drive |
| short-lived CLI or TUI | build once, then start each drive in its own isolated session (fresh tmux or PTY session, fresh temp dir) |

If the driver says instances cannot be isolated, drive only an instance this run started. Never drive the user's own running instance.

## three invariants

Keep all three for the whole pass, whatever fails.

1. **Doctor before driving.** Never drive an instance that has not passed the driver's Doctor since it last did something surprising.
   - run Doctor before the first drive
   - run Doctor on each fresh session, where sessions are the unit
   - run Doctor again after any failed drive, so a dead instance is not mistaken for a broken feature
   - when Doctor cannot see the problem (a stuck UI on a healthy process, a modal left open), reset to a known state or relaunch instead of driving on
2. **Evidence survives every cleanup.** After each cleanup, including cleanup after a failed attempt, check that the evidence captured so far still exists at the driver's evidence location.
3. **Nothing outlives its use.** Clean up what each drive started, whether the session is stuck, exited, or shared. On a shared instance, clean up the residue (records, files, sessions the drive created), not the instance itself. Kill by the PID or session name you recorded, never by process name.

## doctor failure caused by drift

If Doctor fails because the driver is wrong (a renamed health route, a changed port, a new required env var), that is drift:

1. fix it inside `.skills/verify-<app>/`
2. restart only what the fix made invalid
3. retry once

If it still fails, the pass is `blocked`. Report the Doctor command, its output, and the fix you tried.

## verified-unreachable

A feature may be reported as `verified-unreachable` only with both:

- the concrete prerequisite that is missing (an auth provider, a paid entitlement, a specific OS, an external service, a hardware device)
- the route you attempted and what happened there

If the feature map does not mention that prerequisite, add it to the feature file's preconditions as doc drift.

Never report a feature as verified through a different entry point than the one you were checking. A skipped entry point is reported as skipped.

## re-drives

Every harness fix from triage is driven live again before it ships. Final teardown happens only after the last re-drive.
