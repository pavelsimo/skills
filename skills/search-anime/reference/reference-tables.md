# search reference tables

## genre reference

Genre names must be passed to `--genre` in exact Title Case:

| Genre | Common pairings | Natural language aliases |
|-------|----------------|------------------------|
| Action | Adventure, Fantasy, Sci-Fi | "shonen", "fight", "battle" |
| Adventure | Fantasy, Action | "quest", "journey" |
| Comedy | Slice of Life, Romance | "funny", "humor", "lighthearted" |
| Drama | Psychological, Romance | "emotional", "tearjerker" |
| Ecchi | Comedy, Romance | — |
| Fantasy | Adventure, Action, Drama | "magic", "isekai" (also use as search term) |
| Horror | Psychological, Thriller, Supernatural | "scary", "creepy" |
| Mahou Shoujo | Fantasy, Comedy | "magical girl" |
| Mecha | Sci-Fi, Action, Drama | "robot", "mech" |
| Music | Slice of Life, Drama | "idol", "band" |
| Mystery | Psychological, Thriller, Drama | "detective", "whodunit" |
| Psychological | Mystery, Thriller, Drama, Horror | "mind game", "dark", "disturbing" |
| Romance | Comedy, Drama, Slice of Life | "love story", "romcom" |
| Sci-Fi | Action, Mecha, Drama | "space", "futuristic", "space opera" |
| Slice of Life | Comedy, Drama, Romance | "moe", "calm", "everyday" |
| Sports | Drama, Comedy | "competition" |
| Supernatural | Fantasy, Action, Horror | "ghost", "demon", "spirit" |
| Thriller | Psychological, Mystery, Horror | "suspense", "tension" |

## format reference

| Value | Meaning |
|---|---|
| `tv` | Seasonal television series |
| `movie` | Feature film |
| `ova` | Original Video Animation (direct-to-video) |
| `ona` | Original Net Animation (streaming-first) |
| `special` | Short or bonus episode |

Pass to `ani search --format <value>` always lowercase.

## score display guide

| Range | Emoji | Label |
|---|---|---|
| 90–100 | 🔥 | Exceptional |
| 80–89 | ⭐ | Great |
| 70–79 | 👍 | Good |
| 60–69 | 📊 | Average |
| 0–59 | *(number only)* | Below average |
| 0 (unscored) | `—` | No score yet |
