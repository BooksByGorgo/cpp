# Lecture 9+10 --- Numbers

**Source:** `sc++/ch07.md`
**Duration:** 2 x 75 minutes (lectures 9 and 10)

Chapter 7 is split across two lectures:

- **Lecture 9 --- Representation and Conversion:** bases (decimal, binary, hex, octal), integer literals in other bases, printing in other bases, string-to-number / number-to-string conversions
- **Lecture 10 --- Two's Complement and Bit Manipulation:** two's complement, integer sizes and ranges, overflow, binary addition/subtraction, bit operators, shift operators

---

# Lecture 9 --- Representation and Conversion

## Learning Objectives

By the end of lecture 9, students should be able to:

- Count and convert between decimal, binary, hexadecimal, and octal
- Write integer literals in different bases using `0b`, `0x`, and leading `0`
- Use digit separators (`'`) to make large literals readable
- Print a value in a different base with `std::format`/`std::println` specifiers
- Convert strings to numbers with `std::stoi`, `std::stod`, and friends, including the base parameter

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch07.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 8): **What is `factorial(6)`?**
    - A. 120
    - B. 180
    - C. 720
    - D. 5040
    - E. Ben got this wrong

    *Answer: C*

- Today we peek under the hood: how numbers are actually stored, written, and converted

## 1. Why Bases? (5 min)

*There are only 10 kinds of people in the world: those who understand binary and those who don't.*

- The number **five** is still five whether you write it `5`, `V`, or `|||||`
- Different **bases** make different patterns easy to spot
- In this lecture: decimal (what you grew up with), binary (what the CPU thinks in), hex (compact binary), octal (legacy but still seen)

## 2. Decimal and Binary (8 min)

Decimal place values:

```
  4   7   2
  |   |   |
  |   |   +-- 2 * 10^0 =   2
  |   +------ 7 * 10^1 =  70
  +---------- 4 * 10^2 = 400
                          ---
                          472
```

Binary place values:

```
  1   0   1   0   1   0
  |   |   |   |   |   |
  |   +---+---+---+---+-- pow(2, n)
  +-------- 2^5 = 32, etc.
```

Result: `101010` in binary = 42 in decimal

Counting:

| dec | bin |
|---|---|
| 0 | 0 |
| 1 | 1 |
| 2 | 10 |
| 3 | 11 |
| 4 | 100 |
| 5 | 101 |
| 6 | 110 |
| 7 | 111 |
| 8 | 1000 |

## 3. Hex and Octal (10 min)

### Hex (Base 16)

- Digits `0`-`9` and `A`-`F` (A=10, ... F=15)
- **One hex digit = 4 bits**, so 2 hex digits = 1 byte
- Used for colors, memory addresses, bit masks

```
Binary:  1010 1100
Hex:        A    C   -> 0xAC = 172
```

### Octal (Base 8)

- Digits `0`-`7`
- **One octal digit = 3 bits**
- Mostly seen in Unix file permissions (`0755`)

```
Binary:  101 010
Octal:     5   2    -> 052 = 42
```

## 4. Integer Literals in Other Bases (8 min)

```cpp
int dec = 42;         // decimal (no prefix)
int bin = 0b101010;   // binary  (0b prefix)
int hex = 0x2A;       // hex     (0x prefix)
int oct = 052;        // octal   (0  prefix)
```

All four are **exactly 42**.

::: {.tip}
**Trap:** Be careful with leading zeros! `052` is **octal**, not decimal 52. If you meant decimal, drop the leading zero.
:::

### Digit Separators

```cpp
int billion = 1'000'000'000;
int bits    = 0b1010'1100;
int color   = 0xFF'80'00;
```

- Single-quote `'` between digits, anywhere you like
- Compiler ignores them completely
- C++14 and later

## 5. Printing in Other Bases (7 min)

```cpp
int val = 42;
std::println("Decimal:     {}",    val);   // 42
std::println("Binary:      {:b}",  val);   // 101010
std::println("Hex:         {:x}",  val);   // 2a
std::println("Hex (upper): {:X}",  val);   // 2A
std::println("Octal:       {:o}",  val);   // 52

// with base prefix:
std::println("Binary: {:#b}", val);   // 0b101010
std::println("Hex:    {:#x}", val);   // 0x2a
```

- Format specifier lives inside `{}` after a colon
- The value does not change; you are only **looking** at it differently
- `std::format` and `std::println` come from chapter 10 --- full coverage later

## 6. Strings to Numbers (12 min)

```cpp
int a = std::stoi("42");         // 42
int b = std::stoi("  -7");       // -7 (skips leading whitespace)
int c = std::stoi("1984abc");    // 1984 (stops at first non-digit)

double d = std::stod("2.71828"); // 2.71828
double e = std::stod("1.5e3");   // 1500.0 (scientific notation)
```

- `std::stoi`, `std::stol`, `std::stoll` for ints of different sizes
- `std::stof`, `std::stod`, `std::stold` for floating-point

### The `pos` Parameter

```cpp
std::size_t pos;
int val = std::stoi("42px", &pos);
// val == 42, pos == 2 (index of 'p')
```

Useful for parsing multiple numbers from one string.

### Parsing Other Bases

```cpp
int a = std::stoi("101010", nullptr, 2);   // binary -> 42
int b = std::stoi("2A", nullptr, 16);      // hex    -> 42
int c = std::stoi("52", nullptr, 8);       // octal  -> 42
```

::: {.tip}
**Tip:** Pass base `0` to auto-detect from the prefix: `std::stoi("0x2A", nullptr, 0)`. **But** with base 0, `"010"` is parsed as **octal 8**, not decimal 10!
:::

## 7. Numbers to Strings (3 min)

```cpp
std::string s1 = std::to_string(42);      // "42"
std::string s2 = std::to_string(-7);      // "-7"
std::string s3 = std::to_string(3.14);    // "3.140000"
```

For prettier output, use `std::format` (chapter 10).

## 8. Try It --- Number Viewer (5 min)

```cpp
#include <iostream>
#include <print>

int main()
{
    std::print("Enter a number: ");
    int val{};
    std::cin >> val;

    std::println("Decimal:  {}",    val);
    std::println("Binary:   {:#b}", val);
    std::println("Hex:      {:#x}", val);
    std::println("Octal:    {:#o}", val);
}
```

Live-code this and ask students to predict the outputs for 255, 1984, and a negative number.

## 9. Wrap-up Quiz (5 min)

**Q1.** What does `std::stoi("1984abc")` return?

A. 0
B. 1984
C. throws an exception
D. the integer equivalent of the whole string
E. Ben got this wrong

*Answer: B* --- it stops at the first non-digit.

**Q2.** What does `std::stoi("010", nullptr, 0)` return?

A. 0
B. 8
C. 10
D. 16
E. Ben got this wrong

*Answer: B* --- base 0 auto-detects: a leading `0` means octal, and `010` octal is 8.

**Q3.** Which of these prints `0b101010`?

A. `std::println("{:#b}", 42)`
B. `std::println("{:b}", 42)`
C. `std::println("{b}", 42)`
D. `std::println("0b{:b}", 42)`
E. Ben got this wrong

*Answer: A* --- `#` turns on the base prefix.

## 10. Assignment / Reading (2 min)

- **Read:** chapter 7, remaining sections --- two's complement, integer sizes/ranges, overflow, binary arithmetic, bit and shift operators
- **Do:** chapter 7 exercises 3, 4, 5, 6, 8, 9, 10, 11 (two's complement, ranges, overflow, bit tests)
- **Bring:** a piece of paper for binary arithmetic by hand

## Key Points to Reinforce

- The same number has many spellings; the compiler stores the same value for all of them
- `0b`, `0x`, and leading `0` set the base of a literal
- `'` is a digit separator, ignored by the compiler
- `{:b}`, `{:x}`, `{:o}` print the same value in a different base
- `std::stoi`/`std::stod` parse strings; specify a `base` parameter when needed
- Leading zeros in input strings are a **minefield** --- know what `"010"` means in your context

---

# Lecture 10 --- Two's Complement and Bit Manipulation

## Learning Objectives

By the end of lecture 10, students should be able to:

- Compute two's complement by hand and explain why it is used over one's complement
- Describe the size and range of `char`, `short`, `int`, `long`, `long long` and their unsigned cousins
- Predict what happens on signed vs unsigned overflow
- Perform binary addition and subtraction
- Use bit operators (`&`, `|`, `^`, `~`) to set, clear, toggle, and test individual bits
- Use shift operators (`<<`, `>>`) to multiply and divide by powers of two

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch07.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 9): **What does `std::stoi("010", nullptr, 0)` return?**
    - A. 0
    - B. 8
    - C. 10
    - D. 16
    - E. Ben got this wrong

    *Answer: B*

- Now that you can write numbers in any base, let's talk about **how they are actually stored**

## 1. One's Complement (and Why We Don't Use It) (5 min)

- Early idea: flip every bit to negate
- In 8 bits: `42 = 0010 1010`, so `-42 = 1101 0101`
- **Fatal flaw:** two zeros
    - `+0 = 0000 0000`
    - `-0 = 1111 1111`
- Complicates hardware, comparisons, and arithmetic

## 2. Two's Complement (15 min)

Recipe: **flip all bits, then add 1**.

```
 42 = 0010 1010
      1101 0101   (flip)
    + 0000 0001   (add 1)
      ---------
-42 = 1101 0110
```

Check: there is only one zero.

```
 0 = 0000 0000
     1111 1111   (flip)
   + 0000 0001   (add 1)
     ---------
     0000 0000   (overflow discarded --- still 0)
```

### The Sign Bit

In 8-bit two's complement:

- `0xxx xxxx` --- **positive** (0 to 127)
- `1xxx xxxx` --- **negative** (-128 to -1)

Range: **-128 to 127** --- one more negative value than positive because zero takes one of the "positive" slots.

::: {.tip}
**Tip:** Nearly every modern CPU uses two's complement for signed integers. When you write `int x = -42;`, this is the bit pattern in memory.
:::

## 3. Integer Sizes and Ranges (10 min)

| Type | Bytes | Bits |
|---|---|---|
| `char` | 1 | 8 |
| `short` | 2 | 16 |
| `int` | 4 | 32 |
| `long` | 4 or 8 | 32 or 64 |
| `long long` | 8 | 64 |

### Range Formula

With `n` bits:

- **Unsigned:** `0` to `2^n - 1`
- **Signed:** `-2^(n-1)` to `2^(n-1) - 1`

| Type | Range |
|---|---|
| `unsigned char` | 0 to 255 |
| `char`/`signed char` | -128 to 127 |
| `unsigned int` | 0 to ~4.3 billion |
| `int` | -2.1 to +2.1 billion |
| `unsigned long long` | 0 to ~1.8 x 10^19 |
| `long long` | -9.2 x 10^18 to +9.2 x 10^18 |

::: {.tip}
**Tip:** Always use `std::numeric_limits<T>::min()` / `max()` when in doubt.
:::

## 4. Overflow and Underflow (10 min)

```cpp
unsigned char x = 255;
x = x + 1;   // x is now 0 (wraps around)
x = x - 2;   // x is now 254 (wraps around)
```

**Unsigned** wraps predictably.

```cpp
int y = 2'147'483'647;   // INT_MAX
y = y + 1;                // undefined behavior!
```

**Signed** overflow is **undefined behavior**.

::: {.tip}
**Trap:** "Undefined behavior" is not theoretical --- compilers exploit it for optimization and can produce genuinely bizarre results. Never rely on signed overflow.
:::

## 5. Binary Addition (5 min)

Carry at 2 instead of 10:

```
  0 + 0 = 0
  0 + 1 = 1
  1 + 0 = 1
  1 + 1 = 10  (0 carry 1)
```

```
    0010 1010   (42)
  + 0000 1111   (15)
  -----------
    0011 1001   (57)
```

## 6. Binary Subtraction via Two's Complement (5 min)

To compute `42 - 15`:

Step 1: `-15 = 1111 0001`

Step 2:

```
    0010 1010   (42)
  + 1111 0001   (-15)
  -----------
  1 0001 1011   (result 27; overflow bit discarded)
```

The same hardware handles signed and unsigned addition --- that is the brilliance of two's complement.

## 7. Bit Operators (10 min)

| op | name | example | result |
|---|---|---|---|
| `&` | AND | `0b1100 & 0b1010` | `0b1000` |
| `\|` | OR | `0b1100 \| 0b1010` | `0b1110` |
| `^` | XOR | `0b1100 ^ 0b1010` | `0b0110` |
| `~` | NOT | `~0b1100` | flips all bits |

Common idioms:

```cpp
// test a bit (is it set?)
if (flags & 0b0010) { ... }

// set a bit
flags |= 0b0010;

// clear a bit
flags &= ~0b0010;

// toggle a bit
flags ^= 0b0010;
```

## 8. Shift Operators (8 min)

### Left Shift `<<`

```
  0000 0101  (5)
  << 3
  0010 1000  (40)
```

- Multiplies by 2 each shift; `x << n` = `x * 2^n`

### Right Shift `>>`

```
  0010 1000  (40)
  >> 3
  0000 0101  (5)
```

- Divides by 2 each shift (integer division)
- For signed values, the sign bit is copied (arithmetic shift)

::: {.tip}
**Tip:** Modern compilers automatically turn `x * 4` into `x << 2` when the multiplier is a power of two. Write `x * 4` when you mean multiplication --- shifts are for bit manipulation.
:::

::: {.tip}
**Trap:** Shifting by more bits than the type has is **undefined behavior**. Valid shift counts for a 32-bit int are 0-31.
:::

## 9. Wrap-up Quiz (5 min)

**Q1.** Why does this loop never terminate?

```cpp
unsigned int count = 10;
while (count >= 0) {
    --count;
}
```

A. Off-by-one error
B. `count >= 0` is always true for unsigned
C. `--count` is wrong, should be `count--`
D. Infinite loops are undefined behavior
E. Ben got this wrong

*Answer: B* --- unsigned values are never negative, so the condition is always true.

**Q2.** What are the values after these statements?

```cpp
int a = 1 << 10;
int b = 100 >> 3;
int c = (1 << 4) - 1;
```

A. 10, 12, 15
B. 1024, 12, 15
C. 1024, 12, 16
D. 10, 12, 16
E. Ben got this wrong

*Answer: B*

**Q3.** What does this print?

```cpp
uint8_t a = 250;
uint8_t b = 20;
uint8_t sum = a + b;
std::println("{}", sum);
```

A. 270
B. 255
C. 14
D. undefined behavior
E. Ben got this wrong

*Answer: C* --- unsigned wraps: `270 - 256 = 14`.

## 10. Assignment / Reading (2 min)

- **Read:** chapter 8 of *Starting C++*, sections on `std::array` and `std::vector` basics (through size/capacity/empty/clear)
- **Do:** chapter 8 exercises 1, 2, 3, 5, 8, 10 (container basics, copy costs, clear vs capacity)
- **Bring:** questions about bit manipulation --- there will be time to dig deeper if needed

## Key Points to Reinforce

- Two's complement = flip and add 1; only one zero; addition works for signed and unsigned alike
- Signed overflow is **undefined behavior**; unsigned wraps
- `&` tests and clears, `|` sets, `^` toggles, `~` flips
- `<<` and `>>` multiply and divide by powers of two
- `unsigned` comparisons never go below zero --- watch out in loops

