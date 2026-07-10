# Lecture 7 --- Numbers and Casting

**Source:** `c4c++/ch09.md`
**Duration:** 65 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Explain that the CPU sees only numbers and that types tell the compiler how to use them
- Do arithmetic on `char` values and convert between the `%c` and `%d` views
- Explain that a pointer is just a number used as a memory address
- Describe a C string as an array of small integers ending in a `0` byte
- Convert strings to numbers with `strtol` and explain why it beats `atoi`
- Look up integer sizes and ranges with `sizeof` and `<limits.h>`
- Predict the result of unsigned arithmetic like `size_t` subtraction
- Explain why `float f = 1.2` fails an `f == 1.2` comparison
- Cast with `(type)value` and state which scalar casts are allowed
- Spot the `(int)"1999"` trap and fix it with `strtol`

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Whiteboard for the integer-size table and byte diagrams
- Copy of `c4c++/ch09.md` for reference

---

## 0. Review (5 min)

**Q.** Why choose `calloc` over `malloc` + `memset`?

A. `calloc` is always faster
B. It is clearer intent and the library can often skip the memset for fresh pages
C. `malloc` cannot allocate arrays
D. `memset` only works on chars
E. Ben got this wrong

*Answer: B*

## 1. Everything Is a Number (5 min)

- The CPU has no concept of characters, strings, pointers, or objects --- only numbers in registers and memory.
- Types do not change the bits; they tell the *compiler* how you plan to interpret and use those numbers.
- A `char` is just a small integer (usually 8 bits); `'A'` is exactly the same as `65`.

```c
char grade = 'A';   // same as: char grade = 65;

printf("%c %d\n", grade, grade);   // A 65

char next = grade + 1;             // 65 + 1 = 66
printf("%c\n", next);              // B
```

- Math on characters is just integer math --- there is no conversion happening.

## 2. Pointers Are Numbers Too (3 min)

```c
int year = 1999;
int *p = &year;

printf("Address: %p\n", (void *)p);   // e.g., 0x7ffc965e5104
```

- A pointer is an integer that represents a memory address.
- The type `int *` tells the compiler: "treat the number at this address as an `int`."
- `%p` prints the number, usually as hexadecimal.

## 3. Strings Are Not Special (4 min)

- C has no native understanding of "strings."
- A string is an array of characters (small integers) that ends with a `0` byte (the null terminator).
- `<string.h>` provides the illusion by processing those numbers until it hits the `0`.

```c
char word[] = "Hola";

printf("String: %s\n", word);
printf("Bytes: ");
for (int i = 0; i < (int)sizeof(word); i++)
    printf("%d ", word[i]);
printf("\n");
// Output:
// String: Hola
// Bytes: 72 111 108 97 0
```

## 4. Converting Strings to Numbers (8 min)

- The text `"1999"` and the integer `1999` are completely different bit patterns.
- Use `strtol` (string to long) from `<stdlib.h>`:

```c
long strtol(const char *str, char **endptr, int base);
```

- `str` is the text to parse; `endptr` points past the parsed digits (pass `NULL` if you do not care); `base` is 10, 16, or 0 to auto-detect.

```c
long jenny = strtol("8675309", NULL, 10);
printf("Jenny: %ld\n", jenny);   // 8675309
```

Base 0 auto-detects from the prefix:

```c
strtol("42",   NULL, 0);   // 42 --- decimal
strtol("0x2A", NULL, 0);   // 42 --- hex
strtol("052",  NULL, 0);   // 42 --- octal (leading 0)
```

::: {.tip}
**Trap:** With base 0, a leading zero silently means octal.
`strtol("010", NULL, 0)` returns `8`, not `10`.
If your input might be zero-padded decimal, pass `10` explicitly.
:::

- `strtod` does the same for floating point (no base argument).
- You will see the older `atoi`, `atol`, `atoll`, and `atof` in existing code:

```c
int n = atoi("banana");   // 0 --- bad input or a real zero?
```

::: {.tip}
**Tip:** Prefer the `strto*` family over `atoi` and friends.
You get base selection, an `endptr` that shows what was parsed, and real overflow reporting through `errno`.
Treat `atoi` as something you read, not something you write.
:::

Going the other way --- numbers to strings --- is a formatting job:

```c
char buf[16];
snprintf(buf, sizeof(buf), "%d", 1999);   // buf is "1999"
```

- The full `sprintf` / `sscanf` story comes with Standard I/O in chapter 10.

## 5. Integer Types and Ranges (6 min)

| Type | Bytes | Range | Suffix |
|------|:-----:|-------|:------:|
| `char` | 1 | -128 to 127 | |
| `short` | 2 | -32,768 to 32,767 | |
| `int` | 4 | about -2.1 to 2.1 billion | |
| `long` | 8 | about -9.2 to 9.2 quintillion | `L` |
| `long long` | 8 | same as `long` on 64-bit Linux | `LL` |

- Unsigned variants shift the range to start at 0 (`U`, `UL`, `ULL` suffixes).
- Sizes vary by platform --- these are the usual 64-bit numbers.
- Two's complement: the top bit is the sign, and there is one more negative value than positive.
- Explore your machine with `sizeof` and `<limits.h>`:

```c
printf("char: %zu byte,  %d to %d\n",
       sizeof(char), CHAR_MIN, CHAR_MAX);
printf("int:  %zu bytes, %d to %d\n",
       sizeof(int), INT_MIN, INT_MAX);
printf("long: %zu bytes, %ld to %ld\n",
       sizeof(long), LONG_MIN, LONG_MAX);
```

::: {.tip}
**Trap:** Every other integer type is signed by default, but the signedness of plain `char` is implementation-defined.
It is signed on x86_64 and unsigned on ARM.
Spell out `signed char` or `unsigned char` when the numeric range matters.
:::

## 6. Integer Promotion and the `size_t` Trap (4 min)

- Types smaller than `int` (like `char` and `short`) are promoted to `int` in expressions.
- Mixed sizes promote to the larger type; mixed signedness tends to go unsigned --- and that bites.
- `strlen` returns `size_t`, an unsigned type, so subtraction can wrap:

```c
char *a = "Whip";       // strlen = 4
char *b = "Whip It!";   // strlen = 8

size_t diff = strlen(a) - strlen(b);
printf("%zu\n", diff);   // 18446744073709551612

long sdiff = (long)strlen(a) - (long)strlen(b);
printf("%ld\n", sdiff);  // -4
```

- Cast to a signed type *before* subtracting when the difference can be negative.

## 7. Floating-Point Surprises (5 min)

- `float` is 4 bytes, `double` is 8, `long double` is 16; all are signed.
- Floating point has two zeros, infinities, and NaN --- integers have none of those.
- Fractions are sums of negative powers of 2: `0.5` and `0.25` are exact; `0.1` and `0.2` are not.

```c
float f = 1.2;
if (f != 1.2) printf("what?!?\n");
if (f == 1.2f) printf("ok\n");
// BOTH lines print!
```

- The literal `1.2` is a `double`; assigning it to `f` rounds it to `float` precision.
- The first `if` promotes `f` back to `double`, but the lost precision never comes back.
- `1.2f` was rounded the same way `f` was, so the second comparison succeeds.

## 8. Casting (7 min)

- A cast forces the compiler to treat a value of one type as another type: `(type) value`.
- C has exactly one cast syntax; C++ has four named casts.
- Much simpler, and much less magical --- a cast never parses, rounds, or converts text.

```c
double pi = 3.14159;
int roughly_pi = (int)pi;   // 3 --- truncates, does not round
```

- Float to integer truncates, but a value too big to fit the target type is undefined behavior.

Only scalar types can be cast:

| From / To | Integer | Floating-Point | Pointer |
| :--- | :--- | :--- | :--- |
| **Integer** | Yes | Yes | Yes |
| **Floating-Point** | Yes | Yes | No |
| **Pointer** | Yes | No | Yes |

- A cast tells the compiler: "I know what I am doing, suppress the warnings."
- C trusts you implicitly, so a wrong cast is on you.

::: {.tip}
**Trap:** Casting a `char *` to an integer converts the *address*, not the text.

```c
char *song_year = "1999";       // Prince
int bad_year = (int)song_year;  // BUG! not 1999
```

The compiler even warns: `cast from pointer to integer of different size`.
The 8-byte address gets chopped to fit a 4-byte `int` --- garbage either way.
Always use `strtol` to parse strings into numbers.
:::

## 9. Casting Pointers to Other Pointers (4 min)

```c
int nums[] = {1984, 1985, 1986, 1987};

void *vp = nums;         // any pointer converts to void *
int *ip = (int *)vp;     // cast back to use it
printf("%d\n", ip[0]);   // 1984

char *bp = (char *)nums; // byte-level view
printf("0x%02x\n", (unsigned char)bp[0]);   // 0xc0
```

- `void *` points at anything --- this is why `malloc` needs no cast in C (lecture 5).
- `char *` gives you a byte-by-byte view of any object.
- `1984` is `0x7C0`; a little-endian machine stores the low byte first, so `bp[0]` is `0xc0`.
- When you cast pointer to pointer, *you* are responsible for knowing the memory layout.

## 10. Live Coding: Numbers Starter (5 min)

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main(void) {
    // characters are just numbers
    char ch = 'A';
    printf("'%c' is %d\n", ch, ch);
    printf("'%c' + 3 = '%c' (%d)\n", ch, ch + 3, ch + 3);

    // strings are arrays of numbers
    char title[] = "Xanadu";
    printf("\"%s\" bytes: ", title);
    for (int i = 0; i < (int)sizeof(title); i++)
        printf("%d ", title[i]);
    printf("\n");

    // string to number conversion
    long jenny = strtol("8675309", NULL, 10);
    printf("Jenny's number: %ld\n", jenny);

    // hex string to number
    long color = strtol("FF8000", NULL, 16);
    printf("0x%lX = %ld\n", color, color);

    // integer sizes on this machine
    printf("sizeof(int)  = %zu\n", sizeof(int));
    printf("sizeof(long) = %zu\n", sizeof(long));
    printf("INT_MAX      = %d\n", INT_MAX);

    // casting: float to int truncates
    double tempo = 118.9;
    printf("(int)%.1f = %d\n", tempo, (int)tempo);

    // the classic trap
    char *year_str = "1999";
    long bad  = (long)year_str;
    long good = strtol(year_str, NULL, 10);
    printf("(long)\"1999\"        = %ld (an address!)\n", bad);
    printf("strtol(\"1999\", ...) = %ld\n", good);

    // bytes of an int: endianness
    int hex_val = 0xbadd00d;
    unsigned char *raw = (unsigned char *)&hex_val;
    printf("%x -> %02x %02x %02x %02x\n", hex_val,
           raw[0], raw[1], raw[2], raw[3]);

    return 0;
}
```

- Compile with `cc -Wall -Wextra -pedantic`.
- Change the `(long)year_str` cast to `(int)` and read the warning together.
- The byte dump prints `badd00d -> 0d d0 ad 0b` --- ask the class why the bytes are backwards (little-endian).

## 11. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
char c = 'A';
printf("%c %d\n", c + 1, c + 1);
```

A. `B 66`
B. `A 65`
C. `B 65`
D. `66 B`
E. Ben got this wrong

*Answer: A*

**Q2.** Where is the bug?

```c
char *track_str = "42";
int track = (int)track_str;
printf("Track %d\n", track);
```

A. `track_str` needs an `&`
B. `%d` should be `%s`
C. The cast converts the address, not the text --- use `strtol`
D. `"42"` is missing a null terminator
E. Ben got this wrong

*Answer: C*

**Q3.** What does this print?

```c
printf("%ld\n", strtol("010", NULL, 0));
```

A. `10`
B. `8`
C. `2`
D. `0`
E. Ben got this wrong

*Answer: B*

## 12. Assignment / Reading (2 min)

**Read:** chapter 10 of *Gorgo C for C++ Programmers*.
**Do:** exercises 1-7.

## Key Points to Reinforce

- To the CPU everything is a number; types tell the compiler how to use it
- `'A'` is 65; char math is integer math
- A pointer is a number used as a memory address
- A C string is an array of small integers ending in a `0` byte
- `strtol` over `atoi`: bases, `endptr`, and real error reporting
- `size_t` is unsigned; subtraction can wrap to a huge number
- Float literals are doubles; `f == 1.2` and `f == 1.2f` are different questions
- `(type)value` asserts you know what you are doing --- no magic happens
- Casting a `char *` to an int gives the address, not the parsed number --- use `strtol`
