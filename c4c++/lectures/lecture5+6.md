# Lectures 5+6 --- Allocating Memory

**Source:** `c4c++/ch08.md`
**Duration:** two 50-minute sessions

Lecture 5 covers *where variables live* and introduces `malloc` / `free`.
Lecture 6 builds on that with `calloc`, `realloc`, raw-memory helpers, and common pitfalls.

---

# Lecture 5 --- Memory Lifetimes and `malloc`

## Learning Objectives (Lecture 5)

By the end of this lecture, students should be able to:

- Distinguish the lifetimes of global, local, static-local, and heap variables
- Identify where each kind of variable lives in memory
- Recognize the dangling-pointer bug of returning `&local`
- Use `malloc` and `free` correctly and check for allocation failure
- Explain why `malloc` returns `void *` and does not need a cast in C

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Whiteboard for the stack/heap/data-segment diagram
- Copy of `c4c++/ch08.md` for reference

## 0. Review (5 min)

**Q.** What does this print?

```c
void mystery(int x) { x = x * 2; }

int val = 5;
mystery(val);
printf("%d\n", val);
```

A. `10`
B. `5`
C. Undefined
D. Depends on compiler
E. Ben got this wrong

*Answer: B*

## 1. Why Memory Lifetimes Matter (3 min)

- Every variable lives somewhere in memory.
- Three things change by *kind* of variable: visibility, lifetime, and who cleans up.
- Getting lifetime wrong is the #1 source of C crashes.
- Entire languages (Java, Rust) exist to avoid these bugs.

## 2. Global Variables (5 min)

```c
int high_score = 0;         // global — entire program

void update(int points) {
    if (points > high_score) high_score = points;
}
```

- Created at program start, destroyed at exit.
- Visible to every function in the file.
- Useful, but easy to abuse --- any function can change it.

::: {.tip}
**Tip:** Prefer passing data through parameters. Reserve globals for things that truly are program-wide (configuration, logging).
:::

## 3. Local Variables (7 min)

```c
void greet(void) {
    char msg[] = "Hola, amigo";   // dies when greet() returns
    puts(msg);
}
```

- Created on the stack when the function is entered.
- Destroyed when it returns --- no cleanup work for you.
- Fast: stack is a single pointer move.

### Dangling Pointer

```c
int *bad(void) {
    int x = 42;
    return &x;       // BUG: x is gone when bad() returns
}
```

- Already covered in lecture 3, reinforce here.

## 4. Static Local Variables (5 min)

```c
void count_calls(void) {
    static int n = 0;    // initialized once, kept forever
    n++;
    printf("called %d time(s)\n", n);
}
```

- Scope of a local, lifetime of a global.
- Lives in the data segment, not the stack.
- Great for "remember across calls" without exposing a global.

## 5. Heap Memory: `malloc` and `free` (15 min)

```c
void *malloc(size_t size);
void  free(void *ptr);
```

- `#include <stdlib.h>`
- `malloc` returns a `void *` pointing at the allocated block.
- Returns `NULL` on failure.
- In C, the `void *` converts to any pointer type without a cast.

```c
int *nums = malloc(5 * sizeof(int));
if (nums == NULL) { return 1; }

for (int i = 0; i < 5; i++)
    nums[i] = (i + 1) * 10;

free(nums);
```

### The rules

- Every `malloc` that succeeds needs exactly one `free`.
- Use-after-free = undefined behavior.
- Double-free = undefined behavior.
- Forgetting to free = memory leak.
- There are no smart pointers. There is no RAII. There is no GC.

### The "don't check NULL" debate

- Argument: `NULL` checks everywhere clutter code paths that are almost never exercised.
- Counter: safety-critical systems need the check --- or ban dynamic allocation entirely.
- Default advice: check and bail out early in teaching code.

## 6. Where Variables Live: Summary (3 min)

| Kind | Where | Lifetime | Example |
|:---|:---|:---|:---|
| Global | data segment | whole program | `int count = 0;` |
| Local | stack | until function returns | `int x = 5;` |
| Static local | data segment | whole program | `static int n = 0;` |
| Dynamic | heap | until you `free` | `int *p = malloc(...)` |

## 7. Live Coding (5 min)

```c
#include <stdio.h>
#include <stdlib.h>

int total = 0;

void add(int n) { total += n; }

int main(void) {
    add(10); add(20);
    printf("total = %d\n", total);

    int *data = malloc(3 * sizeof(int));
    if (!data) return 1;

    data[0] = 1985; data[1] = 1986; data[2] = 1987;
    for (int i = 0; i < 3; i++) printf("%d\n", data[i]);

    free(data);
    return 0;
}
```

- Compile with `-Wall -Wextra -pedantic`
- Comment out the `free` and mention leak detectors (valgrind, ASan)
- Return the address of a local from a function and watch the warning

## 8. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
void counter(void) {
    static int n = 0;
    n++;
    printf("%d ", n);
}

int main(void) {
    counter(); counter(); counter();
    return 0;
}
```

A. `0 0 0`
B. `1 1 1`
C. `1 2 3`
D. `3 3 3`
E. Ben got this wrong

*Answer: C*

**Q2.** Where is the bug?

```c
int *p = malloc(10 * sizeof(int));
for (int i = 0; i < 10; i++) p[i] = i;
free(p);
printf("%d\n", p[0]);
```

A. `malloc` is missing a cast
B. Use-after-free on `p`
C. `p[0]` should be `*p`
D. `printf` should use `%zu`
E. Ben got this wrong

*Answer: B*

**Q3.** On a 32-bit-int system, `malloc(5 * sizeof(int))` asks for how many bytes?

A. 5
B. 10
C. 16
D. 20
E. 32

*Answer: D*

## 9. Assignment / Reading (2 min)

**Read:** chapter 8 of *Gorgo C for C++ Programmers* (second half --- `calloc`, `realloc`, `memcpy`, `memset`).
**Do:** exercises 1, 2, 3, 6.

---

# Lecture 6 --- `calloc`, `realloc`, and Raw Memory

## Learning Objectives (Lecture 6)

By the end of this lecture, students should be able to:

- Choose between `malloc` and `calloc`
- Resize a buffer with `realloc` without leaking on failure
- Use `memset` to fill a block with a byte
- Use `memcpy` and know when to reach for `memmove`
- Identify the classic double-free bug when two pointers share a block

## 0. Review (5 min)

**Q.** Where is the bug?

```c
int *p = malloc(10 * sizeof(int));
for (int i = 0; i < 10; i++) p[i] = i;
free(p);
printf("%d\n", p[0]);
```

A. `malloc` is missing a cast
B. Use-after-free on `p`
C. `p[0]` should be `*p`
D. `printf` should use `%zu`
E. Ben got this wrong

*Answer: B*

## 1. `calloc` (5 min)

```c
void *calloc(size_t count, size_t size);
```

- `calloc(5, sizeof(int))` --- 5 ints, **zeroed**.
- Equivalent to `malloc(5 * sizeof(int))` + `memset(p, 0, 20)` --- but clearer intent.

## 2. `realloc` (10 min)

```c
void *realloc(void *ptr, size_t size);
```

```c
int *nums = malloc(5 * sizeof(int));
// ...
int *tmp = realloc(nums, 10 * sizeof(int));
if (tmp == NULL) {
    // handle error — nums is still valid
} else {
    nums = tmp;
}
```

::: {.tip}
**Trap:** Never write `nums = realloc(nums, ...);` directly. If `realloc` fails, it returns `NULL` and the original block is untouched --- but you just lost your only pointer to it. Leak.
:::

- `realloc` can grow or shrink.
- It may return the same address or move the block --- never cache a pointer into the old block across a `realloc`.

## 3. `memset` and `memcpy` (10 min)

```c
void *memset(void *s, int c, size_t n);
void *memcpy(void *dest, const void *src, size_t n);
```

```c
int nums[10];
memset(nums, 0, sizeof(nums));   // zero every byte

int src[] = {10, 20, 30};
int dest[3];
memcpy(dest, src, sizeof(src));
```

- `memset` fills bytes --- `memset(nums, 1, sizeof(nums))` does **not** set each int to 1. It sets every byte to `0x01`, giving `0x01010101`.
- `memcpy` copies exactly `n` bytes and ignores `'\0'`.
- `memcpy` source and destination must **not overlap**.

### `memmove`

```c
void *memmove(void *dest, const void *src, size_t n);
```

- Use when source and destination might overlap (e.g., shifting elements inside one array).

## 4. Double-Free via Aliasing (5 min)

```c
int *a = malloc(5 * sizeof(int));
int *b = a;            // two names for one block
free(a);
free(b);               // UB — double free
```

- `a` and `b` name the same memory.
- Ownership is about *who gets to free*, not about *who has a pointer*.
- Pick one owner and document it.

## 5. Live Coding (10 min)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    // calloc zeroes for us
    int *a = calloc(5, sizeof(int));
    for (int i = 0; i < 5; i++) printf("%d ", a[i]);
    putchar('\n');

    // safe realloc
    int *tmp = realloc(a, 10 * sizeof(int));
    if (!tmp) { free(a); return 1; }
    a = tmp;
    for (int i = 5; i < 10; i++) a[i] = i * i;
    for (int i = 0; i < 10; i++) printf("%d ", a[i]);
    putchar('\n');

    // memcpy round trip
    int src[] = {10, 20, 30};
    int dst[3];
    memcpy(dst, src, sizeof(src));
    for (int i = 0; i < 3; i++) printf("%d ", dst[i]);
    putchar('\n');

    free(a);
    return 0;
}
```

- Show what happens if you run `realloc` with a huge size and the return is `NULL`.
- Deliberately `memcpy` from an array to itself with overlap and introduce `memmove`.

## 6. Wrap-up Quiz (5 min)

**Q1.** Why choose `calloc` over `malloc` + `memset`?

A. `calloc` is always faster
B. It is clearer intent and the library can often skip the memset for fresh pages
C. `malloc` cannot allocate arrays
D. `memset` only works on chars
E. Ben got this wrong

*Answer: B*

**Q2.** Where is the bug?

```c
int *a = malloc(5 * sizeof(int));
int *b = a;
free(a);
free(b);
```

A. Missing cast on `malloc`
B. Double free: `a` and `b` name the same block
C. `free(b)` should be `free(&b)`
D. `b = a` should be `b = &a`
E. Ben got this wrong

*Answer: B*

**Q3.** What is unsafe about `p = realloc(p, n)`?

A. `realloc` never fails
B. If `realloc` fails, `p` becomes `NULL` and the original block leaks
C. `realloc` requires a cast in C
D. `realloc` only grows, never shrinks
E. Ben got this wrong

*Answer: B*

## 7. Assignment / Reading (2 min)

**Read:** chapter 9 of *Gorgo C for C++ Programmers*.
**Do:** exercises 1, 2, 3, 4, 5.

## Key Points to Reinforce (Lectures 5+6)

- Four variable lifetimes: global, local, static-local, dynamic
- Every `malloc` needs exactly one `free`
- `malloc` returns `void *` --- no cast needed in C
- `calloc` zeroes; `realloc` resizes via a temp pointer
- `memset` fills bytes, `memcpy` copies bytes, `memmove` handles overlap
- Aliasing two pointers to one block invites double-free bugs
