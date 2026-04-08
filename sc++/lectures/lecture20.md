# Lecture 20 --- Special Members and Friends

**Source:** `sc++/ch14.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- List the five special member functions the compiler can generate (destructor, copy constructor, copy assignment, move constructor, move assignment)
- State and apply the **Rule of Five** when a class manages a raw resource
- State and apply the **Rule of Zero** when all members manage themselves
- Use `= default` and `= delete` to control which special members are generated
- Declare friend functions and friend classes and explain why `operator<<` is typically a friend
- List the rules of friendship (granted, not mutual, not inherited, not transitive)

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch14.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 19): **After `auto b = std::move(a);` where `a` is a `std::unique_ptr<int>`, what is the state of `a`?**
    - A. Contains the same value
    - B. Contains garbage
    - C. Empty (`nullptr`); safe to reassign but unsafe to dereference
    - D. Has been deleted; the program crashes
    - E. Ben got this wrong

    *Answer: C*

- Today: the last C++ building blocks before we look back at the whole course.

## 1. The Five Special Member Functions (8 min)

The compiler can generate up to **five** special member functions for you:

1. **Destructor** --- `~T()`
2. **Copy constructor** --- `T(const T &)`
3. **Copy assignment** --- `T &operator=(const T &)`
4. **Move constructor** --- `T(T &&) noexcept`
5. **Move assignment** --- `T &operator=(T &&) noexcept`

For classes that only contain well-behaved members (like `std::string`, `std::vector`, `std::unique_ptr`), the compiler-generated versions do the right thing.

## 2. Rule of Five (12 min)

**If you write any one of the five, you almost certainly need to write all five.**

This matters when your class manages a raw resource like heap memory:

```cpp
#include <cstring>

class Lyric {
    char *text;
public:
    Lyric(const char *t) {
        text = new char[std::strlen(t) + 1];
        std::strcpy(text, t);
    }

    ~Lyric() { delete[] text; }

    Lyric(const Lyric &other) {
        text = new char[std::strlen(other.text) + 1];
        std::strcpy(text, other.text);
    }

    Lyric &operator=(const Lyric &other) {
        if (this != &other) {
            delete[] text;
            text = new char[std::strlen(other.text) + 1];
            std::strcpy(text, other.text);
        }
        return *this;
    }

    Lyric(Lyric &&other) noexcept : text(other.text) {
        other.text = nullptr;
    }

    Lyric &operator=(Lyric &&other) noexcept {
        if (this != &other) {
            delete[] text;
            text = other.text;
            other.text = nullptr;
        }
        return *this;
    }
};
```

- Without the copy constructor, the default one would copy the pointer, leading to a **double-free**
- Without the move constructor, the vector would copy instead of move during reallocation --- **slow**

::: {.tip}
**Tip:** Mark move constructors and move assignment operators `noexcept`. `std::vector` checks for this and falls back to copying if your moves could throw --- a huge performance hit.
:::

## 3. `= default` and `= delete` (12 min)

### `= default`

Writing any constructor suppresses the default constructor. Bring it back:

```cpp
class Song {
    std::string title;
    std::string artist;
public:
    Song(const std::string &t, const std::string &a) : title(t), artist(a) {}

    Song() = default;                            // bring back the default ctor
    Song(const Song &) = default;                // compiler version is fine
    Song &operator=(const Song &) = default;
    ~Song() = default;
};
```

- Documents intent: "I thought about this; the compiler version is correct"

### `= delete`

Prevent a function from being called at compile time:

```cpp
class AudioStream {
    int device_id;
public:
    AudioStream(int id) : device_id(id) {}

    AudioStream(const AudioStream &) = delete;
    AudioStream &operator=(const AudioStream &) = delete;

    AudioStream(AudioStream &&) noexcept = default;
    AudioStream &operator=(AudioStream &&) noexcept = default;
};
```

- `= delete` produces a clear compile error if someone tries to copy
- You can delete any function, not just special members --- a common use is preventing implicit conversions

::: {.tip}
**Tip:** `= delete` replaces the pre-C++11 trick of making a function `private` and never defining it. The modern approach gives a clearer error message.
:::

## 4. Rule of Zero (10 min)

**If your class does not manage a resource directly, do not write any of the five special member functions. Let the compiler generate them.**

Rewrite `Lyric` using `std::string` instead of `char*`:

```cpp
#include <string>

class Lyric {
    std::string text;
public:
    Lyric(const std::string &t) : text(t) {}
    void print() const { std::cout << text << "\n"; }
};
```

- Does the same thing
- **Zero** special members needed --- `std::string` already knows how to copy, move, and clean up
- Much less code, fewer bugs

::: {.tip}
**Tip:** Prefer `std::string` over `char *`, `std::vector` over raw arrays, and `std::unique_ptr` over raw `new`/`delete`. When all members manage themselves, you write nothing special.
:::

## 5. Friends --- Why They Exist (5 min)

Sometimes an outside function or class genuinely needs access to your private data:

- `operator<<` must be a free function because its left operand is `std::ostream`, not your class. But a free function cannot see private members.
- A class like `DJ` may manipulate a `Playlist`'s internals without being a kind of playlist itself.

C++ solves this with the `friend` keyword. A class **grants** friendship to specific functions or classes.

## 6. Friend Functions (10 min)

```cpp
class Playlist {
    std::string name;
    std::vector<std::string> songs;
public:
    Playlist(const std::string &n) : name(n) {}
    void add(const std::string &s) { songs.push_back(s); }

    friend std::ostream &operator<<(std::ostream &os, const Playlist &p);
};

std::ostream &operator<<(std::ostream &os, const Playlist &p) {
    os << p.name << ":\n";
    for (size_t i = 0; i < p.songs.size(); ++i) {
        os << "  " << i + 1 << ". " << p.songs[i] << "\n";
    }
    return os;
}
```

- The `friend` declaration inside `Playlist` grants `operator<<` access to private members
- The function is **defined outside** the class, like any free function
- Returning `std::ostream &` enables chaining: `std::cout << a << b`

## 7. Friend Classes (8 min)

```cpp
class Playlist {
    std::string name;
    std::vector<std::string> songs;
    friend class DJ;
public:
    Playlist(const std::string &n) : name(n) {}
};

class DJ {
    std::string name;
public:
    DJ(const std::string &n) : name(n) {}

    void swap_first_last(Playlist &p) const {
        if (p.songs.size() > 1) {
            std::string tmp = p.songs.front();
            p.songs.front() = p.songs.back();
            p.songs.back() = tmp;
        }
    }
};
```

- `friend class DJ;` grants every member function of `DJ` access to `Playlist`'s privates
- Friendship is **one-directional**: `DJ` can see `Playlist`'s privates, but not the other way around

## 8. Rules of Friendship (5 min)

- **Friendship is granted, not taken.** The class declares its own friends from inside.
- **Friendship is not mutual.** `A` friending `B` does not make `B` friend `A`.
- **Friendship is not inherited.** A class derived from `DJ` does not automatically inherit `DJ`'s friendship with `Playlist`.
- **Friendship is not transitive.** `A` friend of `B`, `B` friend of `C` does **not** make `A` a friend of `C`.

::: {.tip}
**Tip:** Use `friend` sparingly. Every friend is outside code coupled to your private representation. Prefer public member functions when you can; reserve `friend` for cases like `operator<<` where there is no alternative.
:::

## 9. Wrap-up Quiz (5 min)

**Q1.** Why does the `std::vector` in this class copy elements instead of moving them during reallocation?

```cpp
class Track {
    std::string title;
    std::vector<int> samples;
public:
    Track(const std::string &t) : title(t) {}

    Track(Track &&other)
        : title(std::move(other.title)),
          samples(std::move(other.samples)) {}
};
```

A. `Track` is missing a copy constructor
B. The move constructor is not marked `noexcept`
C. `std::move` is not allowed in member initializer lists
D. `std::vector` always copies
E. Ben got this wrong

*Answer: B*

**Q2.** If class `A` declares class `B` as a friend, and class `B` declares class `C` as a friend, can `C` access `A`'s private members?

A. Yes, friendship is transitive
B. No, friendship is not transitive
C. Only if `A` is also a friend of `B`
D. Only for public members
E. Ben got this wrong

*Answer: B*

**Q3.** A class has `std::string name`, `std::vector<int> scores`, and `int id`. How many of the five special member functions do you need to write?

A. 5
B. 3
C. 2
D. 1
E. 0

*Answer: E* --- the Rule of Zero applies; all members manage themselves.

## 10. Assignment / Reading (5 min)

This is the final lecture of the course.

- **Read (optional):** chapter 15 of *Starting C++* as reference material. It covers `exit()`, `extern "C"`, casting (`static_cast`, `dynamic_cast`, `const_cast`, `reinterpret_cast`), `<chrono>` for time, and `<random>` for random numbers. None of this is required for the final exam, but you will see all of it in real C++ code.
- Review all prior chapters for the final exam.
- Bring your end-of-term questions --- we will hold an open Q&A session next class period.

## Key Points to Reinforce

- Five special members: destructor, copy ctor, copy assignment, move ctor, move assignment
- **Rule of Five**: write one, write all five
- **Rule of Zero**: use well-behaved members and write none
- `= default` restores the compiler's version; `= delete` forbids a call
- Mark move operations `noexcept` so containers use them
- `friend` grants access; use it sparingly and only when you must
