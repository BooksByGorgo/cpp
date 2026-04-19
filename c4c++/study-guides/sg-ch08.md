# Chapter 8 Study Guide: Allocating Memory

## Why memory lifetimes matter

- Why did newer languages like Java and Rust spend so much effort on memory management?
- What three things change depending on where a variable "lives" --- who sees it, how long it exists, and who is responsible for cleaning it up?

## Global variables

- When is a global variable created, and when is it destroyed?
- Who can read and write a global variable?
- Why does the chapter caution against using globals freely?

## Local variables

- When is a local variable created and destroyed?
- Which region of memory holds local variables, and who is responsible for reclaiming it?
- What is a *dangling pointer*, and why does `return &x;` from a function create one?

## Static local variables

- What scope does a `static` local have, and what lifetime does it have?
- How is `static int n = 0;` inside a function different from writing `int n = 0;`?
- Where does the static local actually live in memory?

### Experiment: counting calls

- Write a function `void counter(void)` that prints how many times it has been called, using a `static` local variable.
- Call it five times from `main` and verify the count increments across calls.

## Dynamic allocation: `malloc` and `free`

- What header must you include for `malloc` and `free`?
- What does `malloc` return on success, and what does it return on failure?
- Why does `malloc` return `void *`, and why does C (unlike C++) not require a cast?
- What must you do for every successful `malloc`?
- What two classes of bug come from freeing memory, and what is the third from *not* freeing it?

## The "don't check NULL" debate

- Summarize the argument that `NULL` checks after `malloc` add clutter without value.
- In what kind of system is that argument unacceptable, and why?

## `calloc` and `realloc`

- How does `calloc` differ from `malloc`?
- When is `calloc` preferable to `malloc` followed by `memset`?
- Why is `nums = realloc(nums, new_size);` dangerous, and what is the safer idiom using a temporary pointer?

## `memcpy`, `memmove`, `memset`

- What does `memset` do, and why is it often used on freshly allocated buffers?
- How is `memcpy` different from `strcpy`?
- When must you use `memmove` instead of `memcpy`, and why?

### Experiment: clearing and copying raw memory

- Allocate an `int` array with `malloc`.
- Use `memset` to set every byte to zero (not every element to zero --- every *byte*) and confirm by printing each element.
- Use `memcpy` to copy the contents of one `int` array to another, then modify the destination and verify the source is unchanged.

## Where variables live: summary

- Fill in the following table from memory (lifetime, storage, example):
    - global
    - local
    - static local
    - dynamic

### Experiment: dynamic array of squares

- Ask the user for an integer `n`.
- Allocate an array of `n` integers with `malloc`.
- Fill it with `0, 1, 4, 9, ...` and print each element.
- Free the array and set the pointer to `NULL` after freeing.

### Experiment: realloc safely

- Start with a dynamic array of 4 integers.
- Use `realloc` (via a temporary pointer) to grow it to 8 integers.
- Fill the new tail with values and print all 8 elements.
- Artificially force the `realloc` to fail (for example, by requesting a huge size) and confirm your code still has a valid pointer to the original memory.
