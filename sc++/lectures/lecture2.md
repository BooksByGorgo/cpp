# Lecture 2 --- Variables

**Source:** `sc++/ch02.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Name the fundamental C++ types (`int`, `char`, `float`, `double`, `bool`) and their common sizes
- Declare and initialize variables, and explain why uninitialized variables are dangerous
- Use `sizeof` and `std::numeric_limits<T>` to reason about memory and ranges
- Declare one-dimensional and two-dimensional arrays and index them safely
- Mark a value as read-only with `const`, including both flavors of `const` with pointers
- Group related fields together with a `struct` and access members with the `.` operator

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch02.md` for reference

---

## 0. Welcome and Review (5 min)

- Quick recap of lecture 1: `main()`, `std::cout`, `std::cin`, `argc`/`argv`, and the `-Wall -Wextra -pedantic` flag
- Collect and answer any lingering `hello.cpp` questions from the assigned reading
- Review multiple choice (from lecture 1): **If the user types `Los Del Rio`, what does `std::cin >> name` store in `name`?**
    - A. `Los Del Rio`
    - B. `Los`
    - C. `Rio`
    - D. an empty string
    - E. `Ben got this wrong`

    *Answer: B* --- `>>` stops at whitespace. For the whole line you need `std::getline`.

## 1. Why Variables? (3 min)

- Without variables you can only use literal values --- no way to remember a score, accumulate a total, or compare two inputs
- A variable gives a **name** to a piece of memory that holds a typed value
- In C++, every variable has a **type**, set at compile time
- "Object" in C++ just means "a region of memory with a type" --- it does not imply classes (yet)

## 2. Basic Types (10 min)

Write these on the board and live-code `sizeof` to confirm:

```cpp
int score = 99;
short small = 42;
long big = 1'000'000L;
long long huge = 9'000'000'000LL;

unsigned int positive_only = 42;

float price = 9.99f;
double pi = 3.14159265358979;

char grade = 'A';
bool game_over = false;
```

- Integer types differ in **size** and **range** --- walk the typical sizes table from the chapter
- Prefer `double` over `float` unless you have a reason
- A `char` is a tiny integer --- `'A'` is 65, and `letter + 1` is `'B'`
- Single quotes for chars, double quotes for strings

::: {.tip}
**Trap:** Mixing signed and unsigned in a comparison can silently convert the negative value to a very large positive number. Keep your types consistent.
:::

## 3. Declaring and Initializing Variables (5 min)

```cpp
int waterfalls = 3;
int x = 0, y = 0, z = 0;

int count;          // uninitialized --- garbage!
```

- Spell out the type on the left, assign a value on the right
- You can declare multiple variables of the same type in one statement
- Uninitialized variables contain **whatever garbage was previously in that memory**

Show `auto`:

```cpp
auto waterfalls = 3;      // int
auto speed = 88.0;        // double
auto initial = 'T';       // char
```

- `auto` asks the compiler to deduce the type from the initializer --- C++ is still strictly typed
- Use `auto` when the type is obvious or painfully long; spell it out when it is not

## 4. sizeof and std::numeric_limits (8 min)

```cpp
#include <iostream>
#include <limits>

int main() {
    std::cout << "int: " << sizeof(int) << " bytes\n";
    std::cout << "int max: " << std::numeric_limits<int>::max() << "\n";
    std::cout << "double max: " << std::numeric_limits<double>::max() << "\n";
    return 0;
}
```

- `sizeof(type)` --- parens required for a type; optional for a variable or expression
- `sizeof(char)` is **always** 1, by definition
- `std::numeric_limits<T>::min()`, `max()`, `lowest()` live in `<limits>`

::: {.tip}
**Wut:** For floating-point types, `min()` is the smallest positive normal value, not the most negative value. Use `lowest()` for the most negative.
:::

## 5. Arrays (15 min)

```cpp
int scores[5] = {99, 85, 73, 91, 100};

std::cout << scores[0] << "\n";   // 99
std::cout << scores[4] << "\n";   // 100
```

- Fixed size, same-type elements, contiguous memory
- Indices start at **0** and go to **size - 1**
- Let the compiler count for you: `int primes[] = {2, 3, 5, 7, 11};`
- Element count trick: `sizeof(primes) / sizeof(primes[0])`

::: {.tip}
**Trap:** `scores[5]` in a 5-element array is **undefined behavior**. C++ does not bounds-check --- your program may crash, corrupt memory, or seem to work until it does not.
:::

### 2D Arrays

```cpp
int grid[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
};
```

- Think "3 rows of 4 ints each"
- First index is row, second is column
- Elements are stored row by row in memory, so `grid[0][3]` and `grid[1][0]` are neighbors

Live-demo: build a 5x5 multiplication table with nested `for` loops (preview of chapter 5).

## 6. const (8 min)

```cpp
const double PI = 3.14159265358979;
const int MAX_LIVES = 3;
```

- Once initialized, a `const` variable cannot change
- The compiler catches accidental modifications for you
- Style: use `const` liberally to express intent

### const With Pointers

```cpp
int vida = 99;

const int *p1 = &vida;     // pointer to const int
int *const p2 = &vida;     // const pointer to int
const int *const p3 = &vida; // both
```

- `const int *p1` --- cannot change the value through `p1`; can repoint `p1`
- `int *const p2` --- can change the value through `p2`; cannot repoint `p2`
- `const int *const p3` --- cannot do either

::: {.tip}
**Tip:** Read pointer declarations **right to left**. `int *const p` reads as "p is a const pointer to int" --- the pointer is const.
:::

## 7. Structures (12 min)

```cpp
struct Song {
    std::string title;
    std::string artist;
    int year;
};
```

- A `struct` groups related fields under one type
- Each field is a **member**
- Access members with the **dot operator**: `favorite.title`

```cpp
Song favorite;
favorite.title = "Waterfalls";
favorite.artist = "TLC";
favorite.year = 1995;

std::cout << favorite.title << " by " << favorite.artist
          << " (" << favorite.year << ")\n";
```

Brace initialization is shorter:

```cpp
Song hit = {"No Scrubs", "TLC", 1999};
```

### Structure Assignment Is a Copy

```cpp
Song a = {"Livin' La Vida Loca", "Ricky Martin", 1999};
Song b = a;
b.year = 2000;

std::cout << a.year << "\n";   // 1999 (unchanged)
std::cout << b.year << "\n";   // 2000
```

- `b = a` copies **every member**; `b` has its own storage
- This matters when structs get large --- we will revisit in chapter 6 (Functions)

## 8. Try It --- Live Demo (5 min)

```cpp
#include <iostream>
#include <string>

struct Cancion {
    std::string titulo;
    std::string artista;
    int anio;
};

int main() {
    Cancion playlist[3] = {
        {"Waterfalls", "TLC", 1995},
        {"No Scrubs", "TLC", 1999},
        {"Livin' La Vida Loca", "Ricky Martin", 1999}
    };

    int count = sizeof(playlist) / sizeof(playlist[0]);

    for (int i = 0; i < count; i++) {
        std::cout << playlist[i].titulo << " - " << playlist[i].artista
                  << " (" << playlist[i].anio << ")\n";
    }
    return 0;
}
```

Invite the class to predict the output before you run it. Then add a fourth song and recount.

## 9. Wrap-up Quiz Questions (3 min)

**Q1.** On a system where `int` is 4 bytes, what is `sizeof(scores)` for `int scores[10]`?

A. 4
B. 10
C. 14
D. 40
E. Ben got this wrong

*Answer: D*

**Q2.** What does this print?

```cpp
#include <iostream>
int main() {
    char c = 'C';
    c = c + 3;
    std::cout << c << "\n";
}
```

A. `C3`
B. `C`
C. `F`
D. `70`
E. Ben got this wrong

*Answer: C* --- `'C'` is 67, plus 3 is 70, which is `'F'`.

**Q3.** Which declaration lets you change the value of `*p` but **not** what `p` points to?

A. `const int *p`
B. `int const *p`
C. `int *const p`
D. `const int *const p`
E. Ben got this wrong

*Answer: C*

## 10. Assignment / Reading (1 min)

- **Read:** chapter 3 of *Gorgo Starting C++*
- **Do:** all 9 exercises at the end of chapter 3
- **Bring:** a working program that declares a `struct` and prints it --- we will reuse it next lecture

## Key Points to Reinforce

- Every variable has a type; the type sets the size and the legal operations
- Always initialize --- uninitialized variables contain garbage
- `sizeof` is in bytes; `std::numeric_limits<T>` is for min/max/lowest
- Arrays are fixed-size and zero-indexed; no bounds checking
- Read pointer `const` right to left
- `struct` groups fields; assignment copies every member
