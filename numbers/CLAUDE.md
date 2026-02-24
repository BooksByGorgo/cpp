# Project Description

A chapter to supplement the textbook about representation and storage of numbers in C++.

## Textbook

- This chapter augments the book text found in ../s26/text/
- When covering a concept, mention the first time it appears in the textbook

## Examples

- Include short example code
- Each section includes a complete "Try It" program illustrating the section's concepts
- Make sure to cover corner and exceptional cases
- For strings, use 80s references, lyrics from 80s songs, and spanish occasionally. Keep it short.
- Validate examples to make sure syntax and result is correct

## Format and Style

- Use Pandoc markdown
- Use correct grammar and capitalizations
- Use tip callouts (`::: {.tip}` divs) to highlight idioms, best practices, or warn of bad practices
- Callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` — do not use `wrapfigure`
- Keep the tone professional but light
- Refer to the reader as `you`
- Put jokes in italics

## Build

- Build with: `pandoc numbers.md -o numbers.pdf --lua-filter=callout.lua`
- Requires `header-includes` for `\usepackage[most]{tcolorbox}` (already in frontmatter)

## Content

1. Introduction:
    - start with `There are only 10 people in the world` (in italics)
    - the CPU is a super fast glorified calculator: everything is a number
    - when we think of numbers we can think of 5 or V or ||||| but they all represent the same thing: the number five
    - we've already seen that the character '5' is actually the ASCII code 53, but there are more ways we can represent numbers
2. Bases:
    - continue the joke (in italics) `and people who don't understand ternary numbers, and people who don't understand quadnary numbers...`
    - we use decimal numbers. what does that mean?
    - look how we count in decimal. how can we tell quickly if a number is divisible by 10? how can we tell if it is divisible by 2 or 8?
    - it is often said that computers think in 1s and 0s (it's not entirely accurate) what do numbers look like if we only use 1s and 0s
    - look how we count in binary. how can we tell quickly if a number is divisible by 2? how can we tell if it is divisible by 8 or 10?
    - binary numbers are long, so let's look at hex and octal
3. Representing numbers from other bases in literals
    - `0b`, `0x`, `0` prefixes
    - digit separators with `'`
4. Printing numbers in other bases
    - `std::format`/`std::println` with `{:b}`, `{:x}`, `{:o}`
    - `#` flag for base prefix
5. Converting from other bases
    - manual place-value math
    - `std::stoi` with base parameter
6. Two's complement
    - one's complement (we don't use it — double zero problem)
    - two's complement (flip bits and add 1)
    - how addition and subtraction just works with two's complement
7. Integer sizes and ranges
    - bytes (8 bits) as the basic unit of memory (KB, MB, GB, TB)
    - integer types and their sizes (`char`, `short`, `int`, `long`, `long long`)
    - the range formula (2^n values, signed vs unsigned)
    - signed vs unsigned, `size_t`
    - overflow behavior (unsigned wraps, signed is undefined behavior)
8. Binary addition and subtraction
    - how it works with two's complement
    - worked examples: positive result, negative result
9. Shift operators
    - `<<` and `>>` move bits
    - multiplies and divides by 2
    - arithmetic shift for signed values
    - compound assignment (`<<=`, `>>=`)
10. Conclusion
    - summarize key points
    - reminder that a number may be represented many different ways, but it is always the same number
