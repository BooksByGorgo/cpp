# Chapter 5 Study Guide: Control Flow

## Differences from C++

- Name three C++ control-flow features that C does *not* have.
- What changed between C89 and C99 regarding where you can declare variables inside a block?
- In C, what is the type of a condition in an `if`, `while`, or `for`?

## `if` / `else`

- What values count as true and false in a C condition?
- Why does `if (x = 5)` compile, and what does it actually do?
- How does compiling with `-Wall` help catch that mistake?

## `while` and `do-while`

- What is the key timing difference between `while` and `do-while`?
- Give one concrete example of a situation where `do-while` is more natural than `while`.
- Why is the semicolon after the `while` in a `do-while` required?

## `break` and `continue`

- What exactly does `break` exit?
- What does `continue` do?
- If you need to break out of two nested loops at once, what approaches does C give you?

## `for` loops

- What goes in each of the three parts of a `for` loop header?
- How does a C99-style `for` loop differ from a C89-style `for` loop in where you declare the loop variable?
- Why does C not have a range-based `for` loop, and how does this shape function signatures that take arrays?
- What does the `sizeof(arr) / sizeof(arr[0])` idiom compute, and why does it *not* work on pointer arguments?

### Experiment: array iteration, two ways

- Declare an array of five integers.
- Iterate through it once using an index variable and once using a pointer that advances with `p++`.
- Confirm that both styles print the same values.

## `switch`

- What types can a `switch` condition have?
- Why must every `case` label be a compile-time integer constant?
- What is *fall-through*, and how do you prevent it from happening by accident?
- When is fall-through intentional, and how should you signal that intent to future readers?

### Experiment: grade classifier

- Write a `switch` that maps a `char` grade (`'A'`, `'B'`, `'C'`, `'D'`, `'F'`) to a printed description.
- Use intentional fall-through so that `'A'`, `'B'`, and `'C'` share one message.
- Add a `default` label for unexpected input.

## `goto`

- Why was `goto` frowned upon in your C++ classes, and why is it accepted in C?
- What is the *cleanup pattern*, and why does it pair naturally with `goto`?
- What two things may a `goto` *not* do?

### Experiment: cleanup with goto

- Write a function that opens a file and `malloc`s two buffers in sequence.
- Use the `goto` cleanup pattern so that if any step fails, only the resources already acquired are released.
- Verify by forcing each step to fail in turn and checking that no resources leak.

## Experiment: input validation loop

- Write a program that repeatedly asks the user to enter a number between 1 and 10.
- Use a `do-while` loop to keep prompting until the input is in range.
- Print the accepted value when the loop exits.
