# Chapter 7 Study Guide: Functions

## Differences from C++

- Name four C++ function features that C does not have.
- Given those differences, what do C functions still do well?

## Declarations, definitions, and prototypes

- What is a *prototype*, and why should you always have one in scope before calling a function?
- Where do prototypes usually live, and where does the definition live?
- In C, what does `int foo()` mean, and why is it different from `int foo(void)`?
- Why should every parameterless function use `(void)`?

## No overloading

- Why can't C have two functions named `max`?
- How does the standard library provide "overloaded" versions of `abs` for different types, and what naming convention does it follow?

## No default arguments

- Show a C++ prototype with a default argument and rewrite it as valid C.
- How do C programmers typically simulate default arguments?

## Pass by value

- All function parameters in C are pass by value --- what does that imply for a function that wants to modify its caller's variables?
- If C has no reference parameters, how do you get the same effect?

## `const` parameters

- What promise does `const` on a pointer parameter make to callers?
- Name two specific benefits you get from adding `const` to a pointer parameter.
- Why are `printf`, `strlen`, and `strcmp` natural users of `const char *`?

## Passing structures

- When you pass a struct by value, what happens at the call site in terms of memory?
- Why does `const struct T *p` become preferable once the struct grows past a few bytes?
- When should you drop the `const` from a struct pointer parameter?

### Experiment: measure struct copy cost

- Define a struct containing an `int[1000]` and a single `int count`.
- Write one function that takes the struct by value and one that takes a `const` pointer to it.
- Print `sizeof` the struct inside each function and note how many bytes get copied on each call.

## Recursion

- How does C allocate the local variables of a recursive function?
- Why does the naive Fibonacci recursion become unusable for inputs around 50?
- What happens in C when a recursive function exhausts the stack, and why can't you catch it?

### Experiment: recursion vs iteration

- Write a recursive factorial and an iterative factorial.
- Test both on small values, then time them on the largest input that fits in a `long`.

## Function pointers

- In the declaration `int (*fp)(int, int);`, why are the parentheses around `*fp` critical?
- What does `int *fp(int, int)` declare instead?
- How do you assign a function to a function-pointer variable, and how do you call through it?

### Simplifying with typedef

- How does `typedef int (*binop_fn)(int, int);` change the way you write parameters and locals?
- Where are you most likely to reach for such a typedef in real code?

## Callbacks

- What does it mean to pass a function as a callback?
- How is this C's equivalent of a C++ lambda or functor?
- Which standard library function is the chapter's preview of callbacks in practice?

### Experiment: transform array with callback

- Write a function `void transform(int *arr, int n, int (*fn)(int));` that applies `fn` to each element in place.
- Pass in a "double" function and a "negate" function from `main` and confirm the array changes as expected.

### Experiment: swap, done right and done wrong

- Write a `swap` that takes `int *a, int *b` and correctly exchanges the values in the caller.
- Write a broken `swap(int a, int b)` and verify that the caller's values are unchanged after it returns.
- Explain the difference in terms of pass-by-value.
