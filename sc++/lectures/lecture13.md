# Lecture 13 --- I/O Streams

**Source:** `sc++/ch09.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Explain how the `<<` and `>>` interface is shared by console, string, and file streams
- Use stream manipulators (`std::setw`, `std::setprecision`, `std::fixed`, `std::boolalpha`) to format output
- Build a string with `std::ostringstream` and parse one with `std::istringstream`
- Read from a file with `std::ifstream` and write to a file with `std::ofstream`
- Always check that a file opened successfully before using it
- Combine file mode flags with `|` to open a file in append mode

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- A small text file (e.g., `setlist.txt` with 3-5 song names) for the live demo
- Copies of `sc++/ch09.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 12): **What does this print?**

    ```cpp
    std::vector<int> v = {10, 20, 30, 40, 50};
    v.insert(v.begin() + 2, 25);
    v.erase(v.begin());
    for (const auto& n : v) std::cout << n << " ";
    ```

    - A. `10 20 25 30 40 50`
    - B. `20 25 30 40 50`
    - C. `20 25 30 40`
    - D. `10 25 30 40 50`
    - E. Ben got this wrong

    *Answer: B*

- Today we expand `<<` and `>>` beyond the console --- to **strings** and **files**

## 1. Motivation (5 min)

Console I/O is ephemeral. When your program ends, everything you printed is gone.

- You cannot save results for later
- You cannot process data from an existing file
- You cannot build a complex string piece by piece before outputting it

C++ solves all of this by reusing the same `<<` / `>>` interface you already know --- just pointing it at different backends.

## 2. A Quick Review (3 min)

```cpp
#include <iostream>
#include <string>

int main() {
    std::string song;
    std::cout << "Favorite 90s song? ";
    std::getline(std::cin, song);
    std::cout << "Good choice: " << song << "\n";
}
```

- `std::cout` is an **output stream**, `std::cin` is an **input stream**
- `<<` inserts, `>>` extracts
- Chapter 1 territory --- you have been doing this since day one

## 3. Stream Manipulators (10 min)

Before `std::format` (chapter 10), C++ formatted with **manipulators** from `<iomanip>` and `<iostream>`.

| manipulator | effect |
|---|---|
| `std::boolalpha` | print bool as `true`/`false` |
| `std::fixed` | fixed-point float output |
| `std::scientific` | scientific notation |
| `std::setw(n)` | pad the next value to `n` chars |
| `std::setprecision(n)` | decimal places |
| `std::setfill(c)` | fill character |
| `std::hex` / `std::oct` / `std::dec` | base for integers |

```cpp
#include <iomanip>
#include <iostream>

int main() {
    bool on_tour = true;
    std::cout << on_tour << "\n";                  // 1
    std::cout << std::boolalpha << on_tour << "\n"; // true

    double score = 9.87654;
    std::cout << std::fixed << std::setprecision(2);
    std::cout << std::setw(10) << score << "\n";    //       9.88
}
```

::: {.tip}
**Tip:** Prefer `std::format` (chapter 10) for new code. Manipulators are **sticky** --- once set, they stay in effect for every subsequent output on that stream. Surprises await.
:::

::: {.tip}
**Wut:** `std::setw` is the exception --- it resets after a single `<<`. Every other manipulator is sticky.
:::

## 4. String Streams --- `std::ostringstream` (10 min)

Include `<sstream>`. Treat a `std::string` like a stream.

```cpp
#include <sstream>

std::ostringstream oss;
oss << "Man, it's a hot one" << " --- " << 1999;
std::string result = oss.str();
std::cout << result << "\n";
// Man, it's a hot one --- 1999
```

- Build a string piece by piece with `<<`
- `.str()` extracts the finished string
- Especially useful for mixing text and numbers without manual conversions

## 5. String Streams --- `std::istringstream` (10 min)

```cpp
std::string data = "42 3.14 hola";
std::istringstream iss(data);

int n;
double d;
std::string s;

iss >> n >> d >> s;
// n = 42, d = 3.14, s = "hola"
```

- Tokenize whitespace-separated values out of a string
- Reuse the same `>>` you already know from `std::cin`

Loop pattern:

```cpp
std::istringstream iss("I get knocked down 7 times");
std::string word;
while (iss >> word) {
    std::cout << "[" << word << "]\n";
}
// [I] [get] [knocked] [down] [7] [times]
```

## 6. File Streams --- Writing (10 min)

Include `<fstream>`. `std::ofstream` is an **output file stream**.

```cpp
#include <fstream>
#include <iostream>

int main() {
    std::ofstream outfile("setlist.txt");
    if (!outfile) {
        std::cerr << "Could not open file\n";
        return 1;
    }

    outfile << "Closing Time\n";
    outfile << "Smooth\n";
    outfile << "Tubthumping\n";

    outfile.close();
}
```

- Constructor takes the filename
- `if (!outfile)` checks whether the open succeeded
- Use `<<` exactly like `std::cout`
- `.close()` is good practice; the destructor closes automatically

::: {.tip}
**Trap:** If the file failed to open, subsequent `<<` calls **silently do nothing** --- no error, no data. **Always** check after opening.
:::

## 7. File Streams --- Reading (10 min)

```cpp
std::ifstream infile("setlist.txt");
if (!infile) {
    std::cerr << "Could not open\n";
    return 1;
}

std::string line;
int count = 0;
while (std::getline(infile, line)) {
    std::cout << ++count << ": " << line << "\n";
}
```

- `std::ifstream` for reading
- `std::getline(infile, line)` reads one line at a time
- The loop ends when the stream evaluates to `false` (end of file)

You can also read word by word with `>>`:

```cpp
std::string word;
while (infile >> word) {
    std::cout << word << "\n";
}
```

## 8. File Modes (5 min)

```cpp
std::ofstream log("events.log", std::ios::out | std::ios::app);
```

| flag | meaning |
|---|---|
| `std::ios::out` | write (default for `ofstream`) |
| `std::ios::in` | read (default for `ifstream`) |
| `std::ios::app` | append to end |
| `std::ios::binary` | binary mode, no text translation |
| `std::ios::trunc` | truncate on open (default with `out`) |

- Combine with `|` (same bitwise OR from chapter 4)
- `std::ios::app` is the way to say "do not overwrite, append"

## 9. Try It --- Writing and Reading Together (5 min)

```cpp
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

int main() {
    std::ofstream out("setlist.txt");
    out << "ClosingTime 1998\n";
    out << "Tubthumping 1997\n";
    out << "Smooth 1999\n";
    out.close();

    std::ifstream in("setlist.txt");
    std::string line;
    int count = 0;
    while (std::getline(in, line)) {
        std::istringstream iss(line);
        std::string song;
        int year;
        iss >> song >> year;
        std::cout << ++count << ". " << song << " (" << year << ")\n";
    }
}
```

- One stream writes, another reads
- A third stream (per line) parses

## 10. Wrap-up Quiz (5 min)

**Q1.** What is wrong with this file-writing code?

```cpp
std::ofstream out;
out << "Yo me la paso bien\n";
out.close();
```

A. Missing `#include <fstream>`
B. No filename was passed to the constructor --- the stream is not attached to a file
C. `\n` should be `std::endl`
D. You cannot `<<` to an `ofstream`
E. Ben got this wrong

*Answer: B*

**Q2.** What does this print?

```cpp
std::istringstream iss("100 hola 3.14");
int n;
std::string s;
double d;
iss >> n >> s >> d;
std::cout << d << " " << n << " " << s << "\n";
```

A. `100 hola 3.14`
B. `3.14 100 hola`
C. `3.14 hola 100`
D. `hola 100 3.14`
E. Ben got this wrong

*Answer: B*

**Q3.** Why is it useful that all streams share the same `<<`/`>>` interface?

A. It is not --- it is confusing
B. The compiler requires it
C. Code that works with one stream works with all of them, without rewriting
D. It makes files faster
E. Ben got this wrong

*Answer: C*

## 11. Assignment / Reading (2 min)

- **Read:** chapter 10 of *Gorgo Starting C++* (`std::format` and `std::print`)
- **Do:** all 6 exercises at the end of chapter 10
- **Bring:** any file that you want to process programmatically next week

## Key Points to Reinforce

- All C++ streams share `<<` and `>>` --- once you know one, you know them all
- `std::ostringstream` builds strings; `std::istringstream` parses them
- `std::ofstream` writes; `std::ifstream` reads
- **Always** check `if (!stream) { /* error */ }` after opening a file
- Stream manipulators are sticky --- prefer `std::format` for new code
- Combine file mode flags with `|`; `std::ios::app` appends
