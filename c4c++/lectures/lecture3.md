# Lecture 3 --- Pointers

**Source:** `c4c++/ch06.md`
**Duration:** 50 minutes

## Learning Objectives

By the end of this lecture, students should be able to:

- Define a pointer as a variable that holds a memory address
- Declare pointers correctly, including the two-star-for-two-pointers rule
- Use `&` to take an address and `*` to dereference
- Draw a memory diagram for a chain of `int`, `int *`, and `int **`
- Explain that arrays decay to pointers and that `a[i]` is `*(a + i)`
- Perform pointer arithmetic in units of the pointed-to type
- Use `->` to access struct fields through a pointer
- Use a pointer parameter to let a function modify a caller's variable

## Materials

- Live coding terminal with `cc -Wall -Wextra -pedantic`
- Whiteboard for memory diagrams
- Copy of `c4c++/ch06.md` for reference

---

## 0. Review (5 min)

**Q.** What does this print?

```c
char s[] = "Ghostbusters";
printf("%zu %zu\n", strlen(s), sizeof(s));
```

A. `12 12`
B. `12 13`
C. `13 12`
D. `13 13`
E. Ben got this wrong

*Answer: B*

## 1. What Is a Pointer? (3 min)

- A pointer is a variable whose value is a memory address.
- Nothing magical --- same size as other pointers (8 bytes on a 64-bit system).
- The type before the `*` describes what the address *points to*, not the pointer itself.

## 2. Declaring Pointers (5 min)

```c
int *p;        // pointer to int
char *s;       // pointer to char
double *d;     // pointer to double
```

::: {.tip}
**Trap:** The `*` binds to the variable, not the type.

```c
int *p, q;     // p is int*, q is int
int *p, *q;    // both are int*
```
:::

## 3. `&` and `*` (7 min)

```c
int score = 100;
int *p = &score;        // & gets the address

printf("*p = %d\n", *p);   // 100
*p = 200;                   // modifies score
printf("score = %d\n", score); // 200
```

- In a declaration `*` means "pointer."
- In an expression `*` means "follow the pointer."
- `&x` is "the address of `x`."

## 4. Pointers to Pointers (5 min)

```c
int val = 42;
int *p = &val;
int **pp = &p;

printf("%d\n", **pp);   // 42
```

- `argv` in `int main(int argc, char **argv)` is exactly this.

### Memory diagram (draw on board)

```
Variable  Address   Value
x         0x1000    1985
y         0x1004    80
p         0x1008    0x1000   -> x
pp        0x1010    0x1008   -> p -> x
```

- Follow `*p` to reach `x`.
- Follow `**pp` to reach `x`.

## 5. NULL Pointers (3 min)

```c
int *p = NULL;
if (p) {
    printf("%d\n", *p);   // safe — we checked
}
```

- Dereferencing `NULL` is undefined behavior; usually a segfault.
- C uses `NULL`; C++ also has `nullptr` (C does not).

## 6. Pointers and Arrays (7 min)

- Same type (`int *`) whether it points to one int or the first of many.
- You are responsible for staying in bounds --- the compiler will not help.

```c
int nums[] = {10, 20, 30, 40, 50};
int *p = nums;            // no & needed — array decays

printf("%d\n", *p);       // 10
printf("%d\n", *(p + 1)); // 20
printf("%d\n", p[2]);     // 30 — yes, [] works on pointers
```

- `a[i]` means exactly `*(a + i)`.
- Pointer arithmetic advances by `sizeof(*p)` bytes, not by 1 byte.

## 7. Pointers and Structs --- `->` (5 min)

```c
struct song {
    char title[40];
    int year;
};

struct song track = {"Karma Chameleon", 1983};
struct song *p = &track;

printf("%s\n", (*p).title);   // ugly
printf("%s\n", p->title);     // idiomatic
```

- `.` has higher precedence than `*`, so `(*p).title` needs the parentheses.
- `p->field` is just `(*p).field`, written more cleanly.

## 8. Pass by Value and the Pointer Workaround (10 min)

- **Every** C parameter is pass by value --- the function gets a copy.
- To modify a caller's variable, pass a pointer.

```c
void increment(int *x) {
    (*x)++;
}

int score = 99;
increment(&score);
printf("%d\n", score);   // 100
```

```c
void swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}
```

- The function receives a **copy** of the address, but both copies name the same memory.

::: {.tip}
**Tip:** When you see a `*` on a parameter, ask: does the function need to modify my variable, or does it need a block of memory (like an array)? Often it is both.
:::

## 9. Common Bug: Returning an Address to a Local (3 min)

```c
int *get_value(void) {
    int result = 42;
    return &result;      // DANGLING: result dies when function returns
}
```

- Stack memory is reclaimed when the function returns.
- Return the value, use a caller-provided buffer, or `malloc` it (lecture 5+6).

## 10. Wrap-up Quiz (5 min)

**Q1.** What does this print?

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

**Q2.** Where is the bug?

```c
struct song {
    char title[40];
    int year;
};

struct song *p = NULL;
printf("%s\n", p->title);
```

A. Missing `&` on `p`
B. `->` should be `.`
C. Dereferencing `NULL` is undefined
D. `title` is not initialized
E. Ben got this wrong

*Answer: C*

**Q3.** On a 64-bit system, what is `sizeof(int *)`?

A. 2
B. 4
C. 6
D. 8
E. Depends on the int it points to

*Answer: D*

## 11. Assignment / Reading (2 min)

**Read:** chapter 7 of *Gorgo C for C++ Programmers*.
**Do:** exercises 1, 2, 3, 5, 6, 7.

## Key Points to Reinforce

- A pointer is a variable holding an address; nothing magical
- `*` in a declaration = "pointer"; in an expression = "follow it"
- `&x` = "address of `x`"
- `a[i]` is `*(a + i)`; arrays decay to pointers
- Pointer arithmetic moves by `sizeof(*p)` bytes
- `p->field` is `(*p).field`
- All parameters are pass-by-value; pass a pointer to modify the caller's variable
- Never return the address of a local
