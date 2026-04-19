# Chapter 6 Study Guide: Pointers

## Why pointers matter

- Why does the author claim that modern C++ programmers can "get away with" not fully understanding pointers?
- What kinds of C code force you to understand pointers well?

## What is a pointer?

- In one sentence, define what a pointer is and is not.
- What is the difference between the *value* of a pointer and the *value that the pointer points to*?

## Declaring pointers

- In `int *p, q;`, what is the type of `p` and what is the type of `q`?
- How do you fix the declaration so that both are pointers?
- What does the base type (the type before the `*`) tell the compiler?

## Address-of `&`

- What does `&variable` produce?
- Why is the C++ use of `&` for references unrelated to what `&` does in C?

## Dereferencing `*`

- In a declaration, what does `*` mean?
- In an expression, what does `*` mean?
- Walk through what each line of this snippet does:
    ```c
    int x = 10;
    int *p = &x;
    *p = 20;
    ```

## Pointers to pointers

- If `p` is a pointer to `int`, what is `&p`?
- How many times do you dereference an `int **` to reach the integer value?
- Why might `main(int argc, char **argv)` use a pointer-to-pointer?

### Experiment: memory diagram

- Write a short program that declares an `int`, an `int *` pointing to it, and an `int **` pointing to the pointer.
- Print the address of each variable with `%p` (cast to `void *`) and also print the values of `*p`, `**pp`.
- Sketch a memory diagram matching what the program prints.

## NULL pointers

- What does `NULL` represent?
- What happens (typically) when you dereference a `NULL` pointer?
- How is C's `NULL` different from C++11's `nullptr`?

## Pointers and arrays

- Looking only at a variable's type, can you tell whether an `int *` points to a single `int` or to the first element of an array? Why or why not?
- Who is responsible for staying within the bounds of an array when iterating with a pointer?
- What does *pointer arithmetic* advance by --- bytes, or units of the pointed-to type?
- Why does `p[2]` work on a pointer (not just an array), and what expression is it equivalent to?

## Pointers and structures

- Why does `(*p).field` need the parentheses?
- What does `p->field` expand to?
- Which form will you see far more often in real C code, and why?

## Pass by value and pointer workaround

- In C, how are *all* function arguments passed?
- If C has no references, how do you write a function that modifies the caller's variable?
- When `increment(&score)` is called, what exactly does `increment` receive --- a copy of the address or the original?
- Why does modifying `*x` inside `increment` affect the caller's `score`?

### Experiment: swap

- Write a `swap` function that takes two `int *` parameters and swaps the values they point to.
- Call it on two variables in `main`.
- Then write a broken version that takes `int` parameters and verify that it does *not* swap the caller's values.

### Experiment: pointer iteration

- Declare an array of five integers.
- Iterate through it using a pointer that advances with `p++`, and on each iteration print `*p` and `(void *)p`.
- Compare the addresses to confirm that each step advances by `sizeof(int)` bytes.
