# Lecture 1 --- Introduction to C++

**Source:** `sc++/ch01.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Write, compile, and run a `Hello, World!` program in C++
- Explain the role of `#include`, `main()`, semicolons, and curly braces
- Write comments and use escape sequences like `\n` and `\"`
- Use `std::cout` to write output and `std::cin` to read input
- Describe what a namespace is and why `std::` shows up everywhere
- Read command-line arguments via `argc` and `argv`, and write a USAGE message

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch01.md` for reference

---

## 0. Welcome and Course Logistics (5 min)

- Introduce yourself, the course, where to find materials
- How the lectures map to the textbook (lecture N --- chapter N)
- Where to get help: office hours, discussion board
- No previous programming experience assumed --- ask questions early and often
- **No review question this lecture** --- this is the first one

## 1. Why C++? (3 min)

- C++ is a **compiled** language: source code is translated by a compiler into a runnable program
- Used for games, browsers, operating systems, embedded devices, finance, scientific computing
- Tradeoff: more control over the machine, more responsibility for the programmer
- Today we get the tiniest taste --- we will spend the entire term going deeper

## 2. Hello, World! (8 min)

Live-code this with the class typing along:

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

Walk through it line-by-line:

- `#include <iostream>` --- pulls in the iostream library so we can do I/O
- `int main()` --- entry point of every C++ program; the `int` says it returns an integer
- `std::cout << "Hello, World!" << std::endl;` --- sends text to standard output
    - `<<` is the stream insertion operator
    - `std::endl` ends the line **and** flushes the buffer
- `return 0;` --- by convention, `0` means success

Mention briefly (do not dive in yet):

- The `<<` operator can be chained: `std::cout << a << b << c;`
- `"\n"` is a faster alternative to `std::endl` when you do not need to flush

## 3. Compiling and Running (8 min)

Save the file as `hello.cpp` and run in the terminal:

```
c++ -o hello hello.cpp
./hello
```

Then immediately recompile with warnings on and the standard pinned:

```
c++ -std=c++23 -Wall -Wextra -pedantic -o hello hello.cpp
```

Talking points:

- The compiler turns `hello.cpp` into an executable `hello`
- `-o hello` names the output --- without it you get `a.out`
- `-std=c++23` pins the language version so the compiler does not silently fall back to an older standard
- **Always** compile with warnings on; the compiler is your friend
- Demonstrate a deliberate error (drop the `;` after `std::endl`) so students see what a compiler error looks like
    - Modern g++ points at the end of the line with the missing semicolon and suggests inserting `;`; older compilers sometimes reported the line *after* it instead

::: {.tip}
**Tip:** When students see a confusing error, the first instinct should be: read the message, look where the caret points, and check for a missing `;` or `}`.
If the message still makes no sense, check the line above the one reported.
:::

## 4. Semicolons, Curly Braces, and Whitespace (4 min)

- Every **statement** ends with `;`
- `{` and `}` define a **block** of code
- They always come in pairs --- if you open one, you must close it
- The compiler does not care about whitespace --- indentation is purely for human readers
- Indent everything inside a block (4 spaces is standard) and follow the project's style guide; `clang-format -i hello.cpp` reformats for you
- Forgetting a `;` or `}` is the most common beginner mistake

Quick demo: comment out the `}` at the end of `main` and watch the compiler complain.

## 5. Comments (4 min)

- A **comment** is a note for human readers that the compiler ignores
- `//` starts a line comment that runs to the end of the line
- `/* ... */` is a block comment that can span multiple lines
- Use comments to explain *why* the code does something --- the code already shows *what*

```cpp
int year = 1991;   // the year Nevermind came out

/* this is a comment
   that spans several lines */
```

::: {.tip}
**Trap:** Block comments do not nest --- the compiler stops at the *first* `*/`.
To disable a chunk of code that already contains a block comment, use `//` on each line instead.
:::

## 6. Namespaces and `std::` (4 min)

- C++ groups standard library names inside the `std` namespace
- `std::cout` means "the `cout` that lives in `std`"
- `::` is the **scope resolution operator**
- Optional shortcut --- `using namespace std;` --- but avoid it in real code

Show both versions side-by-side:

```cpp
#include <iostream>
int main() {
    std::cout << "explicit" << std::endl;
}
```

```cpp
#include <iostream>
using namespace std;
int main() {
    cout << "shortcut" << endl;
}
```

For the rest of the course we will write `std::` explicitly so we always know where names come from.

## 7. Output with `std::cout` (4 min)

Chain output to mix strings and numbers:

```cpp
#include <iostream>

int main() {
    std::cout << "Come as you are" << ", " << "as you were" << std::endl;
    std::cout << "The year is " << 1991 << std::endl;
    return 0;
}
```

- The order of `<<` is left-to-right, just like reading
- Numbers can be inserted directly --- no special formatting needed yet
- Anything that does not have a newline stays on the current line

## 8. Escape Sequences (5 min)

- `\` tells the compiler the next character is special --- an **escape sequence**
- `\n` is a single newline character; use it instead of `std::endl` when you do not need to flush
- `\"` puts a double quote inside a string --- a bare `"` would end the string
- `\\` writes a literal backslash, since `\` itself is the escape character
- `\t` is a horizontal tab

```cpp
#include <iostream>

int main() {
    std::cout << "Smells Like\nTeen Spirit\n";
    std::cout << "She said \"hello\" and walked away\n";
    std::cout << "C:\\Users\\Kurt" << std::endl;
    return 0;
}
```

Output:

```
Smells Like
Teen Spirit
She said "hello" and walked away
C:\Users\Kurt
```

Mention the chapter's full table (`\r`, `\0`, `\a`, ...) exists, but `\n`, `\t`, `\\`, and `\"` are the ones students will use constantly.

## 9. Input with `std::cin` (8 min)

```cpp
#include <iostream>
#include <string>

int main() {
    std::string name;

    std::cout << "What is your name? ";
    std::cin >> name;
    std::cout << "Hola, " << name << "!" << std::endl;

    return 0;
}
```

- `std::cin` is the standard input stream; `>>` reads from it into a variable
- `#include <string>` is required because we are using `std::string`
- `std::cin >> name` reads **one word** --- it stops at whitespace
- For an entire line use `std::getline(std::cin, name)`

Reading a number works the same way:

```cpp
int year;
std::cout << "What year? ";
std::cin >> year;
```

::: {.tip}
**Trap:** If the user types `Los Del Rio`, `std::cin >> name` only stores `Los`.
Use `std::getline` when you want the whole line.
:::

## 10. Command-Line Arguments (8 min)

Programs can also receive input when they launch:

```cpp
#include <iostream>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cout << "USAGE: " << argv[0] << " <name>" << std::endl;
        return 1;
    }

    std::cout << "Hello, " << argv[1] << "!" << std::endl;
    return 0;
}
```

- `argc` --- the **argument count**, including the program name
- `argv` --- an array of strings, one per argument
- `argv[0]` is always the program name; user arguments start at `argv[1]`
- Returning a non-zero value (like `1`) signals an error

Demonstrate:

```
./greet Kurt          --> Hello, Kurt!
./greet               --> USAGE: ./greet <name>
```

Stress: **always validate `argc` before touching `argv[i]`** --- otherwise it is undefined behavior.

## 11. Putting It Together --- "Try It" Demo (8 min)

Live-code the `Try It` example from the chapter:

```cpp
#include <iostream>
#include <string>

int main() {
    std::string song;
    int year;

    std::cout << "Name a 90s song: ";
    std::getline(std::cin, song);

    std::cout << "What year? ";
    std::cin >> year;

    std::cout << song << " (" << year << ") es una cancion increible!" << std::endl;
    return 0;
}
```

Sample run:

```
Name a 90s song: Smells Like Teen Spirit
What year? 1991
Smells Like Teen Spirit (1991) es una cancion increible!
```

## 12. Wrap-up Quiz Questions (5 min)

End-of-lecture multiple choice questions to check comprehension:

**Q1.** What does this print?

```cpp
#include <iostream>
int main() {
    std::cout << "A" << "B" << std::endl;
    std::cout << "C" << std::endl;
    return 0;
}
```

A. `A B C`
B. `AB` then `C` on a new line
C. `A` then `B` then `C`, each on their own line
D. `ABC` all on one line, no newline
E. Nothing --- it does not compile

*Answer: B*

**Q2.** Which line contains the bug?

```cpp
1: #include <iostream>
2: int main()
3: {
4:     std::cout << "Here we are now" << std::endl
5:     return 0;
6: }
```

A. Line 1 --- wrong header
B. Line 2 --- `main` should return `void`
C. Line 4 --- missing semicolon
D. Line 5 --- cannot return `0`
E. Line 6 --- extra brace

*Answer: C*

**Q3.** If `argc` is 4, how many arguments did the user actually type after the program name?

A. 0
B. 2
C. 3
D. 4
E. 5 --- Ben got this wrong

*Answer: C*

## 13. Assignment / Reading (1 min)

- **Read:** chapter 2 of *Gorgo Starting C++*
- **Do:** exercises 1-15 at the end of chapter 2
- **Bring:** a working `hello.cpp` to next lecture --- you will be modifying it

## Key Points to Reinforce

- Every program starts at `main()`
- Every statement ends with `;`
- `{}` define blocks; they always pair up
- Comments (`//` and `/* ... */`) are for humans; block comments do not nest
- Escape sequences (`\n`, `\t`, `\"`, `\\`) put special characters inside strings
- `#include <iostream>` is required for `std::cout` / `std::cin`
- `<<` writes, `>>` reads
- `std::` tells the compiler the name comes from the standard library
- `argc` / `argv` give you command-line arguments --- validate before use
- Always compile with `-std=c++23 -Wall -Wextra -pedantic`
