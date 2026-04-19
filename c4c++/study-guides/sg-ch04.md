# Chapter 4 Study Guide: Expressions

## C vs C++ operators

- Which operators can be overloaded in C, and what does that imply about how you read unfamiliar C code?
- In C, what do `<<` and `>>` mean, and how is that different from common C++ use?
- What type does C use for the result of a comparison, and how is that different from C++?

## Assignment

- What value does the expression `a = 5` produce?
- How does that fact let you write `a = b = c = 0;`, and in what order are the assignments performed?
- Why does `while ((ch = getchar()) != EOF)` need the inner parentheses?

## `=` vs `==`

- What bug does `if (x = 5)` introduce, and why does it still compile?
- What is a *Yoda condition*, and how does it catch this bug at compile time?

## Arithmetic operators

- What does integer division do with a value like `17 / 5`, and how do you get the fractional result?
- What sign does `%` take when the dividend is negative, in C99 and later?
- In what way does C's `%` differ from the mathematical modulo operation?

## Comparison and logical operators

- What value does `5 > 3` produce in C, and what is its type?
- What is *short-circuit evaluation*, and why does it let you write `if (p != NULL && *p > 0)` safely?
- Why can you write `if (ptr)` and `if (!ptr)` in C?

## No built-in bool

- Before C99, how did C code represent boolean values?
- What does `<stdbool.h>` add?

## Bitwise operators

- What do `&`, `|`, `^`, and `~` do at the bit level?
- Why are `<<` and `>>` never used for I/O in C?

### Flag manipulation

- How do you use `|` to set a flag bit?
- How do you use `& ~` to clear a flag bit?
- How do you use `^` to toggle a flag bit?
- How do you use `&` in an `if` to test whether a flag bit is set?
- Why is `(1 << n)` a clearer bit mask than a raw hex constant?

## Compound assignment

- Express `a = a + b` as a compound assignment.
- Why is `count += 1` arguably clearer than `count = count + 1` to a reader?

## Increment and decrement

- In `a = ++x` versus `a = x++`, which gets the new value and which gets the old?
- Why is `int result = i++ + ++i;` undefined behavior?
- If you need to modify a variable twice in one line, what should you do instead?

## Ternary operator

- What is the structure of a ternary expression?
- When is a ternary easier to read than an `if`/`else`, and when is `if`/`else` clearer?

## Operator precedence

- In the expression `x & 0x04 == 0x04`, which operator binds tighter and what does the expression actually evaluate?
- How would you fix that expression so it tests "bit 2 of x is set"?
- Which binds tighter, `&&` or `||`, and how does that line up with math conventions like "AND before OR"?
- What is the simplest rule for staying out of precedence trouble?

## Experiment: swap without temp

- Write a program that swaps two integers using three XOR assignments (`a ^= b; b ^= a; a ^= b;`).
- Confirm it works for positive, negative, and zero values.
- Why is this clever but rarely a good idea in production code?

## Experiment: binary printer

- Write a program that reads an `unsigned int` and prints its 32-bit binary representation, most significant bit first.
- Use `(1u << i)` as the mask.
- Test with `0`, `1`, `255`, `1024`, and `UINT_MAX`.

## Experiment: permission bits

- Define `FLAG_READ`, `FLAG_WRITE`, and `FLAG_EXEC` as bit masks.
- Write a small program that sets, toggles, checks, and clears individual bits in a permissions variable, printing the hex value after each step.
