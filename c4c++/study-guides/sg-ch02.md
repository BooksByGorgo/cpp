# Chapter 2 Study Guide: Variables

## Basic types

- Name the built-in integer and floating-point types in C and describe one situation where you would reach for each.
- What is the difference between `signed char` and `unsigned char` in terms of the values each can hold?
- Why does C89 lack a `bool` keyword, and what does `<stdbool.h>` add?
- Without including `<stdbool.h>`, how would you represent true and false in C89 code?

## Variables as named memory

- What two things does a variable declaration do?
- Why does `sizeof(int)` return different values on different systems?
- Why is `%zu` the correct format specifier for a `size_t` value, and what goes wrong if you use `%d`?

## Pointer declarations (preview)

- In `int *p`, which part of the declaration tells the compiler "this is a pointer," and which part tells it the type of the pointed-to data?
- Why is this chapter deferring the deep treatment of pointers to a later chapter?

## Arrays

- What does it mean that an array has a *fixed size*, and when is that size decided?
- What is *array decay*?
- When is `sizeof` one of the rare contexts where an array does *not* decay to a pointer, and why does that matter?
- When you partially initialize an array, what happens to the remaining elements?

### Experiment: sizeof of an array vs a pointer

- Declare a stack-allocated `int` array and an `int *` that points to it.
- Print `sizeof` of each.
- Explain why the two values differ on a 64-bit system.

## Multidimensional arrays

- What does *row-major* order mean for a 2D array, and how is a 3-by-4 array laid out in memory?
- When you pass a multidimensional array to a function, which dimensions must you specify, and why?

## `const`

- What does `const` promise the compiler about a variable?
- Using the "read right-to-left" rule, describe the difference between `const int *p`, `int *const p`, and `const int *const p`.
- Which of those three forms is the most common in real C code, and why?

### Experiment: const combinations

- Write three short programs that declare `const int *p`, `int *const p`, and `const int *const p` respectively.
- In each one, try to change what the pointer points to and try to modify the data through the pointer.
- Record which attempts compile and which produce errors.

## Structures

- How is a C `struct` different from a C++ `class`?
- What does `.` do, and when can you use it?
- When you assign one struct to another, what exactly is copied?
- Why is that a problem when the struct contains a `char *` pointing to `malloc`ed memory?

## No member functions

- Since C structs cannot have member functions, how do C programmers approximate methods?
- What naming convention does this lead to, and what benefit does it give you when reading code?

## Designated initializers

- How do designated initializers let you initialize struct members in a different order than they were declared?
- What value do un-mentioned members get?
- Why are designated initializers more robust than positional initialization when someone later reorders the struct?

### Experiment: designated initializer defaults

- Declare a struct with four members of different types.
- Initialize only the second and fourth members using designated initializers.
- Print all four members and confirm that the un-mentioned ones are zero.

## `typedef`

- What does `typedef` create --- a new type, or an alias?
- Why does `typedef struct { ... } Point;` let you drop the `struct` keyword at use sites?
- How does the placement of the name in `typedef unsigned long ulong;` mirror ordinary variable declaration syntax?

### Experiment: variable lifetimes and sizes

- Write a program that declares one variable of each of these types: `char`, `short`, `int`, `long`, `long long`, `float`, `double`, and `bool`.
- Print `sizeof` each one using `%zu`.
- Compare your output with the table in the chapter and note any surprises.
