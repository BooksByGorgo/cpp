# Lecture 18+19 --- Memory Management

**Source:** `sc++/ch13.md`
**Duration:** 2 x 75 minutes (lectures 18 and 19)

Chapter 13 is split across two lectures:

- **Lecture 18 --- Pointers, `new`/`delete`, and `unique_ptr`:** stack vs heap, pointer basics (`&`, `*`, `->`, `nullptr`), `new`/`delete`/`new[]`/`delete[]`, memory leaks and dangling pointers, introduction to `std::unique_ptr` and RAII
- **Lecture 19 --- `shared_ptr` and Move Semantics:** `std::shared_ptr` with reference counting, `.get()`, `std::move` and move semantics, a complete worked example

---

# Lecture 18 --- Pointers, new/delete, and unique_ptr

## Learning Objectives

By the end of lecture 18, students should be able to:

- Distinguish stack memory (automatic) from heap memory (manual)
- Declare and dereference a pointer, and use `->` to access members
- Allocate and free heap memory with `new` / `delete` and `new[]` / `delete[]`
- Recognize memory leaks and dangling pointers
- Use `std::unique_ptr` with `std::make_unique` as the default heap allocation tool
- Explain what RAII is and why it matters

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch13.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 17): **What does this print?**

    ```cpp
    class Counter {
        int n = 0;
    public:
        Counter &add() { ++n; return *this; }
        int get() const { return n; }
    };

    Counter c;
    c.add().add().add();
    std::cout << c.get();
    ```

    - A. 0
    - B. 1
    - C. 3
    - D. compile error
    - E. Ben got this wrong

    *Answer: C*

- Today we finally get to **pointers** and **dynamic memory** --- the dark art of C++

## 1. Stack vs Heap (10 min)

**Stack** --- fast, automatic, scoped.

```cpp
void play() {
    int volume = 11;   // stack
}   // volume destroyed here
```

**Heap** --- manually allocated, persists until you free it.

- Stack: coat check (ticket in, coat out)
- Heap: storage unit (yours until you cancel the lease)

### Why You Sometimes Need the Heap

Size not known until runtime:

```cpp
int count;
std::cin >> count;
// int scores[count];   // NOT standard C++
```

Object must outlive the current scope:

```cpp
std::string *make() {
    std::string local = "Don't Speak";
    return &local;   // BUG: local is destroyed
}
```

::: {.tip}
**Tip:** Prefer the stack. Use the heap only when you must.
:::

## 2. Pointer Basics (15 min)

A **pointer** holds the address of another variable.

```cpp
int volume = 11;
int *ptr = &volume;   // ptr holds the address of volume
```

- `&` is the **address-of** operator
- `int *ptr` declares a pointer to `int`

### Dereferencing

```cpp
std::cout << *ptr << "\n";   // 11
*ptr = 5;                     // changes volume through the pointer
std::cout << volume << "\n"; // 5
```

::: {.tip}
**Wut:** `*` has three meanings depending on context: "pointer to" in a declaration, "dereference" in an expression, and "multiply" between two values. Context disambiguates.
:::

### The Arrow Operator

```cpp
struct Song { std::string title; int year; };

Song s = {"Popular", 1996};
Song *ptr = &s;

(*ptr).title;   // awkward
ptr->title;     // equivalent, clean
```

- `ptr->member` is exactly the same as `(*ptr).member`

### `nullptr`

```cpp
int *ptr = nullptr;   // points to nothing

if (ptr != nullptr) {
    std::cout << *ptr;
}
```

- Dereferencing `nullptr` is undefined behavior

## 3. `new` and `delete` (10 min)

```cpp
#include <string>

std::string *song = new std::string("Under the Bridge");
std::cout << *song << "\n";
delete song;   // free the memory
```

- `new` allocates on the heap and returns a pointer
- `delete` frees the memory
- Using the pointer after `delete` is **undefined behavior**

### Arrays

```cpp
int *scores = new int[5];
scores[0] = 10;
// ...
delete[] scores;   // must match new[]
```

::: {.tip}
**Trap:** `new` pairs with `delete`; `new[]` pairs with `delete[]`. Mixing them is undefined behavior, and the compiler will not warn you.
:::

## 4. Memory Leaks and Dangling Pointers (8 min)

### Leak

```cpp
void leak() {
    std::string *s = new std::string("Nothing Compares 2 U");
    // oops, never delete s
}
```

- Every call leaks a string; eventually the program runs out of memory

### Dangling Pointer

```cpp
int *p = new int(42);
delete p;
std::cout << *p;   // DANGER: p is dangling
```

- Dereferencing freed memory is undefined behavior; may crash or print garbage

## 5. Smart Pointers and RAII (10 min)

**RAII** --- Resource Acquisition Is Initialization. Resources are acquired in a constructor and released in a destructor. Lifetimes are tied to objects.

A **smart pointer** is an object that owns heap memory and automatically frees it when destroyed.

### `std::unique_ptr`

```cpp
#include <memory>
#include <string>

auto song = std::make_unique<std::string>("Don't Speak");
std::cout << *song << "\n";
// no delete needed --- memory freed when `song` goes out of scope
```

- **Sole ownership**: only one `unique_ptr` can own the memory
- Zero overhead compared to raw pointer

### Cannot Copy, Must Move

```cpp
std::unique_ptr<int> a = std::make_unique<int>(42);
std::unique_ptr<int> b = a;              // ERROR: cannot copy
std::unique_ptr<int> c = std::move(a);   // OK: ownership transferred
// a is now empty
```

::: {.tip}
**Tip:** `std::unique_ptr` should be your default choice for heap allocation. Prefer `std::make_unique` over raw `new`.
:::

## 6. Try It --- A Song Owner (5 min)

Live-code a small example where a function returns a `std::unique_ptr<Song>` and the caller uses `->` to access members. Walk through when the destructor runs.

## 7. Wrap-up Quiz (5 min)

**Q1.** What is wrong with this code?

```cpp
void play() {
    int *volumes = new int[3];
    volumes[0] = 7;
    volumes[1] = 9;
    volumes[2] = 11;
    delete volumes;
}
```

A. Missing `<memory>`
B. `new int[3]` is invalid
C. `delete` should be `delete[]` --- mismatched with `new[]`
D. `volumes` must be `const`
E. Ben got this wrong

*Answer: C*

**Q2.** Why can you not copy a `std::unique_ptr`?

A. Copies are slow
B. It enforces sole ownership --- two owners would both try to free the memory
C. The compiler has a bug
D. `unique_ptr` is not a real type
E. Ben got this wrong

*Answer: B*

## 8. Assignment / Reading (2 min)

- **Read:** chapter 13, remaining sections --- `std::shared_ptr`, `.get()`, move semantics, `std::move`
- **Do:** chapter 13 exercises 2, 4, 5, 6, 7, 8 (shared_ptr ref counts, move semantics, shared ownership)
- **Bring:** questions about pointer syntax --- there will be more next lecture

## Key Points to Reinforce

- Stack is automatic, heap is manual; prefer stack
- `&` = address-of, `*` = dereference, `->` = member access through pointer
- `new` / `delete` are matched; `new[]` / `delete[]` are matched
- Raw `new`/`delete` in modern C++ code is a red flag
- `std::unique_ptr` + `std::make_unique` = sole ownership with automatic cleanup

---

# Lecture 19 --- shared_ptr and Move Semantics

## Learning Objectives

By the end of lecture 19, students should be able to:

- Use `std::shared_ptr` with `std::make_shared` for shared ownership
- Explain how reference counting manages the lifetime of shared memory
- Get a raw pointer from a smart pointer with `.get()` without transferring ownership
- Use `std::move` to transfer resources instead of copying them
- Describe the valid-but-unspecified state of a moved-from object

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch13.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 18): **What is wrong with this code?**

    ```cpp
    int *volumes = new int[3];
    delete volumes;
    ```

    - A. Missing `<memory>`
    - B. `delete` should be `delete[]` --- mismatched with `new[]`
    - C. `volumes` must be `const`
    - D. `new int[3]` is invalid
    - E. Ben got this wrong

    *Answer: B*

- Yesterday we saw `unique_ptr`. Today: **shared ownership** and **moving** values around without copying.

## 1. `std::shared_ptr` (15 min)

What if multiple parts of your code need to own the same object?

```cpp
#include <memory>
#include <string>

auto song1 = std::make_shared<std::string>("Under the Bridge");
auto song2 = song1;   // both own the same string
```

- `std::shared_ptr` uses **reference counting**
- Memory is freed when the **last** `shared_ptr` is destroyed

### Inspecting the Count

```cpp
std::cout << song1.use_count() << "\n";   // 2

song1.reset();   // song1 gives up ownership
std::cout << song2.use_count() << "\n";   // 1
```

- `.use_count()` returns the current reference count
- `.reset()` releases this shared_ptr's ownership (decrements the count)

::: {.tip}
**Tip:** Use `shared_ptr` only when you **truly** need shared ownership. `unique_ptr` is simpler, faster, and enforces clearer ownership.
:::

## 2. Getting a Raw Pointer from a Smart Pointer (8 min)

```cpp
auto song = std::make_unique<std::string>("Under the Bridge");
std::string *raw = song.get();

std::cout << *raw << "\n";
// song still owns the memory --- do NOT delete raw
```

- `.get()` returns the raw pointer **without** releasing ownership
- Needed for C library functions and APIs that expect raw pointers

::: {.tip}
**Trap:** **Never `delete`** a pointer obtained from `.get()`. The smart pointer still owns the memory and will free it. Deleting it yourself is a double-free.
:::

## 3. Move Semantics (20 min)

Copying a large object can be expensive. **Moving** transfers the data instead of duplicating it.

```cpp
#include <string>

std::string a = "Nothing Compares 2 U";
std::string b = std::move(a);   // transfers the contents

std::cout << "a: " << a << "\n";   // a is empty
std::cout << "b: " << b << "\n";   // b has the string
```

- The actual string buffer is transferred, not copied
- `a` is left in a **valid but unspecified** state --- for `std::string`, that typically means empty

::: {.tip}
**Trap:** After moving from an object, do not use it unless you assign a new value first. The state is valid but unspecified.
:::

### What `std::move` Actually Does

- `std::move` does **not** actually move anything
- It simply casts its argument to an **rvalue reference**, telling the compiler "it is OK to move from this"
- The move is performed by the receiving object's move constructor or move assignment operator
- You will learn about the Rule of Five in chapter 14 (lecture 20)

### Moving a `unique_ptr`

```cpp
auto a = std::make_unique<Song>("Don't Speak", "No Doubt");
auto b = std::move(a);
// a is now empty; b owns the Song
```

- This is the **only** way to transfer ownership between unique_ptrs

## 4. Try It --- Full Worked Example (15 min)

```cpp
#include <iostream>
#include <memory>
#include <string>

class Song {
    std::string title;
    std::string artist;
public:
    Song(const std::string &t, const std::string &a) : title(t), artist(a) {
        std::cout << "  created: " << title << "\n";
    }
    ~Song() {
        std::cout << "  destroyed: " << title << "\n";
    }
    void print() const { std::cout << "  " << title << " by " << artist << "\n"; }
};

int main() {
    std::cout << "--- unique_ptr ---\n";
    {
        auto song = std::make_unique<Song>("Don't Speak", "No Doubt");
        song->print();
    }   // song destroyed here

    std::cout << "--- shared_ptr ---\n";
    {
        std::shared_ptr<Song> s1;
        {
            auto s2 = std::make_shared<Song>("Under the Bridge", "RHCP");
            s1 = s2;
            std::cout << "  ref count: " << s1.use_count() << "\n";
        }   // s2 destroyed, but Song lives on
        std::cout << "  ref count: " << s1.use_count() << "\n";
        s1->print();
    }   // s1 destroyed, Song finally freed

    std::cout << "--- move ---\n";
    std::string lyrics = "Nada se compara contigo";
    std::string moved = std::move(lyrics);
    std::cout << "  moved: " << moved << "\n";
    std::cout << "  after: '" << lyrics << "'\n";
}
```

Walk through the output and explain each destructor.

## 5. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```cpp
auto p = std::make_shared<int>(99);
auto q = p;
auto r = p;
std::cout << p.use_count() << "\n";
q.reset();
std::cout << p.use_count() << "\n";
r.reset();
std::cout << p.use_count() << "\n";
```

A. `3 3 3`
B. `3 2 1`
C. `1 1 1`
D. `1 2 3`
E. Ben got this wrong

*Answer: B*

**Q2.** After `auto b = std::move(a);` where `a` is a `std::unique_ptr<int>`, what is the state of `a`?

A. Contains the same value as before
B. Contains garbage
C. Empty (`nullptr`); not safe to dereference but safe to reassign
D. Has been deleted; the program crashes
E. Ben got this wrong

*Answer: C*

**Q3.** Why should you NOT `delete` a pointer obtained from `.get()`?

A. `.get()` returns `nullptr`
B. The smart pointer still owns the memory; a double-free will follow
C. `delete` does not work on raw pointers
D. You would leak memory
E. Ben got this wrong

*Answer: B*

## 6. Assignment / Reading (2 min)

- **Read:** chapter 14 of *Starting C++* (Special Members and Friends)
- **Do:** all 9 exercises at the end of chapter 14
- **Bring:** your `unique_ptr`/`shared_ptr` questions --- we build on these concepts next lecture

## Key Points to Reinforce

- `shared_ptr` uses reference counting --- last one out frees the memory
- `.get()` yields a raw pointer without transferring ownership --- **do not delete** it
- `std::move` casts to rvalue reference; the **move** is done by the target's move constructor
- A moved-from object is **valid but unspecified** --- do not use it until reassigned
- Prefer `unique_ptr` unless shared ownership is genuinely required
