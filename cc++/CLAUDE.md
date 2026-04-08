# Project Description

Continuing C++ book for programming which continues from the point that `Starting C++` left off.
This book covers all the topics that a good C++ programmer uses in daily life in industry.

## Starting C++

- `Startign C++` is the previous book
- it can be found in `../sc++`

## Chapters

- DO NOT MODIFY THE AUTHOR INTRO section
- each numbered element in `Content` represents a chapter
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

- For strings, use 2000s references, lyrics from 2000s songs, and Spanish occasionally. Keep it short.
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
- `\printindex` goes only in appB.md (the last file built into the book) --- do not add it to other chapters or appendices

## 2000s References

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
1. Object-oriented programming
    - inheritance (public, protected, private)
    - polymorphism and virtual functions
    - abstract classes and pure virtual functions
    - RTTI and dynamic_cast
    - multiple inheritance
2. Templates
    - function templates
    - class templates
    - template specialization
    - CTAD (class template argument deduction)
    - variadic templates
    - concepts (C++20)
3. The standard template library
    - associative containers: std::map, std::set, std::multimap, std::multiset
    - unordered containers: std::unordered_map, std::unordered_set
    - container adaptors: std::stack, std::queue, std::priority_queue
    - choosing the right container
4. Ranges, algorithms, and lambdas
5. Enums, constexpr, and compile-time programming
    - enum class
    - constexpr and consteval
    - constinit
    - static_assert
    - type aliases (using)
6. Advanced strings
    - std::string_view
    - regular expressions (std::regex)
    - string conversions (std::stoi, std::to_string, std::from_chars, std::to_chars)
7. Utilities
    - std::optional
    - std::variant
    - std::any
    - std::tuple and structured bindings
    - std::pair revisited
8. Namespaces and the preprocessor
    - namespace design and organization
    - anonymous namespaces
    - inline namespaces
    - using declarations vs using directives
    - include guards and #pragma once
    - macros and conditional compilation
    - modules preview (C++20)
9. RAII and resource management
    - the RAII pattern
    - exception safety guarantees (basic, strong, nothrow)
    - scope guards
    - custom deleters with smart pointers
10. Concurrency
    - std::thread
    - mutexes and locks (std::mutex, std::lock_guard, std::unique_lock)
    - condition variables
    - std::async and std::future
    - atomics (std::atomic)
    - thread safety pitfalls
11. The filesystem library
    - std::filesystem::path
    - directory iteration
    - file operations (copy, rename, remove)
    - file status and permissions
12. Best practices and common idioms
    - coding standards and style
    - common C++ idioms (PIMPL, CRTP, tag dispatch)
    - code review checklist
    - what's next (C++26 preview)

Appendix A. Build systems and tooling
    - CMake basics
    - compiler flags and warnings
    - sanitizers (address, undefined behavior, thread)
    - static analysis
    - debugging with gdb/lldb

Appendix B. Testing
    - unit testing concepts
    - testing frameworks (Google Test, Catch2)
    - test-driven development
    - mocking
