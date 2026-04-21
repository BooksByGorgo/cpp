# Lecture 3 --- Strings

**Source:** `sc++/ch03.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Create `std::string` objects and use `.size()`, `.length()`, and `.empty()`
- Concatenate strings with `+` and `+=`, and explain why `"a" + "b"` does not compile
- Compare strings with `==` and `<`, and explain why ASCII ordering matters
- Access characters with `[]` versus `.at()` and choose between them
- Iterate through a string with a range-based `for` loop
- Find and extract substrings with `.find()` and `.substr()`
- Read a whole line with `std::getline` and avoid the `cin >> ... getline` trap
- Convert between strings and numbers with `std::stoi`, `std::stod`, `std::to_string`

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch03.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 2): **On a system where `int` is 4 bytes, what is `sizeof(scores)` for `int scores[10]`?**
    - A. 4
    - B. 10
    - C. 14
    - D. 40
    - E. Ben got this wrong

    *Answer: D* --- `sizeof` on a whole array is element size times element count.

- Quick reminder: today we move from **single characters** (`char`) to **sequences of characters** (`std::string`)

## 1. Why `std::string`? (5 min)

- Chapter 2 showed you could shove text into a `char` array, but raw char arrays are painful:
    - you must track the length yourself
    - you cannot resize them
    - `==` compares pointers, not content
    - a missing `'\0'` terminator can crash the program
- `std::string` manages its own memory, knows its own length, and provides a rich set of operations
- Always `#include <string>` --- do not rely on `<iostream>` pulling it in for you

## 2. Creating Strings (5 min)

```cpp
#include <iostream>
#include <string>

int main() {
    std::string empty;                  // ""
    std::string greeting = "Hola";     // literal
    std::string copy = greeting;        // copy
    std::string repeat(5, '!');         // "!!!!!"

    std::cout << greeting << "\n";
}
```

- A default-constructed string is **empty**, not uninitialized --- unlike a bare `int`
- `std::string(count, char)` repeats the character `count` times

## 3. Length, Size, and Empty (5 min)

```cpp
std::string title = "Ice Ice Baby";
std::cout << title.size() << "\n";     // 12
std::cout << title.length() << "\n";   // 12

std::string nada;
if (nada.empty()) {
    std::cout << "nothing here\n";
}
```

- `.size()` and `.length()` return the **same** value --- pick whichever reads better
- `.empty()` returns `true` for a zero-length string
- Both return `size_t` --- an **unsigned** type, so be careful comparing against signed ints

## 4. Concatenation (8 min)

```cpp
std::string first = "Baby";
std::string second = " One More Time";
std::string hit = first + second;     // Baby One More Time

std::string lyrics = "Bailamos";
lyrics += ", te quiero";               // appends in place
```

- `+` produces a new string; `+=` modifies the left-hand string
- You can mix a `std::string` with a char or literal on either side

::: {.tip}
**Trap:** `"hello" + " world"` does **not** compile. Both operands are `const char*`, not `std::string`. At least one side of `+` must be a real `std::string`. Fix: `std::string("hello") + " world"` or assign to a `std::string` first.
:::

## 5. Comparing Strings (5 min)

```cpp
std::string a = "Hanson";
std::string b = "Vanilla Ice";
if (a < b) {
    std::cout << a << " comes first\n";
}
```

- `==`, `!=`, `<`, `>`, `<=`, `>=` all work
- Comparison is **character by character** using ASCII values
- Uppercase letters sort **before** lowercase letters because `'Z'` (90) < `'a'` (97)
- Quick board exercise: does `"Zebra" < "apple"` evaluate to true or false?

## 6. Accessing Characters (7 min)

```cpp
std::string song = "MMMBop";
std::cout << song[0] << "\n";     // M
std::cout << song.at(3) << "\n";  // B

std::string shout = "hey!";
shout[0] = 'H';                    // now "Hey!"
```

- `[]` is fast but has **no bounds check** --- out-of-bounds is undefined behavior
- `.at()` throws `std::out_of_range` if the index is invalid
- Both are writable, so you can modify characters in place

::: {.tip}
**Tip:** Use `.at()` when you are not 100% sure the index is valid. The small overhead is worth the early error.
:::

## 7. Iterating Through a String (5 min)

```cpp
std::string word = "Iris";
for (char c : word) {
    std::cout << c << ' ';
}
std::cout << "\n";   // I r i s
```

- Range-based `for` is the cleanest way to iterate
- If you need the **index**, use a traditional loop with `size_t`:

```cpp
for (size_t i = 0; i < word.size(); ++i) {
    std::cout << word[i] << ' ';
}
```

- Prefer `size_t` over `int` to avoid signed/unsigned warnings

## 8. Finding and Extracting (8 min)

```cpp
std::string line = "Ice Ice Baby";

size_t pos = line.find("Baby");
if (pos != std::string::npos) {
    std::cout << "found at position " << pos << "\n";   // 8
}

std::string part = line.substr(8, 4);   // "Baby"
std::string rest = line.substr(4);      // "Ice Baby"
```

- `.find(needle)` returns the **position** of the first match, or `std::string::npos` if not found
- `std::string::npos` is a special "not found" sentinel --- always check for it
- `.substr(pos, len)` extracts `len` characters starting at `pos`; omit `len` to extract to the end

### Finding and Replacing

```cpp
std::string msg = "press play";
size_t pos = msg.find("play");
if (pos != std::string::npos) {
    msg.replace(pos, 4, "stop");
}
std::cout << msg << "\n";   // press stop
```

## 9. Reading Input --- `getline` and the Mix Trap (8 min)

```cpp
std::string full_name;
std::cout << "enter your full name: ";
std::getline(std::cin, full_name);
```

- `std::getline(std::cin, s)` reads **up to the newline**, including spaces
- Contrast with `std::cin >> s`, which stops at whitespace

::: {.tip}
**Trap:** If you mix `std::cin >>` and `std::getline`, the newline left by `>>` gets consumed by the next `getline`, giving an empty string. Fix it with `std::cin.ignore()`:

```cpp
int age;
std::string name;
std::cin >> age;
std::cin.ignore();              // discard the leftover newline
std::getline(std::cin, name);
```
:::

## 10. Strings to/from Numbers (7 min)

```cpp
std::string year_str = "1997";
int year = std::stoi(year_str);
std::cout << year + 1 << "\n";    // 1998

std::string price_str = "9.99";
double price = std::stod(price_str);

int track = 7;
std::string label = "Track " + std::to_string(track);
std::cout << label << "\n";       // Track 7
```

- `std::stoi` --- string to int
- `std::stod` --- string to double
- `std::to_string` --- any number to string

::: {.tip}
**Trap:** `std::stoi("abc")` **throws an exception** and crashes your program unless you handle it. Exception handling is coming in chapter 11.
:::

## 11. Try It --- Live Demo (4 min)

```cpp
#include <iostream>
#include <string>

int main() {
    std::string song = "Bailamos";
    std::cout << song << " has " << song.size() << " characters\n";

    song += ", mi amor";
    std::cout << song << "\n";

    size_t pos = song.find("mi");
    if (pos != std::string::npos) {
        std::cout << "found 'mi' at position " << pos << "\n";
    }

    std::cout << "first word: " << song.substr(0, 8) << "\n";
    return 0;
}
```

Ask the class to predict `song.size()` after the `+=`. Then run it.

## 12. Wrap-up Quiz Questions (3 min)

**Q1.** What does this print?

```cpp
std::string a = "Ice";
std::string b = a + " " + a + " Baby";
std::cout << b.size() << "\n";
```

A. 8
B. 11
C. 12
D. 13
E. Ben got this wrong

*Answer: C* --- `"Ice Ice Baby"` is 12 characters including the spaces.

**Q2.** Where is the bug?

```cpp
std::string greeting = "Hello, " + "world!";
```

A. Missing `#include <string>`
B. `std::string` does not allow `+`
C. Both operands are string literals --- at least one side must be a `std::string`
D. `+` requires `+=` instead
E. Ben got this wrong

*Answer: C*

**Q3.** After `std::cin >> age;`, you call `std::getline(std::cin, name);` and `name` comes back **empty**. Why?

A. `std::getline` only reads one word
B. The newline left by `>>` was consumed by `getline`
C. `std::cin` was closed
D. `std::getline` does not work with `std::string`
E. Ben got this wrong

*Answer: B* --- fix with `std::cin.ignore()`.

## 13. Assignment / Reading (1 min)

- **Read:** chapter 4 of *Gorgo Starting C++*
- **Do:** all 9 exercises at the end of chapter 4
- **Bring:** next time we will build expressions from strings and numbers together

## Key Points to Reinforce

- `std::string` lives in `<string>` --- always include it
- `.size()` / `.length()` are equal; both return `size_t`
- Concatenation with `+` requires at least one `std::string` operand
- `==`, `<`, etc. compare by ASCII value, character by character
- `[]` is fast, `.at()` is safe --- know which you need
- `std::getline` reads full lines; watch out for leftover newlines after `>>`
- `std::stoi`, `std::stod`, `std::to_string` bridge strings and numbers
