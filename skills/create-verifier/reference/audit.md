# audit mode

Read this when `/create-verifier --audit` is invoked. The audit checks that an existing `.skills/verify-<app>/` still matches the code and the running app.

It may only edit files inside `.skills/verify-<app>/`. It never edits product code.

## steps

1. **Index hygiene.** Compare `features/README.md` with the files in `features/`:
   - missing: a feature file exists but is not in the index
   - extra: the index lists a file that does not exist
   - duplicate: two files describe the same feature
   - dead: a feature whose route, command, or screen no longer exists in the source

2. **Read the source behind each feature.** For each feature file, read the routes, controllers, components, or commands it depends on and note every selector, route, field, or flag that no longer matches. When the runtime can start sub-agents, use one read-only reader per feature in parallel; otherwise read them in turn.

3. **One live pass.** Launch, run Doctor, then drive every feature using only its feature file. Run Doctor again after any failed feature, so a dead instance is not mistaken for a broken feature. Capture evidence as the driver's Evidence section says. Clean up.

4. **Triage each mismatch.**

   | Kind | Meaning | Action |
   |------|---------|--------|
   | doc drift | the app works, the feature file is wrong | fix the feature file |
   | harness gap | the app works, the driver cannot reach it | fix the driver, then re-drive that feature |
   | app broken | the app itself fails | report it; never touch product code |

5. **Report the outcome.**

   ```
   audit: .skills/verify-<app>/
   outcome: clean | changed | blocked

   index:    <missing / extra / duplicate / dead entries, or "ok">
   features: <feature> — ok | fixed (<what>) | broken (<what the app did>)
   evidence: <paths from the live pass>
   ```

   - `clean`: nothing needed changing
   - `changed`: corrections were made, all inside `.skills/verify-<app>/`, and every corrected feature was re-driven successfully
   - `blocked`: the app is broken or cannot launch; list what failed and stop
