---
name: humanize
description: remove AI writing patterns and make text sound natural and human
trigger: /humanize
---

# humanize skill

A skill that identifies and removes AI writing patterns to make text sound natural and human — based on Wikipedia's "Signs of AI writing" guide.

## task

When given text to humanize:

1. **identify AI patterns** — scan for the patterns listed below
2. **rewrite problematic sections** — replace AI-isms with natural alternatives
3. **preserve meaning** — keep the core message intact
4. **maintain voice** — match the intended tone (formal, casual, technical, etc.)
5. **add soul** — don't just remove bad patterns; inject actual personality
6. **do a final anti-AI pass** — ask yourself "what makes the below so obviously AI generated?", answer briefly with remaining tells, then revise

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

## content patterns

### 1. undue emphasis on significance, legacy, and broader trends

**words to watch:** stands/serves as, is a testament/reminder, a vital/significant/crucial/pivotal/key role/moment, underscores/highlights its importance, reflects broader, symbolizing its ongoing/enduring/lasting, contributing to the, setting the stage for, marks/shapes the, represents/marks a shift, key turning point, evolving landscape, focal point, indelible mark, deeply rooted

**before:**
> The Statistical Institute of Catalonia was officially established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain.

**after:**
> The Statistical Institute of Catalonia was established in 1989 to collect and publish regional statistics independently from Spain's national statistics office.

---

### 2. undue emphasis on notability and media coverage

**words to watch:** independent coverage, local/regional/national media outlets, written by a leading expert, active social media presence

**before:**
> Her views have been cited in The New York Times, BBC, Financial Times, and The Hindu. She maintains an active social media presence with over 500,000 followers.

**after:**
> In a 2024 New York Times interview, she argued that AI regulation should focus on outcomes rather than methods.

---

### 3. superficial analyses with -ing endings

**words to watch:** highlighting/underscoring/emphasizing, ensuring, reflecting/symbolizing, contributing to, cultivating/fostering, encompassing, showcasing

**before:**
> The temple's color palette resonates with the region's natural beauty, symbolizing Texas bluebonnets, the Gulf of Mexico, and the diverse Texan landscapes, reflecting the community's deep connection to the land.

**after:**
> The temple uses blue, green, and gold. The architect said these reference local bluebonnets and the Gulf coast.

---

### 4. promotional and advertisement-like language

**words to watch:** boasts a, vibrant, rich (figurative), profound, enhancing its, showcasing, exemplifies, commitment to, natural beauty, nestled, in the heart of, groundbreaking, renowned, breathtaking, must-visit, stunning

**before:**
> Nestled within the breathtaking region of Gonder in Ethiopia, Alamata Raya Kobo stands as a vibrant town with a rich cultural heritage and stunning natural beauty.

**after:**
> Alamata Raya Kobo is a town in the Gonder region of Ethiopia, known for its weekly market and 18th-century church.

---

### 5. vague attributions and weasel words

**words to watch:** Industry reports, Observers have cited, Experts argue, Some critics argue, several sources/publications

**before:**
> Experts believe it plays a crucial role in the regional ecosystem.

**after:**
> The Haolai River supports several endemic fish species, according to a 2019 survey by the Chinese Academy of Sciences.

---

### 6. outline-like "challenges and future prospects" sections

**words to watch:** Despite its... faces several challenges, Despite these challenges, Challenges and Legacy, Future Outlook

**before:**
> Despite its industrial prosperity, Korattur faces challenges typical of urban areas. Despite these challenges, with its strategic location and ongoing initiatives, Korattur continues to thrive.

**after:**
> Traffic congestion increased after 2015 when three new IT parks opened. The municipal corporation began a stormwater drainage project in 2022 to address recurring floods.

---

## language and grammar patterns

### 7. overused "AI vocabulary" words

**high-frequency AI words:** actually, additionally, align with, crucial, delve, emphasizing, enduring, enhance, fostering, garner, highlight (verb), interplay, intricate/intricacies, key (adjective), landscape (abstract noun), pivotal, showcase, tapestry (abstract noun), testament, underscore (verb), valuable, vibrant

**before:**
> Additionally, a distinctive feature of Somali cuisine is the incorporation of camel meat. An enduring testament to Italian colonial influence is the widespread adoption of pasta in the local culinary landscape, showcasing how these dishes have integrated into the traditional diet.

**after:**
> Somali cuisine also includes camel meat. Pasta dishes, introduced during Italian colonization, remain common, especially in the south.

---

### 8. avoidance of "is"/"are" (copula avoidance)

**words to watch:** serves as/stands as/marks/represents [a], boasts/features/offers [a]

**before:**
> Gallery 825 serves as LAAA's exhibition space. The gallery features four separate spaces and boasts over 3,000 square feet.

**after:**
> Gallery 825 is LAAA's exhibition space. The gallery has four rooms totaling 3,000 square feet.

---

### 9. negative parallelisms and tailing negations

**before:**
> It's not just about the beat riding under the vocals; it's part of the aggression and atmosphere. It's not merely a song, it's a statement.

**after:**
> The heavy beat adds to the aggressive tone.

**before (tailing negation):**
> The options come from the selected item, no guessing.

**after:**
> The options come from the selected item without forcing the user to guess.

---

### 10. rule of three overuse

**before:**
> The event features keynote sessions, panel discussions, and networking opportunities. Attendees can expect innovation, inspiration, and industry insights.

**after:**
> The event includes talks and panels, with time for informal networking between sessions.

---

### 11. elegant variation (synonym cycling)

**before:**
> The protagonist faces many challenges. The main character must overcome obstacles. The central figure eventually triumphs. The hero returns home.

**after:**
> The protagonist faces many challenges but eventually triumphs and returns home.

---

### 12. false ranges

**before:**
> Our journey through the universe has taken us from the singularity of the Big Bang to the grand cosmic web, from the birth and death of stars to the enigmatic dance of dark matter.

**after:**
> The book covers the Big Bang, star formation, and current theories about dark matter.

---

### 13. passive voice and subjectless fragments

**before:**
> No configuration file needed. The results are preserved automatically.

**after:**
> You do not need a configuration file. The system preserves the results automatically.

---

## style patterns

### 14. em dash overuse

**before:**
> The term is primarily promoted by Dutch institutions—not by the people themselves. You don't say "Netherlands, Europe" as an address—yet this mislabeling continues—even in official documents.

**after:**
> The term is primarily promoted by Dutch institutions, not by the people themselves. You don't say "Netherlands, Europe" as an address, yet this mislabeling continues in official documents.

---

### 15. overuse of boldface

**before:**
> It blends **OKRs (Objectives and Key Results)**, **KPIs (Key Performance Indicators)**, and visual strategy tools such as the **Business Model Canvas (BMC)**.

**after:**
> It blends OKRs, KPIs, and visual strategy tools like the Business Model Canvas.

---

### 16. inline-header vertical lists

**before:**
> - **User Experience:** The user experience has been significantly improved.
> - **Performance:** Performance has been enhanced through optimized algorithms.
> - **Security:** Security has been strengthened with end-to-end encryption.

**after:**
> The update improves the interface, speeds up load times through optimized algorithms, and adds end-to-end encryption.

---

### 17. title case in headings

**before:**
> ## Strategic Negotiations And Global Partnerships

**after:**
> ## Strategic negotiations and global partnerships

---

### 18. emojis in structure

**before:**
> 🚀 **Launch Phase:** The product launches in Q3
> 💡 **Key Insight:** Users prefer simplicity

**after:**
> The product launches in Q3. User research showed a preference for simplicity.

---

### 19. curly quotation marks

Replace curly/smart quotes ("...") with straight quotes ("...").

---

## communication patterns

### 20. collaborative communication artifacts

**words to watch:** I hope this helps, Of course!, Certainly!, You're absolutely right!, Would you like..., let me know, here is a...

**before:**
> Here is an overview of the French Revolution. I hope this helps! Let me know if you'd like me to expand on any section.

**after:**
> The French Revolution began in 1789 when financial crisis and food shortages led to widespread unrest.

---

### 21. knowledge-cutoff disclaimers

**words to watch:** as of [date], Up to my last training update, While specific details are limited/scarce..., based on available information...

**before:**
> While specific details about the company's founding are not extensively documented in readily available sources, it appears to have been founded in the 1990s.

**after:**
> The company was founded in 1994, according to its registration documents.

---

### 22. sycophantic/servile tone

**before:**
> Great question! You're absolutely right that this is a complex topic. That's an excellent point about the economic factors.

**after:**
> The economic factors you mentioned are relevant here.

---

## filler and hedging

### 23. filler phrases

| before | after |
|--------|-------|
| "In order to achieve this goal" | "To achieve this" |
| "Due to the fact that it was raining" | "Because it was raining" |
| "At this point in time" | "Now" |
| "In the event that you need help" | "If you need help" |
| "The system has the ability to process" | "The system can process" |
| "It is important to note that the data shows" | "The data shows" |

---

### 24. excessive hedging

**before:**
> It could potentially possibly be argued that the policy might have some effect on outcomes.

**after:**
> The policy may affect outcomes.

---

### 25. generic positive conclusions

**before:**
> The future looks bright for the company. Exciting times lie ahead as they continue their journey toward excellence.

**after:**
> The company plans to open two more locations next year.

---

### 26. hyphenated word pair overuse

**words to watch:** third-party, cross-functional, client-facing, data-driven, decision-making, well-known, high-quality, real-time, long-term, end-to-end

**before:**
> The cross-functional team delivered a high-quality, data-driven report on our client-facing tools. Their decision-making process was well-known for being thorough.

**after:**
> The cross functional team delivered a high quality, data driven report on our client facing tools. Their decision making process was known for being thorough.

---

### 27. persuasive authority tropes

**phrases to watch:** The real question is, at its core, in reality, what really matters, fundamentally, the deeper issue, the heart of the matter

**before:**
> The real question is whether teams can adapt. At its core, what really matters is organizational readiness.

**after:**
> The question is whether teams can adapt. That mostly depends on whether the organization is ready to change its habits.

---

### 28. signposting and announcements

**phrases to watch:** Let's dive in, let's explore, let's break this down, here's what you need to know, now let's look at, without further ado

**before:**
> Let's dive into how caching works in Next.js. Here's what you need to know.

**after:**
> Next.js caches data at multiple layers, including request memoization, the data cache, and the router cache.

---

### 29. fragmented headers

**before:**
> ## Performance
>
> Speed matters.
>
> When users hit a slow page, they leave.

**after:**
> ## Performance
>
> When users hit a slow page, they leave.

---

## process

1. read the input text carefully
2. identify all instances of the patterns above
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

## credits

Based on [blader/humanizer](https://github.com/blader/humanizer) by [@blader](https://github.com/blader), which in turn draws from Wikipedia's [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide. The pattern catalog, before/after examples, and two-pass process are adapted from that work.
