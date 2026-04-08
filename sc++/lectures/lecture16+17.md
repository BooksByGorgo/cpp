# Lecture 16+17 --- Classes

**Source:** `sc++/ch12.md`
**Duration:** 2 x 75 minutes (lectures 16 and 17)

Chapter 12 is split across two lectures:

- **Lecture 16 --- From Struct to Class:** struct vs class, access specifiers (public/private/protected), constructors (default, parameterized, member initializer lists, `explicit`), destructors
- **Lecture 17 --- Behavior and Operators:** member functions, `const` methods, the `this` pointer, separating declaration from definition, operator overloading (`+`, `+=`, `==`), conversion operators

---

# Lecture 16 --- From Struct to Class

## Learning Objectives

By the end of lecture 16, students should be able to:

- Explain the difference between a `struct` and a `class` (default access)
- Use `public`, `private`, and (briefly) `protected` access specifiers
- Write default and parameterized constructors using member initializer lists
- Mark single-argument constructors `explicit` to prevent surprise conversions
- Write a destructor and understand when it runs

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch12.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 15): **Will this compile, and what happens at runtime?**

    ```cpp
    void load(const std::string &file) { throw std::runtime_error("not found"); }
    void play() noexcept { load("track01.wav"); }
    ```

    - A. Compile error
    - B. Compiles; `play()` throws normally
    - C. Compiles; `play()` calls `std::terminate()`
    - D. Compiles; exception is ignored
    - E. Ben got this wrong

    *Answer: C*

- Chapter 2 gave you `struct`. Today we upgrade to `class` --- **data + behavior**

## 1. Why Classes? (5 min)

Chapter 2 reminder:

```cpp
struct Song {
    std::string title;
    std::string artist;
    int year;
};

Song s;
s.year = -5;   // nothing stops this!
```

- Any code can set `year` to garbage
- The functions that operate on a `Song` live separately from the data
- Classes fix both problems: they bundle data *and* behavior, and control access

## 2. Access Specifiers (8 min)

Three keywords:

- **`public`** --- accessible from anywhere
- **`private`** --- only accessible inside the class
- **`protected`** --- inside the class and derived classes (advanced)

```cpp
class Song {
private:
    std::string title;
    std::string artist;
    int year;

public:
    void set_year(int y) { if (y > 0) year = y; }
    int get_year() const { return year; }
};
```

::: {.tip}
**Wut:** `struct` and `class` are almost the same thing. The only difference is the default access level: `struct` is public by default, `class` is private by default.
:::

## 3. Constructors (15 min)

A **constructor** runs automatically when an object is created. Same name as the class, no return type.

### Default Constructor

```cpp
class Song {
    std::string title;
    std::string artist;
    int year;
public:
    Song() : title("Unknown"), artist("Unknown"), year(0) {}
};

Song s;   // calls default constructor
```

### Parameterized Constructor

```cpp
Song(const std::string &t, const std::string &a, int y)
    : title(t), artist(a), year(y) {}

Song b("Enter Sandman", "Metallica", 1991);
```

### Member Initializer Lists

The `: title(t), artist(a), year(y)` part is a **member initializer list** --- always prefer it over assigning in the body.

- More efficient (avoids a temporary default-construct)
- **Required** for `const` members and references

::: {.tip}
**Trap:** Members are initialized in the order they are **declared** in the class, not the order listed in the initializer list. Keep them in the same order to avoid confusion.
:::

### `explicit` Constructors

```cpp
class Volume {
public:
    explicit Volume(int l) : level(l) {}
    int level;
};

void play(Volume v) { /* ... */ }

play(11);            // ERROR with explicit
play(Volume(11));    // OK
```

- Without `explicit`, the compiler silently converts `11` to `Volume(11)`
- `explicit` prevents unwanted implicit conversions

::: {.tip}
**Trap:** Mark single-argument constructors `explicit` unless you specifically want implicit conversion.
:::

## 4. Destructors (10 min)

A **destructor** runs when the object is destroyed (goes out of scope or is deleted). Name is the class name prefixed with `~`, no parameters.

```cpp
class Song {
    std::string title;
public:
    Song(const std::string &t) : title(t) {
        std::cout << title << " created\n";
    }
    ~Song() {
        std::cout << title << " destroyed\n";
    }
};

int main() {
    Song s("Black Hole Sun");
    std::cout << "doing stuff...\n";
}
```

Output:

```
Black Hole Sun created
doing stuff...
Black Hole Sun destroyed
```

- You do **not** call the destructor yourself --- it runs automatically
- For classes that only hold standard library types, the compiler-generated destructor is fine
- Destructors become critical when your class manages raw resources (chapter 13)

## 5. Order of Construction and Destruction (7 min)

```cpp
int main() {
    Song a("Torn");       // a created
    Song b("Vogue");      // b created
    Song c("Iris");       // c created
    // at the end of main:
    // c destroyed (most recent)
    // b destroyed
    // a destroyed
}
```

- Local objects are destroyed in **reverse order of construction**
- Base classes construct before derived classes, and destruct in reverse (preview of inheritance)

## 6. Try It --- A Song Class (10 min)

Live-code a complete `Song` class with:

- Three private members
- A parameterized constructor using an initializer list
- A destructor that prints a message
- A simple `print()` member function

Ask the class to predict the construction/destruction order.

## 7. Wrap-up Quiz (6 min)

**Q1.** Which is NOT a difference between `struct` and `class` in C++?

A. Default access level
B. Members of `struct` are public by default
C. `class` supports constructors but `struct` does not
D. You can use either for OOP
E. Ben got this wrong

*Answer: C* --- both support constructors.

**Q2.** Why should you prefer member initializer lists over assigning in the constructor body?

A. They look nicer
B. They are the only way to initialize `const` members and references
C. They skip a temporary default-construct-then-assign for complex types
D. Both B and C
E. Ben got this wrong

*Answer: D*

**Q3.** Where is the bug?

```cpp
class Volume {
public:
    Volume(int l) : level(l) {}
    int level;
};

void play(Volume v) { /* ... */ }
play(11);
```

A. Missing semicolon
B. `Volume` has no destructor
C. `Volume(int)` is not `explicit`, so `11` silently converts --- probably not intended
D. `play` cannot take a `Volume`
E. Ben got this wrong

*Answer: C*

## 8. Assignment / Reading (4 min)

- **Read:** chapter 12, remaining sections --- member functions, `const` methods, `this`, operator overloading, conversion operators
- **Do:** chapter 12 exercises 3, 6, 7, 8, 9, 13 (const methods, operator overloads, `this->`, ambiguity, full class)
- **Bring:** the `Song` class from today --- next lecture we add behavior

## Key Points to Reinforce

- `class` = `struct` with private-by-default
- Use access specifiers to hide implementation details
- Always use member initializer lists
- Mark single-arg constructors `explicit`
- Destructors run in **reverse order** of construction

---

# Lecture 17 --- Behavior and Operators

## Learning Objectives

By the end of lecture 17, students should be able to:

- Write member functions and mark them `const` when they do not modify the object
- Use the `this` pointer to resolve name conflicts and return references for method chaining
- Separate a class into a header (`.h`) and source (`.cpp`) file with include guards
- Overload `+`, `+=`, and `==` as member functions
- Write a conversion operator and know when to mark it `explicit`

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch12.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 16): **Where is the bug?**

    ```cpp
    class Volume {
    public:
        Volume(int l) : level(l) {}
        int level;
    };
    void play(Volume v) { }
    play(11);
    ```

    - A. Missing semicolon
    - B. `Volume(int)` is not `explicit` --- `11` silently converts
    - C. `play` cannot take `Volume`
    - D. `Volume` has no destructor
    - E. Ben got this wrong

    *Answer: B*

## 1. Member Functions and `const` (15 min)

```cpp
class Song {
    std::string title;
    std::string artist;
    int year;
public:
    Song(const std::string &t, const std::string &a, int y)
        : title(t), artist(a), year(y) {}

    void print() const {
        std::cout << title << " by " << artist
                  << " (" << year << ")\n";
    }

    bool is_90s() const {
        return year >= 1990 && year <= 1999;
    }
};
```

- `const` after the parameter list means "this function does not modify the object"
- You can call `const` methods on `const` objects; you **cannot** call non-`const` methods on `const` objects
- This matters constantly because **passing by `const` reference** is the standard way to avoid copies

```cpp
void show(const Song &s) {
    s.print();    // OK: print() is const
    s.is_90s();   // OK: is_90s() is const
}
```

If `print()` is not `const`, `show()` fails to compile.

::: {.tip}
**Tip:** Mark every member function that does not modify the object as `const`. Habit-forming: it catches bugs and keeps your class working smoothly with `const` references.
:::

## 2. The `this` Pointer (10 min)

`this` is a hidden pointer to the current object, automatically available inside every member function.

### Resolving Name Conflicts

```cpp
void set_year(int year) {
    this->year = year;   // member = parameter
}
```

### Returning `*this` for Method Chaining

```cpp
class Playlist {
    std::vector<std::string> songs;
public:
    Playlist &add(const std::string &song) {
        songs.push_back(song);
        return *this;
    }
};

Playlist p;
p.add("Torn").add("Vogue").add("Iris");
```

- Return type is `Playlist &` (reference) to avoid copying
- Each `.add()` returns the same object

### Copying the Current Object

```cpp
Song with_year(int y) const {
    Song copy = *this;   // copy the current object
    copy.year = y;
    return copy;
}
```

## 3. Separating Declaration and Definition (10 min)

As classes grow, split them into a header and source file.

**song.h:**

```cpp
#ifndef SONG_H
#define SONG_H

#include <string>

class Song {
    std::string title;
    std::string artist;
    int year;
public:
    Song(const std::string &t, const std::string &a, int y);
    void print() const;
    bool is_90s() const;
};

#endif
```

**song.cpp:**

```cpp
#include "song.h"
#include <iostream>

Song::Song(const std::string &t, const std::string &a, int y)
    : title(t), artist(a), year(y) {}

void Song::print() const {
    std::cout << title << " by " << artist << " (" << year << ")\n";
}

bool Song::is_90s() const {
    return year >= 1990 && year <= 1999;
}
```

- `Song::` is the scope resolution operator (chapter 1) --- "this belongs to `Song`"
- `#ifndef`/`#define`/`#endif` is an **include guard** --- prevents duplicate inclusion
- `#pragma once` is a common non-standard alternative

## 4. Operator Overloading --- `+` and `+=` (12 min)

```cpp
class Playlist {
    std::string name;
    std::vector<std::string> songs;
public:
    Playlist(const std::string &n) : name(n) {}

    Playlist operator+(const std::string &song) const {
        Playlist copy = *this;
        copy.songs.push_back(song);
        return copy;
    }

    Playlist &operator+=(const std::string &song) {
        songs.push_back(song);
        return *this;
    }
};

Playlist p("90s Jams");
p = p + "Torn";      // non-destructive
p += "Vogue";        // in-place
```

- `operator+` is `const` --- returns a **new** playlist, does not modify this one
- `operator+=` is **not** `const` --- modifies in place, returns `*this`
- Mirrors built-in types: `3 + 2` does not change `3`, but `x += 1` does change `x`

## 5. The `==` Operator (5 min)

```cpp
bool operator==(const Playlist &other) const {
    return name == other.name && songs == other.songs;
}
```

- Takes `const Playlist &` --- comparison should not modify either side
- Has access to **other's** private members --- same class, same rights
- Should behave symmetrically and consistently

## 6. Conversion Operators (5 min)

```cpp
class Volume {
    int level;
public:
    explicit Volume(int l) : level(l) {}

    explicit operator int() const { return level; }
};

Volume v(11);
int n = static_cast<int>(v);   // explicit cast required
```

- `operator T()` lets your type convert to type `T`
- Mark them `explicit` to prevent silent conversions (same idea as explicit constructors)
- Common: `explicit operator bool()` for testable objects like streams

## 7. Try It --- Full Playlist Class (5 min)

Walk through the chapter's `Playlist` example that uses constructors, member functions, `operator+`, `operator+=`, and `operator==` together. Let students predict outputs.

## 8. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```cpp
class Counter {
    int n = 0;
public:
    Counter &add() { ++n; return *this; }
    int get() const { return n; }
};

int main() {
    Counter c;
    c.add().add().add();
    std::cout << c.get() << "\n";
}
```

A. 0
B. 1
C. 3
D. compile error
E. Ben got this wrong

*Answer: C* --- each `.add()` returns the same object, so the chain increments three times.

**Q2.** Where is the bug?

```cpp
class Song {
    int year;
public:
    int get_year() { return year; }
};

void show(const Song &s) { std::cout << s.get_year(); }
```

A. `get_year` should be `static`
B. `get_year` is not marked `const`, so it cannot be called on a `const Song &`
C. `year` needs to be `public`
D. `show` should take `Song` by value
E. Ben got this wrong

*Answer: B*

**Q3.** Why does `operator+` on a class typically return a new object, while `operator+=` returns a reference?

A. The compiler requires it
B. `+` should not modify its operands (non-destructive), but `+=` does
C. References are faster
D. `operator+=` is always wrong
E. Ben got this wrong

*Answer: B*

## 9. Assignment / Reading (3 min)

- **Read:** chapter 13 of *Starting C++*, sections on stack vs heap, pointers, `new`/`delete`, memory leaks, and intro to `std::unique_ptr` (first half)
- **Do:** chapter 13 exercises 1, 3, 9, 10 (stack/heap, new/delete, pointer basics)
- **Bring:** a guess at the difference between `new` and `delete`

## Key Points to Reinforce

- `const` member functions are essential for working with `const` references
- `this` resolves name conflicts and enables method chaining via `*this`
- Split classes into `.h` and `.cpp`; use include guards or `#pragma once`
- `operator+` is `const`, `operator+=` is not --- mirror the built-in types
- Conversion operators should be `explicit` by default
