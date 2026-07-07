# adding new templates

To add a new language template (e.g., Python/Django):

1. Create `templates/<language>/` with the same top-level structure as `templates/ruby/`
2. Add the new option to step 1's template field
3. Add the new template's derived values to step 1 (Derived section)
4. Add a scaffold branch for the new template in step 3
5. Update the template variable reference table with any new placeholders
6. Add the new template row to `README.md`
