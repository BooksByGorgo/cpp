# Chapter 10 Study Guide: Standard I/O

## The `<stdio.h>` library

- What C++ facility does `<stdio.h>` replace?
- What does the `FILE *` type represent, and what does it mean that it is *opaque*?

## `scanf` for input

- Why does `scanf` need the address of a scalar variable?
- Why do arrays not need a `&` when passed to `scanf`?
- How does `%lf` in `scanf` differ from `%f` in `printf`?
- What is the danger of `scanf("%s", name)` without a width, and how do you fix it?

## Scan sets

- What is the purpose of the `%[...]` specifier?
- What does a leading `^` inside the brackets do?
- How does `%[^\n]` let you read an entire line?
- Why is a width limit (e.g., `%79[^\n]`) still necessary?

### Experiment: parse a structured string

- Use `sscanf` with a scan set to parse the string `"Track 03: 99 Luftballons"` into an integer track number and a title string.
- Print the two pieces back out to verify.

## The `%m` modifier (POSIX)

- What does `%m` ask `scanf` to do?
- What type must you pass for the corresponding argument, and why?
- Why is `%m` a POSIX extension rather than standard C?

## `stdin`, `stdout`, `stderr`

- What three streams are open when your program starts?
- What C++ equivalents map to each?
- Why does `./program > out.txt` not capture messages written to `stderr`?
- How do you redirect stderr to a file from the shell?

## `fprintf` and `fscanf`

- What is the first argument to `fprintf` and `fscanf`?
- Why is `printf(...)` equivalent to `fprintf(stdout, ...)`?
- Show a loop that reads `"name score"` pairs from a file with `fscanf` and stops cleanly on end of file.

## `fopen` and `fclose`

- What does `fopen` return on failure, and what must you always do before dereferencing its result?
- For each mode string (`"r"`, `"w"`, `"a"`, `"r+"`, `"w+"`, `"a+"`), describe what it does to an existing file and to a nonexistent file.
- What does adding `b` to a mode string do on Unix vs on Windows?

## `sprintf` and `sscanf`

- What does `sprintf` do that `printf` does not?
- What makes `snprintf` safer than `sprintf`?
- What is the difference between the third argument in `snprintf` and the corresponding argument in `sprintf`?

## `asprintf` (POSIX)

- What problem does `asprintf` solve that `snprintf` does not?
- What must you remember to do with the string `asprintf` gives you?
- Why would `asprintf` not be available on Windows with MSVC?

## Binary I/O: `fread` and `fwrite`

- What four arguments do `fread` and `fwrite` take?
- What do their return values mean?
- Why would you open a file with mode `"wb"` before calling `fwrite`?

### Experiment: binary round-trip

- Write an array of five `int` values to a file using `fwrite` in mode `"wb"`.
- Close the file, reopen it in mode `"rb"`, and read the values back with `fread`.
- Print the recovered values and confirm they match.

## Reading lines: `fgets`

- What three conditions cause `fgets` to stop reading?
- Does `fgets` include the newline character in the buffer?
- Why is `fgets` generally safer than `scanf` for line-oriented input?

## Buffering and `fflush`

- Define full buffering, line buffering, and unbuffered modes.
- What is the default buffering for `stdout` when connected to a terminal, and what changes when you redirect `stdout` to a file?
- Why does `stderr` show error messages immediately?
- When is `fflush(stdout)` necessary even though your output ends in `\n`?

### Experiment: buffering behavior

- Write a program that prints `Working...` without a newline, sleeps for a second, then prints ` done!\n`.
- Run it with and without `fflush(stdout)` after the first print, and run it both at the terminal and with output redirected to a file.
- Describe when the first message becomes visible in each case.

### Experiment: write and read a text file

- Open `lyrics.txt` for writing, write five lines, and close it.
- Reopen the same file for reading, use `fgets` to read each line in a loop, and print each line to `stdout`.
- Confirm the `fgets` result is `NULL` at end of file.
