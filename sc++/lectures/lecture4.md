# Lecture 4 --- Expressions

**Source:** `sc++/ch04.md`
**Duration:** 75 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Use the arithmetic operators `+ - * / %` and explain the integer-vs-floating-point division trap
- Build boolean expressions with comparison operators and the logical operators `&& || !`
- Take advantage of **short-circuit evaluation** to write safe guard conditions
- Distinguish prefix (`++n`) and postfix (`n++`) increment, and choose the right one
- Use compound assignment (`+=`, `-=`, etc.) and recognize the common bitwise operators
- Read the ternary operator `?:` and decide when to prefer it over `if/else`
- Apply operator precedence rules and defend themselves with parentheses when in doubt

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch04.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 3): **What is the bug in `std::string greeting = "Hello, " + "world!";`?**
    - A. Missing `#include <string>`
    - B. `std::string` does not allow `+`
    - C. Both operands are string literals; at least one side must be a `std::string`
    - D. `+` should be `+=`
    - E. Ben got this wrong

    *Answer: C*

- Today we leave behind pure storage and learn to **compute** with the values we have stored

## 1. Assignment (3 min)

```cpp
int jumps = 0;
jumps = 42;
jumps = jumps + 1;    // 43
```

- `=` evaluates the right-hand side first, then stores the result in the left
- You can (and often do) use the variable itself on the right

::: {.tip}
**Trap:** `if (x = 5)` **assigns** 5 to `x` and then tests truthiness. Use `==` to compare. Enable `-Wall` to catch this.
:::

## 2. Arithmetic Operators (8 min)

```cpp
7 + 3    // 10
7 - 3    //  4
7 * 3    // 21
7 / 3    //  2  <-- integer division!
7 % 3    //  1  <-- modulo, integers only
```

### Integer Division

```cpp
int wrong   = 7 / 3;         // 2
double right = 7.0 / 3;      // 2.333...
double also  = 7 / 3.0;      // 2.333...
```

- Two integer operands --> fractional part is **truncated**, not rounded
- At least one operand must be floating-point to keep the decimals

::: {.tip}
**Trap:** Integer division by zero is **undefined behavior** (typically a crash). Always check your divisor.
:::

### Modulo for Even/Odd

```cpp
if (number % 2 == 0) {
    std::cout << "even\n";
} else {
    std::cout << "odd\n";
}
```

- `%` only works on integers --- no `%` on `double`

## 3. Comparison Operators (4 min)

`==`, `!=`, `<`, `>`, `<=`, `>=` --- all produce a `bool`.

| expression | result |
|---|---|
| `5 == 5` | `true` |
| `5 != 3` | `true` |
| `3 < 5` | `true` |
| `3 >= 5` | `false` |

- Remember from chapter 3: these also work on strings, character by character

## 4. Logical Operators and Short Circuit (10 min)

| operator | name | example |
|---|---|---|
| `&&` | AND | `a && b` is true only if both are true |
| `\|\|` | OR | `a \|\| b` is true if either is true |
| `!` | NOT | `!a` inverts a bool |

Real example:

```cpp
int pencils = 2;
int pens = 1;
bool has_calculator = true;
bool can_take_test = (pencils == 2 || pens == 1) && !has_calculator;
```

### Short Circuit

```cpp
int x = 0;
if (x != 0 && 10 / x > 2) {
    // safe --- the divide never runs when x is 0
}
```

- `&&` stops at the first false; `||` stops at the first true
- This is **guaranteed**, not an optimization --- you can rely on it for guard conditions

::: {.tip}
**Tip:** When in doubt about how logical operators group, use parentheses. `!` binds tighter than `&&` and `||`.
:::

## 5. Increment and Decrement (6 min)

```cpp
int a = 5;
int b = ++a;   // prefix:  a is 6, b is 6
int c = a++;   // postfix: c is 6 (old a), then a becomes 7
```

- Prefix (`++a`): increment, then yield the new value
- Postfix (`a++`): yield the current value, then increment
- Stand-alone `n++;` and `++n;` behave identically

::: {.tip}
**Tip:** Prefer prefix `++n` as a habit. For complex types (like iterators in chapter 8) prefix can be measurably faster because it avoids copying the old value.
:::

## 6. Compound Assignment (3 min)

```cpp
int score = 100;
score += 50;   // 150
score -= 25;   // 125
score *= 2;    // 250
```

- `+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`
- Pure shorthand --- no behavior difference from `x = x + y`

## 7. Bitwise Operators (Preview) (6 min)

```cpp
0b1100 & 0b1010   // 0b1000   AND
0b1100 | 0b1010   // 0b1110   OR
0b1100 ^ 0b1010   // 0b0110   XOR
~0b1100           // flips all bits
0b0001 << 2       // 0b0100
0b1000 >> 2       // 0b0010
```

- `0b` prefix lets you write binary literals directly
- Bit-level work is coming in detail in chapter 7 --- today is just a preview

::: {.tip}
**Trap:** `&&` is not `&`, and `||` is not `|`. Do not confuse logical and bitwise operators.
:::

::: {.tip}
**Trap:** `^` is **not** exponentiation! `2^2` is **0**, not 4. (XOR of `10` and `10` is `00`.)
:::

## 8. The Ternary Operator (5 min)

```cpp
int temperature = 30;
std::string weather = (temperature > 25) ? "hot" : "cool";
```

- `condition ? value_if_true : value_if_false`
- Equivalent to a simple `if/else`, but as a single **expression**
- Best for short, obvious choices --- fall back to `if/else` when logic gets hairy

## 9. Operator Precedence (8 min)

Show the chapter's precedence table on the board. Call out the common gotchas:

- Multiplicative (`* / %`) binds tighter than additive (`+ -`)
- Comparison (`== !=`) binds **tighter** than bitwise (`& | ^`)
- Assignment is **lower** than almost everything else

The classic trap:

```cpp
// BUG: parses as flags & (0x02 == 0x02)
if (flags & 0x02 == 0x02) { ... }

// CORRECT
if ((flags & 0x02) == 0x02) { ... }
```

::: {.tip}
**Tip:** When in doubt, add parentheses. You do not get bonus points for memorizing the precedence table.
:::

## 10. Try It --- Live Demo (4 min)

```cpp
#include <iostream>
#include <string>

int main() {
    int x = 10, y = 3;
    std::cout << "x + y = " << x + y << "\n";
    std::cout << "x / y = " << x / y << "\n";
    std::cout << "x % y = " << x % y << "\n";

    x += 5;
    std::cout << "x += 5 => " << x << "\n";

    int a = 5;
    int b = ++a;
    int c = a++;
    std::cout << "a=" << a << " b=" << b << " c=" << c << "\n";

    std::string result = (x > y) ? "Jump around!" : "U can't touch this";
    std::cout << result << "\n";
}
```

Have the class predict the values of `a`, `b`, and `c` before you run it.

## 11. Wrap-up Quiz Questions (3 min)

**Q1.** What does this print?

```cpp
int a = 10;
int b = a++;
int c = ++a;
std::cout << a << " " << b << " " << c << "\n";
```

A. `10 10 11`
B. `11 10 11`
C. `12 10 12`
D. `12 11 12`
E. Ben got this wrong

*Answer: C* --- after `b = a++`, a=11, b=10. Then `c = ++a` makes a=12, c=12.

**Q2.** Why does this **not** crash?

```cpp
int x = 0;
bool ok = (x != 0) && (100 / x > 5);
```

A. The compiler optimizes away the divide
B. Division by zero is actually fine
C. Short-circuit evaluation --- `&&` stops after the first false
D. `ok` is just a declaration, nothing runs
E. Ben got this wrong

*Answer: C*

**Q3.** What does this print?

```cpp
int score = 85;
std::string grade = (score >= 90) ? "A"
                  : (score >= 80) ? "B"
                  : (score >= 70) ? "C"
                  : "F";
std::cout << grade << "\n";
```

A. `A`
B. `B`
C. `C`
D. `F`
E. Ben got this wrong

*Answer: B*

## 12. Assignment / Reading (1 min)

- **Read:** chapter 5 of *Gorgo Starting C++*, **sections on `if` and `while` only** (we cover `do-while`/`for`/`switch` next week)
- **Do:** chapter 5 exercises 1, 5, 7 (decision-making and while loops)
- **Bring:** a program that reads a number and classifies it even/odd and positive/negative/zero

## Key Points to Reinforce

- `=` stores, `==` compares --- do not confuse them
- Integer `/` truncates; use a `double` operand for real division
- `%` is integer only
- `&&` and `||` short-circuit --- lean on that for guard conditions
- Prefix vs postfix matters inside an expression
- Comparison binds tighter than bitwise --- parenthesize bitwise checks
- When in doubt, **parenthesize**
