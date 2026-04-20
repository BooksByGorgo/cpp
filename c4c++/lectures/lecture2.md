# Lecture 2 --- Strings

**Source:** `c4c++/ch03.md`
**Duration:** 50 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Describe a C string as a `char` array ended by `'\0'`
- Explain the difference between `char arr[] = "..."` and `const char *p = "..."`
- Use `strlen`, `strcpy`/`strncpy`, `strcmp`/`strncmp`, `strchr`, `strstr`
- Use `strcat`/`strncat` safely and identify buffer-overflow risk
- Use `strdup` and pair it with `free`
- Tokenize a string with `strtok`/`strtok_r` and explain the gotchas
- Classify characters with `<ctype.h>` and use the `(unsigned char)` cast

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Copy of `c4c++/ch03.md` for reference

---

## 0. Review (5 min)

Review multiple choice from lecture 1:

**Q.** What does this print?

```c
printf("%05d %x\n", 42, 255);
```

A. `00042 ff`
B. `42 255`
C. `   42  ff`
D. `00042 FF`
E. Ben got this wrong

*Answer: A*

## 1. What Is a C String? (5 min)

- No `std::string`.
- A "string" is a `char` array terminated by `'\0'`.
- Every string function finds the end by searching for `'\0'`.
- Size your buffers with the null terminator in mind: `"hello"` is **6 bytes**, not 5.

```c
char greeting[] = "Hola, mundo";    // 12 bytes (11 + '\0')
char band[20]   = "Depeche Mode";   // 20-byte buffer, 13 used
```

## 2. String Literals vs Arrays (5 min)

```c
char arr[]        = "I Can't Drive 55";   // modifiable copy
const char *ptr   = "I Can't Drive 55";   // pointer to read-only memory
```

- `arr[0] = 'i';` --- fine; `arr` is a local copy
- `ptr[0] = 'i';` --- compile error (good!)
- `char *bad = "...";` --- compiles, but modifying is **undefined behavior**

::: {.tip}
**Trap:** Always use `const char *` when pointing at a string literal.
:::

## 3. Core `<string.h>` Functions (15 min)

### `strlen`

```c
size_t strlen(const char *s);  // counts bytes before '\0'
```

```c
char s[] = "Take On Me";
printf("%zu\n", strlen(s));    // 10  (array is 11 bytes)
```

### `strcpy` / `strncpy`

```c
char *strcpy(char *dest, const char *src);
char *strncpy(char *dest, const char *src, size_t n);
```

- `strcpy` copies until `'\0'` --- **dest must be big enough**.
- `strncpy` caps the write at `n`, but does **not** guarantee null-termination.
- Defensive habit: `dest[sizeof(dest) - 1] = '\0';` after `strncpy`.

### `strcmp` / `strncmp`

```c
int strcmp(const char *a, const char *b);
```

- `==` on arrays compares addresses, not contents.
- Returns **0 for equal** --- think "difference between the strings."
- `strncmp(a, b, n)` is great for prefix matching.

### `strchr` / `strrchr` / `strstr`

- `strchr(s, c)` --- first occurrence of byte `c`, or `NULL`
- `strrchr(s, c)` --- last occurrence
- `strstr(h, n)` --- first occurrence of substring `n` in haystack `h`

## 4. `strcat` and the Buffer Overflow (5 min)

```c
char buf[12] = "Buenas ";         // 8 used, 4 left
strcat(buf, "noches");             // "noches" needs 7 — OVERFLOW
```

- `strcat` has no way to know the destination size.
- Overflow corrupts neighboring memory, crashes, or opens a security hole.
- Use `strncat(buf, src, sizeof(buf) - strlen(buf) - 1);` --- leave room for `'\0'`.

```c
char buf[20] = "Hello";
strncat(buf, ", World!",
        sizeof(buf) - strlen(buf) - 1);
```

## 5. `strdup` and `strtok` (5 min)

### `strdup`

```c
char *copy = strdup("Video Killed the Radio Star");
// ... use copy ...
free(copy);   // strdup calls malloc internally
```

### `strtok`

```c
char line[] = "Girls Just Want to Have Fun";
char *tok = strtok(line, " ");
while (tok != NULL) {
    puts(tok);
    tok = strtok(NULL, " ");
}
```

- **Modifies the original string** (writes `'\0'` over delimiters)
- **Not thread-safe** (hidden static state)
- Prefer `strtok_r` (POSIX) or `strtok_s` (C11 Annex K)

## 6. `<ctype.h>` (5 min)

| Predicate | True when |
|:---|:---|
| `isalpha(c)` | letter |
| `isdigit(c)` | digit |
| `isalnum(c)` | letter or digit |
| `isspace(c)` | whitespace |
| `isupper(c)` / `islower(c)` | case check |

```c
char title[] = "hysteria";
for (size_t i = 0; title[i]; i++)
    title[i] = toupper((unsigned char)title[i]);
```

::: {.tip}
**Wut:** `<ctype.h>` takes an `int`. On platforms where `char` is signed, a high-bit value sign-extends into a negative int --- **undefined behavior**. Always cast to `unsigned char` first.
:::

## 7. Live Coding: String Starter (5 min)

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
    char song[] = "Sweet Dreams";
    printf("'%s' (%zu chars)\n", song, strlen(song));

    char copy[20];
    strcpy(copy, song);
    printf("copy: '%s'\n", copy);

    char greeting[30] = "Buenos ";
    strncat(greeting, "dias",
            sizeof(greeting) - strlen(greeting) - 1);
    puts(greeting);

    char *dup = strdup("Never Gonna Give You Up");
    puts(dup);
    free(dup);

    return 0;
}
```

- Compile with `cc -Wall -Wextra -pedantic`
- Swap `strncat` for `strcat` and watch the warning

## 8. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
char s[] = "Ghostbusters";
printf("%zu %zu\n", strlen(s), sizeof(s));
```

A. `12 12`
B. `12 13`
C. `13 12`
D. `13 13`
E. Ben got this wrong

*Answer: B* --- `strlen` is 12, the array holds 13 bytes including `'\0'`.

**Q2.** Where is the bug?

```c
char *greeting = "We Got the Beat";
greeting[0] = 'w';
printf("%s\n", greeting);
```

A. `printf` needs `&greeting`
B. Strings cannot be lowercase
C. Modifying a string literal is undefined behavior
D. `greeting` needs to be `char[]`
E. Both C and D

*Answer: E*

**Q3.** What does `strcmp("A", "B")` return?

A. `0`
B. A positive number
C. A negative number
D. `-1` exactly
E. Ben got this wrong

*Answer: C*

## 9. Assignment / Reading (2 min)

**Read:** chapter 6 of *Gorgo C for C++ Programmers*.
**Do:** exercises 1, 2, 3, 4, 5, 6, 7.

## Key Points to Reinforce

- C strings = `char[]` + `'\0'`
- Always leave room for the null terminator
- Use `const char *` for string literals
- `==` compares addresses; use `strcmp`
- `strcpy`, `strcat` have no bounds checks --- prefer `strncpy`/`strncat`
- `strdup` calls `malloc`; match it with `free`
- `strtok` is destructive and non-reentrant --- prefer `strtok_r`/`strtok_s`
- Cast to `unsigned char` before `<ctype.h>` calls
