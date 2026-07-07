# issue format reference

## gitmoji reference

| Type | Gitmoji | Example title |
|------|---------|---------------|
| feat | ✨ | `✨ add oauth login via google` |
| bug | 🐛 | `🐛 password reset link expires too early` |
| chore | 🔧 | `🔧 upgrade go to 1.23` |
| refactor | ♻️ | `♻️ simplify auth middleware` |
| perf | ⚡️ | `⚡️ cache user profile queries` |
| docs | 📝 | `📝 document deployment steps` |
| test | 🧪 | `🧪 add integration tests for login flow` |
| security | 🔒 | `🔒 sanitize file upload paths` |
| ui | 💄 | `💄 update button styles to match design system` |

## issue template

```markdown
## 🎯 Problem

<one paragraph — why this matters, what pain it addresses>

## 📋 Description

<what needs to be done>

## ✅ Acceptance Criteria

- [ ] <criterion 1>
- [ ] <criterion 2>

## 🔁 Steps to Reproduce

> Only included for bug issues

1. <step 1>
2. <step 2>
- **Expected:** <what should happen>
- **Actual:** <what happens instead>

## 💡 Technical Notes

> Optional — file paths, APIs, related code, implementation hints
```
