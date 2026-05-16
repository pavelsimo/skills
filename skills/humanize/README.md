# humanize skill

A skill for agents that strips AI writing patterns from text and makes it sound natural and human — based on Wikipedia's "Signs of AI writing" guide.

## Usage

```
/humanize                          # humanize text in the current context
/humanize --sample <file>          # match voice from a writing sample file
```

Inline voice sample:

```
/humanize Here's a sample of my writing for voice matching: [your text]
Then humanize this: [text to humanize]
```

The assistant scans for 29 AI patterns, rewrites the text, then does a second-pass audit to catch anything that slipped through.

## What it fixes

**Content issues** — significance inflation, promotional language, vague "experts say" attributions, formulaic challenges sections, and superficial -ing constructions that fake depth.

**Language patterns** — overused AI vocabulary (testament, pivotal, delve, landscape), copula avoidance (serves as / boasts / features), synonym cycling, rule-of-three padding, false ranges, and passive-voice fragments.

**Style issues** — em dash clusters, unnecessary boldface, inline-header lists, title case headings, emojis in structure, and curly quotation marks.

**Communication artifacts** — chatbot sign-offs (I hope this helps!), knowledge-cutoff disclaimers, sycophantic openers, and signposting (Let's dive in...).

**Filler and hedging** — excessive qualifiers, generic upbeat conclusions, hyphenated word pair overuse, authority tropes (the real question is / at its core), and fragmented headers.

## Voice calibration

Provide a sample of your own writing to get a rewrite that matches your style rather than generic "clean" prose:

```
/humanize --sample ~/my-blog-post.md
```

The assistant reads the sample, notes your sentence length, word choice, punctuation habits, and transition style, then applies those patterns instead of a one-size-fits-all voice.

## Installation

```bash
npx skills@latest add pavelsimo/humanize
```

## Attribution

Based on [blader/humanizer](https://github.com/blader/humanizer) by [@blader](https://github.com/blader), which draws from Wikipedia's [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide. The pattern catalog, before/after examples, and two-pass rewriting process are adapted from that work.

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
