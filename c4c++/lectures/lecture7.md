# Lecture 7 --- Numbers and Casting

**Source:** `c4c++/ch09.md`
**Duration:** 65 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Explain that the CPU sees only numbers and that types tell the compiler how to interpret them
- Do arithmetic on `char` values and explain why `'A'` is the same as `65`
- Describe a pointer as a number that holds a memory address
- Explain why C has no string type, only `0`-terminated arrays of `char` plus library functions
- Convert strings to numbers with `strtol` and `strtod` and explain why they beat `atoi`
- Recall the common integer sizes and ranges and the `char` signedness trap
- Explain why `0.1 + 0.2` is not exactly `0.3` and why comparing a `float` to a `double` literal can fail
- Use the C cast `(type)value` and state what a cast does and does not do
- Spot the classic bug of casting a `char *` to an integer

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Copy of `c4c++/ch09.md` for reference

---

## 0. Review (5 min)

**Q.** What is unsafe about `p = realloc(p, n)`?

A. `realloc` never fails
B. If `realloc` fails, `p` becomes `NULL` and the original block leaks
C. `realloc` requires a cast in C
D. `realloc` only grows, never shrinks
E. Ben got this wrong

*Answer: B*

## 1. Everything is a Number (6 min)

- To the CPU there are no characters, strings, pointers, or objects --- only numeric values in registers and memory.
- Types do not change the underlying bits; they tell the *compiler* how to interpret and use those numbers.
- Different numeric types give you different sizes (which determine range) and different semantics (signed/unsigned, integer/floating-point).
- A `char` is just a small integer (usually 8 bits). Assigning `'A'` is exactly the same as assigning `65` (in ASCII).

```c
char grade = 'A';
int score = 65;

// Both variables hold the exact same numeric value
printf("grade as char: %c, as int: %d\n", grade, grade);
printf("score as char: %c, as int: %d\n", score, score);

char next_grade = grade + 1;            // 65 + 1 = 66
printf("Next grade: %c\n", next_grade); // 'B'
```

- Same bits, two interpretations: `%c` prints `A`, `%d` prints `65`.
- Math on characters is just math on integers.

## 2. Pointers are Numbers Too (4 min)

```c
int val = 1986; // Year "Danger Zone" charted
int *p = &val;

printf("Address: %p\n", (void *)p); // e.g., 0x7ffd9b8
```

- A pointer is an integer that represents a memory address.
- The type `int *` tells the compiler: "treat this address number as the location of an `int`."
- `%p` prints the address, usually as hexadecimal (cast the pointer to `void *`).

## 3. Strings are Not Special (6 min)

- Because everything is a number, C has no native understanding of "strings."
- A string is merely an array of characters (small integers) ending in a special `0` byte --- the null terminator `'\0'`.
- The literal `"Africa"` is just the numbers `65, 102, 114, 105, 99, 97, 0` in read-only memory, and you get a `char *` to the first one.
- `<string.h>` gives you the *illusion* of strings by walking these arrays until it hits the `0` byte.

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

- The five bytes are the ASCII values for `H`, `o`, `l`, `a`, and the null terminator.

## 4. Converting Strings to Numbers (10 min)

- The text `"1986"` and the integer `1986` are completely different bit patterns.
- Converting between them is one of the most common tasks in C.

```c
long strtol(const char *str, char **endptr, int base);
```

```c
char *year_str = "1986";
long year = strtol(year_str, NULL, 10);
printf("Year: %ld\n", year);   // Year: 1986
```

- `endptr` is set to the first character after the parsed number; pass `NULL` if you don't need it.
- The base is 10 for decimal, 16 for hex, or 0 to auto-detect from the prefix.

```c
strtol("42",   NULL, 0);   // 42 --- decimal
strtol("0x2A", NULL, 0);   // 42 --- hex
strtol("052",  NULL, 0);   // 42 --- octal (leading 0)
```

::: {.tip}
**Trap:** Base 0 is handy when you want to accept multiple formats, but a leading zero silently changes the meaning.
`strtol("010", NULL, 0)` returns `8`, not `10`.
If your input might have zero-padded decimals (like `"007"` for track 7), pass `10` explicitly.
:::

- `strtod` (string to double) works the same way, minus the base argument.
- Older code uses `atoi`, `atol`, `atoll`, and `atof` --- simpler looking, but weaker:

```c
int n = atoi("banana");   // returns 0 --- really "0"? no way to tell.
```

- No base selection, no `endptr`, no error reporting, and undefined behavior on overflow.

::: {.tip}
**Tip:** Prefer `strtol`, `strtoul`, `strtoll`, `strtoull`, and `strtod` over `atoi` and friends.
Treat `atoi` as something you read, not something you write.
:::

- Next lecture covers `sprintf` and `sscanf`, which convert in both directions.

## 5. Integer Types and Promotion (8 min)

| Type | Bytes | Range | Suffix |
|------|:-----:|-------|:------:|
| `signed char` | 1 | -128 to 127 | |
| `unsigned char` | 1 | 0 to 255 | |
| `short` | 2 | -32,768 to 32,767 | |
| `unsigned short` | 2 | 0 to 65,535 | |
| `int` | 4 | -2^31 to 2^31-1 | |
| `unsigned int` | 4 | 0 to 2^32-1 | `U` |
| `long` | 8 | -2^63 to 2^63-1 | `L` |
| `unsigned long` | 8 | 0 to 2^64-1 | `UL` |
| `long long` | 8 | -2^63 to 2^63-1 | `LL` |
| `unsigned long long` | 8 | 0 to 2^64-1 | `ULL` |

- Sizes vary by platform; the standard's guarantees are too loose to be worth quoting :'(.
- **Two's complement:** the top bit is the sign, and there is one more negative value than positive.
- Explore your machine with `sizeof` and `<limits.h>` (`INT_MIN`, `INT_MAX`, `LONG_MAX`, ...).

::: {.tip}
**Trap:** The other integer types are signed by default, but `char` is different --- its signedness is implementation-defined.
On x86_64 CPUs `char` is signed by default, and on ARM CPUs `char` is unsigned by default!
Watch out!
:::

### Integer promotion

- Values smaller than `int` (`char`, `short`) are promoted to `int` in expressions.
- Mixed sizes generally promote to the signedness and size of the larger type.

::: {.tip}
**Trap:** `strlen` returns `size_t`, an *unsigned* type.
Subtracting two `size_t` values never goes negative --- it wraps to a huge positive number.
:::

```c
char *a = "Jump";       // strlen = 4
char *b = "Jump!!!!";   // strlen = 8

// size_t is unsigned, so 4 - 8 wraps around!
size_t diff = strlen(a) - strlen(b);
printf("strlen(a) - strlen(b) = %zu\n", diff);

// cast to a signed type to get the correct result
long sdiff = (long)strlen(a) - (long)strlen(b);
printf("Signed difference:      %ld\n", sdiff);
// Output:
// strlen(a) - strlen(b) = 18446744073709551612
// Signed difference:      -4
```

## 6. Floating Point (5 min)

| Type | Size | Range | Suffix |
|------|------|-------|--------|
| `float` | 4 bytes | -3.4e+38 to 3.4e+38 | `F` |
| `double` | 8 bytes | -1.7e+308 to 1.7e+308 | *(none, default)* |
| `long double` | 16 bytes | -1.2e+4932 to 1.2e+4932 | `L` |

- Always signed; the sign bit can be set on zero, so there are two zeros (they compare equal).
- Special values: infinity and NaN.
- Fractions are stored as sums of negative powers of 2: `0.5` and `0.25` are exact, `0.1` and `0.2` are not.
- Consequence: `0.1 + 0.2` is not exactly equal to `0.3`.

```c
float f = 1.2;
if (f != 1.2) printf("what?!?\n");
if (f == 1.2f) printf("ok\n");
```

- Both lines print!
- `1.2` is a `double`; assigning it to `f` rounds away precision.
- Promoting `f` back to `double` does not recover the lost bits, so `f != 1.2`.
- `1.2f` is a `float` literal rounded the same way, so that comparison succeeds.

## 7. Casting (10 min)

- A cast forces the compiler to treat a value of one type as another type: `(type)value`.
- One unified syntax --- much simpler than C++'s four cast operators, and much less magical.
- Only scalar types can be cast (integers, floating-point, pointers); remember `char` is an integer type.

| From / To | Integer | Floating-Point | Pointer |
| :--- | :--- | :--- | :--- |
| **Integer** | Yes | Yes | Yes |
| **Floating-Point** | Yes | Yes | No |
| **Pointer** | Yes | No | Yes |

- Float to integer *truncates* --- it does not round.
- If the value does not fit the target type: undefined behavior.

```c
double pi = 3.14159;
int roughly_pi = (int)pi; // truncates to 3
```

- A cast tells the compiler: "I know what I am doing, suppress the warnings, treat this as the type I specified."
- C trusts you implicitly, so casting can be dangerous.
- Magic *does not* happen when you cast.

::: {.tip}
**Trap:** A classic beginner mistake is trying to convert a string to an integer by casting the pointer.

```c
char *movie_year = "1985";      // The Goonies
int bad_year = (int)movie_year; // THIS IS A BUG! not 1985!!
```

This converts the *memory address* of the string, not the text `"1985"`.
On a 64-bit system the pointer is 8 bytes and the `int` is 4, so the compiler even warns about casting a pointer to an integer of different size.
Always use functions like `strtol` to parse strings into numbers.
:::

### Casting pointers to other pointers

- `void *` is a pointer to anything --- this is why `malloc` needs no cast in C.
- `char *` gives you byte-level access to any object.
- When casting between pointer types, you must understand the memory layout you are working with.

```c
int nums[] = {1984, 1985, 1986, 1987};

void *vp = nums;            // any pointer converts to void *
int *ip = (int *)vp;        // cast back to use it
printf("First: %d\n", ip[0]);

// byte-level access with char *
char *bp = (char *)nums;
printf("First byte of nums[0]: 0x%02x\n", (unsigned char)bp[0]);
// Output:
// First: 1984
// First byte of nums[0]: 0xc0
```

## 8. Live Coding: Numbers Starter (4 min)

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main(void) {
    // Characters are just numbers
    char ch = 'A';
    printf("'%c' is %d\n", ch, ch);
    printf("'%c' + 3 = '%c' (%d)\n", ch, ch + 3, ch + 3);

    // Strings are arrays of numbers
    char title[] = "Rio";
    printf("\"%s\" bytes: ", title);
    for (int i = 0; i < (int)sizeof(title); i++)
        printf("%d ", title[i]);
    printf("\n");

    // String to number conversion
    char *bpm_str = "120";
    long bpm = strtol(bpm_str, NULL, 10);
    printf("\"%s\" as a number: %ld\n", bpm_str, bpm);

    // Hex string to number
    long color = strtol("FF8000", NULL, 16);
    printf("0x%lX = %ld\n", color, color);

    // Casting: float to int truncates
    double tempo = 120.7;
    int whole = (int)tempo;
    printf("(int)%.1f = %d\n", tempo, whole);

    // The classic trap: casting a pointer
    char *year_str = "1982";
    long bad  = (long)year_str;          // address, not 1982!
    long good = strtol(year_str, NULL, 10);
    printf("(long)\"1982\"        = %ld (an address!)\n", bad);
    printf("strtol(\"1982\", ...) = %ld\n", good);

    // let's look at the bytes of an int (little-endian?)
    int hex_val = 0xbadd00d;
    printf("%d %x\n", hex_val, hex_val);
    unsigned char *raw = (unsigned char *)&hex_val;
    printf("little-endian: %02x %02x %02x %02x\n",
           raw[0], raw[1], raw[2], raw[3]);

    return 0;
}
```

- Compile with `cc -Wall -Wextra -pedantic`.
- Change the `(long)` in the trap to `(int)` and read the "cast from pointer to integer of different size" warning.
- Print `sizeof(int)`, `INT_MAX`, and friends from `<limits.h>` if time permits.

## 9. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
char letter = 'C';
printf("%c %d\n", letter + 2, letter + 2);
```

A. `E 69`
B. `C 67`
C. `E E`
D. `69 69`
E. Ben got this wrong

*Answer: A*

**Q2.** Where is the bug?

```c
char *score_str = "100";
int score = (int)score_str;
printf("You got a %d percent!\n", score);
```

A. `score_str` needs a `&` in the cast
B. The cast converts the address of the string, not its contents --- use `strtol`
C. `%d` should be `%s`
D. `score_str` must be declared `const`
E. Ben got this wrong

*Answer: B*

**Q3.** What does `strtol("010", NULL, 0)` return?

A. `10`
B. `8`
C. `2`
D. `0`
E. Ben got this wrong

*Answer: B*

## 10. Assignment / Reading (2 min)

**Read:** chapter 10 of *Gorgo C for C++ Programmers*.
**Do:** exercises 1-7.

## Key Points to Reinforce

- Under the hood, everything (characters, pointers) is just a number
- Types tell the compiler how to interpret the bits --- they do not change them
- C has no native strings, only arrays of numbers ended with a `0`
- `strtol`/`strtod` for parsing; treat `atoi` as legacy you read but do not write
- `char` signedness is implementation-defined; small types promote to `int`
- `size_t` is unsigned --- subtraction can wrap to a huge positive number
- Floating point is approximate: `0.1 + 0.2` is not exactly `0.3`
- `(type)value` asserts you know what you are doing --- no magic happens
- Casting a `char *` to an integer gives you the address, not the parsed string
