# Project Description

Starting C++ book for programming just starting C++ entitled `Starting C++`
No previous programming experience is assumed.

## Chapters

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
- Compile examples with `cc -Wall -Wextra -pedantic` to verify correctness
- Create short example programs to illustrate the concepts covered
- Use `%zu` for `size_t` (e.g., `strlen` return) and `%td` for `ptrdiff_t` (e.g., pointer subtraction)

## Format and Style

- Use Pandoc markdown
- Use correct grammar and capitalizations
- Use tip callouts (`::: {.tip}` divs) to highlight idioms, best practices, or warn of bad practices
    - `Tip` for highlight idioms, best practices
    - `Trap` for common mistakes
    - `Wut` unexpected or counterintuitive rules
- Callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` — do not use `wrapfigure`
- Keep the tone professional but light
- Preserve emojis and text emojis (e.g., `:'(`) in the text — do not remove them
- Refer to the reader as `you`
- do not wrap sentences in the markdown. every sentence gets its own line

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
- `\printindex` at the end of the file generates the index page

## 90s References

- PLAYLIST.md tracks all songs and references used in the text, organized by chapter
- do not repeat references already listed in PLAYLIST.md
- when adding or changing a reference in the text, update PLAYLIST.md to match

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
7. Functions
    - declarations vs definitions, forward declarations, void parameter lists
    - pass-by-value and pass-by-reference
    - const parameters. why they are important
    - structures can be problematic to pass by value
    - recursive functions
    - function pointers (basics, typedef, callbacks)
9. Numbers and casting
    - to the CPU everything is a number. the numbers can be different sizes and can be used for different things
        - different number bits gives a different range of values
        - a char is just a number; assigning 'A' is the same as assigning 65
        - a pointer is just a number as well, its just a number that represents a memory address; when we use a type and * we let the compiler know how to interpret the number
    - the types we give to numbers indicates how we plan to use the number
    - a pointer type tells the compiler that you want to use the number as an address
    - C doesn't know about strings, it only knows about arrays of characters, and libraries allow us to work with them as strings
    - converting numbers to string and strings to numbers
    - casts
        - (type) value
        - simpler than C++ casts, but no magic happens
        - you are asserting to the compiler that you know what you are doing
        - TRAP: casting a char * to an int doesn't convert a string to an integer value, it converts the address to an integer value. use strtol() to convert a string to an integer value
6. Containers
    - std::array
    - std::vector
    - iterating through containers
7. Ranges, algorithms, and lambdas
8. Views
10. Classes
    - constructors/destructors
    - member methods
11. Memory Management
    - new/delete
    - don't use new/delete use std::unique_ptr
    - std::shared_ptr
    - move
    - special members
10. I/O streams
    - string streams
    - file streams
11. formatted I/O
    - std::format
    - std::print
12. Odds and Ends
    - explain exit() and when it might be more useful than return
    - explain using extern "C" to use c functions from c++
