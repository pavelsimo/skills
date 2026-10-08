# outcome-oriented-execution

**Phase:** changing code

## rule

Aim at the outcome, not the activity. Define what must be true when the work is done, and judge progress by that, not by effort, lines changed, or tasks ticked. Don't preserve incidental behavior nobody relies on just because it exists.

## when it applies

- planning a task or breaking it into steps
- reporting progress
- deciding whether an existing quirk must be kept

## example

The goal is "checkout completes in under two seconds for 95% of users", not "optimize the checkout code". A change that removes an unnecessary redirect counts; a refactor that doesn't move the number doesn't.

## usual violation

Reporting "worked on X for a day", or carefully preserving an internal behavior that no caller, test, or user depends on.
