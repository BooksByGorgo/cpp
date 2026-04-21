# Lecture 14 --- std::format and std::print

**Source:** `sc++/ch10.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Use `std::format` with `{}` placeholders to produce formatted strings
- Distinguish **implicit** (`{}`) and **indexed** (`{0}`, `{1}`) argument numbering --- and remember they cannot be mixed
- Apply format specifiers for width, alignment (`<`, `>`, `^`), fill characters, sign, and base prefix
- Control floating-point precision with `{:.Nf}` and integer base with `{:x}`, `{:o}`, `{:b}`
- Use `std::print` and `std::println` to print formatted output in one call

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`) --- C++23 is required for `<print>`
- A text editor projected for the class
- Copies of `sc++/ch10.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 13): **What is wrong with this file-writing code?**

    ```cpp
    std::ofstream out;
    out << "Yo me la paso bien\n";
    out.close();
    ```

    - A. Missing `#include <fstream>`
    - B. No filename was passed to the constructor --- the stream is not attached to a file
    - C. `\n` should be `std::endl`
    - D. You cannot `<<` to an `ofstream`
    - E. Ben got this wrong

    *Answer: B*

- Last lecture we saw streams and `std::setw`/`std::setprecision`. Today we replace them with something much nicer.

## 1. Motivation (5 min)

```cpp
// old way --- hard to read
std::cout << std::fixed << std::setprecision(2)
          << std::setw(10) << score << "\n";

// new way --- much clearer
std::println("{:10.2f}", score);
```

- Chaining `<<` with manipulators is verbose and sticky
- `std::format` (C++20) and `std::print`/`std::println` (C++23) give you clean format strings

## 2. `std::format` Basics (8 min)

Include `<format>`. Returns a `std::string`.

```cpp
#include <format>
#include <iostream>
#include <string>

int main() {
    std::string artist = "Santana";
    int year = 1999;

    std::string msg = std::format("{} --- Smooth ({})", artist, year);
    std::cout << msg << "\n";
    // Santana --- Smooth (1999)
}
```

- `{}` placeholders are substituted **in order** (implicit numbering)
- Each argument can be any type the library knows how to format

## 3. Indexed Arguments (6 min)

```cpp
std::format("{1} --- {0} ({2})", "Santana", "Smooth", 1999);
// "Smooth --- Santana (1999)"

std::format("{0}, {0}, {0}!", "yeah");
// "yeah, yeah, yeah!"
```

- Numbers inside the braces are zero-based argument indices
- Great for reordering or repeating arguments

::: {.tip}
**Trap:** You **cannot mix** implicit `{}` and indexed `{0}` in the same format string. `std::format("{},{1}", 1, "hi")` is a compile error. Pick one style.
:::

## 4. Format Specifiers --- Width and Alignment (10 min)

The general form is `{index:spec}` where `spec` is `[[fill]align][sign][#][0][width][.prec][type]`.

```cpp
std::format("{:>10}", "hola");    // "      hola"  (right-align)
std::format("{:<10}", "hola");    // "hola      "  (left-align)
std::format("{:^10}", "hola");    // "   hola   "  (center)
```

### Fill Characters

```cpp
std::format("{:*>10}", "hola");   // "******hola"
std::format("{:-^20}", "Smooth"); // "-------Smooth-------"
```

- `fill` is any character, `align` is `<`, `>`, or `^`
- Omit `fill` and you get a space

## 5. Format Specifiers --- Numbers (10 min)

### Sign

```cpp
std::format("{:+}", 42);   // "+42"  (always show sign)
std::format("{:-}", 42);   // "42"   (default)
std::format("{: }", 42);   // " 42"  (space where + would go)
```

### Alternate Form and Zero-padding

```cpp
std::format("{:#x}", 255);      // "0xff"
std::format("{:#b}", 10);       // "0b1010"
std::format("{:05}", 42);       // "00042"
std::format("{:#010x}", 255);   // "0x000000ff"
```

### Base Types

```cpp
std::format("{:d}", 42);    // "42"  (decimal)
std::format("{:x}", 255);   // "ff"  (hex)
std::format("{:o}", 8);     // "10"  (octal)
std::format("{:b}", 10);    // "1010"(binary)
```

## 6. Floating-Point Precision (8 min)

```cpp
std::format("{:.2f}",  3.14159);   // "3.14"
std::format("{:.4f}",  2.5);       // "2.5000"
std::format("{:10.2f}", 3.14);     // "      3.14"
```

- `.N` controls decimal places
- `f` is fixed-point; omit for default "general" formatting
- Combine with width/alignment as needed

## 7. `std::print` and `std::println` (C++23) (10 min)

Include `<print>`. Combine `std::format` and `std::cout` in one call.

```cpp
#include <print>

int main() {
    std::println("You get what you give, don't let go");
    std::print("Track {:d}: {}", 1, "You Get What You Give");
    std::println("");

    double score = 9.5;
    std::println("Rating: {:.1f}/10", score);
}
```

- `std::print` --- no trailing newline
- `std::println` --- adds a newline

::: {.tip}
**Wut:** `std::print` and `std::println` require **C++23**. If your compiler does not have `<print>` yet, fall back to `std::cout << std::format(...)`.
:::

## 8. Try It --- Formatted Table (10 min)

```cpp
#include <format>
#include <iostream>

int main() {
    std::cout << std::format("{:<20} {:>5} {:>8}\n", "Song", "Year", "Score");
    std::cout << std::string(35, '-') << "\n";
    std::cout << std::format("{:<20} {:>5} {:>8.1f}\n", "Wonderwall", 1995, 9.5);
    std::cout << std::format("{:<20} {:>5} {:>8.1f}\n", "Jumper",     1997, 9.8);
    std::cout << std::format("{:<20} {:>5} {:>8.1f}\n", "Say My Name",1999, 8.7);
}
```

Output:

```
Song                  Year    Score
-----------------------------------
Wonderwall            1995      9.5
Jumper                1997      9.8
Say My Name           1999      8.7
```

Have the class predict the output before running.

## 9. Wrap-up Quiz (5 min)

**Q1.** What does `std::format("{:>8.2f}", 3.1)` produce?

A. `"3.10"`
B. `"    3.10"`
C. `"3.1     "`
D. `"00003.10"`
E. Ben got this wrong

*Answer: B* --- width 8, right-aligned, 2 decimals.

**Q2.** What is wrong with this code?

```cpp
std::string result = std::format("{} scored {1} points", name, score);
```

A. Missing `#include <format>`
B. Cannot mix implicit `{}` and indexed `{1}`
C. `score` must be a string
D. You cannot have a space inside a format string
E. Ben got this wrong

*Answer: B*

**Q3.** What does `std::format("{:*^20}", "Hola")` produce?

A. `"****Hola************"`
B. `"********Hola********"`
C. `"Hola****************"`
D. `"********Hola"`
E. Ben got this wrong

*Answer: B* --- center-aligned in a field of 20 with `*` as fill.

## 10. Assignment / Reading (2 min)

- **Read:** chapter 11 of *Gorgo Starting C++* (Exceptions, `std::expected`)
- **Do:** all 9 exercises at the end of chapter 11
- **Bring:** any program from this term that could benefit from `std::format` --- we may use it as an example

## Key Points to Reinforce

- `std::format` returns a `std::string` --- `std::print`/`std::println` write directly
- Implicit `{}` and indexed `{0}` cannot be mixed
- Spec grammar: `[[fill]align][sign][#][0][width][.prec][type]`
- `{:.Nf}` for floats, `{:x}`/`{:o}`/`{:b}` for bases, `#` for base prefix
- Prefer `std::format`/`std::println` over `<<` with `std::setw`/`std::setprecision`
