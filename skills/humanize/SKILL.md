---
name: humanize
description: Removes 29 AI writing patterns and rewrites text to sound natural and human, with optional voice calibration from a writing sample. Use when the user has text that sounds AI-generated and wants it rewritten with a natural, human voice.
---

# humanize skill

A skill that identifies and removes AI writing patterns to make text sound natural and human — based on Wikipedia's "Signs of AI writing" guide.

## features

- identifies and removes 29 common AI writing patterns
- rewrites text while preserving meaning and intended tone
- supports optional voice calibration from a writing sample
- adds concrete voice, rhythm, and specificity instead of sterile neutrality
- runs a final anti-AI audit before presenting the final version

## usage

```
/humanize                          # humanize text in the current context
/humanize --sample <file>          # match voice from a writing sample file
```

Inline voice sample:
```
/humanize Here's a sample of my writing for voice matching: [your sample]
Then humanize this: [text to humanize]
```

## voice calibration (optional)

If the user provides a writing sample, analyze it before rewriting:

1. **read the sample first** — note:
   - sentence length patterns (short and punchy? long and flowing? mixed?)
   - word choice level (casual? academic? somewhere between?)
   - how they start paragraphs (jump right in? set context first?)
   - punctuation habits (lots of dashes? parenthetical asides? semicolons?)
   - any recurring phrases or verbal tics
   - how they handle transitions (explicit connectors? just start the next point?)

2. **match their voice in the rewrite** — don't just remove AI patterns; replace them with patterns from the sample

3. **when no sample is provided**, fall back to natural, varied, opinionated voice (see personality section below)

## personality and soul

Avoiding AI patterns is only half the job. Sterile, voiceless writing is just as obvious as slop.

**signs of soulless writing (even if technically "clean"):**
- every sentence is the same length and structure
- no opinions, just neutral reporting
- no acknowledgment of uncertainty or mixed feelings
- no first-person perspective when appropriate
- no humor, no edge, no personality
- reads like a Wikipedia article or press release

**how to add voice:**

- have opinions — don't just report facts; react to them
- vary your rhythm — short punchy sentences, then longer ones that take their time
- acknowledge complexity — "this is impressive but also kind of unsettling" beats "this is impressive"
- use "I" when it fits — "I keep coming back to..." signals a real person thinking
- let some mess in — tangents, asides, and half-formed thoughts are human
- be specific about feelings — not "this is concerning" but name the actual discomfort



## workflow

1. read the input text carefully
2. identify all instances of the patterns in [reference/patterns.md](reference/patterns.md)
3. rewrite each problematic section
4. ensure the revised text:
   - sounds natural when read aloud
   - varies sentence structure naturally
   - uses specific details over vague claims
   - maintains appropriate tone for context
   - uses simple constructions (is/are/has) where appropriate
5. present a draft humanized version
6. ask: "what makes the below so obviously AI generated?"
7. answer briefly with remaining tells (if any)
8. ask: "now make it not obviously AI generated."
9. present the final version


## output format

provide:
1. draft rewrite
2. brief audit bullets ("what makes this AI generated?")
3. final rewrite
4. optional: brief summary of the main changes made

---

## best practices

- **preserve meaning first** — remove AI tells without changing the user's argument or factual claims
- **match the target voice** — use the sample when provided; otherwise choose a natural, specific, opinionated voice
- **prefer concrete detail** — replace vague significance language with verifiable facts or clear claims
- **vary sentence rhythm** — mix short and longer sentences so the rewrite sounds spoken by a person
- **audit the draft** — always do the final "what still sounds AI-generated?" pass before the final rewrite

## credits

Based on [blader/humanizer](https://github.com/blader/humanizer) by [@blader](https://github.com/blader), which in turn draws from Wikipedia's [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide. The pattern catalog, before/after examples, and two-pass process are adapted from that work.
