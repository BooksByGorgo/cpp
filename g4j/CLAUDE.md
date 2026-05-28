# Project Description

Gorgo Go for Java for programmers.
This book covers all the topics that a good Go programmer uses in daily life in industry from the perspective of a Java programmer.

## Chapters

- DO NOT MODIFY THE AUTHOR INTRO section
- each numbered element in `Content` represents a chapter
- do not spend a lot of time on concepts that are the same between Java and Go --- just mention the concept is the same and move on
- each chapter starts with an introducton to the topics covered. motivation for the topics highlighting things that are hard to do without knowledge of the topics, and a brief overview of the section
- each chapter ends with a brief highlight of key points
- each chapter has some exercises to test reader's comprehesion. there should be a mix of the following types of questions:
    - though provoking questions to make them think a little deeper about what they have read
    - what does this do type questions, where they get a snippet of code and predict what it will do
    - calculation questions to quickly and objectively test comprehension, like `what is the sizeof ilist for int ilist[4] on a system where int is 32-bit?`
    - where is the bug type questions, where you show some code and ask what the problem is
    - propose a short test program they should write to test their knowledge
- an answer key should be generated as a separate document from the main chapter content, containing each exercise question and its answer

## Examples

- for strings, use 2020s references, lyrics from 2020s songs, and Spanish occasionally. Keep it short.
- cover up to Go 1.26
- avoid repeating lyrics in examples even across chapters
- Validate examples to make sure syntax and result is correct
- Create short example programs to illustrate the concepts covered

## Format and Style

- Use Pandoc markdown
- Use correct grammar and capitalizations
- All callouts use `::: {.tip}` as the div class --- `callout.lua` only handles `.tip`
- Differentiate callout types with a bold label on the first line inside the div:
    - `**Tip:**` for idioms and best practices
    - `**Trap:**` for common mistakes
    - `**Wut:**` for unexpected or counterintuitive rules
- Callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` --- do not use `wrapfigure`
- Keep the tone professional but light
- Preserve emojis and text emojis (e.g., `:'(`) in the text --- do not remove them
- Refer to the reader as `you`
- do not wrap sentences in the markdown. every sentence gets its own line
- the first time a fuction or operator is mentioned show it's signature
    -if it is overloaded and the overloaded variants aren't mentioned later, mention at the end of the subsection concisely. show signatures but not examples
- when listing methods or functions in a signature block, add a short inline comment to each line explaining what it does

## Build

- Build with: `make` (or `make all` for both PDFs)
- Uses `pandoc` with `--lua-filter=callout.lua` and `--pdf-engine=latexmk --pdf-engine-opt=-lualatex`
- `latexmk` handles the multi-pass build needed for the index
- Requires `header-includes` for `\usepackage[most]{tcolorbox}` and `\usepackage{makeidx}` (already in frontmatter)

## Table of Contents and Index

- TOC is generated automatically via `toc: true` and `toc-depth: 2` in the YAML frontmatter
- index uses LaTeX `makeidx` package with `\index{}` markers throughout the text
- place `\index{term}` at the primary introduction/definition of a term, not inside code blocks
- use `\index{parent!child}` for sub-entries (e.g., `\index{pointer!arithmetic}`)
- in `\index{}`, escape double quotes by doubling them (e.g., `\index{extern ""C""}`)
- `\printindex` goes only in appB.md (the last file built into the book) --- do not add it to other chapters or appendices

## 2020s References

- PLAYLIST.md tracks all songs and references used in the text, organized by chapter
- do not repeat references already listed in PLAYLIST.md
- when adding or changing a reference in the text, update PLAYLIST.md to match
- avoid references to guns (including ammunition) and violence

## Cross-References Between Chapters

- when a concept is introduced in one chapter and used in a later chapter, reference the earlier chapter rather than re-explaining it

## Content

DO NOT MODIFY THE AUTHOR INTRO section before chapter 0. it is written in lowercase to match the author's informal writing

0. How to use this book:
    - conventions explained
    - chapter layout

