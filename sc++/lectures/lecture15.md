# Lecture 15 --- Exceptions

**Source:** `sc++/ch11.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Throw exceptions using `throw` and one of the standard types from `<stdexcept>`
- Catch exceptions with `try`/`catch`, handling specific types before generic ones
- Always catch by `const` reference and explain why
- Trace stack unwinding and understand why destructors run during it
- Mark functions `noexcept` and list the consequences of violating the promise
- Use `std::expected<T, E>` (C++23) as an alternative to exceptions for routine errors

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch11.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 14): **What does `std::format("{:*^20}", "Hola")` produce?**
    - A. `"****Hola************"`
    - B. `"********Hola********"`
    - C. `"Hola****************"`
    - D. `"********Hola"`
    - E. Ben got this wrong

    *Answer: B*

- Today we learn how to signal and handle errors **without threading error codes** through every function in the chain

## 1. Why Exceptions? (5 min)

- Printing errors and returning early works at the top level, but what about a function buried 4 calls deep?
- You would have to return error codes through every layer and check them everywhere
- Exceptions let a function deep in the call stack signal an error that code much higher up handles

## 2. Throwing Exceptions (10 min)

```cpp
#include <stdexcept>
#include <string>

int parse_track(const std::string &s) {
    int n = std::stoi(s);
    if (n < 1) {
        throw std::out_of_range("track number must be positive");
    }
    return n;
}
```

- `throw` stops the current function **immediately**
- Control travels up the call stack looking for a matching `catch`
- Standard exception types live in `<stdexcept>`

### Standard Exception Types

| type | when to use |
|---|---|
| `std::runtime_error` | general runtime error |
| `std::out_of_range` | value outside valid range |
| `std::invalid_argument` | argument does not make sense |
| `std::logic_error` | programmer bug |
| `std::overflow_error` | arithmetic overflow |

- All take a `std::string` message and offer `.what()` to retrieve it
- All derive from `std::exception`
- The hierarchy splits in two below `std::exception`:
    - `std::out_of_range` and `std::invalid_argument` derive from `std::logic_error`
    - `std::overflow_error` derives from `std::runtime_error`
    - so `catch (const std::logic_error &)` catches `std::out_of_range` but not `std::overflow_error`

## 3. Catching Exceptions (10 min)

```cpp
try {
    int track = parse_track("0");
    std::cout << "Track: " << track << "\n";
} catch (const std::out_of_range &e) {
    std::cout << "Error: " << e.what() << "\n";
}
```

- Wrap the risky code in a `try` block
- Follow with one or more `catch` blocks
- Execution continues normally **after** the `catch` block when handled

### Multiple Catch Blocks

```cpp
try {
    int v = parse_volume("abc");
} catch (const std::out_of_range &e) {
    std::cout << "out of range: " << e.what() << "\n";
} catch (const std::invalid_argument &e) {
    std::cout << "bad input: " << e.what() << "\n";
}
```

- Tested in order; **first match wins**
- List **specific** exception types **before** generic ones

::: {.tip}
**Tip:** Always catch by `const` reference --- catching by value makes a copy and can **slice** off derived information.
:::

### Catch-All

```cpp
try {
    risky();
} catch (const std::exception &e) {
    std::cout << "known: " << e.what() << "\n";
} catch (...) {
    std::cout << "unknown\n";
}
```

- `catch (...)` is a last resort for anything that is not a `std::exception`

## 4. Catch Order Matters --- The Common Bug (4 min)

```cpp
try { /* ... */ }
catch (const std::exception &e) {      // BAD: catches everything
    /* handler for std::exception */
}
catch (const std::out_of_range &e) {    // UNREACHABLE
    /* this never runs */
}
```

- Handlers are tried in source order, **top to bottom**
- If `std::exception` comes first, `std::out_of_range` (which derives from it) can never match
- Fix: specific types **before** generic ones

## 5. Stack Unwinding (10 min)

When an exception is thrown, C++ **unwinds the stack** --- it destroys local variables in each function along the way until it finds a matching handler.
Destructors run automatically.

```cpp
struct Song {
    std::string title;
    Song(const std::string &t) : title(t) { std::cout << "on: " << title << "\n"; }
    ~Song()                                 { std::cout << "off: " << title << "\n"; }
};

void deep()   { Song s("The Freshmen"); throw std::runtime_error("oops"); }
void middle() { Song s("Save Tonight"); deep(); }

int main() {
    try { middle(); }
    catch (const std::exception &e) { std::cout << "caught: " << e.what() << "\n"; }
}
```

Output:

```
on: Save Tonight
on: The Freshmen
off: The Freshmen
off: Save Tonight
caught: oops
```

- Destructors run in **reverse order of construction**
- This is why RAII (resource management through destructors) matters --- cleanup is automatic even when things go wrong

::: {.tip}
**Trap:** **Never throw from a destructor**. If a destructor throws while another exception is already in flight, the program calls `std::terminate()` and dies.
:::

## 6. `noexcept` (8 min)

```cpp
int add(int a, int b) noexcept {
    return a + b;
}
```

- `noexcept` promises the function will not throw
- Violating the promise calls `std::terminate()` immediately --- no unwinding, no catch, just a crash
- **Not verified at compile time**

### Why It Matters

- The compiler uses `noexcept` for optimization
- `std::vector` checks whether your move constructor is `noexcept` before deciding whether to move or copy during reallocation
- Moving is fast, copying is slow --- making your move constructor `noexcept` can be a huge speedup

::: {.tip}
**Tip:** Mark move constructors, move assignment operators, and destructors `noexcept` when possible.
:::

## 7. `std::expected<T, E>` (C++23) (10 min)

Include `<expected>`.
Holds **either** a value **or** an error --- never both.

```cpp
#include <expected>
#include <iostream>
#include <string>

std::expected<int, std::string> divide(int a, int b) {
    if (b == 0) {
        return std::unexpected("division by zero");
    }
    return a / b;
}

int main() {
    auto r1 = divide(10, 3);
    if (r1) std::cout << *r1 << "\n";         // 3

    auto r2 = divide(10, 0);
    if (!r2) std::cout << r2.error() << "\n"; // division by zero
}
```

- Use `*result` or `result.value()` for the value
- Use `result.error()` for the error
- The boolean check (`if (r)`) tells you whether a value is present

::: {.tip}
**Trap:** `*result` and `result.value()` are *not* interchangeable.
`*result` on an error is undefined behavior; `result.value()` checks first and throws `std::bad_expected_access` if there is no value.
Use `*result` only after the boolean check; reach for `value()` when you want the throw-on-empty safety net.
:::

## 8. Exceptions vs `std::expected` (6 min)

| | Exceptions | `std::expected` |
|---|---|---|
| **Best for** | rare, exceptional failures | expected, routine failures |
| **Error path** | unwinds the stack | ordinary return |
| **Caller must check?** | no --- propagates | yes --- inspect return |
| **Cost** | zero until thrown; expensive when thrown | small constant |

Rule of thumb:

- Error should propagate up several layers --> **exceptions**
- Caller is likely to handle the error right away --> **`std::expected`**

## 9. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```cpp
void step3() { throw std::runtime_error("oops"); }
void step2() { step3(); }
void step1() { step2(); }

int main() {
    try {
        step1();
        std::cout << "A\n";
    } catch (const std::runtime_error &e) {
        std::cout << "B: " << e.what() << "\n";
    }
    std::cout << "C\n";
}
```

A. `A C`
B. `A B: oops C`
C. `B: oops`
D. `B: oops C`
E. Ben got this wrong

*Answer: D* --- `step1()` throws, so `A` is skipped; `B: oops` prints, then execution continues to `C`.

**Q2.** What is wrong with this code?

```cpp
try { /* ... */ }
catch (const std::exception &e)        { std::cout << "error\n"; }
catch (const std::out_of_range &e)     { std::cout << "out of range\n"; }
catch (const std::invalid_argument &e) { std::cout << "bad input\n"; }
```

A. Missing `#include`
B. `catch (...)` is required
C. `std::exception` catches everything, so the other handlers are unreachable
D. You cannot have multiple catch blocks
E. Ben got this wrong

*Answer: C*

**Q3.** Will this compile, and what happens at runtime?

```cpp
void load(const std::string &file) {
    throw std::runtime_error("file not found: " + file);
}

void play() noexcept {
    load("track01.wav");
}
```

A. Compile error --- noexcept function cannot throw
B. Compiles; `play()` throws the exception normally
C. Compiles; `play()` calls `std::terminate()` at runtime
D. Compiles; the exception is silently ignored
E. Ben got this wrong

*Answer: C*

## 10. Assignment / Reading (2 min)

- **Read:** chapter 12 of *Gorgo Starting C++*, sections on struct-to-class, access specifiers, constructors, and destructors (first half)
- **Do:** chapter 12 exercises 1, 2, 4, 5, 11 (struct vs class, constructor ordering, initializer lists, explicit)
- **Bring:** a struct from a previous lecture that you would like to turn into a class

## Key Points to Reinforce

- `throw` signals, `try`/`catch` handles
- Always catch by **`const` reference**
- Specific catch blocks **before** generic ones
- Destructors run during stack unwinding --> manage resources via objects
- **Never throw from a destructor**
- `noexcept` is a promise --- violating it calls `std::terminate()`
- `std::expected<T, E>` for routine failures the caller handles immediately
