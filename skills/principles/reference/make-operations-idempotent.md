# make-operations-idempotent

**Phase:** concurrency / ops

## rule

Design operations so that running them twice has the same effect as running them once. Retries, re-delivered messages, double-clicked buttons, and re-run migrations must all be safe.

## when it applies

- job handlers, message consumers, webhooks, cron tasks
- payment, email, and other side effects that must not repeat
- migrations and deploy scripts

## example

A webhook handler stores the provider's event ID with a unique constraint and returns 200 without doing anything when it sees an ID it already processed.

## usual violation

"Insert" where "upsert" was needed, emails sent once per retry, and a migration that fails halfway and can't be run again.
