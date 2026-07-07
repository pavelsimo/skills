---
name: create-web
description: Scaffold a production-ready web application from language templates. Use when the user wants to bootstrap a new web project from scratch.
---

# create-web skill

## features

- Scaffolds a complete, production-ready web application from a language template
- Ruby on Rails 8.x template built on 37signals conventions (Basecamp / Fizzy architecture)
- Passwordless magic link authentication — no Devise, ~150 lines of custom code
- UUID primary keys, Solid Queue/Cache/Cable (no Redis dependency)
- Hotwire (Turbo + Stimulus) frontend with importmap-rails — no Node.js bundler required
- Native CSS with cascade layers — no Tailwind, no preprocessors
- Minitest test suite with fixtures — no RSpec, no FactoryBot
- Kamal deployment configuration with multi-stage Dockerfile
- GitHub Actions CI (rubocop + minitest + system tests)
- Comprehensive `AGENTS.md` encoding 37signals engineering principles (symlinked as `CLAUDE.md`)

## usage

```
/create-web
/create-web name=my-app template=ruby database=mysql
```

## workflow

Read `templates/` to understand the available templates and what variable placeholders each one uses before collecting any input from the user. Read [reference/37signals-style.md](reference/37signals-style.md) before changing Rails conventions, and [reference/template-maintenance.md](reference/template-maintenance.md) only when adding a new language template.

### 1. clarify

Collect these values via `AskUserQuestion`. Auto-detect `github_user` silently; never prompt the user for it.

| Field | Default | Notes |
|-------|---------|-------|
| `name` | — | Lowercase, hyphenated app name (e.g., `my-app`) |
| `template` | `ruby` | Currently `ruby` only — present as "(only option currently)" |
| `description` | — | One sentence: what this app does |
| `github_user` | auto | `gh api user --jq .login` |
| `database` | `sqlite` | `sqlite` or `mysql` |
| `ruby_version` | `3.4.2` | Latest stable Ruby |
| `visibility` | `private` | `private` or `public` |

**Derived values — never ask the user:**

| Variable | Derivation | Example |
|----------|-----------|---------|
| `APP_CLASS` | PascalCase(`name`) | `my-app` → `MyApp` |
| `APP_MODULE` | underscore(`name`) | `my-app` → `my_app` |
| `APP_NAME_HUMAN` | Title Case(`name`) | `my-app` → `My App` |
| `YEAR` | current year | `2025` |

PascalCase: split on `-`, capitalize each word, join. Underscore: replace `-` with `_`.

### 2. show spec card

Display a confirmation card before creating anything:

```
╭─ App Spec ──────────────────────────────────────────╮
│ Name:        {name}                                  │
│ Class:       {APP_CLASS}                             │
│ Description: {description}                           │
│ Template:    Ruby on Rails 8.x (37signals style)    │
│ Database:    {database}                              │
│ Ruby:        {ruby_version}                          │
│ Auth:        Passwordless magic links (no Devise)    │
│ Frontend:    Hotwire (Turbo + Stimulus) + importmap  │
│ CSS:         Native CSS (no Tailwind)                │
│ Jobs:        Solid Queue (no Redis)                  │
│ Deploy:      Kamal                                   │
│ Repo:        github.com/{github_user}/{name}         │
╰──────────────────────────────────────────────────────╯
```

Ask: "Does this look right? Shall I scaffold the project?"

### 3. scaffold

Execute in order:

1. **Create GitHub repo and clone:**
   ```bash
   gh repo create {github_user}/{name} --{visibility} --clone --description "{description}"
   cd {name}
   ```

2. **Copy template files with variable substitution:**
   - Copy all files from `templates/ruby/` (relative to this skill's directory) to the project root
   - Substitute all `{{PLACEHOLDER}}` tokens in both file contents and filenames:
     - `{{APP_NAME}}` → `{name}`
     - `{{APP_CLASS}}` → `{APP_CLASS}`
     - `{{APP_MODULE}}` → `{APP_MODULE}`
     - `{{APP_NAME_HUMAN}}` → `{APP_NAME_HUMAN}`
     - `{{GITHUB_USER}}` → `{github_user}`
     - `{{DESCRIPTION}}` → `{description}`
     - `{{RUBY_VERSION}}` → `{ruby_version}`
     - `{{DATABASE}}` → `{database}` (value: `sqlite3` for sqlite, `mysql2` for mysql)
     - `{{YEAR}}` → current year
   - Strip `.tmpl` extension from all `*.tmpl` files after substitution
   - Make all bin scripts executable: `chmod +x bin/*`

3. **Install dependencies:**
   ```bash
   bundle install
   ```

4. **Prepare database (runs db:create + db:migrate + db:seed):**
   ```bash
   bin/rails db:prepare
   ```

5. **Install git hooks:**
   ```bash
   bundle exec lefthook install
   ```

6. **Create CLAUDE.md symlink:**
   ```bash
   ln -s AGENTS.md CLAUDE.md
   ```

7. **Initial commit and push:**
   ```bash
   git add -A
   git commit -m "🎉 init: scaffold {APP_NAME_HUMAN} from create-web"
   git push -u origin main
   ```

8. **Configure GitHub repo:**
   ```bash
   gh repo edit --enable-wiki=false --enable-issues=true
   ```

### 4. output summary

```
✅ Created: https://github.com/{github_user}/{name}

Template: Ruby on Rails 8.x (37signals style)

Next steps:
  cd {name}
  bin/dev                        # start development server (localhost:3000)
  open http://localhost:3000     # view the app
  bin/rails test                 # run tests
  make lint                      # run rubocop
  bin/rails generate model ...   # add your first model

Documentation:
  docs/development.md            # local setup guide
  docs/deployment.md             # Kamal deployment guide
  config/deploy.yml              # Kamal deployment config — fill in your server IP and domain
  AGENTS.md                      # AI agent conventions (← CLAUDE.md)
```

## template variable reference

| Placeholder | Example | Used in |
|------------|---------|---------|
| `{{APP_NAME}}` | `my-app` | filenames, Kamal config, README |
| `{{APP_CLASS}}` | `MyApp` | Ruby module names, application.rb |
| `{{APP_MODULE}}` | `my_app` | database names, directory paths |
| `{{APP_NAME_HUMAN}}` | `My App` | page titles, email subjects, commit message |
| `{{GITHUB_USER}}` | `pavelsimo` | repo URL, Docker image registry, Kamal |
| `{{DESCRIPTION}}` | `A task manager...` | README, repo description |
| `{{RUBY_VERSION}}` | `3.4.2` | .ruby-version, Gemfile, Dockerfile |
| `{{DATABASE}}` | `sqlite3` | database.yml default adapter |
| `{{YEAR}}` | `2025` | LICENSE copyright line |

Substitution applies to both file contents and filenames. `.tmpl` extension is stripped post-substitution.

## best practices

- Always show the spec card and wait for explicit confirmation before creating the GitHub repo or any files
- Detect `github_user` silently via `gh api user --jq .login`; never prompt the user for it
- The template ships with a working auth system — do not replace it with Devise or other gems
- When users ask for tests, remind them that fixtures (not FactoryBot) and Minitest (not RSpec) are the 37signals convention
- When modeling state ("close", "archive", "publish"), always use a separate record (`Closure`, `Publication`) rather than boolean columns — this is the 37signals pattern
- CSS additions go in focused component files under `app/assets/stylesheets/` using cascade layers — never suggest Tailwind
- Background jobs go through Solid Queue — never suggest Sidekiq or Redis
- New routes nominalize verbs: "close" → `resource :closure`, "pin" → `resource :pin`, "watch" → `resource :watch`
