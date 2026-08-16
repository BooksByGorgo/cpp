# Assertions Needing Justification

This is an audit inventory of sentences in the sc++ chapters that assert an opinion or an external fact a skeptical reader could challenge --- best practices, popularity claims ("most common", "almost everyone"), historical anecdotes, and empirical claims about performance, platforms, or toolchains.
Objectively verifiable language rules, code comments, exercise questions, and Key Points restatements of claims already listed are excluded.
Line numbers refer to the chapter files as of the commit that adds this table and will drift as chapters are edited.

Types:

- **best practice** --- prescriptive guidance (prefer/always/never/should)
- **popularity** --- claims about how common something is or what programmers do
- **historical** --- claims about history, design intent, or standards committees
- **empirical** --- measurable claims about performance, platforms, compilers, or external facts
- **opinion** --- value judgments and superlatives

| Chapter | Line | Type | Statement |
|---|---|---|---|
| ch00 | 32 | opinion | As the intro to the most amazing programming language book ever written [@KernighanRitchie1988] starts out: |
| ch00 | 40 | opinion | It's the only way to master a language. |
| ch00 | 47 | empirical | If you look at the answer key first, the concepts will not sink in. |
| ch01 | 8 | opinion | Input and output are the first skills every programmer needs. |
| ch01 | 24 | historical | In the early days programmers really did write machine code by hand --- pages of raw numbers, no names for anything, and one wrong digit could break the whole program. |
| ch01 | 35 | popularity | The `c++` command you will meet shortly runs both tools for you, which is why programmers usually say "compiling" for the whole pipeline. |
| ch01 | 39 | historical | Every programming journey begins with the same tradition: printing "Hello, World!" to the screen. |
| ch01 | 106 | empirical | For most programs, `"\n"` is fine and slightly faster. |
| ch01 | 116 | popularity | Forgetting a semicolon is one of the most common mistakes beginners make, and the compiler error message can be confusing because it may point to the *next* line rather than the line with the missing semicolon. |
| ch01 | 161 | popularity | Most projects you work on will have a style guide --- often explicit, sometimes just implicit in the surrounding code. |
| ch01 | 163 | historical | Style wars have flared up over the years, the most famous being tabs-vs-spaces --- should you indent with a tab or with spaces? --- and two-vs-four spaces of indentation. |
| ch01 | 166 | opinion | The best way to do that in any codebase is to use a style consistently. |
| ch01 | 185 | popularity | The most common is the line comment, which starts with `//` and runs to the end of the line: |
| ch01 | 202 | popularity | You can also use `/* ... */` in the middle of a line to comment out a small piece of an expression, but in practice almost everyone reaches for `//` first. |
| ch01 | 218 | popularity | C++ source files typically end in `.cpp`. |
| ch01 | 239 | best practice | **Tip:** Always compile with warnings enabled and pin a language version. |
| ch01 | 244 | empirical | `-O2` enables optimization, which often surfaces additional warnings the unoptimized build hides. |
| ch01 | 284 | popularity | It is fine for small programs while you are learning, but be aware that many professional C++ programmers avoid it. |
| ch01 | 420 | popularity | The others are rare in modern code --- `\a` rings the terminal bell, `\b` and `\f` come from the days of teletype printers, and `\?` exists only to defeat an obscure C feature called **trigraphs** that you will probably never see. |
| ch01 | 519 | empirical | `argv[0]` is always the program name |
| ch01 | 541 | best practice | **Tip:** Always validate command-line arguments before using them. |
| ch02 | 37 | empirical | On most modern systems: |
| ch02 | 87 | empirical | These types are guaranteed to be exactly the named width on every platform that provides them (all mainstream ones do), so the same code reads the same bytes everywhere. |
| ch02 | 91 | best practice | For everyday counters and indices, plain `int` and `std::size_t` are still the right defaults --- they are usually the most efficient size for the CPU you are running on. |
| ch02 | 111 | best practice | Unless you have a specific reason to pick something else (memory constraints push you toward `float`; extreme precision pushes you toward `long double`), prefer `double`. |
| ch02 | 239 | best practice | Always initialize your variables. |
| ch02 | 267 | historical | The reason there are several forms is partly history --- the `=` form is the one C++ inherited from C --- and partly that brace initialization (added in C++11) closes a hole the older forms have: |
| ch02 | 280 | best practice | **Tip:** Prefer brace initialization (`int x{10};` or `int x = {10};`) when you want the compiler to flag suspicious conversions. |
| ch02 | 334 | best practice | **Tip:** Use `auto` when the type is obvious from the right-hand side or when it is painfully long to write out. |
| ch02 | 386 | empirical | On virtually all modern systems, a char is 8 bits, but the C++ standard does not require it. |
| ch02 | 399 | empirical | An `int` is 4 bytes on most modern systems, which caps it at about 2.1 billion --- but a 64-bit machine happily creates objects bigger than that, and `sizeof` has to be able to report their size. |
| ch02 | 555 | opinion | **Tip:** The Containers chapter will introduce `std::array` and `std::vector`, which are safer and more flexible alternatives to raw arrays. |
| ch02 | 556 | best practice | Prefer those in modern C++ whenever possible. |
| ch02 | 587 | popularity | This subsection is a preview of how `const` interacts with pointers because the rule is famously confusing the first time you see it. |
| ch02 | 606 | best practice | **Tip:** Read pointer declarations from right to left. |
| ch02 | 672 | opinion | The designated form is harder to mis-order and self-documents which value means what, especially as structs grow. |
| ch02 | 707 | popularity | **Wut:** Structure assignment copies everything, which is usually what you want. |
| ch03 | 9 | opinion | `std::string` solves all of these problems --- it manages its own memory, knows its own length, and provides a rich set of operations for searching, slicing, and combining text. |
| ch03 | 40 | best practice | **Tip:** Always include `<string>` when using `std::string`. |
| ch03 | 160 | popularity | `auto greeting = "Hola";` deduces `const char*` --- not what you want most of the time. |
| ch03 | 209 | best practice | For most code, prefer adjacent literals --- they let you indent the continuation without polluting the string. |
| ch03 | 247 | opinion | Raw literals are ideal for regular expressions, embedded SQL or JSON, Windows file paths, and any other text where you would otherwise be drowning in `\\` escapes. |
| ch03 | 251 | opinion | Reach for `\`-continuation only when those two will not do --- the indentation pitfall makes it the most error-prone of the three. |
| ch03 | 309 | opinion | The small performance cost is worth the safety. |
| ch03 | 347 | best practice | **Tip:** Use `std::size_t` (or `std::string::size_type`) for the loop variable when comparing against `.size()`. |
| ch03 | 471 | empirical | Unicode reserves room for over 1.1 million code points, of which roughly 160,000 are currently assigned. |
| ch03 | 478 | popularity | Several encodings exist for doing this; the most common one --- and what g++ and clang use for C++ string literals by default --- is **UTF-8**. |
| ch03 | 517 | empirical | There is no built-in way in standard C++ to count "characters" the way a human would --- doing it correctly requires a Unicode library. |
| ch03 | 518 | popularity | For most string work --- passing strings around, writing them to a file, sending them over a network --- bytes are exactly what you want, so this is rarely a problem in practice. |
| ch04 | 79 | best practice | Always check your divisor before dividing. |
| ch04 | 153 | empirical | Because `int` is meant to be the natural word size of the processor --- the size it computes with fastest. |
| ch04 | 192 | best practice | **Trap:** Avoid arithmetic and comparisons that mix signed and unsigned integers. |
| ch04 | 256 | best practice | **Tip:** When mixing logical operators, use parentheses. |
| ch04 | 259 | popularity | There are rules about order of operations, but your average developer will not be certain that they remember them correctly. |
| ch04 | 280 | best practice | This is an idiom C++ inherited from C, and you will see it in real code collapsing a value into a clean `true` or `false` --- but `volume != 0` says the same thing more clearly, so prefer that in your own code. |
| ch04 | 338 | best practice | **Tip:** When you do not need the old value, prefer prefix `++n` out of habit. |
| ch04 | 388 | popularity | These are not something you will use every day, but they are essential for systems programming, hardware interfaces, and flags. |
| ch04 | 447 | opinion | The ternary operator is best for simple choices. |
| ch04 | 501 | popularity | The classic gotcha is forgetting that comparison binds tighter than bitwise operators. |
| ch04 | 554 | popularity | Confusing them is one of the most common bugs. |
| ch04 | 558 | popularity | Mixing signed and unsigned at the same width is a frequent source of bugs. |
| ch05 | 156 | best practice | If you find yourself nesting more than two or three levels deep, consider using `else if` chains or guard clauses to flatten the logic. |
| ch05 | 331 | historical | There is a proposal to add it (and the C committee already adopted named loops for the next C standard), so hopefully some day. |
| ch05 | 339 | popularity | The `for` loop is the most common loop in C++. |
| ch05 | 385 | best practice | **Tip:** Declare loop variables inside the `for` statement when possible: `for (int i = 0; ...)`. |
| ch05 | 452 | empirical | Because the compiler knows every case value up front, it can verify that no two cases collide, and it can compile the whole statement into a single computed jump --- often a table indexed by the value --- instead of testing the cases one at a time. |
| ch05 | 476 | opinion | The most important thing to understand about `switch` is **fall-through** behavior. |
| ch05 | 502 | popularity | But accidental fall-through is a frequent bug: |
| ch05 | 518 | best practice | **Trap:** Every `case` should end with `break` unless you intentionally want fall-through. |
| ch05 | 526 | best practice | It is optional, but good practice to always include one --- it catches unexpected values and makes your intent clear. |
| ch05 | 529 | popularity | Put it last anyway: that is where programmers look for it, and a `default` buried in the middle of a `switch` is easy to miss when reading. |
| ch06 | 36 | popularity | Write them anyway, because a declaration is often all another programmer reads. |
| ch06 | 68 | best practice | **Tip:** You can usually avoid forward declarations by placing function definitions above where they are called (mutually recursive functions are the one case where you cannot). |
| ch06 | 115 | empirical | Modern compilers decide on their own whether to inline a call, regardless of the keyword. |
| ch06 | 208 | popularity | For functions you almost never write `extern` explicitly --- just use the plain forward declaration. |
| ch06 | 234 | popularity | The usual pattern is to put the `extern` declaration in a header that every file includes, with the real definition in exactly one `.cpp` file: |
| ch06 | 269 | historical | Everything compiles cleanly, but at link time you get a duplicate definition error (on older toolchains that defaulted to `-fcommon`, the program would even link, with every file silently operating on its own private copy of what was supposed to be a shared global). |
| ch06 | 388 | best practice | Use pass-by-reference for larger types like `std::string` and structures to avoid the cost of copying. |
| ch06 | 408 | best practice | **Tip:** A good rule of thumb: if a function does not need to modify a parameter, make it `const`. |
| ch06 | 520 | best practice | **Tip:** Pass-by-rvalue-reference is most useful when you are writing functions that *consume* or *store* their argument. |
| ch06 | 530 | popularity | This trips up nearly everyone the first time they encounter it. |
| ch06 | 663 | best practice | When the winner is not obvious to you, it will not be obvious to the next reader either --- convert the argument explicitly to the type you mean, like `display(static_cast<double>(n))`. |
| ch06 | 700 | popularity | **Trap:** Forgetting the base case is the most common recursion mistake. |
| ch06 | 793 | opinion | The function pointer syntax is admittedly ugly. |
| ch06 | 861 | popularity | **Tip:** Modern C++ callbacks are usually lambdas, with `std::function` (a *Gorgo Continuing C++* topic) to store capturing ones. |
| ch06 | 902 | historical | `std::ignore` says the same thing as an assignment; C++26 officially blessed it for exactly this job, and the major compilers already handle it today. |
| ch06 | 916 | opinion | To some they are an abomination, but to others, especially those writing core C++ APIs, they are fun ways to expand the semantics of language operators in new and unimagined ways. |
| ch06 | 920 | historical | But visually they look like they are pushing data in a direction --- and the iostream library used that intuition to overload them for stream I/O. |
| ch06 | 1018 | best practice | **Tip:** Make your operators behave the way people expect. |
| ch06 | 1024 | best practice | **Trap:** Do not overload `&&`, `\|\|`, or `,`. |
| ch07 | 59 | popularity | It is often said that computers think in 1s and 0s. |
| ch07 | 110 | popularity | You will see hex used frequently for colors, memory addresses, and bit masks. |
| ch07 | 124 | popularity | Octal is less common than hex in modern code, but you will encounter it when working with Unix file permissions (like `0755`). |
| ch07 | 258 | best practice | **Tip:** Prefer uppercase `L`. |
| ch07 | 470 | historical | The auto-detect rules are inherited from C's `strtol`, which historically did *not* recognize the `0b` prefix that C++14 added for binary literals. |
| ch07 | 471 | empirical | C23 (and matching updates in some C++ standard library implementations) added `0b` to the auto-detect set, so `std::stoi("0b101010", nullptr, 0)` may produce `42` on glibc and may produce `0` (parsed up to the leading zero) elsewhere. |
| ch07 | 541 | empirical | This is essentially what `std::stoi` does internally. |
| ch07 | 619 | historical | Engineers needed a better solution. |
| ch07 | 655 | empirical | **Tip:** Nearly every modern computer uses two's complement for signed integers. |
| ch07 | 659 | opinion | Why Two's Complement Is Brilliant |
| ch07 | 661 | opinion | The beauty of two's complement is that addition and subtraction **just work** with the same hardware used for unsigned numbers. |
| ch07 | 708 | empirical | More precisely, 1 GB (gigabyte) is 2^30^ bytes, which equals 1,073,741,824 --- just over a billion. |
| ch07 | 733 | empirical | On most modern systems, the sizes are: |
| ch07 | 810 | best practice | When possible, stick to signed types for general arithmetic and use unsigned only when you have a specific reason (like bit manipulation or interfacing with APIs that require it). |
| ch07 | 839 | empirical | Compilers actively exploit it for optimization. |
| ch07 | 1127 | best practice | Write `x * 4` rather than `x << 2` unless you are doing actual bit manipulation --- it is clearer, and the compiler will generate the same code. |
| ch08 | 7 | opinion | But C-style arrays have serious problems: they do not know their own size, they silently decay to pointers when passed to functions (losing size information), they cannot be returned from functions, and they cannot grow or shrink at runtime. |
| ch08 | 70 | best practice | **Tip:** Use `.at()` while developing and debugging. |
| ch08 | 118 | popularity | `std::vector` is the workhorse container of C++. |
| ch08 | 155 | popularity | The **initializer list** syntax with `{}` is the most common way to create a vector with specific values. |
| ch08 | 203 | best practice | Always check that the vector is not empty first using `.empty()` or `.size()`. |
| ch08 | 280 | empirical | When the vector runs out of room, it allocates a larger block of memory (a constant factor larger --- g++ doubles, MSVC grows by 1.5x) and copies everything over. |
| ch08 | 309 | empirical | This is intentional --- if you are going to refill it, there is no point in freeing the memory just to reallocate it. |
| ch08 | 407 | opinion | The simplest and most modern way to iterate is the **range-based for loop**: |
| ch08 | 453 | best practice | Avoid plain `auto` (without `&`) for anything larger than a primitive type --- it makes a copy of each element, which can be wasteful. |
| ch08 | 502 | historical | This is a deliberate design choice in C++ called a "half-open range." |
| ch08 | 522 | opinion | This is one of the best uses of `auto`. |
| ch08 | 569 | empirical | **Better performance**: the standard library implementations are usually faster than what most of us would write by hand, and they take advantage of optimizations the compiler can apply because the operation is named. |
| ch08 | 571 | popularity | Here are the most common ones you will see in everyday code. |
| ch08 | 655 | popularity | There is almost always a named operation that does what you want, and using it makes your intent obvious to the next reader. |
| ch09 | 37 | opinion | Once you learn one, you know them all. |
| ch09 | 113 | best practice | **Tip:** Prefer `std::format` (Chapter 10) for new code. |
| ch09 | 250 | opinion | **Tip:** String streams are great for converting between strings and numbers. |
| ch09 | 313 | best practice | **Tip:** Always check if a file opened successfully before using it. |
| ch09 | 329 | popularity | The most common pattern is reading line by line with `std::getline`: |
| ch09 | 392 | best practice | You should call `.close()` when you are done with a file. |
| ch09 | 404 | best practice | **Tip:** While files close automatically when the stream goes out of scope, calling `.close()` explicitly makes your intent clear and ensures data is flushed immediately. |
| ch09 | 488 | popularity | The most common recoverable failure is a type mismatch during extraction: asking `>>` for an `int` when the next token is not a number. |
| ch09 | 533 | best practice | **Trap:** Do not loop on `while (!file.eof())`. |
| ch09 | 538 | popularity | Streams can be configured to throw exceptions on failure instead of setting flags --- every stream has an `exceptions()` member that selects which flags should throw --- but checking states is the idiomatic default for I/O. |
| ch10 | 15 | opinion | Mixing text and values with lots of `<<` operators gets hard to read quickly. |
| ch10 | 223 | best practice | If your compiler supports C++20 or later, prefer `std::format` for any non-trivial formatting. |
| ch10 | 265 | opinion | These are the modern replacements for `std::cout <<`. |
| ch10 | 270 | empirical | Not all compilers support them yet. |
| ch11 | 8 | opinion | You would have to thread error codes back through every function in the chain, and every caller would have to check the return value --- tedious and easy to get wrong. |
| ch11 | 168 | best practice | Always catch specific types first and use `catch (...)` only as a safety net. |
| ch11 | 171 | best practice | **Tip:** Always catch exceptions by `const` reference (`const std::exception &e`). |
| ch11 | 230 | best practice | This automatic cleanup during stack unwinding is why destructors are so important --- and why you should manage resources through objects rather than raw `new`/`delete`. |
| ch11 | 234 | best practice | Never throw from a destructor. |
| ch11 | 251 | empirical | `noexcept` is not just documentation --- the compiler uses it to generate more efficient code. |
| ch11 | 257 | best practice | **Tip:** Mark functions `noexcept` when you are certain they will not throw. |
| ch11 | 271 | opinion | They are best for truly exceptional situations --- file not found, out of memory, network failure. |
| ch11 | 272 | empirical | For errors that are a normal part of a function's contract (like parsing invalid user input), the overhead of exception handling can be unnecessary. |
| ch11 | 343 | best practice | A good rule of thumb: if the caller is *likely* to handle the error immediately, use `std::expected`. |
| ch11 | 344 | best practice | If the error should propagate up several layers, use exceptions. |
| ch11 | 449 | popularity | The standard exception types in `<stdexcept>` cover most common error categories. |
| ch12 | 76 | popularity | You could use either one, but by convention `class` is used when you want to bundle data with behavior. |
| ch12 | 107 | best practice | **Tip:** Not every private member needs a getter and setter. |
| ch12 | 183 | best practice | This is a **member initializer list**, and it is the preferred way to initialize members in C++. |
| ch12 | 187 | empirical | For complex types like `std::string`, the initializer list is more efficient because it avoids default-constructing the member only to immediately overwrite it. |
| ch12 | 260 | best practice | **Tip:** Delegate from the simplest constructors *to* the most complete one. |
| ch12 | 304 | best practice | As a rule of thumb, mark single-argument constructors `explicit` unless you specifically want implicit conversion. |
| ch12 | 307 | popularity | Surprise conversions almost always come from single-argument constructors (a multi-parameter constructor can still be invoked implicitly from a braced list like `{"Torn", 1997}`, but that is much harder to do by accident), so `explicit` matters most on single-argument constructors. |
| ch12 | 411 | best practice | You should mark every member function that does not change the object as `const`. |
| ch12 | 561 | opinion | Overloading keeps your interface clean: one verb for one concept, regardless of how many ways you can call it. |
| ch12 | 585 | historical | Before C++11, raw **pointers** were used constantly in C++. |
| ch12 | 587 | popularity | Modern C++ has largely moved away from raw pointers in favor of references and smart pointers (Chapter 13), which is why we have made it this far without discussing them. |
| ch12 | 827 | popularity | **Tip:** Most compilers support `#pragma once` as a simpler alternative to include guards. |
| ch12 | 922 | best practice | This is the preferred style for class-wide constants. |
| ch12 | 950 | historical | The C++ committee has been apologizing for this ever since. |
| ch12 | 958 | best practice | Prefer `static constexpr` when the value is known at compile time. |
| ch12 | 974 | opinion | Static members get tempting as a way to bolt loose functions or global variables onto an existing class, and that temptation usually leads to bad design. |
| ch12 | 978 | opinion | A "utility class" that is never instantiated is almost always a namespace wearing a costume. |
| ch12 | 988 | opinion | It is a reasonable design and not really a bug, but it also reads like the kind of function that ends up as a static member more by association than by necessity. |
| ch12 | 989 | best practice | When choosing between "static member function on `X`" and "free function in a namespace near `X`," lean toward the free function unless the operation is genuinely tied to the class. |
| ch12 | 1160 | popularity | The most common use of `explicit` conversion operators is `explicit operator bool()`. |
| ch12 | 1185 | best practice | **Tip:** Prefer `explicit` on conversion operators. |
| ch13 | 115 | best practice | Do not use it. |
| ch13 | 138 | best practice | **Tip:** Prefer stack allocation whenever possible. |
| ch13 | 252 | historical | Historically C++ used `NULL` to indicate a pointer to nothing. |
| ch13 | 254 | popularity | C still uses `NULL`, and many older C++ code bases do too, but `nullptr` is preferred in modern C++ because it can be distinguished from an `int`. |
| ch13 | 265 | empirical | Dereferencing a null pointer is undefined behavior --- your program will almost certainly crash. |
| ch13 | 275 | popularity | **Tip:** Modern C++ reduces the need for raw pointers significantly. |
| ch13 | 337 | popularity | Manual memory management with `new` and `delete` is notoriously error-prone. |
| ch13 | 338 | popularity | Two of the most common bugs are **memory leaks** and **dangling pointers**. |
| ch13 | 368 | best practice | **Trap:** After `delete`, set the pointer to `nullptr` if you plan to keep the pointer variable around. |
| ch13 | 372 | popularity | These problems are why modern C++ strongly discourages using raw `new` and `delete`. |
| ch13 | 424 | best practice | Always prefer `make_unique` over `new`. |
| ch13 | 442 | best practice | **Tip:** `std::unique_ptr` should be your default choice for heap allocation. |
| ch13 | 443 | empirical | It has essentially zero overhead compared to a raw pointer --- the compiler generates nearly identical code, but with automatic cleanup. |
| ch13 | 500 | best practice | `std::make_shared` is the preferred way to create a `shared_ptr`, just as `make_unique` is for `unique_ptr`. |
| ch13 | 503 | best practice | **Tip:** Use `shared_ptr` only when you truly need shared ownership. |
| ch13 | 582 | opinion | That check-then-use pattern is the only safe way to access whatever a `weak_ptr` points at. |
| ch13 | 611 | best practice | **Trap:** Never `delete` a pointer obtained from `.get()`. |
| ch13 | 679 | empirical | A `std::string` typically contains a pointer to a heap-allocated character buffer, a length, and a capacity --- all stored on the stack: |
| ch13 | 828 | best practice | **Tip:** Prefer `std::move` when passing a `shared_ptr` that the caller no longer needs. |
| ch13 | 835 | empirical | In practice, the compiler applies **copy elision** (also called **return value optimization**, or RVO) to avoid copies entirely. |
| ch13 | 848 | best practice | **Tip:** Do not write `return std::move(local);` from a function. |
| ch14 | 28 | best practice | If your class manages a resource (like raw heap memory), and you write any one of these five, you almost certainly need to write *all* five. |
| ch14 | 30 | historical | (Before C++11 added move semantics there were only three special members to worry about --- destructor, copy constructor, copy assignment --- and the same advice was called the **Rule of Three**.) |
| ch14 | 116 | popularity | The standard fix is the **copy-and-swap idiom**: build a temporary copy first, then swap it with `*this`. |
| ch14 | 180 | historical | Before C++11, the workaround for the second problem was to declare the unwanted function `private` and never define it. |
| ch14 | 264 | opinion | This is much better than making a function private and leaving it undefined, which was the pre-C++11 workaround and produced cryptic linker errors instead. |
| ch14 | 274 | popularity | This is closely related to **RAII** (Resource Acquisition Is Initialization), a fundamental C++ pattern where you acquire resources in the constructor and release them in the destructor. |
| ch14 | 301 | best practice | **Tip:** Follow the Rule of Zero whenever you can. |
| ch14 | 468 | best practice | **Tip:** Use `friend` sparingly. |
| ch14 | 471 | best practice | Prefer member functions or public interfaces when possible, and reserve `friend` for cases like `operator<<` where there is no alternative. |
| ch15 | 73 | best practice | **Tip:** Prefer `return` from `main()` when possible. |
| ch15 | 151 | popularity | **Tip:** In practice, you rarely need to write `extern "C"` declarations yourself. |
| ch15 | 261 | popularity | `static_cast` is the most common cast. |
| ch15 | 341 | opinion | This is rarely needed and usually a sign that something in the design should be reconsidered. |
| ch15 | 359 | popularity | The main legitimate use is interfacing with old C APIs that take non-const pointers but promise not to modify the data. |
| ch15 | 377 | opinion | This is the most dangerous cast and should be used rarely. |
| ch15 | 423 | best practice | The C++ named casts are preferred because: |
| ch15 | 433 | best practice | Never use C-style casts in new C++ code. |
| ch15 | 447 | popularity | The most common use of `<chrono>` is measuring how long a piece of code takes to run. |
| ch15 | 448 | best practice | For this, `std::chrono::steady_clock` is the right clock because it never jumps forward or backward. |
| ch15 | 578 | popularity | The trig functions take **radians**, not degrees --- this is a constant source of beginner bugs. |
| ch15 | 631 | best practice | **Tip:** Reach for `std::numbers::pi` instead of `3.14159...` typed by hand --- the constant is precise to the full width of the type, and a future reader does not have to count the digits to confirm you didn't typo one. |
| ch15 | 645 | opinion | It is worth pausing and treating UB as a topic in its own right, because it is the single biggest difference between C++ and most other languages. |
| ch15 | 665 | historical | The short answer is performance: when the compiler can assume that programs do not exhibit UB, it gets to skip a lot of runtime checks --- bounds, signedness, alignment --- that would otherwise slow every program down. |
| ch15 | 687 | popularity | The two debuggers you will run into most often are **gdb** (GNU Debugger; commonly installed alongside GCC) and **lldb** (the LLVM debugger; Clang's counterpart). |
| ch15 | 717 | empirical | **Reproduce, then break.** Set a breakpoint *just before* the line you suspect, run the program, then use `next`/`step` and `print` to walk the failure live. This is faster than scattering print statements and recompiling. |
| ch15 | 721 | empirical | **Tip:** Most IDEs (VS Code, CLion, Qt Creator) drive gdb or lldb under a graphical interface; Visual Studio ships its own debugger with the same mental model. |
| ch15 | 723 | opinion | Learn the command-line basics first; the GUI is just a thin layer on top. |
| ch15 | 766 | empirical | `rand()` produces low-quality random numbers on many systems. |
| ch15 | 771 | best practice | **Trap:** Avoid `rand()` and `srand()` in new C++ code. |
| ch15 | 830 | empirical | **`std::random_device rd`** provides a seed from your operating system's entropy source --- truly unpredictable. |
| ch15 | 831 | empirical | **`std::mt19937 gen(rd())`** creates a Mersenne Twister engine seeded with that random value. This engine produces high-quality pseudo-random numbers. |
| ch15 | 836 | best practice | **Tip:** Create the engine once and reuse it. |
| ch15 | 843 | empirical | In practice, on Linux, macOS, and Windows, it reads from the OS entropy pool and is fine for seeding. |
| ch15 | 882 | popularity | The `<random>` header provides many other distributions (Bernoulli, Poisson, etc.), but uniform and normal cover most practical needs. |
