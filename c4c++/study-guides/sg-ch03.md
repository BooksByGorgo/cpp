# Chapter 3 Study Guide: Strings

## What is a string in C?

- How does a C "string" differ from a C++ `std::string`?
- Why does every C string function depend on the null terminator?
- What happens if you forget to leave room for `'\0'` in a buffer?

## Declaring C strings

- What is the difference in size between `char s[] = "Hola"` and `char s[10] = "Hola"`?
- How many bytes does `"hello"` occupy, and why is the answer not 5?

## String literals vs arrays

- What is the key difference between `char arr[] = "..."` and `const char *ptr = "..."` in terms of where the data lives and whether you can modify it?
- Why should a pointer to a string literal be declared `const char *`?
- What kind of bug happens if you try `char *bad = "literal"; bad[0] = 'x';`, and why might it pass your tests before failing on someone else's machine?

## `strlen`

- What does `strlen` count, and what does it *not* count?
- If an array holding `"Take On Me"` is 11 bytes, what does `strlen` return and why?

## `strcpy` and `strncpy`

- What does `strcpy` copy, and what must the caller guarantee?
- What is the one guarantee `strncpy` does *not* make that `strcpy` does make?
- Why is setting `dest[sizeof(dest) - 1] = '\0';` after `strncpy` a defensive habit?

## `strcmp` and `strncmp`

- Why does `a == b` not compare the contents of two `char` arrays?
- What does `strcmp` return when the strings are equal, when the first is less, and when the first is greater?
- How is `strncmp` useful for checking prefixes?

## `strchr`, `strrchr`, `strstr`

- What is the difference between `strchr` and `strrchr`?
- How do you compute the zero-based index of the found character from the pointer `strchr` returns?
- What does each of these three functions return when the needle is not found?

## `strcat` and `strncat`

- Why is `strcat` one of the most dangerous functions in C?
- When you call `strncat`, why must the third argument leave room for the null terminator?

## `strdup`

- Where does `strdup` put the copy, and who is responsible for freeing it?
- Why does compiling with `-std=c99 -pedantic` sometimes produce a warning for `strdup`?

## `strtok` and its safer siblings

- What two global side effects make `strtok` hard to use correctly?
- Why do you pass `NULL` on the second and later calls to `strtok`?
- How do `strtok_r` and `strtok_s` fix the thread-safety problem?

## The dangers of `strcat`

- Walk through the `buf[12] = "Buenas "` + `strcat("noches")` example.
- Where exactly does the overflow happen, and what kinds of outcomes are possible?

## `<ctype.h>`

- Name at least four `is*` predicates from `<ctype.h>` and describe what each tests.
- What do `toupper` and `tolower` do, and what do they return for a character that is already the right case?
- Why must you cast a `char` to `unsigned char` before passing it to one of these functions?

## Preview: `sprintf` and `snprintf`

- What does `sprintf` do that `printf` does not?
- Why is `snprintf` the safer alternative to `sprintf`?

## Experiment: manual strlen

- Write your own `strlen` that takes a `const char *` and returns a `size_t` by walking the string until it hits `'\0'`.
- Compare its result to the standard library `strlen` for several inputs, including the empty string `""`.

## Experiment: safe concatenation

- Write a program that builds a greeting by concatenating two strings into a fixed-size buffer.
- Use `strncat` (not `strcat`) and compute the third argument so it always respects the buffer size.

## Experiment: character classification

- Read a string from the user with `fgets` (or `scanf` with a width specifier).
- Count the uppercase letters, lowercase letters, digits, whitespace, and other characters using `<ctype.h>` functions.
- Print the totals.
