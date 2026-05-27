# Project Description

Gorgo Java for C++ for programmers.
This book covers all the topics that a good Java programmer uses in daily life in industry from the perspective of a C++ programmer.

## Chapters

- DO NOT MODIFY THE AUTHOR INTRO section
- each numbered element in `Content` represents a chapter
- each chapter starts with an introducton to the topics covered. motivation for the topics highlighting things that are hard to do without knowledge of the topics, and a brief overview of the section
- each chapter ends with a brief highlight of key points
- each chapter has some exercises to test reader's comprehesion. there should be a mix of the following types of questions:
    - though provoking questions to make them think a little deeper about what they have read
    - what does this do type questions, where they get a snippet of code and predict what it will do
    - calculation questions to quickly and objectively test comprehension, like `what is the sizeof ilist for int ilist[4] on a system where int is 32-bit?`
    - where is the bug type questions, where you show some code and ask what the problem is
    - propose a short test program they should write to test their knowledge
- an answer key should be generated as a separate document from the main chapter content, containing each exercise question and its answer

## Examples

- for strings, use 1990s references, lyrics from 1990s songs, and Spanish occasionally. Keep it short.
- cover up to Java 25
- avoid repeating lyrics in examples even across chapters
- Validate examples to make sure syntax and result is correct
- Create short example programs to illustrate the concepts covered

## Format and Style

- Use Pandoc markdown
- Use correct grammar and capitalizations
- All callouts use `::: {.tip}` as the div class --- `callout.lua` only handles `.tip`
- Differentiate callout types with a bold label on the first line inside the div:
    - `**Tip:**` for idioms and best practices
    - `**Trap:**` for common mistakes
    - `**Wut:**` for unexpected or counterintuitive rules
- Callouts are rendered as full-width `tcolorbox` boxes via `callout.lua` --- do not use `wrapfigure`
- Keep the tone professional but light
- Preserve emojis and text emojis (e.g., `:'(`) in the text --- do not remove them
- Refer to the reader as `you`
- do not wrap sentences in the markdown. every sentence gets its own line
- the first time a fuction or operator is mentioned show it's signature
    -if it is overloaded and the overloaded variants aren't mentioned later, mention at the end of the subsection concisely. show signatures but not examples

## Build

- Build with: `make` (or `make all` for both PDFs)
- Uses `pandoc` with `--lua-filter=callout.lua` and `--pdf-engine=latexmk --pdf-engine-opt=-lualatex`
- `latexmk` handles the multi-pass build needed for the index
- Requires `header-includes` for `\usepackage[most]{tcolorbox}` and `\usepackage{makeidx}` (already in frontmatter)

## Table of Contents and Index

- TOC is generated automatically via `toc: true` and `toc-depth: 2` in the YAML frontmatter
- index uses LaTeX `makeidx` package with `\index{}` markers throughout the text
- place `\index{term}` at the primary introduction/definition of a term, not inside code blocks
- use `\index{parent!child}` for sub-entries (e.g., `\index{pointer!arithmetic}`)
- in `\index{}`, escape double quotes by doubling them (e.g., `\index{extern ""C""}`)
- `\printindex` goes only in appB.md (the last file built into the book) --- do not add it to other chapters or appendices

## 1990s References

- PLAYLIST.md tracks all songs and references used in the text, organized by chapter
- do not repeat references already listed in PLAYLIST.md
- when adding or changing a reference in the text, update PLAYLIST.md to match
- avoid references to guns (including ammunition) and violence

## Cross-References Between Chapters

- when a concept is introduced in one chapter and used in a later chapter, reference the earlier chapter rather than re-explaining it

## Content

DO NOT MODIFY THE AUTHOR INTRO section before chapter 0. it is written in lowercase to match the author's informal writing

0. How to use this book:
    - conventions explained
    - chapter layout

### Part 1 --- Getting Oriented

1. The Java Platform:
    - JVM, bytecode, JDK/JRE/JIT distinction
    - `javac`/`java`, classpath, JAR files
    - Maven/Gradle at a glance (vs make/cmake)
    - Java versioning and LTS releases

2. Your First Java Program:
    - package and import (vs `namespace` and `#include`)
    - `public static void main(String[] args)`
    - basic syntax delta from C++ (no header files, no `::`, semicolon rules)
    - `System.out.println` and basic I/O

### Part 2 --- The Type System

3. Primitives, References, and Variables:
    - primitive types and their sizes (guaranteed, unlike C++)
    - reference types --- the Java version of a pointer (but not a pointer)
    - `var` (Java 10+), autoboxing/unboxing, wrapper classes
    - operators --- what's missing (`>>>` shift, no pointer arithmetic, no operator overloading)

4. Control Flow:
    - `if/else`, `while`, `for`, for-each
    - `switch` statements and `switch` expressions (Java 14+)
    - no `goto`, no computed jumps

5. Methods:
    - signatures, overloading, varargs
    - pass-by-value always (including references)
    - no default arguments, no `const` parameters

### Part 3 --- OOP

6. Classes and Objects:
    - class structure, constructors, `this`
    - access modifiers: `public`, `private`, `protected`, package-private
    - no destructor --- GC model, why RAII doesn't exist
    - `equals()`, `hashCode()`, `toString()` --- the Object contract

7. Inheritance:
    - `extends` (single), `implements` (multiple interfaces)
    - all non-`final`/non-`private`/non-`static` methods are virtual
    - `@Override`, `super`, `final` classes and methods
    - `instanceof` and casting

8. Interfaces and Abstract Classes:
    - interface semantics (vs pure virtual base classes)
    - default and static interface methods (Java 8+)
    - private interface methods (Java 9+)
    - functional interfaces and `@FunctionalInterface`

### Part 4 --- Key APIs

9. Strings:
    - `String` immutability and the string pool
    - `StringBuilder` / `StringBuffer`
    - text blocks (Java 13+)
    - `String.format()`, `formatted()`, `printf`

10. Arrays and the Collections Framework:
    - arrays (fixed size, `length` field, `Arrays` utility)
    - `List`, `Set`, `Map`, `Queue`, `Deque` --- interfaces and common implementations
    - `ArrayList` vs `LinkedList` vs `ArrayDeque`
    - `Collections` utility class

11. Generics:
    - syntax vs C++ templates
    - type erasure --- what it costs you
    - wildcards: `? extends T`, `? super T`
    - bounded type parameters, generic methods

12. Exceptions:
    - checked vs unchecked --- unique to Java
    - `try/catch/finally`, multi-catch
    - try-with-resources (Java 7+)
    - exception hierarchy, when to use each tier

### Part 5 --- Functional Java

13. Lambdas and Method References:
    - lambda syntax, captured variables (effectively final)
    - method references: `Class::method`, `instance::method`, `Class::new`
    - common functional interfaces: `Predicate`, `Function`, `Consumer`, `Supplier`, `BiFunction`

14. The Stream API:
    - pipeline model: source -> intermediate ops -> terminal op
    - key operations: `filter`, `map`, `flatMap`, `reduce`, `collect`
    - `Collectors`: `toList`, `groupingBy`, `joining`
    - parallel streams, when to use them

15. Optional:
    - null-safety idiom, `Optional<T>` API
    - `map`, `flatMap`, `orElse`, `orElseThrow`, `ifPresent`
    - when Optional is the right tool (and when it isn't)

### Part 6 --- Modern Java (14--25)

16. Records and Value Classes:
    - `record` as an immutable data carrier (Java 16+)
    - auto-generated `equals`, `hashCode`, `toString`, accessors
    - compact constructors
    - value classes (Java 25 preview)

17. Sealed Classes and Pattern Matching:
    - `sealed`/`permits` hierarchies (Java 17+)
    - pattern matching for `instanceof` (Java 16+)
    - pattern matching in `switch` (Java 21+)
    - unnamed patterns and variables (Java 21+)

### Part 7 --- Concurrency

18. Concurrency Fundamentals:
    - `Thread`, `Runnable`, `synchronized`, `volatile`
    - the Java memory model (happens-before)
    - deadlock, race conditions, visibility

19. java.util.concurrent:
    - `ExecutorService`, thread pools
    - `Future`, `CompletableFuture`
    - atomic variables, `Lock`, `ReadWriteLock`
    - virtual threads (Java 21+) --- why they matter vs C++ `std::thread`

### Part 8 --- I/O and the Module System

20. I/O:
    - classic streams (`InputStream`/`OutputStream`, `Reader`/`Writer`)
    - NIO: `Path`, `Files`, `FileChannel`, `ByteBuffer`
    - try-with-resources for I/O

21. The Module System:
    - JPMS: `module-info.java`, `requires`, `exports`, `opens`
    - unnamed module vs named module
    - common pain points migrating pre-module code

22. Reflection and Annotations:
    - the `Class<T>` object, `getClass()`, class literals (`Foo.class`)
    - inspecting fields, methods, constructors at runtime (`Field`, `Method`, `Constructor`)
    - invoking methods and accessing fields reflectively
    - built-in annotations: `@Override`, `@Deprecated`, `@SuppressWarnings`, `@FunctionalInterface`
    - defining custom annotations (`@interface`, retention, target)
    - reading annotations at runtime via reflection
    - annotation processors (compile-time), a brief overview

### Appendices

- appA.md: C++ / Java Side-by-Side Cheat Sheet
- appB.md: Index (`\printindex` goes here)
