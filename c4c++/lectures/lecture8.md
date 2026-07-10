# Lecture 8 --- Standard I/O

**Source:** `c4c++/ch10.md`
**Duration:** 65 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Use `scanf` for formatted input and explain why scalar arguments need `&`
- Name the three standard streams and send error messages to `stderr`
- Use `fprintf` and `fscanf` with any `FILE *`
- Open and close files with `fopen`/`fclose`, choosing the right mode string (including binary)
- Format into strings with `sprintf`/`snprintf` and parse strings with `sscanf` and scan sets (`%[...]`)
- Round-trip raw data with `fwrite` and `fread`
- Read whole lines safely with `fgets`
- Explain line buffering vs full buffering and use `fflush` when output must appear immediately

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Copy of `c4c++/ch10.md` for reference

---

## 0. Review (5 min)

**Q.** You want `year` to hold the number 1985. Where is the bug?

```c
char *year_str = "1985";
int year = (int)year_str;
```

A. Nothing --- the cast converts the string to the number 1985
B. The cast converts the *address*, not the text --- parse with `strtol`
C. `year_str` must be declared as a `char[]`, not a `char *`
D. `(int)` should be `(long)`
E. Ben got this wrong

*Answer: B*

- Magic does not happen when you cast --- the pointer's numeric value gets chopped to fit an `int`.
- The compiler even warns: `cast from pointer to integer of different size`.

## 1. `<stdio.h>`: `printf` Out, `scanf` In (7 min)

- `<stdio.h>` replaces `iostream` --- everything flows through `FILE *`, an opaque pointer that tracks the state of an I/O stream.
- `printf`/`scanf` for formatted text, `fopen`/`fclose` for files, `fread`/`fwrite` for raw bytes.
- This is the last new-material lecture --- after today you have the whole C toolbox.
- You have used `printf` since lecture 1; `scanf` is its input twin.

```c
int year;
printf("Enter a year: ");
scanf("%d", &year);
printf("You entered: %d\n", year);
```

- `scanf` needs the *address* of the variable so it can store the result there.
- Forgetting the `&` compiles fine, then crashes or produces garbage at runtime.
- Arrays do not need `&` --- the array name already decays to a pointer.

```c
char name[50];
double gpa;
scanf("%49s %lf", name, &gpa);
```

- `scanf` uses `%lf` for `double`; `printf` uses `%f`.

::: {.tip}
**Trap:** `scanf("%s", ...)` reads a single word and has no bounds checking --- it will happily overflow your buffer.
Always add a width like `%49s` (49 characters plus `'\0'`).
For whole lines, `fgets(line, sizeof(line), stdin)` is safer and simpler.
:::

## 2. `stdin`, `stdout`, and `stderr` (5 min)

Three streams are already open when your program starts:

| Stream | Purpose | C++ equivalent |
|:---|:---|:---|
| `stdin` | Standard input (keyboard) | `std::cin` |
| `stdout` | Standard output (screen) | `std::cout` |
| `stderr` | Standard error (screen) | `std::cerr` |

- `printf(...)` is shorthand for `fprintf(stdout, ...)`.

```c
fprintf(stderr, "Error: file not found\n");
```

- `./program > out.txt` redirects only `stdout` --- errors still appear on the screen.
- `./program 2> err.txt` redirects `stderr` instead.

## 3. `fprintf` and `fscanf` (5 min)

```c
int fprintf(FILE *stream, const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
```

- The file versions of `printf` and `scanf` --- same format strings, plus a `FILE *` first argument.

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

- `fscanf` returns the number of items successfully read --- `== 2` means we got both, and the loop stops cleanly at end of file.
- With `scores.txt` containing `Maverick 94`, `Goose 87`, `Iceman 99`, this prints each pilot's score on its own line.

## 4. Opening and Closing Files (7 min)

```c
FILE *fopen(const char *path, const char *mode);
int fclose(FILE *stream);
```

```c
FILE *f = fopen("setlist.txt", "w");
if (f == NULL) {
    fprintf(stderr, "cannot open setlist.txt\n");
    return 1;
}
fprintf(f, "Eye of the Tiger\n");
fprintf(f, "Year: %d\n", 1982);
fclose(f);
```

- `fclose` flushes any buffered output and releases the stream.

The mode string:

| Mode | Meaning |
|:---|:---|
| `"r"` | Read (file must exist) |
| `"w"` | Write (creates or truncates) |
| `"a"` | Append (creates or appends) |
| `"r+"` | Read and write (file must exist) |
| `"w+"` | Read and write (creates or truncates) |
| `"a+"` | Read and append |

- Add `b` for binary mode: `"rb"`, `"wb"`, `"ab"`.
- On Unix, binary and text modes behave identically; on Windows, text mode translates `\r\n` to `\n` and back.

::: {.tip}
**Trap:** `fopen` returns `NULL` on failure --- a missing file, a bad path, no permission.
Always check before using the file pointer; writing through a `NULL` `FILE *` is undefined behavior.
:::

## 5. Formatting Into Strings (7 min)

- `sprintf` writes formatted output into a buffer; `sscanf` parses formatted input from a string.

```c
char buf[100];
sprintf(buf, "Track %02d: %s", 2, "Whip It");
// buf is now "Track 02: Whip It"

int track;
char title[50];
sscanf(buf, "Track %d: %49[^\n]", &track, title);
// track is 2, title is "Whip It"
```

- `%[...]` is a **scan set**: it accepts only the listed characters and stops at the first one outside the set --- `%[aeiou]` reads vowels and nothing else.
- A leading `^` negates the set, so `%79[^\n]` reads up to 79 characters of anything *except* a newline --- the `scanf` way to grab a whole line.
- That is what `%49[^\n]` does above: read the whole title, stopping at a newline (or the end of the string).

::: {.tip}
**Tip:** the POSIX `%m` modifier (glibc only, not standard C) makes `scanf` `malloc` a right-sized buffer --- `scanf("%m[^\n]", &line)` --- and you must `free` it.
:::

::: {.tip}
**Trap:** `sprintf` has the same overflow risk as `strcpy` --- it never checks the destination size.
Use `snprintf`, which will not write more than `size` bytes, null terminator included:

```c
char small[15];
snprintf(small, sizeof(small), "Jenny: %d", 8675309);
// "Jenny: 8675309" --- 14 chars + '\0' fits exactly
```
:::

::: {.tip}
**Tip:** POSIX `asprintf(&msg, ...)` formats into a `malloc`'d string of exactly the right size (glibc and friends, not standard C) --- you must `free` it.
:::

## 6. Binary I/O: `fwrite` and `fread` (6 min)

```c
size_t fwrite(const void *ptr, size_t size, size_t count,
              FILE *stream);
size_t fread(void *ptr, size_t size, size_t count, FILE *stream);
```

- Four arguments: pointer to the data, size of each element, number of elements, stream.
- Raw bytes only --- no format conversion, no text.

```c
int tracks[] = {4, 8, 15, 16};
FILE *f = fopen("tracks.bin", "wb");
fwrite(tracks, sizeof(int), 4, f);
fclose(f);
```

- The file is exactly `4 * sizeof(int)` = 16 bytes.
- Both functions return the number of *elements* transferred --- check `fread`'s return to detect a short read.

## 7. Reading Lines: `fgets` (3 min)

```c
char *fgets(char *s, int size, FILE *stream);
```

```c
char line[80];
while (fgets(line, sizeof(line), f) != NULL) {
    printf("%s", line);   // line already includes '\n'
}
```

- Stops after `size - 1` characters, at a newline (which it *keeps* in the buffer), or at end of file.
- Always null-terminates on success; returns `NULL` at end of file or on error --- which is why the `while` loop works.
- Safer than `scanf` for lines because it always respects the buffer size --- this is the line reader the earlier Trap promised.

## 8. Buffering and `fflush` (5 min)

- `stdio` does not hit the device on every call --- it accumulates output in a buffer.
- **Full buffering:** written when the buffer fills (default for files).
- **Line buffering:** written at each `\n` (default for `stdout` at a terminal).
- **Unbuffered:** written immediately (default for `stderr`).

```c
printf("Working...");
fflush(stdout);   // force output to appear now
// ... long computation ...
printf(" done!\n");
```

- Without the `fflush`, `Working...` has no `\n`, so nothing appears until the final newline --- the whole line shows up at once when the work finishes.

::: {.tip}
**Trap:** At a terminal, `\n` triggers a flush.
Redirect `stdout` to a file or pipe and it becomes *fully* buffered --- even lines ending in `\n` may not appear until the buffer fills or the program exits.
For progress indicators, call `fflush(stdout)`.
`stderr` is unbuffered, which is why error messages always appear immediately.
:::

## 9. Live Coding: Mixtape Files (8 min)

Write a text file, read it back, then round-trip binary data --- the whole chapter in one program.

```c
#include <stdio.h>

int main(void) {
    // write a text file
    FILE *f = fopen("mixtape.txt", "w");
    if (f == NULL) {
        fprintf(stderr, "cannot open mixtape.txt\n");
        return 1;
    }
    fprintf(f, "Devo %d\n", 1980);
    fprintf(f, "Survivor %d\n", 1982);
    fprintf(f, "Prince %d\n", 1984);
    fclose(f);

    // read it back with fscanf
    f = fopen("mixtape.txt", "r");
    if (f == NULL) {
        fprintf(stderr, "cannot reopen mixtape.txt\n");
        return 1;
    }
    char artist[50];
    int year;
    while (fscanf(f, "%49s %d", artist, &year) == 2) {
        printf("%s dropped a hit in %d\n", artist, year);
    }
    fclose(f);

    // binary round-trip
    int tracks[] = {4, 8, 15, 16};
    f = fopen("tracks.bin", "wb");
    fwrite(tracks, sizeof(int), 4, f);
    fclose(f);

    int back[4];
    f = fopen("tracks.bin", "rb");
    if (fread(back, sizeof(int), 4, f) != 4) {
        fprintf(stderr, "short read\n");
        return 1;
    }
    fclose(f);
    printf("%d %d %d %d\n", back[0], back[1], back[2], back[3]);

    // format into a string with snprintf
    char small[15];
    snprintf(small, sizeof(small), "Jenny: %d", 8675309);
    printf("%s\n", small);
    return 0;
}
```

Expected output:

```
Devo dropped a hit in 1980
Survivor dropped a hit in 1982
Prince dropped a hit in 1984
4 8 15 16
Jenny: 8675309
```

Experiments to run with the class:

- `cat mixtape.txt` to see the text file; `xxd tracks.bin` to see the 16 raw bytes.
- Change `"w"` to `"a"` and run twice --- the mixtape doubles.
- Remove the `&` from `&year` in the `fscanf` call and read the compiler warning.
- Run `./mixtape > out.txt` --- everything from `printf` lands in the file; only `stderr` would reach the screen.
- Shrink the buffer to `char small[8]` --- `snprintf` truncates safely to `Jenny: `, and `-Wall` warns at compile time: `'%d' directive output truncated writing 7 bytes into a region of size 1`.

## 10. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
char buf[20];
snprintf(buf, sizeof(buf), "Track %02d", 7);
printf("%zu\n", strlen(buf));
```

A. 6
B. 7
C. 8
D. 10
E. Ben got this wrong

*Answer: C*

**Q2.** Run at a terminal, what appears?

```c
printf("Working...");
sleep(2);
printf(" done!\n");
```

A. `Working...` now, ` done!` 2 seconds later
B. Nothing for 2 seconds, then `Working... done!` all at once
C. `Working...` after 2 seconds, then ` done!` 2 seconds after that
D. Nothing --- the program deadlocks without `fflush`
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

## 11. Assignment / Reading (2 min)

This was the final lecture --- congratulations, you now speak C.

**Read (optional):** chapters 11 (Low-Level I/O) and 12 (Odds and Ends) of *Gorgo C for C++ Programmers*, for the curious --- file descriptors, `qsort`, and the odds and ends we did not have time for.
**Exam prep:** review the study guides in `c4c++/study-guides/` and redo the wrap-up quizzes from lectures 1-8.

## Key Points to Reinforce

- `printf` writes to `stdout`; `fprintf` writes to any `FILE *`
- `scanf` needs `&` for scalars; arrays decay, so no `&`
- `fopen` returns `NULL` on failure --- always check before using the pointer
- Add `"b"` to the mode string for binary files; it matters on Windows
- `fread`/`fwrite` move raw bytes: pointer, element size, count, stream
- `fgets` reads at most `size - 1` chars, keeps the newline, and returns `NULL` at end of file
- `sprintf` can overflow; `snprintf` takes the buffer size and never exceeds it
- `stdout` is line buffered at a terminal, fully buffered when redirected; `fflush` forces output out
- C's whole I/O story is return values --- no exceptions, so check them
