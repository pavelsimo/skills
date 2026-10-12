# source reader brief

Read this in workflow step 3. Send one reader per feature file, all in parallel. Give each reader the brief below with the placeholders filled in, and nothing else from your context.

## brief

````markdown
You are a read-only source reader. Do not run the app, do not start servers,
and do not edit, create, or delete any file.

Feature file: .skills/verify-<app>/features/<feature>.md
Driver:       .skills/verify-<app>/SKILL.md

Question: how does this user-facing feature work today, according to the source?

1. Read the feature file and the driver's Drive section.
2. Find the code behind every entry point the feature file lists (routes,
   controllers, components, CLI command definitions, keybindings). Then look
   for entry points the file does not list.
3. Compare every selector, accessible name, route, field, flag, prompt string,
   precondition, and expected result in the feature file with the source.
4. Return exactly this shape, and nothing more:

## <feature>

summary: <two or three sentences: what the user can do and how they reach it>

entry points:
- <route / command / control> — <file:line>

drift:
- <claim in the feature file> → <what the source says> — <file:line>
(or "none")

recipe:
<one live-verification recipe: preconditions, then numbered user actions, each
with the exact driver command and the observable result that proves it>
````

## what to do with the results

- A reader that returns no `file:line` for a drift claim has not shown drift. Treat the claim as unproven.
- Readers report likely drift. Only the live pass confirms it. Do not edit a feature file from a reader's claim alone.
- If two readers cite the same code for different features, check for a duplicate feature in step 4.
