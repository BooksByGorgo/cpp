# Lecture 11+12 --- Containers

**Source:** `sc++/ch08.md`
**Duration:** 2 x 75 minutes (lectures 11 and 12)

Chapter 8 is split across two lectures:

- **Lecture 11 --- Array and Vector Basics:** `std::array` (fixed size), `std::vector` construction, `push_back`/`pop_back`, `[]`/`.at()`/`.front()`/`.back()`, `size`/`capacity`/`empty`/`clear`
- **Lecture 12 --- Mutation and Iteration:** `insert`/`erase`/`reserve`/`shrink_to_fit`, range-based `for`, iterators, `.begin()`/`.end()` and `auto`

---

# Lecture 11 --- Array and Vector Basics

## Learning Objectives

By the end of lecture 11, students should be able to:

- Declare and use a `std::array<T, N>` and explain why size is part of the type
- Declare a `std::vector<T>` with several construction styles
- Add and remove elements at the end with `push_back` / `pop_back`
- Access elements with `[]`, `.at()`, `.front()`, and `.back()`
- Distinguish **size** from **capacity** and explain why capacity grows in jumps
- Clear and check a vector with `.clear()` and `.empty()`

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch08.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 10): **What does this print?**

    ```cpp
    uint8_t a = 250;
    uint8_t b = 20;
    uint8_t sum = a + b;
    std::println("{}", sum);
    ```

    - A. 270
    - B. 255
    - C. 14
    - D. undefined behavior
    - E. Ben got this wrong

    *Answer: C* --- unsigned wraps.

- Today we leave raw C arrays behind and meet the standard library containers

## 1. The Trouble With C-Style Arrays (5 min)

Review of chapter 2 pain points:

- They do not know their own size
- They decay to pointers when passed to functions (size is lost)
- You cannot return them
- They cannot grow or shrink at runtime
- You pass a separate size parameter everywhere and hope nothing goes out of bounds

The standard library fixes all of this.

## 2. `std::array<T, N>` (15 min)

Include `<array>`. Size is part of the type.

```cpp
#include <array>

std::array<int, 5> scores = {90, 85, 92, 88, 76};

std::cout << scores[0] << "\n";       // 90 (fast, no bounds check)
std::cout << scores.at(1) << "\n";    // 85 (bounds checked, throws on bad index)
std::cout << scores.size() << "\n";   // 5
```

- `std::array<int, 5>` and `std::array<int, 10>` are **different types**
- `.size()` is `constexpr` and known at compile time

### Passing to Functions

```cpp
void print_scores(const std::array<int, 3>& scores) {
    for (size_t i = 0; i < scores.size(); i++) {
        std::cout << scores[i] << "\n";
    }
}
```

- The function **knows** the size --- no separate parameter required

::: {.tip}
**Trap:** The size of a `std::array` must be a **compile-time constant**. You cannot use `std::array<int, n>` where `n` is a variable. Use `std::vector` for runtime-sized collections.
:::

## 3. `std::vector<T>` --- Introduction (8 min)

Include `<vector>`. Dynamic size, grows as needed.

```cpp
#include <vector>

std::vector<int> empty;                // size 0
std::vector<int> zeros(5);             // 5 zeros
std::vector<int> fives(5, 42);         // 5 copies of 42
std::vector<std::string> songs =
    {"Wannabe", "No Diggity"};         // initializer list
```

- The workhorse container of C++ --- use it for almost everything

## 4. Growing a Vector --- `push_back` / `pop_back` (10 min)

```cpp
std::vector<std::string> playlist;

playlist.push_back("Wannabe");
playlist.push_back("No Diggity");
std::cout << playlist.size() << "\n";   // 2

playlist.pop_back();
std::cout << playlist.size() << "\n";   // 1
```

- `push_back` adds one element at the end
- `pop_back` removes the last element (does **not** return it)

::: {.tip}
**Trap:** `pop_back()` on an **empty** vector is undefined behavior. Always check `.empty()` or `.size()` first.
:::

## 5. Accessing Elements (7 min)

```cpp
std::vector<std::string> bands = {"Spice Girls", "Blackstreet", "Oasis"};

std::cout << bands[0]      << "\n";   // Spice Girls --- no bounds check
std::cout << bands.at(1)   << "\n";   // Blackstreet --- bounds checked
std::cout << bands.front() << "\n";   // Spice Girls
std::cout << bands.back()  << "\n";   // Oasis
```

- `.at()` throws `std::out_of_range` for bad indices
- `.front()` / `.back()` are convenient shortcuts for the first/last element

## 6. Size, Capacity, and Empty (15 min)

**Two different numbers:**

- `.size()` --- how many elements the vector **holds**
- `.capacity()` --- how much memory it has **allocated**

```cpp
std::vector<int> v;
for (int i = 0; i < 5; i++) {
    v.push_back(i * 10);
    std::cout << "size=" << v.size()
              << " cap=" << v.capacity() << "\n";
}
```

Typical output:

```
size=1 cap=1
size=2 cap=2
size=3 cap=4
size=4 cap=4
size=5 cap=8
```

- Capacity grows in jumps (typically doubling)
- When capacity is exhausted, the vector **reallocates** a bigger block and copies everything
- `push_back` is amortized O(1): mostly fast, occasionally does extra work

### `empty` and `clear`

```cpp
if (v.empty()) { /* size() == 0 */ }

v.clear();    // size -> 0
```

::: {.tip}
**Wut:** After `v.clear()`, `v.size()` is 0 but `v.capacity()` is **unchanged**. The memory is kept for future use.
:::

## 7. Try It --- Live Demo (7 min)

```cpp
#include <iostream>
#include <vector>

int main()
{
    std::vector<int> v;
    for (int i = 0; i < 8; i++) {
        v.push_back(i);
        std::cout << "size=" << v.size()
                  << " cap=" << v.capacity() << "\n";
    }
}
```

Have the class predict when the next reallocation happens.

## 8. Wrap-up Quiz (3 min)

**Q1.** What does this print?

```cpp
std::vector<int> v = {10, 20, 30};
v.push_back(40);
v.pop_back();
v.pop_back();
std::cout << v.size() << " " << v.back() << "\n";
```

A. `3 30`
B. `2 20`
C. `2 30`
D. `4 30`
E. Ben got this wrong

*Answer: B*

**Q2.** What does this print?

```cpp
std::vector<int> v = {1, 2, 3};
v.clear();
std::cout << v.size() << " " << v.empty() << "\n";
```

A. `0 0`
B. `0 1`
C. `3 0`
D. `3 1`
E. Ben got this wrong

*Answer: B* --- `.empty()` returns `true` (which prints as `1`).

## 9. Assignment / Reading (5 min)

- **Read:** chapter 8, remaining sections --- insert/erase/reserve, range-based for with references, iterators and `auto`
- **Do:** chapter 8 exercises 4, 6, 7, 9, 11, 12 (iteration, insert/erase/reserve, auto references)
- **Bring:** questions about capacity growth if anything was surprising

## Key Points to Reinforce

- `std::array` is compile-time sized; `std::vector` is runtime-sized
- `[]` is fast, `.at()` is safe
- Vector capacity grows in jumps; `.clear()` keeps the memory
- Never `pop_back` an empty vector

---

# Lecture 12 --- Mutation and Iteration

## Learning Objectives

By the end of lecture 12, students should be able to:

- Use `insert` and `erase` to modify a vector at any position
- Preallocate with `reserve` and shrink with `shrink_to_fit`
- Iterate with a range-based `for` loop using `const auto&` or `auto&` as appropriate
- Use `.begin()` / `.end()` iterators and dereference with `*it`
- Recognize iterator **invalidation** after insert/erase

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch08.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 11): **A vector has size 3 and capacity 8. How many more `push_back` calls before it reallocates?**
    - A. 3
    - B. 5
    - C. 7
    - D. 8
    - E. Ben got this wrong

    *Answer: B* --- capacity 8 minus current size 3 = 5 more elements fit without reallocation.

- Today we finish chapter 8 with **mutation in the middle** and **iteration**

## 1. Insert and Erase (15 min)

```cpp
std::vector<std::string> lista = {"Creep", "No Rain", "Linger"};

lista.insert(lista.begin() + 1, "Possum Kingdom");
// {"Creep", "Possum Kingdom", "No Rain", "Linger"}

lista.erase(lista.begin());
// {"Possum Kingdom", "No Rain", "Linger"}
```

- Position is expressed as an **iterator** --- `lista.begin() + n` means "index n"
- `insert` places the new element **before** the given position
- `erase` removes one element (or a range)

### Why They Are Slower

- Inserting in the middle shifts every subsequent element over
- Erasing shifts every subsequent element back
- Both are O(n) in the worst case --- prefer `push_back`/`pop_back` when you can

::: {.tip}
**Trap:** Insert and erase **invalidate** iterators, pointers, and references into the vector. After either call, get **fresh** iterators before touching the vector again.
:::

## 2. Reserve and shrink_to_fit (10 min)

```cpp
std::vector<int> v;
v.reserve(1000);   // allocate space for 1000 ints
// v.size() == 0, v.capacity() >= 1000
```

- `reserve(n)` preallocates capacity so subsequent `push_back`s do not reallocate
- Use it when you **know** how many elements you will add

```cpp
v.shrink_to_fit();   // non-binding request to match capacity to size
```

- `shrink_to_fit` asks the implementation to release excess memory
- It is **non-binding** --- the implementation may ignore it

## 3. Range-Based `for` Loop (15 min)

```cpp
std::vector<std::string> songs = {"Wannabe", "No Diggity"};

for (const auto& song : songs) {
    std::cout << song << "\n";
}
```

Breakdown:

- `auto` --- let the compiler deduce the type
- `&` --- reference, no copy
- `const` --- promise not to modify

### Modifying Elements

```cpp
std::vector<int> values = {1, 2, 3, 4, 5};

for (auto& v : values) {
    v *= 10;
}
// {10, 20, 30, 40, 50}
```

::: {.tip}
**Tip:** Prefer `const auto&` when reading. Use `auto&` when modifying. **Avoid** plain `auto` (no `&`) for anything larger than a primitive --- it copies every element.
:::

## 4. Iterators (15 min)

Under the hood, range-based `for` uses **iterators**.

```cpp
std::vector<std::string> canciones = {"Wannabe", "No Diggity"};

for (auto it = canciones.begin(); it != canciones.end(); ++it) {
    std::cout << *it << "\n";
}
```

- `.begin()` returns an iterator to the first element
- `.end()` returns an iterator **one past** the last element --- not at the last element
- `*it` dereferences (like a pointer) to get the element
- `++it` advances to the next element

::: {.tip}
**Wut:** `.end()` points **past** the last element, not at it. The valid range is `[begin, end)` --- a half-open interval. It makes loops cleaner and avoids off-by-one errors.
:::

### `auto` With Iterators

```cpp
// without auto
std::vector<std::string>::iterator it = canciones.begin();

// with auto
auto it = canciones.begin();
```

- `auto` shines here --- iterator types are long and the type is obvious from context

### Why Use Iterators Directly?

- Standard library algorithms require them (sort, find, copy, ...)
- You can iterate backward (`rbegin`/`rend`)
- You can erase while iterating safely

## 5. Try It --- Live Demo (6 min)

```cpp
#include <iostream>
#include <vector>

int main()
{
    std::vector<int> nums = {1, 2, 3, 4, 5};

    for (auto& n : nums) {
        n *= 2;
    }

    for (const auto& n : nums) {
        std::cout << n << " ";
    }
    std::cout << "\n";
}
```

Walk through how the range-based form rewrites to an explicit iterator loop.

## 6. Wrap-up Quiz (4 min)

**Q1.** What does this print?

```cpp
std::vector<int> v = {10, 20, 30, 40, 50};
v.insert(v.begin() + 2, 25);
v.erase(v.begin());
for (const auto& n : v) { std::cout << n << " "; }
std::cout << "\n";
```

A. `10 20 25 30 40 50`
B. `20 25 30 40 50`
C. `20 25 30 40`
D. `10 25 30 40 50`
E. Ben got this wrong

*Answer: B*

**Q2.** Where is the bug?

```cpp
std::vector<int> scores = {95, 87, 91};
for (int i = 0; i <= scores.size(); i++) {
    std::cout << scores[i] << "\n";
}
```

A. `scores` cannot be iterated
B. `[]` does not work on `std::vector`
C. `<=` should be `<` --- reads one past the end
D. `i` should be `size_t`
E. Both C and D --- Ben got this wrong

*Answer: E* --- the `<=` causes an off-by-one read past the last element, and `int` vs `size_t` is a signed/unsigned mismatch.

**Q3.** Why is `for (auto x : vec)` usually wrong for `std::vector<std::string>`?

A. It does not compile
B. It copies every string on each iteration
C. It modifies the original vector
D. It only works for vectors of ints
E. Ben got this wrong

*Answer: B*

## 7. Assignment / Reading (5 min)

- **Read:** chapter 9 of *Starting C++* (I/O streams --- string streams, file streams, stream manipulators)
- **Do:** all 9 exercises at the end of chapter 9
- **Bring:** a plain-text file with 3-5 lines for next lecture's file-reading demo

## Key Points to Reinforce

- `insert`/`erase` shift elements; prefer end operations when you can
- Insert/erase **invalidate** iterators --- get fresh ones afterward
- Range-based `for` with `const auto&` is the default for read-only loops
- `.end()` is **one past** the last element --- half-open interval `[begin, end)`
- `auto` saves you from writing `std::vector<T>::iterator` by hand
