# Chapter 1 Study Guide: Introduction

## C and C++ are different languages

- Why did knowing C++ once imply knowing C, and what changed?
- Name four modern C++ features you will *not* find in C.
- If C++ has drifted so far from C, why is it still worth learning C today?

## The K&R hello-world program

- What header must you include to call `printf`, and why?
- Why does K&R's example end its string with `\n` even though C++ `std::println` does not require it?
- What file extension should the source go in, and which compiler command should you use to build it?

## `printf` basics

- What is a *format string*, and what are *format specifiers*?
- What happens to each `%`-prefixed specifier when `printf` runs?
- Why is `printf("%s", str)` safer than `printf(str)`, even when `str` is a trusted variable?

## Format specifiers

- When would you choose `%x` over `%X` (or vice versa)?
- What type does `%zu` expect, and why is `%d` wrong for it?
- What type does `%p` expect, and why should you usually cast the pointer to `void *`?
- What is the difference between `%f` and `%e`?

## Width, precision, and zero-fill

- What is the difference between `%5d` and `%.5d`? between `%5.2f` and `%.2f`?
- How does adding a `0` after `%` change the padding?
- How do you print a literal `%` character?

## `printf` traps

- `printf` does not check that your specifiers match your argument types. What kind of bug can that hide?
- What is a format string attack, and which `printf` call opens the door to it?

## `scanf` basics

- Why does `scanf` need the `&` operator on most arguments but not on arrays?
- What does `scanf` return, and how do you use that return value to detect incomplete input or end-of-file?
- Why is `%s` in `scanf` dangerous without a width specifier like `%49s`?
- What does `%s` in `scanf` stop at, and what does that mean for input like `Rick James`?

## Experiment: echo program

- Write a program that reads a single integer and a single word with one `scanf` call, checks that both were read successfully, and echoes them back with `printf`.
- Modify the program to fail gracefully (print a message to the user) if `scanf` returns fewer than two items.

## Experiment: formatting table

- Write a program that prints a small table of track numbers and prices.
- Use width specifiers so the columns line up.
- Use `%02d` for the track number and `%.2f` for the price.
- Try printing a literal `%` sign as part of a column header.
