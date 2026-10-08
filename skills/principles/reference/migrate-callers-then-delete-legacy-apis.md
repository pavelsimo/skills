# migrate-callers-then-delete-legacy-apis

**Phase:** changing code

## rule

When you replace an **internal** API, move every caller to the new one and delete the old one in the same change. Don't leave a compatibility shim "for now". **Public** APIs, used by code you don't control, keep backward compatibility and follow a deprecation path.

## when it applies

- renaming or reshaping a function, class, module, or internal endpoint
- introducing a "v2" of something that only this codebase uses
- reviewing a change that adds an adapter from the old shape to the new one

## example

`fetch_user(id)` becomes `users.get(id)`. The same change updates all 14 call sites found with `rg 'fetch_user\('` and deletes `fetch_user`. The search returning nothing is the check.

## usual violation

Both APIs living side by side for months, new code accidentally using the old one, and the shim becoming permanent.
