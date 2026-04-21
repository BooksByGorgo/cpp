# Lecture 5+6 --- Control Flow

**Source:** `sc++/ch05.md`
**Duration:** 2 x 75 minutes (lectures 5 and 6)

Chapter 5 is split across two lectures:

- **Lecture 5 --- Decisions and `while`:** `if`/`else`/`else if`/nested `if`, `while` loops
- **Lecture 6 --- Loops, Jumps, and `switch`:** `do-while`, `break`/`continue`, `for` (classic and range-based), `switch` with fall-through

---

# Lecture 5 --- Decisions and `while`

## Learning Objectives

By the end of lecture 5, students should be able to:

- Write `if`, `if/else`, and `if/else if/else` chains to make decisions
- Recognize and avoid the `=` vs `==` trap in a condition
- Write a `while` loop that terminates correctly
- Trace a nested `if` and decide when to flatten it

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch05.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 4): **What does this print?**

    ```cpp
    int a = 10;
    int b = a++;
    int c = ++a;
    std::cout << a << " " << b << " " << c << "\n";
    ```

    - A. `10 10 11`
    - B. `11 10 11`
    - C. `12 10 12`
    - D. `12 11 12`
    - E. Ben got this wrong

    *Answer: C*

- Up until now every program runs straight through. Today we learn how to **branch** and **repeat**.

## 1. `if` Statements (10 min)

```cpp
int score = 85;

if (score >= 90) {
    std::cout << "Excelente!\n";
}
```

- The condition must be a boolean expression
- If true, the body runs; if false, it is skipped entirely
- Always use `{}` around the body --- it costs you nothing and saves you from the dangling-if trap

### `else` and `else if`

```cpp
if (score >= 90) {
    std::cout << "A\n";
} else if (score >= 80) {
    std::cout << "B\n";
} else if (score >= 70) {
    std::cout << "C\n";
} else {
    std::cout << "Try again\n";
}
```

- Conditions are tested **top to bottom**
- As soon as one matches, the rest are skipped
- The final `else` catches anything that did not match

::: {.tip}
**Trap:** `if (x = 5)` **assigns** 5 to `x`; it does not compare. Use `==`. `-Wall` will warn you.
:::

## 2. Nested `if` (8 min)

```cpp
int age = 20;
bool has_ticket = true;

if (age >= 18) {
    if (has_ticket) {
        std::cout << "Welcome to the show\n";
    } else {
        std::cout << "You need a ticket\n";
    }
} else {
    std::cout << "Must be 18 or older\n";
}
```

- Works, but deep nesting is hard to read
- Flatten by combining conditions with `&&`/`||` or by returning early from a function (we cover functions in chapter 6)

## 3. `while` Loops (15 min)

```cpp
int countdown = 5;

while (countdown > 0) {
    std::cout << countdown << "... ";
    countdown--;
}
std::cout << "Vamos!\n";
// 5... 4... 3... 2... 1... Vamos!
```

- Condition is tested **before** each iteration
- If the condition is false from the start, the body never runs at all
- Make sure the condition will eventually become false, or you have an infinite loop

::: {.tip}
**Trap:** Forgetting to update the loop variable is a classic infinite loop:

```cpp
int i = 0;
while (i < 10) {
    std::cout << i << "\n";
    // oops, forgot i++
}
```

Ctrl+C is your friend.
:::

### Input Validation With `while`

```cpp
int n;
std::cout << "Enter a positive number: ";
std::cin >> n;
while (n <= 0) {
    std::cout << "Try again: ";
    std::cin >> n;
}
```

- Classic pattern: ask, test, ask again
- Next lecture we will see that `do-while` makes this even cleaner

## 4. Try It --- Live Demo (15 min)

Live-code a simple guessing game:

```cpp
#include <iostream>

int main() {
    int target = 42;
    int guess;
    std::cout << "Guess my number: ";
    std::cin >> guess;

    while (guess != target) {
        if (guess < target) {
            std::cout << "Higher! ";
        } else {
            std::cout << "Lower! ";
        }
        std::cin >> guess;
    }
    std::cout << "You got it!\n";
    return 0;
}
```

- Ask the class for the smallest change that would make the loop infinite
- Ask what happens if the user types non-numeric input (preview of chapter 9)

## 5. Wrap-up Quiz (4 min)

**Q1.** What does this print?

```cpp
int x = 5;
if (x = 10) {
    std::cout << "A ";
}
std::cout << x << "\n";
```

A. `A 5`
B. `A 10`
C. `5`
D. `10`
E. Ben got this wrong

*Answer: B* --- `x = 10` assigns 10 and evaluates to 10 (truthy).

**Q2.** How many times does the body of this loop run?

```cpp
int i = 10;
while (i > 10) {
    std::cout << "hi\n";
    i++;
}
```

A. 0
B. 1
C. 10
D. infinite
E. Ben got this wrong

*Answer: A* --- the condition is false from the start.

## 6. Assignment / Reading (3 min)

- **Read:** chapter 5 of *Gorgo Starting C++*, sections on `do-while`, `break`/`continue`, `for`, and `switch` (the rest of the chapter)
- **Do:** chapter 5 exercises 2, 3, 4, 6, 8 (loop control, `for`, `switch`, fall-through, day-of-week program)
- **Bring:** questions about today's guessing game if anything is unclear

## Key Points to Reinforce

- `if` / `else if` / `else` chains are tested top-to-bottom, first match wins
- `while` tests the condition before each iteration
- Make sure the loop variable changes --- infinite loops are the #1 beginner bug
- `==` compares, `=` assigns --- do not confuse them

---

# Lecture 6 --- Loops, Jumps, and `switch`

## Learning Objectives

By the end of lecture 6, students should be able to:

- Use `do-while` for loops that must run at least once
- Use `break` to exit a loop and `continue` to skip an iteration
- Write classic `for` loops and range-based `for` loops
- Use `switch` with `break`, fall-through, and `default` clauses

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch05.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 5): **How many times does this loop run?**

    ```cpp
    int i = 10;
    while (i > 10) {
        i++;
    }
    ```

    - A. 0
    - B. 1
    - C. 10
    - D. infinite
    - E. Ben got this wrong

    *Answer: A*

- Last lecture we saw `if` and `while`. Today we finish chapter 5 with more powerful looping constructs.

## 1. `do-while` Loops (10 min)

```cpp
#include <iostream>
#include <string>

int main() {
    std::string input;

    do {
        std::cout << "Dime algo (or 'quit'): ";
        std::getline(std::cin, input);
        std::cout << "You said: " << input << "\n";
    } while (input != "quit");

    std::cout << "Adios!\n";
}
```

- Condition is tested **after** the body --- the body always runs at least once
- Notice the **semicolon** after `while(...)` --- required for `do-while`
- Classic use cases: menu loops, input prompts, retry-until-valid

::: {.tip}
**Tip:** Use `do-while` when you would otherwise duplicate code to prime a `while` loop's first test.
:::

## 2. `break` and `continue` (10 min)

```cpp
// break: stop searching once we find what we want
std::string tracks[] = {
    "Losing My Religion",
    "Bitter Sweet Symphony",
    "Zombie"
};

for (int i = 0; i < 3; i++) {
    if (tracks[i] == "Zombie") {
        std::cout << "Found it at index " << i << "\n";
        break;
    }
}
```

- `break` exits the **nearest** enclosing loop immediately
- `continue` skips the rest of the current iteration and jumps to the next iteration
- In a `for` loop, `continue` runs the update expression before testing the condition

```cpp
// continue: print only odd numbers
for (int i = 1; i <= 10; i++) {
    if (i % 2 == 0) continue;
    std::cout << i << " ";
}
std::cout << "\n";
// 1 3 5 7 9
```

::: {.tip}
**Trap:** `break` and `continue` only affect the **innermost** loop. A `break` inside a nested loop does not escape the outer loop.
:::

## 3. `for` Loops (15 min)

```cpp
for (int i = 0; i < 5; i++) {
    std::cout << i << " ";
}
// 0 1 2 3 4
```

Three parts of the header:

1. **init** --- runs once before the loop
2. **condition** --- tested before each iteration; if false, the loop ends
3. **update** --- runs after each iteration, before the next condition test

Iterating over an array with an index:

```cpp
int scores[] = {90, 84, 77, 95, 88};
int n = sizeof(scores) / sizeof(scores[0]);

for (int i = 0; i < n; i++) {
    std::cout << "Score " << (i + 1) << ": " << scores[i] << "\n";
}
```

Any part of the header can be omitted. `for (;;)` is an infinite loop.

::: {.tip}
**Tip:** Always declare your loop variable inside the `for`: `for (int i = 0; ...)`. That keeps `i` scoped to the loop.
:::

### Range-Based `for`

```cpp
int scores[] = {90, 84, 77, 95, 88};

for (int s : scores) {
    std::cout << s << " ";
}
// 90 84 77 95 88
```

- Takes each value in turn --- no index variable, no bounds worries
- Essential for `std::vector` and `std::array` in chapter 8

::: {.tip}
**Wut:** A range-based `for` **copies** each element by default. To modify in place or avoid copying large objects, use a reference: `for (int &s : scores)` (we cover references in chapter 6).
:::

## 4. `switch` Statements (15 min)

```cpp
int track = 2;

switch (track) {
case 1:
    std::cout << "Losing My Religion\n";
    break;
case 2:
    std::cout << "Bitter Sweet Symphony\n";
    break;
case 3:
    std::cout << "Zombie\n";
    break;
default:
    std::cout << "Unknown track\n";
    break;
}
```

- Each `case` label must be a **compile-time constant** (no variables, no strings)
- `default` runs when no other case matches --- include one for safety

### Fall-Through (Sometimes Useful, Often a Bug)

Intentional fall-through:

```cpp
switch (grade) {
case 'A':
case 'B':
case 'C':
    std::cout << "Passing\n";
    break;
case 'D':
case 'F':
    std::cout << "Not passing\n";
    break;
}
```

Accidental fall-through:

```cpp
switch (x) {
case 1:
    std::cout << "uno\n";
    // oops, no break!
case 2:
    std::cout << "dos\n";
    break;
}
```

If `x` is 1, this prints **both** "uno" and "dos".

::: {.tip}
**Trap:** End every `case` with `break` unless you intentionally want fall-through. When fall-through is deliberate, add `[[fallthrough]];` (C++17) or at least a comment so the reader knows you meant it.
:::

## 5. Try It --- Combined Demo (10 min)

Walk through the chapter's `Try It` combined example that uses `if`, `while`, `do-while`, `for`, range-based `for`, and `switch` together. Ask the class to predict each block's output.

```cpp
for (int i = 1; i <= 100; i++) {
    if (i >= 20) break;
    if (i % 2 == 0) continue;
    std::cout << i << " ";
}
// 1 3 5 7 9 11 13 15 17 19
```

## 6. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```cpp
int x = 2;
switch (x) {
case 1:
    std::cout << "uno ";
case 2:
    std::cout << "dos ";
case 3:
    std::cout << "tres ";
    break;
default:
    std::cout << "other ";
}
std::cout << "\n";
```

A. `uno`
B. `dos`
C. `dos tres`
D. `uno dos tres`
E. Ben got this wrong

*Answer: C* --- case 2 matches and falls through case 3.

**Q2.** How many times does the body run?

```cpp
int count = 0;
int i = 10;
do {
    count++;
    i--;
} while (i > 10);
```

A. 0
B. 1
C. 9
D. 10
E. Ben got this wrong

*Answer: B* --- `do-while` always runs the body once.

**Q3.** Where is the bug?

```cpp
int total = 0;
for (int i = 0; i < 10; i++);
{
    total += i;
}
```

A. Stray `;` after `for(...)` ends the loop body
B. `total` needs to be `double`
C. `i` is not in scope inside the braces
D. Both A and C
E. Ben got this wrong

*Answer: D* --- the `;` makes the loop body empty, and the block that follows cannot see `i`.

## 7. Assignment / Reading (3 min)

- **Read:** chapter 6 of *Gorgo Starting C++*, sections on declarations, parameters, pass-by-value, pass-by-reference, `const` parameters, and default parameters (first half of the chapter)
- **Do:** chapter 6 exercises 1, 2, 6, 11 (pass-by semantics, default params, ODR rule)
- **Bring:** a `for` loop that surprises you if anything from today is unclear

## Key Points to Reinforce

- `do-while` runs at least once --- use it for menus and input retries
- `break` exits the nearest loop; `continue` skips to the next iteration
- Classic `for` = init + condition + update; declare `i` inside
- Range-based `for` is cleaner when you do not need the index; use `&` to avoid copies
- `switch` requires a constant integer/enum; **always** `break` unless you mean to fall through
