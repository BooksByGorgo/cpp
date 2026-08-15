# Project Description

Write a chapter about operators in C++ 23.

## Textbook

- This chapter augments the book text found in ../s26/text/
- When covering an operator, mention the first time it appears in the textbook

## Examples

- Include short example code of the operators
- Make sure to cover corner and exceptional cases
- For strings, use 80s references, lyrics from 80s songs, and spanish occasionally. Keep it short.
- Validate examples to make sure syntax and result is correct

## Format and Style

- Use Pandoc markdown
- Use correct grammar and capitalizations
- Use tip callouts (`::: {.tip}` divs) to highlight idioms, best practices, or warn of bad practices
- Callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` --- do not use `wrapfigure`
- Keep the tone professional but light
- Refer to the reader as `you`

## Build

- Build with: `pandoc operators.md -o operators.pdf --lua-filter=../callout.lua`
- Requires `header-includes` for `\usepackage[most]{tcolorbox}` (already in frontmatter)

## Content

1. Introduction: define what an operator is and give some examples using `::`, `+`, `=`, and `==`.
2. Math operators:
    - quickly cover =, mention the reader has used it a lot, explain the result of = and do `a = b = 3;` example
    - quickly cover +, -, *, and / since those are well known
    - review % and show examples of it's use
    - motivate and cover ++ and --
    - motivate and cover +=, -=, *=, /=, %=
    - talk about precidence and using ()
3. Comparison operators:
    - ==, <, <=, >, >=, !=
    - keep this brief since students have seen it before
    - warn about the common trap of using = instead of == for comparison and what happens
4. Logical operators:
    - &&, ||, !
    - warn about confusing with & and |
    - talk about precidence and using ()
5. Ternary operator :?
    - motivate its use
6. Bit operators
    - &, |, ^, ~, <<, >>
    - review binary numbers and bits
    - cover each operator give the common use case for each one with an example (| to set a bit, ^ to flip a bit, etc)
    - cover the assignment forms
    - talk about precidence but recommend that they always use () to make it clear
7. Cover the rest of the operators
8. Operator overrides
    - sometimes the operators will do different things with other types
    - cover the examples of std::string and + and cin with >>
9. Precedence
    - show the table
    - explain how to read the table
```
Precedence 	Operator 	Description 	Associativity
1 	:: 	Scope resolution 	Left-to-right
2 	() [] . -> ++ -- static_cast... 	Function call, array subscript, member access, postfix inc/dec, casts, etc. 	Left-to-right
3 	++ -- + - ! ~ * & 	Prefix inc/dec, unary plus/minus, logical NOT, bitwise NOT, address-of 	Right-to-left
5 	* / % 	Multiplication, division, modulus 	Left-to-right
6 	+ - 	Addition, subtraction 	Left-to-right
7 	<< >> 	Bitwise left and right shift 	Left-to-right
8 	< <= > >= 	Relational operators 	Left-to-right
9 	== != 	Equality and inequality 	Left-to-right
10 	& 	Bitwise AND 	Left-to-right
11 	^ 	Bitwise XOR 	Left-to-right
12 	∣ 	Bitwise OR 	Left-to-right
13 	&& 	Logical AND 	Left-to-right
14 	∣∣ 	Logical OR 	Left-to-right
15 	?: = += -= *= /= %= <<= >>= &= ^= ∣= throw 	Conditional (ternary), assignment, compound assignment, throw expression 	Right-to-left
16 	, 	Comma operator 	Left-to-right
```

