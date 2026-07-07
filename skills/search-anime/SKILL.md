---
name: search-anime
description: Searches anime and manga by natural-language query using the ani CLI and AniList, supporting trending, popular, top, search, info, hidden gems, and binge modes. Use when the user wants to find anime or manga, explore trending titles, or get information about a specific series.
---

# search-anime skill

Search anime and manga by natural-language query using the ani CLI and AniList.

## features

- **natural language search** — type what you want, it figures out the `ani` command
- **trending** — what's trending in anime or manga right now
- **streaming links** — `info` shows Crunchyroll, HIDIVE, and other links from AniList
- **recommendations** — what AniList users recommend next to any title
- **hidden gems** — titles with high scores but low view counts
- **season preview** — what's airing this season and what's coming up
- **similarity search** — "like Attack on Titan" searches by that show's genres
- **manga** — works for manga too, just add `--manga`

## usage

```
/search-anime                                # default: trending digest (anime + manga)
/search-anime trending                       # currently trending anime
/search-anime trending --manga               # currently trending manga
/search-anime popular                        # popular this season
/search-anime popular --season winter --year 2024
/search-anime upcoming                       # season preview: upcoming + current popular
/search-anime top                            # top-rated of all time
/search-anime all-time                       # most-watched of all time
/search-anime search <natural query>         # smart NL search
/search-anime info <title or AniList id>     # full detail card with streaming links
/search-anime digest                         # full weekly briefing
/search-anime gems                           # hidden gems: high score, lower popularity
/search-anime gems --manga                   # hidden gem manga
/search-anime binge                          # completed series worth binging (24+ eps)
```

**natural search examples**

```
/search-anime search action anime from 2023 with score above 85
/search-anime search something like attack on titan
/search-anime search dark psychological thriller finished
/search-anime search slice of life romance with high ratings
/search-anime search isekai comedy
/search-anime search mecha sci-fi from the 90s
```

## workflow

### 0. prerequisite check

Before any command, verify `ani` is installed:
```bash
which ani
```
If not found, stop and tell the user:
> `ani` is not installed. Install it from https://github.com/pavelsimo/ani — `go install github.com/pavelsimo/ani@latest` or grab a release binary.

### 1. mode detection

Parse the first argument:

| Argument | Mode |
|---|---|
| (none) or `digest` | digest |
| `trending` | trending |
| `popular` | popular |
| `upcoming` | preview |
| `top` | top |
| `all-time` | all-time |
| `search <query>` | search |
| `info <name-or-id>` | info |
| `gems` | gems |
| `binge` | binge |

`--manga` flag anywhere → append `--type manga` to all `ani` calls for that invocation. `--lang english` → append `--lang english` to all calls. Derive the current season from today's month: Jan–Mar = winter, Apr–Jun = spring, Jul–Sep = summer, Oct–Dec = fall.


### 2. execute selected mode

After detecting the mode, read [reference/output-modes.md](reference/output-modes.md) for the exact `ani` commands, JSON parsing rules, output templates, and error handling for that mode. Read [reference/reference-tables.md](reference/reference-tables.md) when mapping natural-language genres, formats, or score displays.

## best practices

- **always use `--json`** — never parse the human-readable table output
- **always show interpreted filters** after NL search so the user can correct them
- **deduplicate by `id`** in digest and preview modes — never show the same title twice
- **cap per-page at 50** — that is the AniList API maximum
- **convert seconds to human time** — `timeUntilAiring` is in seconds; always display as "Xd Yh"
- **derive the current season dynamically** from today's month; never hardcode it
- **null-guard recommendations** — `mediaRecommendation` can be null if the entry was deleted; skip silently
- **streaming links are detail-only** — `externalLinks` only comes from `ani info`, not from list commands; surface a tip in list modes to run `/search-anime info <title>` for streaming links
