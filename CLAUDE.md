# project description

a collection of programming texts --- focused on C++ for the moment --- suitable for introductory programming classes

## chapters

- DO NOT MODIFY THE AUTHOR INTRO section
- each markdown file starting with `ch` or `app` represents a chapter
- the chapter should start with a chapter title. the chapters are numbered automatically when formatted into a single PDF or into webpages
- each chapter starts with an introducton to the topics covered. motivation for the topics highlighting things that are hard to do without know    ledge of the topics, and a brief overview of the section
- each chapter ends with a brief highlight of key points
- each chapter has some exercises to test reader's comprehesion of the topics covered. there should be a mix of the following types of questions:
    - though provoking questions to make them think a little deeper about what they have read
    - what does this do type questions, where they get a snippet of code and predict what it will do
    - calculation questions to quickly and objectively test comprehension, like `what is the sizeof ilist for int ilist[4] on a system where int is 32-bit?`
    - where is the bug type questions, where you show some code and ask what the problem is
    - propose a short test program they should write to test their knowledge
- every chapter has Try It, Key Points, and Exercises; answer key has a heading per chapter and restates every exercise question (including code snippets) before its answer
- an answer key should be generated as a separate document from the main chapter content, containing each exercise question and its answer

## format and style

- use pandoc markdown
- do not use emdash or endash, use --- or -- instead
- use correct grammar and capitalizations
- use tip callouts (`::: {.tip}` divs) to highlight idioms, best practices, or warn of bad practices
    - `Tip` for highlight idioms, best practices
    - `Trap` for common mistakes
    - `Wut` unexpected or counterintuitive rules
- callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` --- do not use `wrapfigure`
- keep the tone professional but light
- preserve emojis and text emojis (e.g., `:'(`) in the text --- do not remove them
- refer to the reader as `you`
- do not wrap sentences in the markdown. every sentence gets its own line

## code examples

- opening `{` of a function goes on the same line as the function head (K&R style), including constructors with initializer lists and `requires`-constrained templates
- this applies to all code examples across books, answer keys, and lecture notes --- the only exceptions are intentional bug demos and scope-limiting blocks (e.g. RAII lock guards)
- when a run of consecutive code lines each end in a trailing `//` comment, align the `//` markers to a common column so the comments line up visually

## extra content

- operators
- c4c++ (C for C++ programmers)

## implementing github issues

when committing a change based on an issue (or set of issues)

- the issue reporter is the author of the change
- list everyone else who contributed to the issues and text developement as coauthors
- `gh issue view N` currently fails on this repo with a "Projects (classic) is being deprecated" GraphQL error --- use `gh api repos/BooksByGorgo/cpp/issues/N --jq '...'` to read issue details instead
- end the commit message body with `Closes #N` so merging the PR closes the issue

## validating chapters

- fix any grammar or spelling errors
- check for awkward phrasing
- check any code examples for errors
- check that everything is explained accurately
- are there any missing concepts that should be covered?
- does the chapter have all the required elements
- does each chapter have exercises with a mix of:
    - thought provoking questions
    - what does this do type questions with code snippets
    - calculation questions
    - where is the bug type questions with code snippets
    - propose a short test program they should write
- formatting checks (build the PDF and inspect it):
    - tables render correctly: all columns visible, no missing borders, header row distinct
    - no content overflows the page margins (long lines in code blocks, wide tables, long URLs)
    - code blocks are not split across pages in a way that breaks readability
    - callout boxes (tcolorbox) render as full-width blocks with no text spilling outside
    - no stray LaTeX artifacts: missing characters, undefined references, overfull hbox warnings

## verify the book

### mechanical checks (script these; do not delegate to agents)

- every `::: {.tip}` fence must be preceded by a blank line --- a non-blank line above it (even `\index{}`) makes the callout render as literal `::: {.tip}` text in the PDF 
- every callout body starts with `**Tip:**`, `**Trap:**`, or `**Wut:**`; fence opens equal fence closes per file
- code-block lines must be at most 96 chars, and at most 80 inside callouts --- longer lines clip at the page edge and verbatim produces NO overfull warning, so the LaTeX log will not catch this
- no unicode em/en dashes outside code blocks; no `\index{}` inside code blocks
- every ch*.md/app*.md is in CHAPTERS; cross-reference audit via `grep -rn "Chapter [0-9]"`

### PDF checks (the make build discards the LaTeX log)

- to get a log, pandoc the book to .tex in a temp dir and run latexmk there; ignore the `../images` not-found errors (path artifact) and look for Overfull hbox of 20pt+, "undefined", and "missing character"
- pdftotext the built PDF and grep for leftover markup: `:::`, `{.tip}`, `\index{`, `[@`, `??` --- then visually read any suspect page
- visually read every page containing a table (column overlap does not show up in any log or text scan)
- check that text is not going into the margin

### content checks (read-only finder agents, one per chapter)

- extract and actually compile and run every code example in /tmp (for C++: `g++ -std=c++23 -Wall -Wextra -pedantic`); claimed outputs in comments and prose must match observed output; intentional bug demos must fail with the diagnostic the text describes
- verify every "since C++XX" claim, header name, function signature, CLI flag, and tool name against the current toolchain --- several were stale or wrong on first audit
- check PLAYLIST.md in both directions: every reference in the text is listed under the right chapter, and every listed entry still exists in the text
- have agents return structured findings with severity (error/warning/suggestion) and verify each claim yourself before editing --- agents produce occasional false positives (e.g. flagging the intentional `***[rule-name]***` convention as an artifact)
- when an exercise is reworded, grep answer key for the old wording and change both files in the same edit pass
- fix-up agents get exactly one file each and must not run git commands; review the full diff before committing
- validate chapters
- clean up index. check that key terms are in the index. a term may have multiple page numbers if a term is discussed indepth in multiple parts

# making changes

- whenever you finish making changes automatically commit to git
- if there are changes that haven't been pushed, amend the commit to the latest local only commit

## pr and merge workflow

- the repo on github allows rebase merges only --- no merge commits and no squash merges
- to turn a local commit on main into a merged pr:
    1. `git branch <feature-branch>` to preserve the commit
    2. `git reset --hard origin/main` to move main back to its pushed tip
    3. `git push -u origin <feature-branch>`
    4. `gh pr create --base main --head <feature-branch> --title ... --body ...`
    5. `gh pr merge <pr#> --rebase --delete-branch`
    6. `git fetch origin && git pull --ff-only origin main`
- only run this workflow when the user asks for a pr; just committing to main locally is the default

