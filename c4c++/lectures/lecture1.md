# Lecture 1 --- Introduction to C

**Source:** `c4c++/ch01.md`
**Duration:** 50 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Describe how modern C has diverged from C++ and list the major feature differences
- Compile a C program with `cc` and explain why the extension is `.c`
- Use `printf` with the format specifiers `%d`, `%x`, `%X`, `%f`, `%e`, `%c`, `%s`, `%p`, and `%zu`
- Control width, precision, and zero-fill in `printf` output
- Use `scanf` with `%d` and `%s` and explain why `&` is needed on scalar arguments but not arrays
- Identify common `printf`/`scanf` traps (format-string attacks, mismatched specifiers, missing `&`, unbounded `%s`)

## Materials

- Live coding terminal with `cc` (`cc -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copy of `c4c++/ch01.md` for reference

---

## 0. Welcome (3 min)

- No review question --- this is the first lecture.
- What this course is: a bridge from modern C++ back to C.
- Why it matters: operating systems, embedded firmware, database engines, runtimes, and almost every C++ codebase you will ever touch include some C.

## 1. C and C++ Are Different Languages (5 min)

- In the beginning, `cfront` literally translated C++ into C before compiling.
- Modern C++ adds `std::string`, `std::vector`, smart pointers, RAII, templates, `iostream`, exceptions --- none of these exist in C.
- Your modern C++ instincts will not carry you through a C codebase.

The high-level differences table from the chapter:

| C++ | C |
|:---|:---|
| `std::string` | `char` arrays with `'\0'` |
| `std::vector` | raw arrays or `malloc` |
| `std::cout` / `std::println` | `printf` |
| `std::cin` | `scanf` |
| `new` / `delete` | `malloc` / `free` |
| smart pointers | raw pointers (only option) |
| classes and objects | structs and functions |
| references (`&`) | pointers (`*`) |
| `bool` built-in | `_Bool` or `<stdbool.h>` |
| `// comments` | `/* comments */` (C89); `//` since C99 |

## 2. Hello, World in C (5 min)

```c
#include <stdio.h>

int main(void) {
    printf("hello, world\n");
    return 0;
}
```

- Source file ends in `.c`, not `.cpp`.
- Compile with `cc hello.c` (not `c++`).
- `printf` comes from `<stdio.h>` --- no `std::cout`, no `std::println`.
- `\n` at the end --- `printf` does not add a newline for you.

::: {.tip}
**Tip:** If you compile a `.c` file with `c++`, the compiler may accept syntax real C rejects. Always use `cc`.
:::

## 3. `printf` Format Specifiers (10 min)

```c
int printf(const char *format, ...);
```

The first argument is a format string.
`%`-prefixed specifiers consume one argument each:

| Specifier | Type | Output for 255 / "hola" / 3.14 |
|:---|:---|:---|
| `%d` | `int` (decimal) | `255` |
| `%x` | `int` (hex, lower) | `ff` |
| `%X` | `int` (hex, upper) | `FF` |
| `%f` | `double` | `3.140000` |
| `%e` | `double` (scientific) | `3.140000e+00` |
| `%c` | `char` | `A` |
| `%s` | `char *` | `hola` |
| `%p` | pointer (cast to `void *`) | `0x7ffd...` |
| `%zu` | `size_t` | `4` |

### Width, precision, zero-fill

```c
printf("Score: %f\n", 98.6);    // 98.600000  (default: 6 decimals)
printf("Score: %.2f\n", 98.6);  // 98.60
printf("Track %02d\n", 3);       // Track 03
printf("%06X\n", 0xFF8800);      // FF8800
printf("%d%%\n", 95);            // 95%  (%% prints a literal %)
```

### Traps

- **Format-string attack:** never write `printf(str)` with a user-controlled `str`. Always write `printf("%s", str)`.
- **Mismatched specifier/type:** `printf("%d\n", 3.14)` is undefined behavior. The compiler may warn but will not stop you.

## 4. `scanf` for Input (10 min)

```c
int scanf(const char *format, ...);
```

```c
int age;
scanf("%d", &age);     // & because scanf fills in the variable
```

- `scanf` uses format specifiers like `printf`, but it fills in variables.
- C has no references --- we give `scanf` the **address** of the variable with `&`.
- Arrays already decay to addresses, so no `&` on array arguments.

```c
char name[50];
scanf("%49s", name);   // no & — name is already an address
```

- `%s` reads only until the first whitespace; `Rick James` stops at `"Rick"`.
- `scanf` returns the number of items read, or `EOF`.

```c
int track;
char name[50];
if (scanf("%d %s", &track, name) != 2) {
    printf("I needed a number and a name\n");
}
```

### Traps

- Forgetting `&`: `scanf("%d", age);` compiles with a warning and crashes at runtime.
- Unbounded `%s`: use `%49s` to stop at 49 characters in a 50-byte buffer.

::: {.tip}
**Trap:** `scanf` does no bounds checking on `%s`. Always cap with a width specifier.
:::

## 5. Live Coding: Try It (10 min)

Type in and run the chapter's Try It program in class:

```c
#include <stdio.h>

int main(void) {
    int num;

    printf("Enter a number: ");
    scanf("%d", &num);

    printf("Integer: %d\n", num);
    printf("Hex:     %x (lower)  %X (upper)\n", num, num);
    printf("Char:    %c\n", num);
    printf("Float:   %f\n", 3.14);
    printf("Sci:     %e\n", 3.14);
    printf("String:  %s\n", "Hola");

    printf("\nFormatted output:\n");
    for (int i = 1; i <= 3; i++)
        printf("  Track %02d\n", i);

    printf("  Pi: %.2f\n", 3.14159);
    printf("  100%% complete\n");

    return 0;
}
```

- Compile with `cc -Wall -Wextra -pedantic tryit.c`
- Drop the `\n` from `printf("Enter a number: ")` and discuss buffering (preview for lecture 10/11)
- Deliberately mismatch a specifier (`%d` with a `double`) and let the class see the warning

## 6. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
printf("%05d %x\n", 42, 255);
```

A. `00042 ff`
B. `42 255`
C. `   42  ff`
D. `00042 FF`
E. Ben got this wrong

*Answer: A*

**Q2.** Where is the bug?

```c
int count;
scanf("%d", count);
```

A. `%d` is wrong for `int`
B. Missing `&` before `count`
C. `count` is uninitialized
D. `scanf` is missing a semicolon
E. Ben got this wrong

*Answer: B*

**Q3.** What is one reason to pick `printf` over `std::cout` when writing a log file?

A. `printf` is slower, which gives prettier output
B. Format strings make the message template visible at a glance and easy to translate
C. `printf` never fails
D. `std::cout` does not support integers
E. Ben got this wrong

*Answer: B*

## 7. Assignment / Reading (2 min)

**Read:** chapter 3 of *Gorgo C for C++ Programmers*.
**Do:** exercises 1, 2, 4, 5, 7, 8.

## Key Points to Reinforce

- C and C++ are different languages --- do not expect C++ idioms to work
- `.c` files compile with `cc`; `<stdio.h>` replaces `<iostream>`
- Format specifiers must match argument types
- `scanf` needs `&` for scalar variables, not for arrays
- Always cap `%s` with a width specifier
- Never write `printf(user_string)` --- format-string attacks are a real vulnerability
