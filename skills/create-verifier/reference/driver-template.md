# driver template

Read this in workflow step 4. Copy each template, then replace every `<…>` with a real value from the repo. No `<…>` may remain in the generated files.

## `.skills/verify-<app>/SKILL.md`

````markdown
---
name: verify-<app>
description: Launches, health-checks, drives, captures evidence from, and cleans up <app> for verification. Used by the prove skill when a check needs the running app; also usable directly to launch the app and reach a feature.
---

# verify-<app>

How to operate <app> for verification. This skill holds no pass/fail rules; `prove` decides what counts as proven, and the task's done-predicates decide what to check.

## Launch

```bash
<exact command to start the app, including env vars and port>
```

- ready when: <e.g. `curl -fsS http://localhost:3000/up` returns 200, retry every 1s for up to 60s>
- runs in: <foreground terminal | background process; how to capture its PID>
- logs: <where the app writes logs during the run>

## Doctor

One read-only check that this instance is worth driving:

```bash
<e.g. bin/rails runner 'puts User.count' — expect at least 1 seeded user>
```

If the doctor fails, stop and report it. Do not drive a broken instance.

## Drive

- harness: <browser automation tool | curl | direct CLI | tmux>
- base URL / entry: <http://localhost:3000 | ./bin/<cli> | …>
- sign in as a user: <exact steps, test account, where dev-only codes or emails appear>
- feature map: [features/README.md](features/README.md)

## Evidence

- directory: `.skills/verify-<app>/evidence/<YYYYmmdd-HHMMSS>/` (gitignored)
- capture: <screenshots after each step | full HTTP responses | stdout + exit code | DB rows read back>
- naming: `<feature>-<step>-<before|after>.<ext>`
- proof standard: evidence must show the changed surface, not a neighbouring one

## Cleanup

```bash
<stop only what Launch started, e.g. kill "$APP_PID">
```

- never delete the evidence directory
- confirm nothing is left listening: `lsof -i :<port>` returns nothing
````

## `.skills/verify-<app>/features/README.md`

```markdown
# <app> feature map

## baseline preconditions

- <database migrated and seeded with `<command>`>
- <test account: email / how to sign in>
- <required env vars, with dev-safe values>

## proof standards

- UI features: screenshot after the final step, plus the URL
- API features: status code and body of the final response
- persisted changes: read the value back from a second view (reload, fresh query)

## features

| Feature | File | Reached from |
|---------|------|--------------|
| <feature> | [<feature>.md](<feature>.md) | <route, menu, or command> |
```

## `.skills/verify-<app>/features/<feature>.md`

```markdown
# <feature>

## Sub-features

- <user-visible capability>
- <user-visible capability>

## How to get to it (user POV)

1. <start at …>
2. <click / run / submit …>
3. <what the user sees when it worked>

## Driving it with <harness>

<exact selectors, routes, request bodies, or commands, copied from the repo>

## Gotchas

- <timing, flaky element, seed-data dependency, dev-only behavior>
```
