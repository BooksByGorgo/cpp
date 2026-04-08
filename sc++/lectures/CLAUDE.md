# Content Description

- lecture outlines in markdown format
- lectures are assumed to be 75 minutes
- lecture notes are named lectureX.md for lecture X or lectureX+Y.md for lecture X and Y
- lecture slides are in a directory named lectureX for lecture X in that directory is lectureX.html with any support files also in that directory
- slides use remark.js. Hand-crafted HTML presentations built from lecture note outlines.

# Lecture source material

- Lectures are based on the chapters and the corresponding exercises at the end of the chapters in `..`

# Lecture to chapter mapping

- lecture 1: chapter 1
- lecture 2: chapter 2
- lecture 3: chapter 3
- lecture 4: chapter 4
- lecture 5+6: chapter 5
- lecture 7+8: chapter 6
- lecture 9+10: chapter 7
- lecture 11+12: chapter 8
- lecture 13: chapter 9
- lecture 14: chapter 10
- lecture 15: chapter 11
- lecture 16+17: chapter 12
- lecture 18+19: chapter 13
- lecture 20: chapter 14

# Slide Creation Process

Slides are manually created from lecture notes — there is no build script or automation.

## Output: Slides (`*.html`)

- Remark.js presentations with markdown inside `<textarea id="source">`
- Slides separated by `---`
- Make sure that everything fits on the slide. you may need to use a two column layout
- After creating or editing slides, open the HTML file in a browser to visually verify that all content fits on each slide. do not rely on estimating content length from the source alone.

## Transformation Rules

1. **Strip timing metadata** --- `(10 min)` annotations are removed
2. **Section headings become slides** --- each `##` section becomes one or more `---`-delimited slides
3. **Keep content terse** --- one idea per slide, short bullets, no long paragraphs. Code is the main content; prose is a short bulleted gloss
4. **Add multiple-choice quiz questions** --- `What is printed?` / `Where is the bug?` format, 5 choices, last choice is `Ben got this wrong`
5. **Use two-column layouts** --- code on the left (`.lc`), bullets or answer choices on the right (`.rc`)

## HTML Template Conventions

Use `sc++/lectures/lecture1/lecture1.html` as the canonical template. The structure is intentionally minimal --- a `<head><style>` block, the remark.js `<script>` include, a `<textarea id="source">` with the slides, and a final `<script>` that calls `remark.create({ ratio: '16:9' })`. No `<html>` or `<body>` wrapping.

- Font stack: `'Crimson Text', Georgia, serif`
- Body font size: `64px`; `.remark-slide-content` font size: `32px`
- Aspect ratio: `remark.create({ ratio: '16:9' })`
- Quiz answers use upper-alpha ordered lists: `ol { list-style-type: upper-alpha; }`
- Minimal padding: `padding: 0.25em 0.5em` and `h1 { margin-top: 0; margin-bottom: 0.2em; }`
- Two-column classes: `.lc` (left, 50% width, floated left) and `.rc` (right, 45% width, floated right)
- White background, default text color --- no custom title slide, no callout boxes, no background images
- Title slide uses `class: center, middle` (built-in remark classes), not a custom class
- Load remark from: `https://remarkjs.com/downloads/remark-latest.min.js`

## Slide Content Conventions

- Title slide: `# CMPE 30: Lecture N` followed by the lecture topic on the next line
- Quiz slide titles are the question itself (`# What is printed?`, `# Where is the bug?`) --- no `Q1`/`Q2` numbering
- Tips and traps are inline prose (`**Trap:** ...`) --- do not use custom callout divs
- Code blocks are plain fenced blocks --- no line-number prefixes unless the question needs line references
- Prefer `\n` in example code over `std::endl` to keep lines short

## Multiple choice questions

- Multiple choice questions have 5 choices
- The final choice is always a humorous wrong answer: `Ben got this wrong`
- Start each lecture with a multiple choice review question from the previous lecture (skip for lecture 1)
- At the end of the lecture add 2 or 3 multiple choice questions about the lecture
- One question per slide --- do not batch multiple questions onto the same slide

## Last slide

The last slide of each lecture assigns the reading and exercises for the **next** lecture (not the current one), so students come prepared. Use the lecture-to-chapter mapping above to find the next chapter, then reference its exercises:

```
**Read:** chapter N of *Starting C++*. **Do:** exercises 1-M.
```

where `N` is the chapter covered by the next lecture and `M` is the last exercise number in that chapter.

