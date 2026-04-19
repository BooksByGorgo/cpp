# Chapter 12 Study Guide: Odds and Ends

## `exit` vs `return`

- Which functions can call `exit`, and which can `return` from?
- What does `exit` do to open `stdio` streams before terminating?
- What is `atexit`, and how do the functions it registers relate to `exit`?
- When is `exit` the right tool, and when is propagating an error code back to `main` better?

### Experiment: atexit demo

- Register a cleanup function with `atexit` that prints a goodbye message.
- Call `exit(0)` before the end of `main` and confirm the cleanup function still runs.

## `extern "C"` --- calling C from C++

- Why does C++ mangle function names, and what does that have to do with overloading?
- What problem does `extern "C"` solve for a C++ program that calls into a C library?
- What does `#ifdef __cplusplus` inside a C header let the header do?

### Experiment: call strlen from C++

- Write a small C++ program that uses `extern "C"` to include `<string.h>` and calls `strlen` on a literal.
- Compile with `c++` and confirm it links and runs.

## Pointer ownership

- What question should you ask whenever a function hands you a pointer?
- For each of the three ownership patterns in the chapter (caller owns, library owns, you-owned-it-all-along), give a concrete example function or situation.
- What two classes of bug come from getting ownership wrong?

## Error handling without exceptions

- Since C has no `throw`/`catch`, what two mechanisms do C programs use to report and propagate errors?
- What does `errno` hold, and where is it declared?
- What do `perror` and `strerror(errno)` do, and how do they differ?

### The `goto` cleanup pattern

- Walk through the chapter's `process(const char *path)` example.
- In the order resources were acquired, in what order are they released?
- How does this pattern approximate RAII in a language that has no destructors?

### Experiment: cleanup pattern

- Write a function that opens a file, allocates two buffers, and would want all three released in the correct order on any failure.
- Implement it with `goto` cleanup and force each step to fail in turn, verifying no leaks.

## `enum`

- How does a C `enum` differ from a C++ `enum class` with respect to scoping and implicit conversion to `int`?
- Why do you have to write `enum direction heading` in C unless you use `typedef`?
- How do you assign explicit values to some or all of the constants, and what happens to the rest?

## `union`

- How is a `union` laid out in memory compared with a `struct`?
- What is the size of a union?
- What is a *tagged union*, and how does it track which member is currently valid?
- What is the C++ facility that most closely resembles a tagged union?

### Experiment: tagged union

- Define a `struct shape` containing an `enum` tag (`CIRCLE` or `RECTANGLE`) and a `union` with a radius or a width-and-height.
- Write a function that prints the area of a shape based on the tag.
- Test both variants.

## `qsort`

- What are the four parameters to `qsort`, and what does each control?
- Why does the comparison function take `const void *` parameters, and how do you use them safely?
- Why is `return a - b;` a bad comparator for integers in general, and what is the safer pattern?

### Experiment: sort years

- Sort an `int[]` of years in ascending order with `qsort`.
- Write a second comparator that sorts in *descending* order and verify by printing.

### Experiment: sort strings

- Sort an array of `const char *` with `qsort`.
- Explain why the comparator receives a `const char **` (disguised as `const void *`) and use `strcmp` correctly on the dereferenced pointers.

## Key takeaways, in your own words

- Summarize in one or two sentences each: `exit`, `extern "C"`, pointer ownership, the `goto` cleanup pattern, `enum`, `union`, and `qsort`.

\newpage

# Appendix A Study Guide: Macros

## Why macros?

- What does the preprocessor do, and when does it run relative to the compiler?
- What three features does C++ have that remove most of the pressure to use macros?
- Why does C still rely on macros so heavily in practice?

## Object-like macros

- What does `#define MAX_BUF 1024` do, and where in the code does it take effect?
- Why is it a mistake to end a `#define` with a semicolon?

## Conditional compilation

- What is the difference between `#ifdef`, `#ifndef`, and `#if`?
- How do `#elif` and `#else` extend `#if`?
- What is the macro `__cplusplus`, and when is it defined?

## Include guards

- What is the problem that include guards prevent?
- Walk through the flow of an `#ifndef MY_HEADER_H ... #define MY_HEADER_H ... #endif` guard on the first and second inclusion.
- How does `#pragma once` compare to the `#ifndef` guard in portability and simplicity?

## Function-like macros

- How does a function-like macro differ from a real function?
- Why must every parameter appearance and the macro body be wrapped in parentheses?
- Show what goes wrong with `#define SQUARE(x) x * x` when called as `SQUARE(1 + 2)`, and contrast with the parenthesized version.

## The double-evaluation trap

- When you pass `i++` to a function-like macro that uses its argument twice, what happens?
- Why does a real function not have this problem?
- Which kinds of expressions should you therefore avoid passing to function-like macros?

## `do { ... } while (0)`

- What problem does the `do { ... } while (0)` idiom solve that a bare `{ ... }` block does not?
- Walk through why the bare-braces version breaks in an `if`/`else` chain.

### Experiment: SWAP macro

- Write a `SWAP(a, b)` macro using `do { ... } while (0)`.
- Use it inside an `if (x > y) SWAP(x, y); else ...` and confirm it compiles and runs correctly.
- Try replacing the `do ... while (0)` with bare braces and see the compile error the chapter warns about.

## Stringification `#` and token pasting `##`

- What does `#x` do inside a macro?
- How does the C rule that adjacent string literals concatenate interact with stringification?
- What does `a##b` do?
- Why does token pasting often show up when generating families of related names?

## Multi-level expansion

- What is the difference between `STRINGIFY(MAX_BUF)` and `XSTRINGIFY(MAX_BUF)` from the chapter?
- Why does the two-level pattern exist?

### Experiment: debug print

- Write `PRINT_INT(var)` that prints the variable's name (via `#`) and value.
- Use it to print the contents of three different variables.

## Variadic macros

- What does `...` mean in a macro parameter list?
- What is `__VA_ARGS__`?
- Why does `##__VA_ARGS__` exist, and how does C23 standardize the same idea?

### Experiment: logging macro

- Write a `LOG(fmt, ...)` macro that prepends `"[LOG] "` to the format and ends with a newline, printing to `stderr`.
- Call it with no extra arguments and with several, and confirm both forms compile.

## X-macros

- What is the core idea of an X-macro?
- How does the `LOG_LEVELS(X)` example keep the enum and the string table in sync?
- In what real-world situations (command tables, error codes, state machines) would you reach for X-macros?

### Experiment: X-macro of colors

- Define an X-macro list of at least four colors.
- Use it to generate both an `enum color` and a function `const char *color_name(enum color)` that returns the string form.
- Print each color's enum value and name.
