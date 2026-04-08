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

1. **Strip timing metadata** — `(10 min)` annotations are removed
2. **Section headings become slides** — each `##` section becomes one or more `---`-delimited slides
3. **Expand content significantly**:
   - Brief bullets become full working code examples
   - Add multiple-choice quiz questions ("What is printed?" format, 5 choices)
   - Include a humorous wrong answer option ("Ben got this wrong")
4. **Use two-column layouts** — code on left (`.lc`), answer choices on right (`.rc`)

## HTML Template Conventions

- Font: Crimson Text (serif)
- Aspect ratio: `remark.create({ ratio: '16:9' })`
- Quiz answers use upper-alpha ordered lists (`ol { list-style-type: upper-alpha; }`)
- Minimal padding: `padding: 0.25em 0.5em` and `h1 { margin-top: 0; margin-bottom: 0.2em; }`
- Two-column classes: `.lc` (left, 40% width) and `.rc` (right, 50% width)
- Load remark from: `https://remarkjs.com/downloads/remark-latest.min.js`

## Multiple choice questions

- Multiple choice questions have 5 choices
- Start each lecture with a multiple choice review question from the previous lecture
- At the end of the lecture add 2 or 3 multiple choice questions about the lecture

