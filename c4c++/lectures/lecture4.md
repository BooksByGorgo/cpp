# Lecture 4 --- Functions

**Source:** `c4c++/ch07.md`
**Duration:** 50 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Distinguish a function declaration (prototype) from its definition
- Explain why `int foo()` and `int foo(void)` differ in C
- State that C has no overloading, no defaults, and no references --- and explain the consequences
- Add `const` to pointer parameters and explain the two benefits
- Choose between pass-by-value and `const T *` for struct parameters
- Write a recursive function and reason about stack depth
- Declare, assign, and call through a function pointer
- Use `typedef` to tame function-pointer syntax
- Pass a function pointer as a callback

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Copy of `c4c++/ch07.md` for reference

---

## 0. Review (5 min)

**Q.** What does this print?

```c
int a[] = {10, 20, 30, 40, 50};
int *p = a + 2;
printf("%d %d %d\n", *p, *(p - 1), p[1]);
```

A. `30 20 40`
B. `20 10 30`
C. `3 1 4`
D. `30 40 20`
E. Ben got this wrong

*Answer: A*

## 1. Declarations vs Definitions (5 min)

```c
int add(int a, int b);          // declaration (prototype)

int add(int a, int b) {         // definition
    return a + b;
}
```

- Prototypes live in headers (`.h`); the definition lives in one `.c` file.
- In C++, a parameterless `foo()` means "no parameters." In C, `foo()` means **unspecified parameters** --- the compiler will not check your call.

```c
int get_score(void);    // truly no parameters (enforced)
int get_score();        // unspecified — avoid
```

::: {.tip}
**Tip:** Always write `(void)` for an empty parameter list.
:::

## 2. No Overloading, No Defaults (5 min)

- `int max(int, int)` and `double max(double, double)` cannot coexist --- C has no overloading.
- Standard library convention: `abs` for `int`, `fabs` for `double`, `labs` for `long`.
- No default arguments: every call site passes every argument.
- Trade-off: when you see `add(x, y)`, you know exactly which function runs. No ambiguity.

## 3. Pass by Value (3 min)

- Every parameter is copied.
- `void bad_swap(int a, int b) { ... }` cannot affect the caller's variables.
- Use pointers for "output" parameters --- covered in lecture 3.

## 4. `const` Parameters (7 min)

```c
void print_name(const char *name) {
    printf("I am %s\n", name);
}
```

- **Documents intent:** "this function will not modify what I point at."
- **Enforced by the compiler:** trying to write through `name` is a compile error.

You already saw this all over the standard library:

- `strlen(const char *)`, `strcmp(const char *, const char *)`, `printf(const char *, ...)`

::: {.tip}
**Tip:** Mark every pointer parameter `const` unless the function genuinely needs to modify the pointed-to data.
:::

## 5. Passing Structures (5 min)

```c
struct hero { char name[40]; int power; };

void print_hero(struct hero h);            // copies ~44 bytes every call
void print_hero(const struct hero *h);     // copies 8 bytes
```

- Small structs: by value is fine.
- Large structs: `const struct T *p` to avoid the copy.
- Drop the `const` when the function must modify the struct.

## 6. Recursion (5 min)

```c
long factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
```

```c
int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

- Each call gets its own locals on the stack.
- Naive Fibonacci is **exponential** --- try `fibonacci(50)` at your peril.
- No stack-overflow exception in C. Running out of stack = crash.
- For deep recursion, convert to iteration or add memoization.

## 7. Function Pointers (10 min)

```c
int (*fp)(int, int);    // fp: pointer to function(int,int) -> int
```

::: {.tip}
**Wut:** `int (*fp)(int, int)` vs `int *fp(int, int)`:

- The first is a pointer to a function.
- The second is a function returning an `int *`.
- Parentheses matter.
:::

```c
int add(int a, int b)      { return a + b; }
int multiply(int a, int b) { return a * b; }

int (*op)(int, int);
op = add;       printf("%d\n", op(3, 4));   // 7
op = multiply;  printf("%d\n", op(3, 4));   // 12
```

### `typedef` to the rescue

```c
typedef int (*binop_fn)(int, int);

void apply(binop_fn fn, int x, int y) {
    printf("%d\n", fn(x, y));
}
```

### Callbacks

- Pass a function pointer to another function, let it call the function at the right moment.
- C's answer to lambdas and `std::function`.
- The canonical example is `qsort` (we will see it in a later chapter).

## 8. Live Coding: Functions Starter (5 min)

```c
#include <stdio.h>

void shout(const char *msg) { printf(">>> %s <<<\n", msg); }

struct song { char title[50]; int year; };

void print_song(const struct song *s) {
    printf("\"%s\" (%d)\n", s->title, s->year);
}

long factorial(int n) {
    return (n <= 1) ? 1 : n * factorial(n - 1);
}

int sumar(int a, int b) { return a + b; }
int restar(int a, int b) { return a - b; }
typedef int (*math_fn)(int, int);

void compute(math_fn fn, int x, int y) {
    printf("  result = %d\n", fn(x, y));
}

int main(void) {
    shout("I Am Iron Man");
    struct song fav = {"Iron Man", 1970};
    print_song(&fav);
    printf("7! = %ld\n", factorial(7));
    compute(sumar, 8, 3);
    compute(restar, 8, 3);
    return 0;
}
```

## 9. Wrap-up Quiz (5 min)

**Q1.** What does this print?

```c
void mystery(int x) { x = x * 2; }

int main(void) {
    int val = 5;
    mystery(val);
    printf("%d\n", val);
    return 0;
}
```

A. `10`
B. `5`
C. Undefined
D. Depends on the compiler
E. Ben got this wrong

*Answer: B*

**Q2.** Where is the bug?

```c
int count_chars(const char *s) {
    int count;
    while (*s != '\0') { count++; s++; }
    return count;
}
```

A. Missing `const`
B. `count` is not initialized
C. Should compare with `NULL`, not `'\0'`
D. `s++` inside a loop is UB
E. Ben got this wrong

*Answer: B*

**Q3.** What does this print?

```c
int mul(int a, int b) { return a * b; }

int apply(int (*fn)(int, int), int a, int b) {
    return fn(a, b);
}

printf("%d\n", apply(mul, 6, 7));
```

A. `13`
B. `42`
C. `67`
D. Compile error
E. Ben got this wrong

*Answer: B*

## 10. Assignment / Reading (2 min)

**Read:** chapter 8 of *Gorgo C for C++ Programmers* (first half --- through `malloc`/`free`).
**Do:** exercises 2, 3, 4, 5.

## Key Points to Reinforce

- Always use `(void)` for empty parameter lists
- No overloading and no defaults in C
- Every parameter is pass-by-value
- `const T *param` for read-only pointer arguments
- Pass large structs by `const T *`, not by value
- Recursion has no safety net --- watch stack depth
- Function pointers are C's lambdas; tame them with `typedef`
