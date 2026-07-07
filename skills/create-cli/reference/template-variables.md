# template variable substitution

When copying from `templates/{template}/`, replace every occurrence of:

| Placeholder | Replaces with | Template |
|-------------|---------------|----------|
| `{{TOOL_NAME}}` | CLI name (e.g. `my-tool`) | all |
| `{{GITHUB_USER}}` | GitHub username/org | all |
| `{{DESCRIPTION}}` | One-sentence description | all |
| `{{HOMEBREW_TAP}}` | Homebrew tap repo (e.g. `pavelsimo/homebrew-tap`) | all |
| `{{YEAR}}` | Current 4-digit year | all |
| `{{COLOR_SCHEME}}` | Docs color theme: `teal`, `ocean`, `purple`, or `amber` | all |
| `{{MODULE_PATH}}` | `github.com/{github_user}/{name}` | go only |
| `{{MODULE_NAME}}` | Package name with `-` → `_` (e.g. `my_tool`) | python only |
| `{{TOOL_CLASS}}` | PascalCase class name (e.g. `MyTool`) | python only |

After substitution, rename every `*.tmpl` file by stripping the `.tmpl` extension.

Python template additional renames (after stripping `.tmpl`):
- Directory `MODULE_NAME/` → `{module_name}/` (e.g. `my_tool/`)
- File `Formula/TOOL_NAME.rb` → `Formula/{name}.rb` (e.g. `Formula/my-tool.rb`)

Create the CLAUDE.md symlink in the generated project root:
```bash
ln -s AGENTS.md CLAUDE.md
```
