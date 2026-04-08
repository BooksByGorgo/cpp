# Project Description

Starting C++ book for programming just starting C++ entitled `Starting C++`
No previous programming experience is assumed.

## Chapters

- These rules do not apply to chapter 0 or the author intro
- DO NOT MODIFY THE AUTHOR INTRO section
- each numbered element in `Content` represents a chapter
- each chapter starts with a brief overview
- each chapter ends with a brief highlight of key points
- each chapter has some exercises to test reader's comprehesion. there should be a mix of the following types of questions:
    - though provoking questions to make them think a little deeper about what they have read
    - what does this do type questions, where they get a snippet of code and predict what it will do
    - calculation questions to quickly and objectively test comprehension, like `what is the sizeof ilist for int ilist[4] on a system where int is 32-bit?`
    - where is the bug type questions, where you show some code and ask what the problem is
    - propose a short test program they should write to test their knowledge
- an answer key should be generated as a separate document from the main chapter content, containing each exercise question and its answer

## Examples

- For strings, use 90s references, lyrics from 90s songs, and Spanish occasionally. Keep it short.
- avoid repeating lyrics in examples even across chapters
- Validate examples to make sure syntax and result is correct
- Compile examples with `g++ -std=c++23 -Wall -Wextra -pedantic` to verify correctness
- Always include the headers needed by every example (e.g., `#include <string>` when using `std::string`)
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

## Build

- Build with: `make` (or `make all` for both PDFs)
- Uses `pandoc` with `--lua-filter=callout.lua` and `--pdf-engine=latexmk`
- `latexmk` handles the multi-pass build needed for the index
- Requires `header-includes` for `\usepackage[most]{tcolorbox}` and `\usepackage{makeidx}` (already in frontmatter)

## Table of Contents and Index

- TOC is generated automatically via `toc: true` and `toc-depth: 2` in the YAML frontmatter
- index uses LaTeX `makeidx` package with `\index{}` markers throughout the text
- place `\index{term}` at the primary introduction/definition of a term, not inside code blocks
- use `\index{parent!child}` for sub-entries (e.g., `\index{pointer!arithmetic}`)
- in `\index{}`, escape double quotes by doubling them (e.g., `\index{extern ""C""}`)
- `\printindex` goes only in ch15.md (the last chapter) --- do not add it to other chapters

## 90s References

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
1. Introduction:
    - Lets look at the classic `Hello World!` program
    - Explain how to compile and run it
    - Introduce the idea of namespaces
    - Intro to input and output using std::cin and std::cout
    - command-line arguments: `Hello ` argv[1] and USAGE messages
2. Variables
    - basic types: char, int, float, ...
    - variables give a name to memory allocated to store the declared type
    - we can use [] to declare arrays of types
        - tricks to using multi dimensional arrays
        - the Pointers chapter will talk about the relationship between arrays and pointers
        - the "value" of an array is the address of the first element
    - const is used to mark a variable as unchanging.
        - const is a bit tricky to use with *, depending where the const is it prevents the pointer from changing or it prevents what the pointer is pointing to from being changed through the pointer
    - structures allow data to be grouped together
        - members accessed with . operator
        - assignment does a copy
3. Strings
    - std::string
    - Introduce common string operations
4. Expressions
    - assignment operators
    - math operators
    - logical operators
    - bit operators
    - compound assignment operators
    - ternary operator
    - operator precedence
5. Control flow
    - if statements
    - while loop/do while
        - break/continue
    - for loops
    - switch statements
6. Functions
    - declarations vs definitions, forward declarations, void parameter lists
    - pass-by-value and pass-by-reference
    - const parameters. why they are important
    - structures can be problematic to pass by value
    - recursive functions
    - function pointers (basics, typedef, callbacks)
7. Numbers
    - bases: decimal, binary, hex, octal
    - integer literals in other bases (`0b`, `0x`, `0`) and digit separators
    - printing in other bases with `std::format` / `std::println`
    - strings to/from numbers (`std::stoi`, `std::stod`, `std::to_string`)
    - two's complement
    - integer sizes, ranges, signed vs unsigned, overflow
    - binary addition and subtraction
    - shift operators (`<<`, `>>`)
8. Containers
    - std::array
    - std::vector
    - iterating through containers
9. I/O streams
    - string streams
    - file streams
10. std::format and std::print
    - formatted I/O with std::format and std::print
    - Header: `#include <format>` or `#include <print>`
    - Implicit: `std::format("{},{}", 1, "hi")` -> `1,hi`
    - Indexed: `std::format("{1},{0}", 1, "hi")` -> `hi,1`
    - YOU CANNOT MIX IMPLICIT AND INDEXED!
        - `std::format("{},{1}", 1, "hi")` ->❌
    - `{arg-identifier:format-spec}`
    - `format-spec` after the `:` in a format string: `{:.2}` or `{1:.2}`
        - `[[fill]align][sign][#][0][width][.prec][type]`
        - `fill`: any character (default: space) except {}
        - `align`: `<` (left), `>` (right), `^` (center)
        - `sign`: `+` (on all #s), `-` (only neg), or space (for positive #s) 
        - `#`: alternate form (e.g., 0x for hex)
        - `0`: zero-padding (implies right align)
        - `width`: minimum field width
        - `prec`: fixed floats: # of digits after . else precision; strings: max len 
        - `type`: `d` (decimal), `x` (hex), `f` (fixed-point), `s` (string), `p` pointer, etc.
11. Exceptions
    - try/catch/throw
    - standard exception types (std::exception, std::runtime_error, std::logic_error)
    - throwing and catching exceptions
    - stack unwinding
    - noexcept
    - std::expected (C++23) as an alternative to exceptions
    - when to use exceptions vs std::expected
12. Classes
    - constructors/destructors
    - member methods
13. Memory Management
    - new/delete
    - don't use new/delete use std::unique_ptr
    - std::shared_ptr
    - move
14. Special Members and Friends
    - special member functions and the Rule of Five
    - defaulted and deleted functions
    - the Rule of Zero
    - friends
15. Odds and Ends
    - explain exit() and when it might be more useful than return
    - explain using extern "C" to use c functions from c++
    - casting (static_cast, dynamic_cast, const_cast, reinterpret_cast)
    - time
    - random numbers
