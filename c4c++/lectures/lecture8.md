# Lecture 8 --- Standard I/O

**Source:** `c4c++/ch10.md`
**Duration:** 65 minutes

This is the final lecture of the course.

## Learning Objectives

By the end of this lecture, students should be able to:

- Read input with `scanf` and explain why scalar arguments need `&` but arrays do not
- Limit string input with width specifiers to avoid buffer overflow
- Parse structured text with scan sets (`%[...]`)
- Describe `stdin`, `stdout`, and `stderr` and how shell redirection affects each
- Write to any stream with `fprintf` and read from one with `fscanf`
- Open and close files with `fopen`/`fclose`, pick the right mode string, and check for `NULL`
- Format into strings with `sprintf`/`snprintf` and parse strings with `sscanf`
- Move raw bytes with `fwrite` and `fread`
- Read lines safely with `fgets`
- Explain `stdio` buffering and force output with `fflush`

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Copy of `c4c++/ch10.md` for reference

---

## 0. Review (5 min)

**Q.** Where is the bug?

```c
char *score_str = "100";
int score = (int)score_str;
printf("You got a %d percent!\n", score);
```

A. `score_str` needs a `&` in the cast
B. The cast converts the address of the string, not its contents --- use `strtol`
C. `%d` should be `%s`
D. `score_str` must be declared `const`
E. Ben got this wrong

*Answer: B*

## 1. `scanf` and Why `&` Is Needed (8 min)

- `<stdio.h>` is your replacement for C++ `iostream`.
- Everything flows through `FILE *` --- an opaque pointer to a structure tracking the state of a stream.

```c
int scanf(const char *format, ...);
```

```c
int year;
printf("Enter a year: ");
scanf("%d", &year);
printf("You entered: %d\n", year);
```

- C has no pass by reference, so `scanf` needs the *address* of the variable to store the result there.
- Forgetting the `&` compiles but crashes or produces garbage at runtime --- a classic bug.
- `scanf` specifiers are similar to `printf` but not identical: `scanf` uses `%lf` for `double` while `printf` uses `%f`.

```c
char name[50];
double gpa;
scanf("%s %lf", name, &gpa);
```

- `name` needs no `&` --- an array name already points to the bytes we want to fill.

::: {.tip}
**Trap:** `scanf("%s", ...)` reads a single word (stopping at whitespace) and has no bounds checking --- it will happily overflow your buffer.
Use a width specifier like `%49s` to limit input to 49 characters (plus `'\0'`).
:::

## 2. Scan Sets (4 min)

- `%[...]` accepts only the listed characters and stops at the first character not in the set.
- A leading `^` negates the set: read everything *except* those characters.
- `%[^\n]` is the `scanf` way to read a whole line.

```c
char line[80];
scanf("%79[^\n]", line);   // reads a full line (up to 79 chars)
printf("You said: %s\n", line);
```

- Scan sets work with `sscanf` too:

```c
char buf[] = "Track 03: 99 Luftballons";
int track;
char title[50];
sscanf(buf, "Track %d: %49[^\n]", &track, title);
// track is 3, title is "99 Luftballons"
```

::: {.tip}
**Tip:** `fgets` is generally safer and simpler for line-oriented input; use scan sets for structured parsing.
POSIX also offers the `%m` modifier, which `malloc`s a right-sized buffer for you (`scanf("%m[^\n]", &line)`) --- glibc only, not standard C, and you must `free` the result.
:::

## 3. `stdin`, `stdout`, and `stderr` (5 min)

When your C program starts, three `FILE *` streams are already open:

| Stream | Purpose | C++ equivalent |
|:---|:---|:---|
| `stdin` | Standard input (keyboard) | `std::cin` |
| `stdout` | Standard output (screen) | `std::cout` |
| `stderr` | Standard error (screen) | `std::cerr` |

- `printf(...)` is actually shorthand for `fprintf(stdout, ...)`.
- `./program > output.txt` redirects only `stdout`, so `stderr` messages still appear on the screen.
- `./program 2> err.txt` redirects `stderr` instead.

```c
fprintf(stderr, "Error: file not found\n");
```

## 4. `fprintf` and `fscanf` (5 min)

```c
int fprintf(FILE *stream, const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
```

- The file versions of `printf` and `scanf` --- same formats, plus a `FILE *` first argument.

```c
fprintf(stdout, "Hello\n");           // same as printf("Hello\n")
fprintf(stderr, "Something broke\n"); // write to stderr
```

```c
FILE *f = fopen("scores.txt", "r");
if (f != NULL) {
    char name[50];
    int score;
    while (fscanf(f, "%49s %d", name, &score) == 2) {
        printf("%s scored %d\n", name, score);
    }
    fclose(f);
}
```

- `fscanf` returns the number of items successfully read --- check it to know whether the read worked.

## 5. Opening and Closing Files (7 min)

```c
FILE *fopen(const char *path, const char *mode);
int fclose(FILE *stream);
```

```c
FILE *f = fopen("log.txt", "w");
if (f == NULL) {
    fprintf(stderr, "Cannot open file\n");
    return 1;
}

fprintf(f, "Under Pressure\n");
fprintf(f, "Year: %d\n", 1981);

fclose(f);
```

- `fopen` returns `NULL` on failure --- *always* check before using the pointer.

The mode string:

| Mode | Meaning |
|:---|:---|
| `"r"` | Read (file must exist) |
| `"w"` | Write (creates or truncates) |
| `"a"` | Append (creates or appends) |
| `"r+"` | Read and write (file must exist) |
| `"w+"` | Read and write (creates or truncates) |
| `"a+"` | Read and append |

- Add `b` for **binary mode**: `"rb"`, `"wb"`, `"ab"`, ...
- On Unix, binary and text modes behave identically.
- On Windows, text mode translates `\r\n` to `\n` on input and back on output --- binary mode does not.

## 6. `sprintf`, `sscanf`, and `snprintf` (6 min)

- `sprintf` formats into a string buffer instead of a stream; `sscanf` parses from a string.
- Together they are C's number-to-string and string-to-number formatting kit.

```c
char buf[100];
sprintf(buf, "Track %02d: %s", 3, "99 Luftballons");
// buf is now "Track 03: 99 Luftballons"

int track;
char title[50];
sscanf(buf, "Track %d: %49[^\n]", &track, title);
// track is 3, title is "99 Luftballons"
```

::: {.tip}
**Trap:** `sprintf` has the same buffer overflow risk as `strcpy` --- it does not check the size of the destination buffer.
Use `snprintf` for safety:

```c
snprintf(buf, sizeof(buf), "Track %02d: %s",
         3, "99 Luftballons");
```

`snprintf` guarantees it will not write more than `sizeof(buf)` bytes, including the null terminator.
:::

::: {.tip}
**Tip:** POSIX `asprintf(&msg, ...)` goes one step further and `malloc`s a buffer that is exactly the right size --- no sizing, no truncation, no overflow.
Like `%m`, it is not standard C (no MSVC), and you must `free` the result.
:::

## 7. Binary I/O: `fwrite` and `fread` (6 min)

```c
size_t fread(void *ptr, size_t size, size_t count, FILE *stream);
size_t fwrite(const void *ptr, size_t size, size_t count,
              FILE *stream);
```

- Four arguments: pointer to the data, size of each element, number of elements, stream.
- Raw bytes only --- no format conversion.

```c
int nums[] = {10, 20, 30, 40, 50};

// Write binary data
FILE *f = fopen("data.bin", "wb");
fwrite(nums, sizeof(int), 5, f);
fclose(f);

// Read it back
int result[5];
f = fopen("data.bin", "rb");
fread(result, sizeof(int), 5, f);
fclose(f);

for (int i = 0; i < 5; i++) {
    printf("%d ", result[i]);   // 10 20 30 40 50
}
printf("\n");
```

- Both return the number of elements successfully transferred.

## 8. Reading Lines: `fgets` (3 min)

```c
char *fgets(char *s, int size, FILE *stream);
```

```c
char line[80];
while (fgets(line, sizeof(line), f) != NULL) {
    printf("%s", line);   // line already includes '\n'
}
```

- Stops after `size - 1` characters, at a newline (kept in the buffer), or at end of file.
- Always null-terminates on success; returns `NULL` at end of file or on error.
- Safer than `scanf` for lines because it always respects the buffer size.

## 9. Buffering and `fflush` (5 min)

- `stdio` does not write to the device on every call --- it accumulates output in a buffer and writes larger chunks.
- **Full buffering:** flushed when the buffer is full (default for files).
- **Line buffering:** flushed at each `\n` (default for `stdout` at a terminal).
- **Unbuffered:** written immediately (default for `stderr`).

```c
printf("Working...");
fflush(stdout);   // force output to appear now
// ... long computation ...
printf(" done!\n");
```

::: {.tip}
**Trap:** When `stdout` is connected to a terminal, a `\n` triggers a flush.
When `stdout` is redirected to a file or pipe, it is fully buffered --- output may not appear until the buffer fills or the program exits.
If you need output to appear immediately (progress indicators!), call `fflush(stdout)`.
`stderr` is unbuffered, which is why error messages appear immediately.
:::

## 10. Live Coding: Standard I/O Starter (4 min)

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    // sprintf: format into a string
    char buf[100];
    sprintf(buf, "Track %02d: %s", 7, "Hungry Like the Wolf");
    printf("sprintf: %s\n", buf);

    // snprintf: safe version with size limit
    char small[15];
    snprintf(small, sizeof(small), "Year: %d", 1984);
    printf("snprintf: %s\n", small);

    // sscanf: parse from a string
    int track;
    char title[50];
    sscanf(buf, "Track %d: %49[^\n]", &track, title);
    printf("sscanf: track=%d title='%s'\n", track, title);

    // fprintf to stderr
    fprintf(stderr, "This goes to stderr\n");

    // fwrite/fread round-trip
    int nums[] = {10, 20, 30};
    FILE *f = fopen("/tmp/tryit_data.bin", "wb");
    fwrite(nums, sizeof(int), 3, f);
    fclose(f);

    int result[3];
    f = fopen("/tmp/tryit_data.bin", "rb");
    fread(result, sizeof(int), 3, f);
    fclose(f);

    printf("fread: %d %d %d\n", result[0], result[1], result[2]);

    return 0;
}
```

- Compile with `cc -Wall -Wextra -pedantic`.
- Run it as `./a.out > out.txt` and show that the `stderr` line stays on the screen.
- Shrink `small` to `char small[8]` and watch `snprintf` truncate safely.

## 11. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
char buf[50];
sprintf(buf, "%s: %d", "Score", 100);
printf("%zu\n", strlen(buf));
```

A. `10`
B. `9`
C. `11`
D. `50`
E. Ben got this wrong

*Answer: A*

**Q2.** Where is the bug?

```c
int x;
scanf("%d", x);
```

A. `%d` should be `%i`
B. Missing `&` before `x` --- `scanf` needs the address
C. `x` must be initialized first
D. `scanf` cannot read integers
E. Ben got this wrong

*Answer: B*

**Q3.** You run `./program > output.txt`.
Where does `fprintf(stderr, "boom\n")` go?

A. Into `output.txt`
B. To the screen
C. Nowhere --- it is discarded
D. Both the screen and `output.txt`
E. Ben got this wrong

*Answer: B*

## 12. Course Wrap-up (2 min)

This is the final lecture of the course.

- **Optional reading:** chapter 11 (Low-Level I/O) and chapter 12 (Odds and Ends) of *Gorgo C for C++ Programmers* as reference material. Not required for the final exam, but you will see all of it in real C code.
- Review all prior chapters for the final exam.
- Bring your end-of-term questions --- we will hold an open Q&A session next class period.

## Key Points to Reinforce

- `printf` writes to `stdout`; `fprintf` writes to any `FILE *`
- `scanf` needs `&` for scalars; arrays already decay to pointers
- Always width-limit string input: `%49s`, `%79[^\n]`
- `fopen` returns `NULL` on failure --- always check before using the pointer
- Add `"b"` to the mode string for binary files; it matters on Windows
- `fread` and `fwrite` transfer raw bytes --- no format conversion
- `snprintf` over `sprintf` --- respect the buffer size
- `stdout` is line buffered at a terminal, fully buffered when redirected; `fflush` forces output
