---
title: "Gorgo C for Java Programmers --- Answer Key"
---

# About This Answer Key

Work out the answers yourself before looking here.
The explanations are meant to help you understand *why* the answer is what it is, not just tell you *what* the answer is.

---

# Chapter 0: How to Use This Booklet

There are no exercises in Chapter 0.

---

# Chapter 1: Introduction

**Exercise 1** (Think about it): Java compiles to bytecode that runs on the JVM, while C compiles directly to native machine code.
What are the practical tradeoffs of each approach in terms of portability, performance, and safety?

Java bytecode is portable: the same `.class` file runs on any JVM, whether the host is Windows, macOS, or Linux.
The JVM also provides safety guarantees --- bounds checking, null pointer detection, and garbage collection --- at the cost of runtime overhead.
C programs are faster because they run directly on the hardware with no interpreter or garbage collector between the code and the CPU.
The downside is that you must recompile for each target platform, and there is no safety net: a bad pointer or out-of-bounds access crashes the program or silently corrupts memory.
Neither approach is universally better; the right choice depends on whether portability and safety or raw performance are more important for your use case.

---

**Exercise 2** (What does this print?):

```c
#include <stdio.h>
int main(void) {
    printf("[%6d]\n",  99);
    printf("[%-6d]\n", 99);
    printf("[%06d]\n", 99);
    return 0;
}
```

Output:
```
[    99]
[99    ]
[000099]
```

Explanation: `%6d` right-aligns `99` in a field 6 wide, padding with spaces.
`%-6d` left-aligns it, adding trailing spaces.
`%06d` right-aligns and zero-fills to 6 characters.

---

**Exercise 3** (What does this print?):

```c
#include <stdio.h>
int main(void) {
    double x = 1982.5;
    printf("%.0f\n", x);
    printf("%e\n",   x);
    printf("%10.2f\n", x);
    return 0;
}
```

Output:
```
1982
1.982500e+03
   1982.50
```

Explanation: `%.0f` prints the value with zero decimal places, so `1982.5` rounds to `1982`.
`%e` uses scientific notation with 6 decimal places by default.
`%10.2f` places the value in a 10-character-wide field with 2 decimal places; leading spaces pad to fill the width.

---

**Exercise 4** (Calculation): If `sizeof(int)` is 4 on your system, what does `printf("%zu\n", sizeof(int));` print?
What format specifier should you use to print the result of `sizeof`, and why is `%d` technically wrong?

`printf("%zu\n", sizeof(int));` prints `4`.

You must use `%zu` because `sizeof` returns a value of type `size_t`, which is an unsigned integer type.
On a 64-bit system `size_t` is typically 8 bytes while `int` is 4 bytes.
Using `%d` interprets a `size_t` as a signed `int`, which is undefined behavior --- the sizes and signedness do not match.
Your compiler will warn you about this mismatch when you compile with `-Wall`.

---

**Exercise 5** (Where is the bug?):

```c
#include <stdio.h>
int main(void) {
    int score;
    printf("Enter score: ");
    scanf("%d", score);
    printf("Score: %d\n", score);
    return 0;
}
```

The bug is the missing `&` before `score` in the `scanf` call.
`scanf` needs the *address* of `score` so it can store the input there.
Without `&`, you are passing the current (uninitialized) *value* of `score` to `scanf` as if it were a memory address.
`scanf` then tries to write the parsed integer to that garbage address, which is almost certainly not a valid location.
The program will likely crash with a segmentation fault, or silently corrupt memory.
The fix is `scanf("%d", &score);`.

---

**Exercise 6** (Write a program): Asks for name and favorite 1980s year, then prints a greeting.

```c
#include <stdio.h>

int main(void) {
    char name[64];
    int  year;

    printf("Enter your name: ");
    scanf("%63s", name);
    printf("Enter your favorite year in the 1980s: ");
    scanf("%d", &year);

    printf("Hello, %s! %d was a great year.\n", name, year);
    return 0;
}
```

Note: `%63s` limits input to 63 characters (plus the null terminator), preventing a buffer overflow.
The array `name` does not need `&` in `scanf` because an array name already decays to a pointer to its first element.

---

# Chapter 2: Variables

**Exercise 1** (Think about it): In Java, `int` is always 32 bits on every platform.
In C, the size of `int` can vary.
Why might a C programmer use `int32_t` from `<stdint.h>` instead of plain `int`?
When might plain `int` still be the right choice?

Use `int32_t` when you need a guaranteed 32-bit signed integer --- for example, when reading or writing binary file formats, communicating over a network protocol, or interfacing with hardware that expects a specific register width.
In those cases, relying on plain `int` being 32 bits on a particular platform will break when the code is ported to an embedded system where `int` might be 16 bits.

Plain `int` is still the right choice for loop counters, array indices, and general arithmetic where portability of the exact size does not matter.
The C standard guarantees `int` is at least 16 bits and is the "natural" size for the machine.
Using `int` for everyday arithmetic lets the compiler use the most efficient native integer width.

---

**Exercise 2** (What does this print?):

```c
int a[] = {10, 20, 30, 40};
printf("%zu %zu\n", sizeof(a), sizeof(a[0]));
```

Output:
```
16 4
```

Explanation: The array `a` holds 4 `int` values.
On a system where `int` is 4 bytes, the total size of the array is `4 * 4 = 16` bytes.
`sizeof(a[0])` is the size of one element, which is `sizeof(int) = 4`.

---

**Exercise 3** (What does this print?):

```c
struct point { int x; int y; };
struct point a = {3, 7};
struct point b = a;
b.x = 99;
printf("%d %d\n", a.x, b.x);
```

Output:
```
3 99
```

Explanation: `struct point b = a;` copies all the bytes of `a` into `b`, giving you two completely independent structs.
Modifying `b.x` has no effect on `a.x`.
This is different from Java, where assigning one object to another copies the reference and both variables would see the same data.

---

**Exercise 4** (Calculation): On a system where `int` is 4 bytes, what is `sizeof(grid)`?

```c
int grid[3][5];
```

`sizeof(grid)` = 3 rows * 5 columns * 4 bytes per `int` = **60 bytes**.

The two-dimensional array is stored as a flat block of 15 consecutive integers in row-major order.

---

**Exercise 5** (Where is the bug?):

```c
const int MAX = 100;
int *p = &MAX;
*p = 200;
printf("MAX = %d\n", MAX);
```

The bug is assigning `&MAX` to a non-`const` pointer `int *p` and then writing through it.
`MAX` is declared `const`, meaning the compiler is allowed to assume it never changes --- it may even replace uses of `MAX` with the literal `100` at compile time.
Attempting to modify a `const` variable through a pointer is undefined behavior.
The program may appear to work (printing `200`), it may print `100`, or it may crash.
A compiler with `-Wall` will warn that you are discarding the `const` qualifier when assigning to `p`.
The fix is `const int *p = &MAX;`, which makes it a compile error to write `*p = 200;`.

---

**Exercise 6** (Think about it): In Java, `String s2 = s1;` makes `s2` point to the same `String` object as `s1`.
In C, `struct song copy = original;` copies all the bytes.
What problem could arise if the struct contained a `char *` member pointing to heap-allocated memory?
What would happen when both `original` and `copy` are freed?

When you copy a struct that contains a `char *` pointer, both `original` and `copy` end up holding the *same address* --- they both point to the same heap-allocated string.
This is a **shallow copy**.

If you then call `free` on the string through one struct and later try to access it through the other, you have a **use-after-free** bug.
If you call `free` on the string through both structs, you have a **double-free** bug, which is undefined behavior and can corrupt the allocator's internal data structures.
In Java, the garbage collector prevents this because the string object stays alive as long as any reference to it exists.
In C, you must either deep-copy the heap memory manually (allocating a new buffer and copying the content), or establish a clear ownership rule for who is responsible for freeing it.

---

**Exercise 7** (Write a program): Declare a `Student` struct with typedef, create an array of 3, initialize with designated initializers, print with a loop.

```c
#include <stdio.h>

typedef struct {
    char   name[32];
    int    id;
    double gpa;
} Student;

int main(void) {
    Student students[3] = {
        {.name = "Alex",   .id = 1001, .gpa = 3.75},
        {.name = "Morgan", .id = 1002, .gpa = 3.40},
        {.name = "Jordan", .id = 1003, .gpa = 3.90}
    };

    for (int i = 0; i < 3; i++) {
        printf("Name: %-10s  ID: %d  GPA: %.2f\n",
               students[i].name, students[i].id, students[i].gpa);
    }

    return 0;
}
```

---

# Chapter 3: Strings

**Exercise 1** (Think about it): In Java, `String` objects are immutable --- you cannot change a character in place.
In C, `char` arrays are mutable.
What advantages does Java's immutability give you?
What does C's mutability let you do that Java makes awkward?

Java's immutability makes strings safe to share between threads without locking, allows the JVM to deduplicate string literals, and makes `String` suitable as a hash map key (since the hash never changes).
It also means you cannot accidentally corrupt a string that was passed into a function.

C's mutable `char` arrays let you modify strings in place without allocating new memory.
You can reverse a string, convert it to uppercase, or overwrite a delimiter character during tokenization --- all operations that in Java require building a new `String` object.
In memory-constrained environments or performance-critical code, avoiding allocations matters.

---

**Exercise 2** (What does this print?):

```c
char s[] = "Human";
printf("%zu %zu\n", strlen(s), sizeof(s));
```

Output:
```
5 6
```

Explanation: `strlen` counts the characters before the null terminator, so `strlen("Human")` is 5.
`sizeof(s)` gives the total size of the array in bytes, which includes the null terminator: 6 bytes (5 characters + `'\0'`).

---

**Exercise 3** (Calculation): What is `sizeof(buf)` for `char buf[20] = "Roxanne";`?
What does `strlen(buf)` return?

`sizeof(buf)` is **20** --- the size of the declared array, regardless of how many bytes are actually used.

`strlen(buf)` returns **7** --- the number of characters in `"Roxanne"` before the null terminator.
The remaining 12 bytes of the buffer (positions 8 through 19) are initialized to `'\0'` because partial array initialization zero-fills the rest.

---

**Exercise 4** (Where is the bug?):

```c
char buf[10] = "Beat ";
strcat(buf, "It Now!");
printf("%s\n", buf);
```

The bug is a **buffer overflow**.
`buf` is 10 bytes.
`"Beat "` uses 6 bytes (5 characters + `'\0'`), leaving only 4 bytes of space.
`"It Now!"` is 8 characters plus a null terminator --- 9 bytes --- which does not fit in the 4 remaining bytes.
`strcat` has no way to know the buffer size, so it blindly writes past the end of `buf`, corrupting whatever memory follows it on the stack.
The fix is to use a larger buffer and `strncat`: `strncat(buf, "It Now!", sizeof(buf) - strlen(buf) - 1);`

---

**Exercise 5** (Where is the bug?):

```c
char *a = "Billie Jean";
char *b = "Billie Jean";
if (a == b) {
    printf("Same song!\n");
} else {
    printf("Different!\n");
}
```

The `==` operator compares the *pointer values* (memory addresses), not the string contents.
`a` and `b` may or may not point to the same memory location.
Many compilers will deduplicate identical string literals, making `a == b` true --- but this is an implementation detail, not a language guarantee.
The output is not guaranteed.

To compare string contents, use `strcmp(a, b) == 0`.

---

**Exercise 6** (What does this print?):

```c
printf("%d\n", strncmp("Total Eclipse", "Total Recall", 5));
```

Output:
```
0
```

Explanation: `strncmp` compares at most the first 5 characters.
The first 5 characters of both strings are `"Total"`, so they are equal.
`strncmp` returns `0` for equal strings.

---

**Exercise 7** (Where is the bug?):

```c
char *lyric = "Roxanne";
lyric[0] = 'r';
printf("%s\n", lyric);
```

The bug is attempting to modify a string literal.
`char *lyric = "Roxanne";` declares a pointer to a string literal, which is stored in read-only memory.
Writing to `lyric[0]` is undefined behavior --- on most modern systems, it causes a segmentation fault (write to read-only memory).
To have a modifiable string, declare it as an array: `char lyric[] = "Roxanne";`
Then `lyric[0] = 'r';` is perfectly legal.

---

**Exercise 8** (What does this print?):

```c
char c = '8';
printf("%d %d %d\n",
       isdigit((unsigned char)c)  != 0,
       isalpha((unsigned char)c)  != 0,
       isalnum((unsigned char)c)  != 0);
```

Output:
```
1 0 1
```

Explanation: `'8'` is a digit but not a letter.
`isdigit` returns non-zero (true), so `!= 0` gives `1`.
`isalpha` returns zero (false) for a digit, so `!= 0` gives `0`.
`isalnum` returns non-zero because `'8'` is alphanumeric (it is a digit), so `!= 0` gives `1`.

---

**Exercise 9** (Write a program): Read a string, reverse it in place, print the result.

```c
#include <stdio.h>
#include <string.h>

void reverse(char *s) {
    int left  = 0;
    int right = (int)strlen(s) - 1;
    while (left < right) {
        char tmp  = s[left];
        s[left]   = s[right];
        s[right]  = tmp;
        left++;
        right--;
    }
}

int main(void) {
    char buf[256];
    printf("Enter a string: ");
    if (scanf("%255s", buf) == 1) {
        reverse(buf);
        printf("Reversed: %s\n", buf);
    }
    return 0;
}
```

---

**Exercise 10** (Write a program): Count uppercase letters, lowercase letters, digits, and other characters using `<ctype.h>`.

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int main(void) {
    char input[256];
    printf("Enter a string: ");
    if (fgets(input, sizeof(input), stdin) == NULL)
        return 1;

    int upper = 0, lower = 0, digits = 0, other = 0;

    for (int i = 0; input[i] != '\0'; i++) {
        unsigned char c = (unsigned char)input[i];
        if (isupper(c))      upper++;
        else if (islower(c)) lower++;
        else if (isdigit(c)) digits++;
        else                 other++;
    }

    printf("Upper: %d  Lower: %d  Digits: %d  Other: %d\n",
           upper, lower, digits, other);
    return 0;
}
```

---

# Chapter 4: Expressions

**Exercise 1** (Think about it): In Java, the compiler rejects `if (x = 5)` because `x = 5` is an `int`, not a `boolean`.
In C, this compiles without error.
What does the C version actually do?
How can you configure your C compiler to catch this kind of mistake?

In C, `if (x = 5)` assigns the value `5` to `x`, then uses that assignment's result (`5`) as the condition.
Since `5` is nonzero, the condition is always true, and the body of the `if` always executes.
The variable `x` is also silently changed to `5` as a side effect, which is almost certainly not what was intended.

Compile with `-Wall` (or more specifically `-Wparentheses`) to make `gcc` or `clang` warn about assignments in conditions.
The idiomatic workaround in C is to write the constant on the left: `if (5 == x)` --- if you accidentally write `if (5 = x)`, the compiler rejects it because you cannot assign to a literal.
This is called a Yoda condition.

---

**Exercise 2** (What does this print?):

```c
int x = 10;
int y = x++ + ++x;
printf("%d %d\n", x, y);
```

Is this even defined behavior?

This is **undefined behavior**.
The expression `x++ + ++x` modifies `x` more than once without an intervening sequence point.
The C standard says the result is undefined --- different compilers, or even the same compiler at different optimization levels, may produce different results.
You should never write code like this.
Use separate statements: `y = x + (x + 1); x += 2;` or similar, depending on what you actually intend.

---

**Exercise 3** (Calculation): What is the result of each of these expressions?

```c
25 / 4
25 % 4
-25 % 4
(1 << 4) | (1 << 1)
0xFF & 0x0F
```

- `25 / 4` = **6** (integer division truncates toward zero; 25 / 4 = 6.25, truncated to 6)
- `25 % 4` = **1** (25 = 6*4 + 1)
- `-25 % 4` = **-1** (the remainder has the same sign as the dividend; -25 = (-6)*4 + (-1))
- `(1 << 4) | (1 << 1)` = **18** (bit 4 = 16, bit 1 = 2; 16 | 2 = 18; in hex `0x12`)
- `0xFF & 0x0F` = **15** (0xFF = 11111111, 0x0F = 00001111; AND gives 00001111 = 15 = 0x0F)

---

**Exercise 4** (Where is the bug?):

```c
int status = 0x07;
if (status & 0x04 == 0x04) {
    printf("Bit 2 is set\n");
}
```

The bug is operator precedence.
`==` has higher precedence than `&`, so the expression is parsed as `status & (0x04 == 0x04)`, which is `status & 1`.
This checks whether bit 0 of `status` is set, not whether bit 2 is set.
With `status = 0x07` (binary `111`), bit 0 is indeed set, so the message happens to print --- but for the wrong reason.
If `status` were `0x04` (binary `100`), bit 2 would be set but bit 0 would not, so the condition would be false and the message would not print even though bit 2 is set.

The fix is to add parentheses: `if ((status & 0x04) == 0x04)`.

---

**Exercise 5** (What does this print?):

```c
int a = 5, b = 10;
a ^= b;
b ^= a;
a ^= b;
printf("a=%d b=%d\n", a, b);
```

Output:
```
a=10 b=5
```

Explanation: This is the XOR swap idiom.
After `a ^= b`: `a = 5 ^ 10 = 15`, `b = 10`.
After `b ^= a`: `b = 10 ^ 15 = 5`, `a = 15`.
After `a ^= b`: `a = 15 ^ 5 = 10`, `b = 5`.
The values of `a` and `b` have been swapped without using a temporary variable.

---

**Exercise 6** (Where is the bug?):

```c
int count = 0;
if (count = 0) {
    printf("El contador es cero\n");
} else {
    printf("El contador no es cero\n");
}
```

The bug is `count = 0` instead of `count == 0`.
The `=` is assignment, not comparison.
The expression `count = 0` assigns `0` to `count` and evaluates to `0`, which is false.
So the `else` branch always runs, printing `"El contador no es cero"` regardless of what `count` was.
The fix is `if (count == 0)`.

---

**Exercise 7** (What does this print?):

```c
#include <stdbool.h>
#include <stdio.h>

int main(void) {
    bool result = (3 > 1);
    printf("%d\n", result);
    printf("%d\n", (1 == 1) + (2 == 2) + (3 == 3));
    return 0;
}
```

Output:
```
1
3
```

Explanation: `(3 > 1)` is true, so `result` is `true`, which prints as `1` with `%d`.
Each comparison `(1 == 1)`, `(2 == 2)`, and `(3 == 3)` evaluates to `1` (true in C).
Adding three `1`s gives `3`.
This illustrates that in C, boolean comparison results are just integers.

---

**Exercise 8** (Write a program): Print an `unsigned int` in binary using bitwise operators.

```c
#include <stdio.h>

void print_binary(unsigned int n) {
    for (int bit = 31; bit >= 0; bit--) {
        printf("%d", (n >> bit) & 1);
        if (bit % 4 == 0 && bit > 0)
            printf(" ");   /* group into nibbles for readability */
    }
    printf("\n");
}

int main(void) {
    unsigned int tests[] = {0, 1, 255, 1024};
    int count = sizeof(tests) / sizeof(tests[0]);

    for (int i = 0; i < count; i++) {
        printf("%6u = ", tests[i]);
        print_binary(tests[i]);
    }
    return 0;
}
```

---

# Chapter 5: Control Flow

**Exercise 1** (Think about it): Java's `switch` (since Java 7) can switch on a `String`.
C's `switch` only accepts integer constants.
What do you think would make switching on strings harder to implement in C?
How would you implement a string-dispatch in C using `if`/`else if`?

A `switch` statement is compiled as a jump table or a series of comparisons against integer constants, which can be done at compile time.
Strings are not simple integers --- comparing them requires `strcmp`, which walks through the characters one by one at runtime.
There is no efficient way to compile a string switch into a jump table without hashing or other runtime infrastructure that C does not provide natively.

In C, string dispatch uses a chain of `if`/`else if` blocks with `strcmp`:

```c
if (strcmp(cmd, "quit") == 0) {
    do_quit();
} else if (strcmp(cmd, "help") == 0) {
    print_help();
} else if (strcmp(cmd, "list") == 0) {
    list_items();
} else {
    printf("Unknown command: %s\n", cmd);
}
```

---

**Exercise 2** (What does this print?):

```c
for (int i = 0; i < 5; i++) {
    if (i == 2)
        continue;
    printf("%d ", i);
}
printf("\n");
```

Output:
```
0 1 3 4
```

Explanation: When `i == 2`, `continue` skips the `printf` for that iteration and goes directly to `i++`.
All other values of `i` (0, 1, 3, 4) are printed normally.

---

**Exercise 3** (What does this print?):

```c
int x = 2;
switch (x) {
case 1:
    printf("uno ");
case 2:
    printf("dos ");
case 3:
    printf("tres ");
    break;
default:
    printf("otro ");
}
printf("\n");
```

Output:
```
dos tres
```

Explanation: `x` is `2`, so execution jumps to `case 2:`.
There is no `break` after `printf("dos ")`, so execution **falls through** to `case 3:`.
`"tres "` is printed, then `break` exits the switch.
`case 1:` is never reached because execution started at `case 2:`.
This is why every `case` should have a `break` unless fall-through is intentional.

---

**Exercise 4** (Where is the bug?):

```c
int total = 0;
int i;
for (i = 0; i < 10; i++);
{
    total += i;
}
printf("Total: %d\n", total);
```

The bug is the semicolon after `for (i = 0; i < 10; i++)`.
The semicolon is a complete empty statement and is the entire body of the `for` loop.
The loop runs 10 times doing nothing, incrementing `i` to `10`.
The block `{ total += i; }` is **not** part of the loop --- it is a separate compound statement that executes exactly once after the loop, adding `i` (which is now `10`) to `total`.

The program prints `Total: 10`, which is almost certainly not the intended result (the likely intent was to sum 0+1+...+9 = 45).

---

**Exercise 5** (Calculation): How many times does the body of this loop execute?

```c
int count = 0;
int i = 10;
do {
    count++;
    i--;
} while (i > 10);
```

The body executes **once**.
A `do-while` loop always executes the body at least once before checking the condition.
After the first execution, `i` is decremented to `9`.
The condition `i > 10` is `9 > 10`, which is false, so the loop exits.
`count` is `1`.

---

**Exercise 6** (Where is the bug?):

```c
int level = 5;
if (level = 10) {
    printf("Max level!\n");
}
```

The bug is using `=` (assignment) instead of `==` (comparison).
`level = 10` assigns `10` to `level` and evaluates to `10`, which is nonzero (true).
The `if` body always executes, and `level` is now `10` regardless of its original value.
The fix is `if (level == 10)`.

---

**Exercise 7** (What does this print?):

```c
#include <stdio.h>

int main(void) {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (j == 1)
                break;
            printf("(%d,%d) ", i, j);
        }
    }
    printf("\n");
    return 0;
}
```

Output:
```
(0,0) (1,0) (2,0)
```

Explanation: The inner loop iterates `j` from 0 to 2.
When `j == 1`, `break` exits the *inner* loop only.
So for each value of `i`, only `j = 0` is printed before the break fires.
The outer loop runs for `i = 0, 1, 2`, giving three printed pairs.

---

**Exercise 8** (Write a program): Read integers until `0`, print sum and average.

```c
#include <stdio.h>

int main(void) {
    int value;
    int sum   = 0;
    int count = 0;

    printf("Enter integers (0 to stop):\n");
    while (scanf("%d", &value) == 1 && value != 0) {
        sum += value;
        count++;
    }

    if (count == 0) {
        printf("No numbers entered.\n");
    } else {
        printf("Sum: %d\n", sum);
        printf("Average: %.2f\n", (double)sum / count);
    }
    return 0;
}
```

---

# Chapter 6: Pointers

**Exercise 1** (Think about it): In Java, you cannot accidentally corrupt memory by going out of bounds on an array --- the runtime throws `ArrayIndexOutOfBoundsException`.
In C, out-of-bounds access is undefined behavior and may silently corrupt other data.
What are the tradeoffs between Java's approach (safe, with runtime overhead) and C's approach (unsafe, but no overhead)?

Java's bounds checking adds a small overhead to every array access --- a compare and branch instruction.
This is negligible for most programs but can matter in tight inner loops on performance-critical code.
The benefit is that bugs surface immediately with a clear error message rather than causing silent data corruption that might not be detected until much later.

C's lack of bounds checking gives you the speed of raw hardware access but means you are solely responsible for staying within bounds.
An out-of-bounds write in C may corrupt other variables, overwrite a return address, or cause a crash in a completely unrelated part of the program, making the bug extremely difficult to diagnose.
Security vulnerabilities such as buffer overflow exploits have caused enormous damage precisely because C has no bounds checking.

Choose Java (or any memory-safe language) when safety and developer productivity matter more than the last few percent of performance.
Choose C when you need maximum control, are writing systems software (OS kernels, device drivers, embedded firmware), or are in a context where every CPU cycle counts.

---

**Exercise 2** (What does this print?):

```c
int a[] = {867, 5309, 1984, 1985};
int *p = a + 2;
printf("%d %d %d\n", *p, *(p - 1), p[1]);
```

Output:
```
1984 5309 1985
```

Explanation: `a + 2` advances the pointer by 2 `int`s from the start, so `p` points to `a[2]` (which holds `1984`).
`*p` is `1984`.
`*(p - 1)` moves back one `int` to `a[1]`, which is `5309`.
`p[1]` is `*(p + 1)`, which is `a[3]`, holding `1985`.

---

**Exercise 3** (Calculation): On a 64-bit system, what is `sizeof(int *)`, `sizeof(char *)`, and `sizeof(double *)`?
Do the sizes differ?

On a 64-bit system, all three are **8 bytes**.
All pointer types have the same size on a given platform --- they all hold a memory address, and on a 64-bit system every address is 8 bytes.
The type before the `*` tells the compiler how to interpret the memory at that address and how far to step during pointer arithmetic, but it does not affect the size of the pointer itself.

---

**Exercise 4** (Where is the bug?):

```c
int *get_year(void) {
    int year = 1985;
    return &year;
}
```

This function returns a pointer to a local variable.
`year` is allocated on the stack for the duration of `get_year`.
When the function returns, its stack frame is reclaimed and `year` no longer exists.
The returned pointer is a **dangling pointer** --- it points to memory that the program no longer owns.
Using the returned pointer is undefined behavior.
The memory might still contain `1985` (if nothing has overwritten the stack frame yet), or it might contain garbage from the next function call.

The fix is to either return the value directly (`return year;`) or allocate the memory on the heap with `malloc` (remembering that the caller must then `free` it).

---

**Exercise 5** (What does this print?):

```c
int x  = 867;
int *p  = &x;
int **pp = &p;
**pp = 5309;
printf("%d\n", x);
```

Output:
```
5309
```

Explanation: `p` points to `x`, and `pp` points to `p`.
`**pp` dereferences `pp` twice: first `*pp` gives you `p`, then `*(*pp)` gives you `x`.
Assigning `5309` to `**pp` is the same as assigning `5309` to `x`.

---

**Exercise 6** (Where is the bug?):

```c
struct song {
    char title[40];
    int  year;
};

struct song *p = NULL;
printf("%s (%d)\n", p->title, p->year);
```

The bug is dereferencing a `NULL` pointer.
`p` is set to `NULL`, meaning it does not point to any valid memory.
Accessing `p->title` and `p->year` attempts to read from address `NULL` (typically address 0), which is not mapped in the process's address space.
On virtually all operating systems, this causes a **segmentation fault** --- the program crashes immediately.
In Java, the equivalent would throw a `NullPointerException`.

Before using a pointer, always check that it is not `NULL`.

---

**Exercise 7** (What does this print?):

```c
#include <stdio.h>
void mystery(int *p, int n) {
    for (int i = 0; i < n; i++) {
        p[i] *= 2;
    }
}

int main(void) {
    int vals[] = {1, 2, 3, 4};
    mystery(vals, 4);
    for (int i = 0; i < 4; i++) {
        printf("%d ", vals[i]);
    }
    printf("\n");
    return 0;
}
```

Output:
```
2 4 6 8
```

Explanation: `mystery` receives a pointer to `vals[0]`.
It doubles each element in place through the pointer.
Since arrays are passed as a pointer to the first element, `mystery` modifies the original array in `main`.
This is the standard C way to have a function modify an array: pass the pointer and the length.

---

**Exercise 8** (Write a program): Use a pointer to iterate through `{10, 20, 30, 40, 50}` and print each element with its address.

```c
#include <stdio.h>

int main(void) {
    int nums[] = {10, 20, 30, 40, 50};
    int n = sizeof(nums) / sizeof(nums[0]);

    for (int *p = nums; p < nums + n; p++) {
        printf("Value: %2d   Address: %p\n", *p, (void *)p);
    }
    return 0;
}
```

---

# Chapter 7: Functions

**Exercise 1** (Think about it): C does not have function overloading.
How does the C standard library handle functions for different numeric types?
Look at `abs` (for `int`) and `fabs` (for `double`) as examples.
What naming convention do you see, and how does it compare to Java's approach?

The C standard library uses distinct names with type-indicating prefixes or suffixes.
`abs` handles `int`, `labs` handles `long`, `llabs` handles `long long`, and `fabs` handles `double`.
Similarly, `strlen` returns `size_t`, and there are separate functions like `strcmp` vs. `strncmp` vs. `strcasecmp` for different comparison needs.
The type information that overloading encodes in Java is encoded in the function name in C.

Java's approach --- identical name, different parameter types, compiler resolves at compile time --- is more concise for the caller but requires the compiler to do more work.
C's approach is more explicit: when you see `fabs`, you know immediately you are getting a `double` operation.
The trade-off is verbosity for transparency.

---

**Exercise 2** (What does this print?):

```c
void mystery(int x) {
    x = x * 2;
    printf("inside: %d\n", x);
}

int main(void) {
    int val = 5;
    mystery(val);
    printf("outside: %d\n", val);
    return 0;
}
```

Output:
```
inside: 10
outside: 5
```

Explanation: C is strictly pass-by-value.
`mystery` receives a *copy* of `val`.
It doubles its local copy to `10` and prints it.
But `val` in `main` is never touched --- it is still `5`.

---

**Exercise 3** (Where is the bug?):

```c
int count_chars(const char *s) {
    int count;
    while (*s != '\0') {
        count++;
        s++;
    }
    return count;
}
```

The bug is that `count` is never initialized.
Local variables in C have indeterminate (garbage) values when they are declared without an initializer.
`count++` increments whatever garbage value happens to be on the stack.
The function may return a completely wrong result, or the behavior is technically undefined.
The fix is `int count = 0;`.

---

**Exercise 4** (Calculation): Given the struct below, approximately how many bytes are copied each time `process` is called by value?
Assume `int` is 4 bytes.

```c
struct playlist {
    int  ids[500];
    int  count;
};

void process(struct playlist p) { /* ... */ }
```

`ids` is an array of 500 `int` values: `500 * 4 = 2000 bytes`.
`count` is one `int`: `4 bytes`.
Total: **2004 bytes** copied onto the stack on every call.

This is why large structs should be passed as `const struct playlist *p` instead --- you pay only 8 bytes for the pointer regardless of the struct size.

---

**Exercise 5** (What does this print?):

```c
int apply(int (*fn)(int, int), int a, int b) {
    return fn(a, b);
}

int mul(int a, int b) { return a * b; }

int main(void) {
    printf("%d\n", apply(mul, 6, 7));
    return 0;
}
```

Output:
```
42
```

Explanation: `apply` takes a function pointer `fn`, two integers, and calls `fn(a, b)`.
`mul` is passed as the function pointer.
`apply(mul, 6, 7)` calls `mul(6, 7)`, which returns `42`.

---

**Exercise 6** (Where is the bug?):

```c
void swap(int a, int b) {
    int tmp = a;
    a = b;
    b = tmp;
}

int main(void) {
    int x = 867, y = 5309;
    swap(x, y);
    printf("x=%d y=%d\n", x, y);
}
```

The bug is that `swap` receives copies of `x` and `y`.
All the swapping happens on the copies inside `swap`.
When `swap` returns, the copies are destroyed and `x` and `y` in `main` are unchanged.
The output is `x=867 y=5309` --- no swap has occurred.

The fix is to pass pointers:

```c
void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

swap(&x, &y);
```

---

**Exercise 7** (What does this print?):

```c
#include <stdio.h>

long fact(int n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
}

int main(void) {
    for (int i = 0; i <= 5; i++) {
        printf("%d! = %ld\n", i, fact(i));
    }
    return 0;
}
```

Output:
```
0! = 1
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
```

Explanation: `fact(0)` hits `n <= 1` and returns `1`.
`fact(1)` also returns `1`.
Each subsequent call multiplies `n` by the factorial of `n - 1`.

---

**Exercise 8** (Write a program): Define `void transform(int *arr, int n, int (*fn)(int))` and test with double and negate functions.

```c
#include <stdio.h>

void transform(int *arr, int n, int (*fn)(int)) {
    for (int i = 0; i < n; i++) {
        arr[i] = fn(arr[i]);
    }
}

int double_it(int x) { return x * 2; }
int negate(int x)    { return -x; }

void print_array(const int *arr, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main(void) {
    int nums[] = {1, 2, 3, 4, 5};
    int n = sizeof(nums) / sizeof(nums[0]);

    printf("Original:  ");
    print_array(nums, n);

    transform(nums, n, double_it);
    printf("Doubled:   ");
    print_array(nums, n);

    transform(nums, n, negate);
    printf("Negated:   ");
    print_array(nums, n);

    return 0;
}
```

---

# Chapter 8: Allocating Memory

**Exercise 1** (Think about it): In Java, you cannot get a dangling pointer because the garbage collector keeps objects alive as long as a reference exists.
C has no such protection.
Describe two different ways a C programmer can accidentally end up with a dangling pointer, and explain what the symptoms might look like.

**Way 1 --- returning a pointer to a local variable:**
A function allocates a local variable on the stack and returns its address.
When the function returns, the stack frame is reclaimed.
The caller holds a pointer to memory that is no longer valid.
The symptom is that the pointer appears to hold the correct value initially (the stack memory has not been overwritten yet), but the value changes unexpectedly or the program crashes after subsequent function calls reuse the same stack space.

**Way 2 --- using a pointer after `free`:**
A pointer `p` is passed to `free`, releasing the heap memory.
Later, the code uses `p` again (read or write) without realizing the memory has been returned to the allocator.
The symptom is that reads return garbage or the value written through `p` shows up corrupted because the allocator may have reused the memory for something else.
Worse, writing through a freed pointer can corrupt the allocator's metadata, causing bizarre crashes in unrelated `malloc` or `free` calls much later in the program.

---

**Exercise 2** (What does this print?):

```c
#include <stdio.h>

void counter(void) {
    static int n = 0;
    n++;
    printf("%d ", n);
}

int main(void) {
    counter(); counter(); counter(); counter();
    printf("\n");
    return 0;
}
```

Output:
```
1 2 3 4
```

Explanation: `n` is a `static` local variable.
It is initialized to `0` once when the program starts and retains its value between calls to `counter`.
Each call increments it, so successive calls print `1`, `2`, `3`, `4`.
Without `static`, `n` would be re-initialized to `0` on every call and the output would be `1 1 1 1`.

---

**Exercise 3** (What does this print?):

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    int data[] = {10, 20, 30, 40, 50};
    memset(data, 0, 3 * sizeof(int));
    for (int i = 0; i < 5; i++)
        printf("%d ", data[i]);
    printf("\n");
    return 0;
}
```

Output:
```
0 0 0 40 50
```

Explanation: `memset(data, 0, 3 * sizeof(int))` sets the first 12 bytes (3 integers * 4 bytes each) to zero.
This zeroes `data[0]`, `data[1]`, and `data[2]`.
`data[3]` and `data[4]` are untouched and retain their values `40` and `50`.

---

**Exercise 4** (Calculation): On a system where `int` is 32 bits and `double` is 64 bits, how many bytes does each of the following allocate?

(a) `malloc(8 * sizeof(int))`
(b) `calloc(4, sizeof(double))`

(a) `8 * sizeof(int)` = `8 * 4` = **32 bytes**

(b) `4 * sizeof(double)` = `4 * 8` = **32 bytes**

Both allocate the same number of bytes, but `calloc` also initializes all bytes to zero, while `malloc` leaves the memory uninitialized.

---

**Exercise 5** (Where is the bug?):

```c
int *p = malloc(10 * sizeof(int));
for (int i = 0; i < 10; i++)
    p[i] = i;
free(p);
printf("%d\n", p[0]);
```

The bug is **use-after-free**.
`free(p)` releases the memory back to the allocator.
`p` still holds the same address, but accessing `p[0]` after `free` is undefined behavior.
The memory may have been reused for something else.
The program might print `0`, might print garbage, or might crash.
After calling `free(p)`, you should set `p = NULL;` to prevent accidental use of the dangling pointer.

---

**Exercise 6** (Where is the bug?):

```c
int *a = malloc(5 * sizeof(int));
int *b = a;
free(a);
free(b);
```

The bug is a **double free**.
Both `a` and `b` point to the same heap allocation.
`free(a)` releases that allocation.
`free(b)` attempts to free the same memory a second time.
This is undefined behavior and corrupts the allocator's internal data structures.
Typical symptoms include a crash inside a future `malloc` or `free` call, or a crash with a message like "double free or corruption."
The fix is to only free memory once.
After `free(a)`, set `a = NULL;` and do not call `free(b)` (or set `b = NULL` before calling `free(a)`).

---

**Exercise 7** (Write a program): Read `n`, `calloc` an array of `n` doubles, fill with `1.0..n.0`, print, free.

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n;
    printf("Enter count: ");
    if (scanf("%d", &n) != 1 || n <= 0) {
        fprintf(stderr, "Invalid count\n");
        return 1;
    }

    double *arr = calloc((size_t)n, sizeof(double));
    if (arr == NULL) {
        fprintf(stderr, "Allocation failed\n");
        return 1;
    }

    for (int i = 0; i < n; i++) {
        arr[i] = (double)(i + 1);
    }

    for (int i = 0; i < n; i++) {
        printf("arr[%d] = %.1f\n", i, arr[i]);
    }

    free(arr);
    return 0;
}
```

---

# Chapter 9: Numbers and Casting

**Exercise 1** (Think about it): In Java, casting an object to an incompatible type at runtime throws a `ClassCastException`.
In C, casting a pointer to an incompatible pointer type compiles silently.
What are the consequences of this difference, and what discipline should a C programmer apply to pointer casts?

In Java, the runtime checks the actual type of the object and throws an exception if the cast is invalid.
This is safe but has a runtime cost.
In C, a pointer cast is a compile-time instruction to the compiler to interpret the bits at a given address as a different type.
There is no runtime check.
If you cast an `int *` to a `double *` and dereference the result, you get undefined behavior --- you are reinterpreting 4 bytes as an 8-byte `double`.
The compiler trusts you completely.

The discipline a C programmer should apply: only cast pointers when you have a concrete, well-understood reason and know the memory layout is compatible.
The main legitimate uses are casting to and from `void *` (which is safe and required for generic functions like `malloc`, `qsort`, etc.), casting to `unsigned char *` for byte-level access to an object's representation, and type-punning through a union (the sanctioned way to reinterpret bits).
Casting between unrelated pointer types (e.g., `int *` to `float *`) is almost always a bug.

---

**Exercise 2** (What does this print?):

```c
#include <stdio.h>
int main(void) {
    char c = 'H';
    printf("%c %d\n", c + 3, c + 3);
    return 0;
}
```

Output:
```
K 75
```

Explanation: `'H'` has the ASCII value `72`.
`72 + 3 = 75`, which is the ASCII value for `'K'`.
`%c` prints the character corresponding to the integer value, so it prints `K`.
`%d` prints the raw integer value, so it prints `75`.

---

**Exercise 3** (What does this print?):

```c
#include <stdio.h>
int main(void) {
    int   a = 7, b = 2;
    printf("%d\n",   a / b);
    printf("%.1f\n", (double)a / b);
    printf("%.1f\n", (double)(a / b));
    return 0;
}
```

Output:
```
3
3.5
3.0
```

Explanation: `a / b` is integer division: `7 / 2 = 3`.
`(double)a / b` casts `a` to `double` first, making it `7.0 / 2`, which is floating-point division: `3.5`.
`(double)(a / b)` performs the integer division first (`7 / 2 = 3`), then casts the result to `double`: `3.0`.
The order of operations matters: you must cast *before* the division to get a floating-point result.

---

**Exercise 4** (Calculation): On a system where `int` is 32 bits and `char` is 8 bits, what is the value of each expression?

(a) `(int)3.9`
(b) `(int)-3.9`
(c) `(char)300`

(a) `(int)3.9` = **3**.
Casting a floating-point value to an integer truncates toward zero.

(b) `(int)-3.9` = **-3**.
Truncation toward zero applies for negative values too: `-3.9` truncates to `-3`, not `-4`.

(c) `(char)300` = **44**.
`300` in binary is `100101100`.
A `char` is 8 bits, so only the low 8 bits are kept: `00101100` = 44.
(On a system where `char` is signed, 44 is positive and fits, so the result is 44.)

---

**Exercise 5** (Where is the bug?):

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char *score_str = "100";
    int   score     = (int)score_str;
    printf("You scored %d%%\n", score);
    return 0;
}
```

The bug is casting a `char *` pointer to `int`.
`score_str` holds the *memory address* of the string `"100"`, not the integer value 100.
`(int)score_str` truncates that address to fit in an `int`, producing some large arbitrary number (or producing a compiler warning about casting a pointer to an integer of different size on a 64-bit system).
The program will print something like `You scored -1234567890%` rather than `You scored 100%`.

The fix is to parse the string: `int score = (int)strtol(score_str, NULL, 10);`.

---

**Exercise 6** (Where is the bug?):

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char *word1 = "Hello";
    char *word2 = "Hi";

    if (strlen(word1) - strlen(word2) > 0)
        printf("word1 is longer\n");
    else
        printf("word2 is longer or equal\n");
    return 0;
}
```

The bug is subtracting two `size_t` (unsigned) values.
`strlen` returns `size_t`, which is unsigned.
In this specific example `strlen("Hello") = 5` and `strlen("Hi") = 2`, so `5 - 2 = 3`, which is `> 0` and prints `"word1 is longer"` --- accidentally correct.

The bug bites when `word2` is longer than `word1`.
If `strlen(word1) = 2` and `strlen(word2) = 5`, then `2 - 5` on unsigned types wraps around to a huge positive number (approximately 18 quintillion on a 64-bit system), which is certainly `> 0`.
The program would incorrectly print `"word1 is longer"` even though `word2` is longer.

The fix is to cast to a signed type before subtracting:

```c
if ((long)strlen(word1) - (long)strlen(word2) > 0)
```

Or compare directly: `if (strlen(word1) > strlen(word2))`.

---

**Exercise 7** (Write a program): Separate integer and fractional parts of a `double`.

```c
#include <stdio.h>

int main(void) {
    double val  = 98.6;
    int    ival = (int)val;
    double frac = val - (double)ival;

    printf("Value:    %.6f\n", val);
    printf("Integer:  %d\n",   ival);
    printf("Fraction: %.6f\n", frac);
    return 0;
}
```

---

**Exercise 8** (Write a program): Read a hex string, convert with `strtol` base 16, print decimal.

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char buf[64];
    printf("Enter a hex string (e.g., FF): ");
    if (scanf("%63s", buf) != 1) {
        fprintf(stderr, "Input error\n");
        return 1;
    }

    long value = strtol(buf, NULL, 16);
    printf("0x%s = %ld\n", buf, value);
    return 0;
}
```

---

# Chapter 10: Standard I/O

**Exercise 1** (Think about it): Java's `try-with-resources` automatically closes files when the block exits, even if an exception is thrown.
C has no equivalent --- you must call `fclose` manually.
What can go wrong if you forget to call `fclose`?
What happens if your program calls `exit` before reaching the `fclose` call?

Forgetting `fclose` causes two problems.
First, any data in the `stdio` write buffer that has not been flushed to disk will be lost.
If you write to a file and exit without closing it, the last few kilobytes of output may never reach the file.
Second, the operating system has a per-process limit on open file descriptors (typically 1024 on Linux).
If your program opens many files without closing them, it will eventually exhaust the limit and `fopen` will return `NULL` for any subsequent open.

When your program calls `exit`, the C runtime automatically flushes and closes all open `stdio` streams --- so data is not lost in that case.
However, if the program terminates abnormally (crash, `_exit`, signal), the buffers are *not* flushed and the files are not cleanly closed.
Best practice: always call `fclose` explicitly when you are done with a file.

---

**Exercise 2** (What does this print?):

```c
char buf[50];
snprintf(buf, sizeof(buf), "%s: %d", "Sweet Dreams", 1983);
printf("%zu\n", strlen(buf));
```

Output:
```
18
```

Explanation: `snprintf` writes `"Sweet Dreams: 1983"` into `buf`.
`"Sweet Dreams"` is 12 characters, `": "` is 2 characters, and `"1983"` is 4 characters, for a total of 18 characters (plus the null terminator).
`strlen` counts the characters before the null terminator, so it returns `18`.

---

**Exercise 3** (What does this print?):

```c
fprintf(stdout, "A");
fprintf(stderr, "B");
fprintf(stdout, "C\n");
```

When both `stdout` and `stderr` go to the terminal, the output is:

```
ABC
```

(or possibly `BAC` --- the ordering of `stderr` relative to `stdout` is not guaranteed because they are separate streams that can flush at different times).

If you redirect stdout to a file with `./program > out.txt`:
`out.txt` contains `AC` (the stdout output), and `B` still appears on the terminal (stderr is not redirected).

---

**Exercise 4** (Calculation): If `buf` is declared as `char buf[12]` and you call `snprintf(buf, sizeof(buf), "Year: %d", 1985)`, what string ends up in `buf`?
How many characters were written (excluding the null terminator)?

`"Year: 1985"` is exactly 10 characters plus a null terminator = 11 bytes total.
`sizeof(buf)` is 12, which is enough room.
`buf` contains `"Year: 1985"`.
`snprintf` wrote **10** characters (excluding the null terminator).

Note: if the buffer were smaller --- say `char buf[8]` --- `snprintf` would write 7 characters plus a null, producing `"Year: 1"`, and return 10 (the number it *would* have written if the buffer were large enough).

---

**Exercise 5** (Where is the bug?):

```c
int x;
scanf("%d", x);
```

The bug is the missing `&` before `x`.
`scanf` needs the *address* of `x` so it can store the scanned integer there.
Without `&`, `scanf` receives the current (uninitialized, garbage) value of `x` and treats it as a memory address.
It then tries to write the parsed integer to that garbage address, which is almost certainly not valid.
The program will crash with a segmentation fault or silently corrupt memory.
The fix is `scanf("%d", &x);`.

---

**Exercise 6** (Where is the bug?):

```c
FILE *f = fopen("noexist.txt", "r");
fprintf(f, "Hello\n");
fclose(f);
```

The bug is using `f` without checking whether `fopen` succeeded.
`fopen` returns `NULL` when the file cannot be opened.
If `"noexist.txt"` does not exist, `f` is `NULL`.
Passing a `NULL` `FILE *` to `fprintf` is undefined behavior --- typically a segmentation fault.

The fix:
```c
FILE *f = fopen("noexist.txt", "r");
if (f == NULL) {
    perror("fopen");
    return 1;
}
fprintf(f, "Hello\n");
fclose(f);
```

Also note: opening with mode `"r"` is for reading, but `fprintf` writes.
You would need `"w"` to write to a file.

---

**Exercise 7** (Think about it): You run `./program > output.txt` and your program contains both `printf` calls and `fprintf(stderr, ...)` calls.
Which messages appear in `output.txt` and which appear on the terminal?
Why?

`printf` writes to `stdout` (file descriptor 1).
The shell redirection `> output.txt` connects file descriptor 1 to the file, so all `printf` output goes into `output.txt`.

`fprintf(stderr, ...)` writes to `stderr` (file descriptor 2).
The shell redirection `> output.txt` does not affect file descriptor 2, so `stderr` output still goes to the terminal.

This is by design --- error messages should remain visible even when normal output is redirected.
To redirect both, use `./program > output.txt 2>&1`, which also connects file descriptor 2 to the file.

---

**Exercise 8** (Write a program): Write five lines to a file, reopen for reading, print with `fgets`.

```c
#include <stdio.h>

int main(void) {
    const char *filename = "/tmp/ch10_demo.txt";

    /* Write five lines */
    FILE *f = fopen(filename, "w");
    if (f == NULL) {
        perror("fopen for writing");
        return 1;
    }
    fprintf(f, "Line 1: Every breath you take\n");
    fprintf(f, "Line 2: Every move you make\n");
    fprintf(f, "Line 3: Every bond you break\n");
    fprintf(f, "Line 4: Every step you take\n");
    fprintf(f, "Line 5: I'll be watching you\n");
    fclose(f);

    /* Read and print */
    f = fopen(filename, "r");
    if (f == NULL) {
        perror("fopen for reading");
        return 1;
    }
    char line[128];
    while (fgets(line, sizeof(line), f) != NULL) {
        printf("%s", line);   /* line already includes '\n' */
    }
    fclose(f);
    return 0;
}
```

---

# Chapter 11: Low-Level I/O

**Exercise 1** (Think about it): Why would you use low-level `read`/`write` instead of `fprintf`/`fscanf`?
When would `stdio` be the better choice?

Use low-level `read`/`write` when:
- You need precise control over I/O timing with no buffering --- for example, writing to a device where each `write` must correspond to exactly one system call.
- You are implementing inter-process communication over pipes or sockets, where the `stdio` buffering model does not apply cleanly.
- You are using `pread`/`pwrite` for multi-threaded access to a shared file descriptor without races.
- You are working at the systems level (writing a shell, a server, or part of an OS) where the extra abstraction of `stdio` is unwanted.

Use `stdio` (`fprintf`/`fscanf`/`fgets`) when:
- You are doing formatted text I/O --- parsing numbers, building strings --- where format specifiers save a lot of work.
- The built-in buffering improves performance for sequential reads and writes.
- Portability matters: `stdio` is standard C, while `open`/`read`/`write` are POSIX.

In practice, most application code uses `stdio` and only reaches for the low-level interface when the higher-level abstraction gets in the way.

---

**Exercise 2** (What does this print?):

```c
write(1, "Video", 5);
write(1, " Killed\n", 8);
```

Output:
```
Video Killed
```

Explanation: `write(1, ...)` writes raw bytes to file descriptor 1 (stdout).
The first call writes `"Video"` (5 bytes) and the second writes `" Killed\n"` (8 bytes, including the newline).
There is no buffering --- the bytes go directly to the output device.

---

**Exercise 3** (Calculation): If `read(fd, buf, 1024)` returns 512, what does that tell you?
Does it mean there was an error?

A return value of 512 means 512 bytes were successfully read --- it is **not** an error.
A short read (fewer bytes than requested) is normal and can happen for several reasons:
the file had only 512 bytes left before end-of-file, the read was from a terminal or pipe and the data available was less than 1024 bytes, or a signal interrupted the system call.

`read` returns `-1` to indicate an actual error.
It returns `0` to indicate end-of-file.
Any positive return value (even one byte) indicates successful data was read.
If you need exactly N bytes, you must loop until you have accumulated them:

```c
size_t total = 0;
while (total < 1024) {
    ssize_t n = read(fd, buf + total, 1024 - total);
    if (n <= 0) break;   /* EOF or error */
    total += n;
}
```

---

**Exercise 4** (Where is the bug?):

```c
int fd = open("newfile.txt", O_WRONLY | O_CREAT);
write(fd, "Everybody Wants to Rule the World\n", 34);
close(fd);
```

The bug is using `O_CREAT` without providing a permissions argument.
When `O_CREAT` is specified, `open` requires a third argument --- the file permissions (mode).
Without it, the third argument is whatever garbage happens to be on the stack, giving the new file unpredictable permissions.
The fix:

```c
int fd = open("newfile.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
```

`0644` gives the owner read/write permission and everyone else read-only.
The `O_TRUNC` flag also ensures the file is truncated to zero length if it already exists, which is usually the right behavior when creating for writing.

---

**Exercise 5** (What does this do?):

```c
off_t size = lseek(fd, 0, SEEK_END);
```

This seeks to the end of the file and returns the resulting offset, which is the size of the file in bytes.
`SEEK_END` positions relative to the end of the file, and an offset of `0` means "the end itself."
The current read/write position of `fd` is moved to the end of the file as a side effect.

---

**Exercise 6** (Think about it): Explain the difference between `lseek(fd, 0, SEEK_END)` and `lseek(fd, -1, SEEK_END)`.
What does each position you at?

`lseek(fd, 0, SEEK_END)` positions you at the byte *past* the last byte --- one byte beyond the end.
If the file has 100 bytes (offsets 0 through 99), this positions you at offset 100.
A subsequent read will return 0 (EOF immediately).
This is typically used to find the file size.

`lseek(fd, -1, SEEK_END)` positions you at the last byte of the file --- at offset 99 in a 100-byte file.
A subsequent read of one byte will return the last byte of the file.
Using negative offsets with `SEEK_END` is how you seek to a position relative to the end.

---

**Exercise 7** (Write a program): Copy one file to another using low-level I/O, filenames from `argv`.

```c
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {
    if (argc != 3) {
        write(2, "Usage: copy src dst\n", 20);
        return 1;
    }

    int src = open(argv[1], O_RDONLY);
    if (src == -1) {
        perror("open source");
        return 1;
    }

    int dst = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (dst == -1) {
        perror("open destination");
        close(src);
        return 1;
    }

    char buf[4096];
    ssize_t n;
    while ((n = read(src, buf, sizeof(buf))) > 0) {
        ssize_t written = 0;
        while (written < n) {
            ssize_t w = write(dst, buf + written, (size_t)(n - written));
            if (w == -1) {
                perror("write");
                close(src);
                close(dst);
                return 1;
            }
            written += w;
        }
    }

    if (n == -1)
        perror("read");

    close(src);
    close(dst);
    return (n == -1) ? 1 : 0;
}
```

---

# Chapter 12: Odds and Ends

**Exercise 1** (Think about it): In Java you use exceptions for error handling in deeply nested function calls.
In C there are no exceptions.
What strategies can you use to handle errors that occur deep inside a call chain?
When is `exit` appropriate and when is it not?

The primary strategies in C are:

**Return codes:** Every function returns a value indicating success or failure.
Callers check the return value and propagate the error up the call stack, transforming it as needed.
This is verbose but explicit and gives the top-level code control over how to respond.

**`errno` and `perror`:** Standard library functions set the global `errno` variable on failure.
Use `perror` or `strerror(errno)` to print a human-readable message.

**`goto` cleanup pattern:** Within a single function, `goto` jumps to cleanup labels at the bottom to release resources acquired before the failure.

**Global error state:** Some libraries use a global error variable (like `errno` itself) that callers check after operations.

`exit` is appropriate when the error is truly unrecoverable and there is no meaningful way for the program to continue --- for example, failing to open a required configuration file at startup, or detecting heap corruption.
It is also acceptable in short utility programs where robust error propagation would add complexity disproportionate to the program's purpose.

`exit` is NOT appropriate in library code (libraries should return errors to the caller, not decide to end the program) or in code that has acquired resources that need orderly cleanup.

---

**Exercise 2** (What does this print?):

```c
#include <stdio.h>
#include <stdlib.h>

void farewell(void) {
    printf("Mis ojos lloran por ti!\n");
}

int main(void) {
    atexit(farewell);
    printf("Everybody wants to rule the world.\n");
    exit(0);
}
```

Output:
```
Everybody wants to rule the world.
Mis ojos lloran por ti!
```

Explanation: `atexit` registers `farewell` to be called when the program exits.
`printf` prints the first line.
`exit(0)` begins the shutdown sequence: it calls all registered `atexit` functions in reverse registration order and then flushes `stdio` buffers.
`farewell` prints the second line before the process terminates.

---

**Exercise 3** (Where is the bug?): (Hint: ownership)

```c
char *name = strdup("Video Killed the Radio Star");
char *alias = name;
free(name);
printf("%s\n", alias);
```

The bug is **use-after-free**.
`strdup` allocates memory and returns a pointer to it.
`alias = name` makes `alias` point to the *same* heap block.
`free(name)` releases that block back to the allocator.
`printf("%s\n", alias)` then accesses the freed memory --- this is undefined behavior.
The string may still appear to print correctly (if the allocator has not overwritten that memory yet), or it may print garbage, or the program may crash.

The rule: once you `free` a pointer, do not access the memory through *any* pointer that was pointing to the same block.
Set freed pointers to `NULL` to make accidental use more obvious.

---

**Exercise 4** (Think about it): You call a function `char *lookup_name(int id)` from an unfamiliar library.
How would you determine whether you need to `free` the returned pointer?
What risks do you face if the documentation is unclear?

The only reliable source of truth is the documentation.
Look for explicit statements like "the caller must free the returned pointer" or "the returned pointer points to a static internal buffer --- do not free it."
Check whether similar functions in the same library consistently follow a pattern.
Look at example code in the documentation or test suite.

If the documentation is unclear:
- If you `free` a pointer you do not own (the library owns it), you get a double-free or a corrupt heap --- undefined behavior that may crash the allocator at an unrelated time and location.
- If you fail to `free` a pointer you do own, you get a memory leak that slowly exhausts your process's memory.

In practice, use tools like `valgrind` to detect both memory leaks and invalid frees.
When in doubt, read the source code of the library if it is available.
C is a "read the contract carefully" language.

---

**Exercise 5** (Calculation): Given `int nums[] = {1979, 1982, 1983, 1985, 1987};`, what is the value of `sizeof(nums) / sizeof(nums[0])`?

`sizeof(nums)` = 5 elements * 4 bytes per `int` = 20 bytes.
`sizeof(nums[0])` = `sizeof(int)` = 4 bytes.
`20 / 4` = **5**.

This is the standard C idiom for computing the number of elements in a stack-allocated array.

---

**Exercise 6** (What does this print?):

```c
#include <stdio.h>
#include <stdlib.h>

int compare_desc(const void *a, const void *b) {
    int ia = *(const int *)a;
    int ib = *(const int *)b;
    return (ib > ia) - (ib < ia);
}

int main(void) {
    int vals[] = {1979, 1982, 1985, 1983, 1987};
    qsort(vals, 5, sizeof(int), compare_desc);
    printf("%d %d %d %d %d\n",
           vals[0], vals[1], vals[2], vals[3], vals[4]);
    return 0;
}
```

Output:
```
1987 1985 1983 1982 1979
```

Explanation: `compare_desc` sorts in descending order.
It returns a positive value when `ib > ia` (meaning `b` should come before `a`, i.e., larger values first).
`qsort` sorts the array so the largest value appears first.

---

**Exercise 7** (Where is the bug?):

```c
int compare_ints(const void *a, const void *b) {
    int ia = *(const int *)a;
    int ib = *(const int *)b;
    return ia - ib;
}
```

The bug is using subtraction to compare integers.
The expression `ia - ib` can **overflow** when `ia` and `ib` have very different signs.
For example, if `ia = INT_MAX` (2147483647) and `ib = -1`, then `ia - ib = 2147483647 - (-1) = 2147483648`, which overflows a 32-bit signed integer and wraps to a negative value --- making the comparator report that `INT_MAX < -1`, which is completely wrong and will corrupt the sort.

The safe idiom is `(ia > ib) - (ia < ib)`, which always returns exactly -1, 0, or 1 without any possibility of overflow.

---

**Exercise 8** (Write a program): Sort an array of strings in reverse alphabetical order using `qsort`.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int compare_reverse(const void *a, const void *b) {
    const char *sa = *(const char **)a;
    const char *sb = *(const char **)b;
    return strcmp(sb, sa);   /* reversed: compare sb to sa instead of sa to sb */
}

int main(void) {
    const char *songs[] = {
        "Sweet Dreams",
        "Master of Puppets",
        "Blue Monday",
        "Karma Chameleon",
        "Video Killed the Radio Star"
    };
    int n = sizeof(songs) / sizeof(songs[0]);

    qsort(songs, n, sizeof(char *), compare_reverse);

    printf("Reverse alphabetical order:\n");
    for (int i = 0; i < n; i++) {
        printf("  %s\n", songs[i]);
    }
    return 0;
}
```

The key is swapping the arguments to `strcmp`: `strcmp(sb, sa)` instead of `strcmp(sa, sb)`.
When `sb` comes before `sa` alphabetically, `strcmp(sb, sa)` is negative, which tells `qsort` that `sb` (element `b`) should come first --- producing reverse alphabetical order.
