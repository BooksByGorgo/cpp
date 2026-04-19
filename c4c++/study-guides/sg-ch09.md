# Chapter 9 Study Guide: Numbers and Casting

## Everything is a number

- From the CPU's perspective, what do types like `char`, `int`, and `int *` mean?
- How does a type declaration influence what the *compiler* does, even though the underlying bits are the same?

## Characters are numbers

- What is the numeric value of `'A'` in ASCII, and what happens when you print `'A' + 1` with `%c` vs `%d`?
- Why can you do arithmetic on `char` values directly?

### Experiment: shift a character

- Read a letter from the user.
- Shift it by 3 positions in the alphabet (Caesar cipher style) using ordinary integer arithmetic.
- Print the shifted letter.

## Pointers are numbers

- Why is `%p` the right format specifier for a pointer, and why do we cast to `void *`?
- In what sense is a pointer "just a number"?

## Strings are arrays of numbers

- Why does C have no native understanding of strings?
- When you write `"Africa"` in source code, what does the compiler actually emit in memory?
- Where does a string literal typically live, and why is that important?

### Experiment: print bytes of a string

- Declare `char word[] = "Hola";`
- Print each byte of `word` as a decimal number using a loop.
- Confirm the last byte is `0`.

## Converting strings to numbers

- Why does `(int)"1986"` *not* give you the number 1986?
- What does `strtol` do with its three arguments?
- When is the `endptr` parameter useful, and when can you pass `NULL`?
- What base value auto-detects `0x...` and `0...` prefixes?

## Integer types

- What is the typical size and range of each of `char`, `short`, `int`, `long`, and `long long` on a 64-bit system?
- What literal suffix marks an `unsigned long` constant?
- Why is the range asymmetric for signed integers (one more negative than positive)?
- What does *two's complement* mean at the level of bits?
- Why is `char`'s signedness implementation-defined, and how does that bite you on x86 vs ARM?

### Experiment: limits.h

- Include `<limits.h>`.
- Write a program that prints the size and the min/max of each integer type on your system.
- Compare to the table in the chapter.

## Integer promotion

- Which types get promoted to `int` in expressions?
- When `int` cannot represent all values of the type, what does the type get promoted to?
- Why is subtracting two `size_t` values dangerous when the first might be smaller?
- How do you get a correct signed difference between two `size_t` values?

## Floating-point types

- What are the typical sizes of `float`, `double`, and `long double`?
- What special values can a floating-point number represent that an integer cannot?
- Why do floating-point numbers have *two* zeros?
- Why can't `0.1` be represented exactly as a `float` or `double`?
- Why does the program `if (f != 1.2) ... if (f == 1.2f) ...` print both messages?

## Casting basics

- What is a cast, syntactically?
- How are C casts simpler than the various C++ casts?
- Between which pairs of scalar types are casts allowed, and which pair is explicitly disallowed in the chapter's table?
- When you cast a `double` to `int`, does the result round or truncate?

## The string-to-int cast trap

- What does `int bad = (int)"1985";` actually do?
- Why does this usually produce a compiler warning, and what does the warning tell you?
- What should you use instead to parse `"1985"` into `1985`?

## Casting pointers to other pointers

- What can a `void *` point to?
- Why does `malloc` return `void *`, and why is that convenient in C?
- When is `char *` useful for pointer arithmetic?

### Experiment: split a double

- Declare a `double` with a fractional component (e.g., `3.14`).
- Use a cast to extract the integer part.
- Compute the fractional part by subtracting the integer part back out.
- Print both pieces.

### Experiment: parse a hex string

- Use `strtol` to parse a hex string like `"FF8000"` into a `long`.
- Print the result in decimal and back in hex.
- Try passing base `0` and prefixing the string with `0x`; confirm you get the same result.

### Experiment: look at the bytes of an int

- Declare `int x = 0x0badd00d;`.
- Get an `unsigned char *` to `&x` and print the four bytes in memory order.
- Decide from the output whether your system is little-endian or big-endian.
