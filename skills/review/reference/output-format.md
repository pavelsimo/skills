# output format

Always produce the review in this exact structure:

```
🎯 Review target: <local diff scope | PR #N | issue #N>
📂 Scope: <files changed, surface area, affected subsystems>

💬 Summary: <2–4 sentences describing what changed and the overall assessment>

🔍 Findings:
  1. [🔴 Critical / 🟠 High / 🟡 Medium / 🔵 Low / 🔹 Nit] Title
     📄 File: <path>:<line> or <path>
     🔎 Evidence: <exact code reference, symbol, or behavior>
     💥 Why it matters: <failure mode or user impact>
     🛠️ Suggested fix: <concrete recommendation>

  2. [Severity] Title
     ...

🧪 Tests / proof:
  <commands run and results, or explicit statement that tests were not run and why>

♻️ Refactor opportunities:
  <specific shape of any refactors worth considering, or "none identified">

⚠️ Remaining risks:
  <what is still uncertain, untested, or depends on runtime behavior>

✅ Verdict: <one of: No blocking issues | Needs changes | Needs discussion>
```

If there are no findings, say so explicitly under `Findings:` — do not omit the section.
