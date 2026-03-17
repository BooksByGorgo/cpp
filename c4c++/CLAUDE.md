# Project Description

Write chapters to help beginning C++ programmers become beginning C programmers.

## Textbook

- These chapter augments the book text found in ../s26/text/

## Chapters

- DO NOT MODIFY THE AUTHOR INTRO section
- each numbered element in `Content` represents a chapter
- each chapter starts with a brief overview
- each chapter ends with a brief highlight of key points
- each chapter has some exercises to test reader's comprehesion. there should be a mix of the following types of questions:
    - though provoking questions to make them think a little deeper about what they have read
    - what does this do type questions, where they get a snippet of code and predict what it will do
    - calculation questions to quickly and objectively test comprehension, like `what is the sizeof ilist for int ilist[4] on a system where int is 32-bit?`
    - where is the bug type questions, where you show some code and ask what the problem is
    - propose a short test program they should write to test their knowledge
- an answer key should be generated as a separate document from the main chapter content, containing each exercise question and its answer

## Examples

- For strings, use 80s references, lyrics from 80s songs, and Spanish occasionally. Keep it short.
- avoid repeating lyrics in examples even across chapters
- Validate examples to make sure syntax and result is correct
- Compile examples with `cc -Wall -Wextra -pedantic` to verify correctness
- Create short example programs to illustrate the concepts covered
- Use `%zu` for `size_t` (e.g., `strlen` return) and `%td` for `ptrdiff_t` (e.g., pointer subtraction)

## Format and Style

- Use Pandoc markdown
- Use correct grammar and capitalizations
- Use tip callouts (`::: {.tip}` divs) to highlight idioms, best practices, or warn of bad practices
- Callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` — do not use `wrapfigure`
- Keep the tone professional but light
- Refer to the reader as `you`
- do not wrap sentences in the markdown. every sentence gets its own line

## Build

- Build with: `make` (or `make all` for both PDFs)
- Uses `pandoc` with `--lua-filter=callout.lua` and `--pdf-engine=latexmk`
- `latexmk` handles the multi-pass build needed for the index
- Requires `header-includes` for `\usepackage[most]{tcolorbox}` and `\usepackage{makeidx}` (already in frontmatter)

## Table of Contents and Index

- TOC is generated automatically via `toc: true` and `toc-depth: 2` in the YAML frontmatter
- index uses LaTeX `makeidx` package with `\index{}` markers throughout the text
- place `\index{term}` at the primary introduction/definition of a term, not inside code blocks
- use `\index{parent!child}` for sub-entries (e.g., `\index{pointer!arithmetic}`)
- in `\index{}`, escape double quotes by doubling them (e.g., `\index{extern ""C""}`)
- `\printindex` at the end of the file generates the index page

## 80s References

- PLAYLIST.md tracks all songs and references used in the text, organized by chapter
- do not repeat references already listed in PLAYLIST.md
- when adding or changing a reference in the text, update PLAYLIST.md to match
- exception: "Come As You Are" by Nirvana (1991) is allowed in Ch 11 despite being early 90s

# next 80s references

the next 80s songs to use

(all used — add more here)

## Cross-References Between Chapters

- when a concept is introduced in one chapter and used in a later chapter, reference the earlier chapter rather than re-explaining it
- Ch 2 (Variables) introduces arrays, const with pointers, and structs; Ch 6 (Pointers) should reference Ch 2 for these basics and focus on pointer-specific details (pointer arithmetic, ->, etc.)
- Ch 6 (Pointers) introduces pass by value with pointer workaround; Ch 7 (Functions) should reference Ch 6 rather than repeating the explanation
- Ch 7 (Functions) introduces function pointers; Ch 12 (Odds and Ends) should reference Ch 7 and focus on qsort as a practical example
- Ch 5 (Control Flow) briefly introduces goto cleanup with a reference forward to Ch 12; Ch 12 covers it in depth

## Content

DO NOT MODIFY THE AUTHOR INTRO section before chapter 0. it is written in lowercase to match the author's informal writing

0. How to use this book:
    - conventions explained
    - chapter layout
1. Introduction:
    - in the beginning know C++ automatically meant you know C, but modern C++ has dramatically different idioms and standard libraries than C, so the modern C++ programmer has some things to learn in order to program in C.
    - `The C Programming Language (Second Edition)` my go to textbook.
    - introduce this intro section quoted verbatim from the book and then quote the section for the first section `the-c-programming-language-intro.txt`
    - cover printf: format specifiers (%d, %x/%X, %f, %e, %c, %s, %p, %zu), width/precision, zero-fill, \n for newlines, %% for literal percent
2. Variables
    - basic types in C: char, int, float, ...
    - variables give a name to memory allocated to store the declared type
    - we can make new types with typedef
    - we can use * to declare a variable that holds addresses for data of the given type
    - we can use [] to declare arrays of types
        - tricks to using multi dimensional arrays
        - the Pointers chapter will talk about the relationship between arrays and pointers
        - the "value" of an array is the address of the first element
    - const is used to mark a variable as unchanging.
        - const is a bit tricky to use with *, depending where the const is it prevents the pointer from changing or it prevents what the pointer is pointing to from being changed through the pointer
    - structures allow data to be grouped together
        - unlike C++, only member variables allowed -- no member functions; although, you can use function pointers (described later)
        - members accessed with . operator
        - assignment does a copy
3. Strings
    - there is no std::string in C++. everything revolves around arrays of characters that end with a null '\0'
    - using strings, you always have to careful have the right amount of memory allocated. (remember to include space for the null!)
    - string manipulation routines: strlen(), strchr(), strrchr(), strstr(), strcat(), strdup(), strtok() (include any additional ones that students should know)
    - recommend strtok_r (POSIX) or strtok_s (C11/Windows) over strtok for thread safety
    - review the problems that can arise using strcat()
    - point out that there are convenient ways to manipulate strings with sprintf() and sscanf that will be shown later in I/O
4. Expressions
    - assignment operators
    - math operators
    - logical operators
    - bit operators
    - compound assignment operators
    - ternary operator
    - operator precedence
5. Control flow
    - if statements
    - while loop/do while
        - break/continue
    - for loops
    - switch statements
    - goto (brief intro with reference forward to Ch 12 for full cleanup pattern)
6. Pointers
    - modern C++ programmers rarely see pointers and thus can get away with not fully understanding them, but C programmers must be very comfortable with pointers
    - a type that ends in * represents a pointer. the type information before the * represents the type of the memory that the pointer points to
    - all pointers are an address to a location in memory
    - you can get the address of a variable using & (including addresses of a pointer variable)
    - create a figure of a small program with a couple of variables and pointers to those variables and one pointer to one of the pointers and then show a memory diagram and label addresses of those variable
    - explain that a pointer can point to a single value stored in memory or the first element of an array of elements
    - pointer arithmetic and explain that a[i] is much more convenient to write than *(a+i) — reference Ch 2 for array decay basics
    - show the -> operator for accessing struct members through pointers — reference Ch 2 for struct basics
    - pass by value with pointer workaround
7. Functions
    - declarations vs definitions, forward declarations, void parameter lists
    - all function parameters are `pass by value` (no `pass by reference`) — reference Ch 6 rather than re-explaining
    - const parameters. why they are important
    - structures can be problematic to pass by value, why const struct type *var is useful
    - recursive functions
    - function pointers (basics, typedef, callbacks)
8. Allocating memory
    - global variables get started at the beginning of a program and stay around until the program finishes
    - local variables are declared inside of functions and go away when the function goes away
    - static local variables have the scope of a local but the lifetime of a global
    - if we want to allocate memory, use it for a while and release it, we can use malloc() and free()
    - memcpy and memset for working with raw memory (memmove for overlapping regions)
9. Numbers and casting
    - to the CPU everything is a number. the numbers can be different sizes and can be used for different things
        - different number bits gives a different range of values
        - a char is just a number; assigning 'A' is the same as assigning 65
        - a pointer is just a number as well, its just a number that represents a memory address; when we use a type and * we let the compiler know how to interpret the number
    - the types we give to numbers indicates how we plan to use the number
    - a pointer type tells the compiler that you want to use the number as an address
    - C doesn't know about strings, it only knows about arrays of characters, and libraries allow us to work with them as strings
    - converting numbers to string and strings to numbers
    - casts
        - (type) value
        - simpler than C++ casts, but no magic happens
        - you are asserting to the compiler that you know what you are doing
        - TRAP: casting a char * to an int doesn't convert a string to an integer value, it converts the address to an integer value. use strtol() to convert a string to an integer value
10. Standard I/O
    - printf for output and scanf for input
    - show examples of reading input explain why & is needed
    - explain stdin, stdout, stderr
    - show fprintf and fscanf
    - open/create files with fopen/fclose. explain binary modes. show how to use with fprintf and fscanf
    - fwrite and fread
    - sprintf, sscanf, and snprintf for string formatting
    - explain buffering and fflush
    - add tip explaining \n and flush behavior when output going to terminal vs file
11. Low-Level I/O
    - explain file descriptors starting with 0, 1, and 2
    - show read() and write() with file descriptors
    - explain open() and creat() and how to do creat with open()
    - explain lseek()
    - explain pread() and pwrite()
12. Odds and Ends
    - explain exit() and when it might be more useful than return
    - explain using extern "C" to use c functions from c++
    - explain why they should always wonder about ownership when the receive a pointer from the function they just called (should they free it?)
    - explain error handling without exceptions: return codes, errno/perror, and goto cleanup pattern for releasing multiple resources
    - qsort as a practical example of function pointers — reference Ch 7 for function pointer basics
