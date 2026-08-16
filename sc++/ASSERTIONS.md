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

The Citation column records the outcome of the citation pass.
Rows marked `added ...` link the source now cited in the chapter text as a `[@key]` marker with a matching entry in `references.bib`.
All other rows give the reason the statement stands uncited.

| Chapter | Line | Type | Statement | Citation |
|---|---|---|---|---|
| ch00 | 32 | opinion | As the intro to the most amazing programming language book ever written [@KernighanRitchie1988] starts out: | deliberate authorial hyperbole; the adjacent [@KernighanRitchie1988] covers the quote, not the superlative |
| ch00 | 40 | opinion | It's the only way to master a language. | author's pedagogy |
| ch00 | 47 | empirical | If you look at the answer key first, the concepts will not sink in. | author's pedagogy |
| ch01 | 8 | opinion | Input and output are the first skills every programmer needs. | author's opinion |
| ch01 | 24 | historical | In the early days programmers really did write machine code by hand --- pages of raw numbers, no names for anything, and one wrong digit could break the whole program. | well-known history; no single source |
| ch01 | 35 | popularity | The `c++` command you will meet shortly runs both tools for you, which is why programmers usually say "compiling" for the whole pipeline. | folklore; no canonical source |
| ch01 | 39 | historical | Every programming journey begins with the same tradition: printing "Hello, World!" to the screen. | folklore; K&R popularized it --- could cite [@KernighanRitchie1988] if desired |
| ch01 | 106 | empirical | For most programs, `"\n"` is fine and slightly faster. | verifiable: `std::endl` flushes the stream, `"\n"` does not |
| ch01 | 116 | popularity | Forgetting a semicolon is one of the most common mistakes beginners make, and the compiler error message can be confusing because it may point to the *next* line rather than the line with the missing semicolon. | folklore; no canonical source |
| ch01 | 161 | popularity | Most projects you work on will have a style guide --- often explicit, sometimes just implicit in the surrounding code. | folklore; no canonical source |
| ch01 | 163 | historical | Style wars have flared up over the years, the most famous being tabs-vs-spaces --- should you indent with a tab or with spaces? --- and two-vs-four spaces of indentation. | well-known history; no single source |
| ch01 | 166 | opinion | The best way to do that in any codebase is to use a style consistently. | author's opinion |
| ch01 | 185 | popularity | The most common is the line comment, which starts with `//` and runs to the end of the line: | folklore; no canonical source |
| ch01 | 202 | popularity | You can also use `/* ... */` in the middle of a line to comment out a small piece of an expression, but in practice almost everyone reaches for `//` first. | folklore; no canonical source |
| ch01 | 218 | popularity | C++ source files typically end in `.cpp`. | folklore; no canonical source |
| ch01 | 239 | best practice | **Tip:** Always compile with warnings enabled and pin a language version. | author's guidance; rationale in the text |
| ch01 | 244 | empirical | `-O2` enables optimization, which often surfaces additional warnings the unoptimized build hides. | verifiable against the toolchain/standard |
| ch01 | 284 | popularity | It is fine for small programs while you are learning, but be aware that many professional C++ programmers avoid it. | folklore; no canonical source |
| ch01 | 420 | popularity | The others are rare in modern code --- `\a` rings the terminal bell, `\b` and `\f` come from the days of teletype printers, and `\?` exists only to defeat an obscure C feature called **trigraphs** that you will probably never see. | folklore; no canonical source |
| ch01 | 519 | empirical | `argv[0]` is always the program name | inaccurate as stated --- `argv[0]` is implementation-defined and may be empty; candidate for a text fix, not a citation |
| ch01 | 541 | best practice | **Tip:** Always validate command-line arguments before using them. | author's guidance; rationale in the text |
| ch02 | 37 | empirical | On most modern systems: | platform generality; verifiable against mainstream ABIs |
| ch02 | 87 | empirical | These types are guaranteed to be exactly the named width on every platform that provides them (all mainstream ones do), so the same code reads the same bytes everywhere. | platform generality; verifiable against mainstream ABIs |
| ch02 | 91 | best practice | For everyday counters and indices, plain `int` and `std::size_t` are still the right defaults --- they are usually the most efficient size for the CPU you are running on. | author's guidance; rationale in the text |
| ch02 | 111 | best practice | Unless you have a specific reason to pick something else (memory constraints push you toward `float`; extreme precision pushes you toward `long double`), prefer `double`. | author's guidance; rationale in the text |
| ch02 | 239 | best practice | Always initialize your variables. | added [Core Guidelines ES.20](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#res-always) |
| ch02 | 267 | historical | The reason there are several forms is partly history --- the `=` form is the one C++ inherited from C --- and partly that brace initialization (added in C++11) closes a hole the older forms have: | well-known history; no single source |
| ch02 | 280 | best practice | **Tip:** Prefer brace initialization (`int x{10};` or `int x = {10};`) when you want the compiler to flag suspicious conversions. | added [Core Guidelines ES.23](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#res-list) |
| ch02 | 334 | best practice | **Tip:** Use `auto` when the type is obvious from the right-hand side or when it is painfully long to write out. | author's guidance; rationale in the text |
| ch02 | 386 | empirical | On virtually all modern systems, a char is 8 bits, but the C++ standard does not require it. | platform generality; verifiable against mainstream ABIs |
| ch02 | 399 | empirical | An `int` is 4 bytes on most modern systems, which caps it at about 2.1 billion --- but a 64-bit machine happily creates objects bigger than that, and `sizeof` has to be able to report their size. | platform generality; verifiable against mainstream ABIs |
| ch02 | 555 | opinion | **Tip:** The Containers chapter will introduce `std::array` and `std::vector`, which are safer and more flexible alternatives to raw arrays. | author's opinion |
| ch02 | 556 | best practice | Prefer those in modern C++ whenever possible. | author's guidance; rationale in the text |
| ch02 | 587 | popularity | This subsection is a preview of how `const` interacts with pointers because the rule is famously confusing the first time you see it. | folklore; no canonical source |
| ch02 | 606 | best practice | **Tip:** Read pointer declarations from right to left. | author's guidance; rationale in the text |
| ch02 | 672 | opinion | The designated form is harder to mis-order and self-documents which value means what, especially as structs grow. | author's opinion |
| ch02 | 707 | popularity | **Wut:** Structure assignment copies everything, which is usually what you want. | folklore; no canonical source |
| ch03 | 9 | opinion | `std::string` solves all of these problems --- it manages its own memory, knows its own length, and provides a rich set of operations for searching, slicing, and combining text. | author's opinion |
| ch03 | 40 | best practice | **Tip:** Always include `<string>` when using `std::string`. | author's guidance; rationale in the text |
| ch03 | 160 | popularity | `auto greeting = "Hola";` deduces `const char*` --- not what you want most of the time. | folklore; no canonical source |
| ch03 | 209 | best practice | For most code, prefer adjacent literals --- they let you indent the continuation without polluting the string. | author's guidance; rationale in the text |
| ch03 | 247 | opinion | Raw literals are ideal for regular expressions, embedded SQL or JSON, Windows file paths, and any other text where you would otherwise be drowning in `\\` escapes. | author's opinion |
| ch03 | 251 | opinion | Reach for `\`-continuation only when those two will not do --- the indentation pitfall makes it the most error-prone of the three. | author's opinion |
| ch03 | 309 | opinion | The small performance cost is worth the safety. | author's opinion |
| ch03 | 347 | best practice | **Tip:** Use `std::size_t` (or `std::string::size_type`) for the loop variable when comparing against `.size()`. | author's guidance; rationale in the text |
| ch03 | 471 | empirical | Unicode reserves room for over 1.1 million code points, of which roughly 160,000 are currently assigned. | added [Unicode 17.0](https://www.unicode.org/versions/Unicode17.0.0/) |
| ch03 | 478 | popularity | Several encodings exist for doing this; the most common one --- and what g++ and clang use for C++ string literals by default --- is **UTF-8**. | compiler default verifiable; web-usage stats (W3Techs) citable if desired |
| ch03 | 517 | empirical | There is no built-in way in standard C++ to count "characters" the way a human would --- doing it correctly requires a Unicode library. | verifiable against the toolchain/standard |
| ch03 | 518 | popularity | For most string work --- passing strings around, writing them to a file, sending them over a network --- bytes are exactly what you want, so this is rarely a problem in practice. | folklore; no canonical source |
| ch04 | 79 | best practice | Always check your divisor before dividing. | author's guidance; rationale in the text |
| ch04 | 153 | empirical | Because `int` is meant to be the natural word size of the processor --- the size it computes with fastest. | verifiable against the toolchain/standard |
| ch04 | 192 | best practice | **Trap:** Avoid arithmetic and comparisons that mix signed and unsigned integers. | added [Core Guidelines ES.100](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#res-mix) |
| ch04 | 256 | best practice | **Tip:** When mixing logical operators, use parentheses. | author's guidance; rationale in the text |
| ch04 | 259 | popularity | There are rules about order of operations, but your average developer will not be certain that they remember them correctly. | folklore; no canonical source |
| ch04 | 280 | best practice | This is an idiom C++ inherited from C, and you will see it in real code collapsing a value into a clean `true` or `false` --- but `volume != 0` says the same thing more clearly, so prefer that in your own code. | author's guidance; rationale in the text |
| ch04 | 338 | best practice | **Tip:** When you do not need the old value, prefer prefix `++n` out of habit. | author's guidance; rationale in the text |
| ch04 | 388 | popularity | These are not something you will use every day, but they are essential for systems programming, hardware interfaces, and flags. | folklore; no canonical source |
| ch04 | 447 | opinion | The ternary operator is best for simple choices. | author's opinion |
| ch04 | 501 | popularity | The classic gotcha is forgetting that comparison binds tighter than bitwise operators. | folklore; no canonical source |
| ch04 | 554 | popularity | Confusing them is one of the most common bugs. | folklore; no canonical source |
| ch04 | 558 | popularity | Mixing signed and unsigned at the same width is a frequent source of bugs. | folklore; no canonical source |
| ch05 | 156 | best practice | If you find yourself nesting more than two or three levels deep, consider using `else if` chains or guard clauses to flatten the logic. | author's guidance; rationale in the text |
| ch05 | 331 | historical | There is a proposal to add it (and the C committee already adopted named loops for the next C standard), so hopefully some day. | added [WG14 N3355](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3355.htm) |
| ch05 | 339 | popularity | The `for` loop is the most common loop in C++. | folklore; no canonical source |
| ch05 | 385 | best practice | **Tip:** Declare loop variables inside the `for` statement when possible: `for (int i = 0; ...)`. | author's guidance; rationale in the text |
| ch05 | 452 | empirical | Because the compiler knows every case value up front, it can verify that no two cases collide, and it can compile the whole statement into a single computed jump --- often a table indexed by the value --- instead of testing the cases one at a time. | verifiable against the toolchain/standard |
| ch05 | 476 | opinion | The most important thing to understand about `switch` is **fall-through** behavior. | author's opinion |
| ch05 | 502 | popularity | But accidental fall-through is a frequent bug: | folklore; no canonical source |
| ch05 | 518 | best practice | **Trap:** Every `case` should end with `break` unless you intentionally want fall-through. | added [Core Guidelines ES.78](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#res-break) |
| ch05 | 526 | best practice | It is optional, but good practice to always include one --- it catches unexpected values and makes your intent clear. | author's guidance; rationale in the text |
| ch05 | 529 | popularity | Put it last anyway: that is where programmers look for it, and a `default` buried in the middle of a `switch` is easy to miss when reading. | folklore; no canonical source |
| ch06 | 36 | popularity | Write them anyway, because a declaration is often all another programmer reads. | folklore; no canonical source |
| ch06 | 68 | best practice | **Tip:** You can usually avoid forward declarations by placing function definitions above where they are called (mutually recursive functions are the one case where you cannot). | author's guidance; rationale in the text |
| ch06 | 115 | empirical | Modern compilers decide on their own whether to inline a call, regardless of the keyword. | verifiable against the toolchain/standard |
| ch06 | 208 | popularity | For functions you almost never write `extern` explicitly --- just use the plain forward declaration. | folklore; no canonical source |
| ch06 | 234 | popularity | The usual pattern is to put the `extern` declaration in a header that every file includes, with the real definition in exactly one `.cpp` file: | folklore; no canonical source |
| ch06 | 269 | historical | Everything compiles cleanly, but at link time you get a duplicate definition error (on older toolchains that defaulted to `-fcommon`, the program would even link, with every file silently operating on its own private copy of what was supposed to be a shared global). | well-known history; no single source |
| ch06 | 388 | best practice | Use pass-by-reference for larger types like `std::string` and structures to avoid the cost of copying. | added [Core Guidelines F.16](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rf-in) |
| ch06 | 408 | best practice | **Tip:** A good rule of thumb: if a function does not need to modify a parameter, make it `const`. | related to F.16, cited at ch06:388 |
| ch06 | 520 | best practice | **Tip:** Pass-by-rvalue-reference is most useful when you are writing functions that *consume* or *store* their argument. | author's guidance; rationale in the text |
| ch06 | 530 | popularity | This trips up nearly everyone the first time they encounter it. | folklore; no canonical source |
| ch06 | 663 | best practice | When the winner is not obvious to you, it will not be obvious to the next reader either --- convert the argument explicitly to the type you mean, like `display(static_cast<double>(n))`. | author's guidance; rationale in the text |
| ch06 | 700 | popularity | **Trap:** Forgetting the base case is the most common recursion mistake. | folklore; no canonical source |
| ch06 | 803 | opinion | The function pointer syntax is admittedly ugly. | author's opinion |
| ch06 | 871 | popularity | **Tip:** Modern C++ callbacks are usually lambdas, with `std::function` (a *Gorgo Continuing C++* topic) to store capturing ones. | folklore; no canonical source |
| ch06 | 912 | historical | `std::ignore` says the same thing as an assignment; C++26 officially blessed it for exactly this job, and the major compilers already handle it today. | added [WG21 P2968R2](https://wg21.link/p2968r2) |
| ch06 | 926 | opinion | To some they are an abomination, but to others, especially those writing core C++ APIs, they are fun ways to expand the semantics of language operators in new and unimagined ways. | author's opinion |
| ch06 | 930 | historical | But visually they look like they are pushing data in a direction --- and the iostream library used that intuition to overload them for stream I/O. | added [Stroustrup, The Design and Evolution of C++](https://www.stroustrup.com/dne.html) |
| ch06 | 1028 | best practice | **Tip:** Make your operators behave the way people expect. | author's guidance; rationale in the text |
| ch06 | 1034 | best practice | **Trap:** Do not overload `&&`, `\|\|`, or `,`. | added [Meyers, More Effective C++, Item 7](https://www.aristeia.com/books.html) |
| ch07 | 59 | popularity | It is often said that computers think in 1s and 0s. | folklore; no canonical source |
| ch07 | 110 | popularity | You will see hex used frequently for colors, memory addresses, and bit masks. | folklore; no canonical source |
| ch07 | 124 | popularity | Octal is less common than hex in modern code, but you will encounter it when working with Unix file permissions (like `0755`). | folklore; no canonical source |
| ch07 | 258 | best practice | **Tip:** Prefer uppercase `L`. | author's guidance; rationale in the text |
| ch07 | 470 | historical | The auto-detect rules are inherited from C's `strtol`, which historically did *not* recognize the `0b` prefix that C++14 added for binary literals. | verifiable standard history; the C23 half is cited at ch07:471 |
| ch07 | 471 | empirical | C23 (and matching updates in some C++ standard library implementations) added `0b` to the auto-detect set, so `std::stoi("0b101010", nullptr, 0)` may produce `42` on glibc and may produce `0` (parsed up to the leading zero) elsewhere. | added [ISO/IEC 9899:2024 (C23)](https://www.iso.org/standard/82075.html) |
| ch07 | 541 | empirical | This is essentially what `std::stoi` does internally. | verifiable against the toolchain/standard |
| ch07 | 619 | historical | Engineers needed a better solution. | well-known history; no single source |
| ch07 | 655 | empirical | **Tip:** Nearly every modern computer uses two's complement for signed integers. | verifiable: C++20 mandates two's complement for signed integers |
| ch07 | 659 | opinion | Why Two's Complement Is Brilliant | author's opinion |
| ch07 | 661 | opinion | The beauty of two's complement is that addition and subtraction **just work** with the same hardware used for unsigned numbers. | author's opinion |
| ch07 | 708 | empirical | More precisely, 1 GB (gigabyte) is 2^30^ bytes, which equals 1,073,741,824 --- just over a billion. | book convention: GB means 2^30^ bytes |
| ch07 | 733 | empirical | On most modern systems, the sizes are: | platform generality; verifiable against mainstream ABIs |
| ch07 | 810 | best practice | When possible, stick to signed types for general arithmetic and use unsigned only when you have a specific reason (like bit manipulation or interfacing with APIs that require it). | added [Core Guidelines ES.102](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#res-signed) |
| ch07 | 839 | empirical | Compilers actively exploit it for optimization. | added [Lattner, What Every C Programmer Should Know About UB](https://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html) |
| ch07 | 1127 | best practice | Write `x * 4` rather than `x << 2` unless you are doing actual bit manipulation --- it is clearer, and the compiler will generate the same code. | author's guidance; rationale in the text |
| ch08 | 7 | opinion | But C-style arrays have serious problems: they do not know their own size, they silently decay to pointers when passed to functions (losing size information), they cannot be returned from functions, and they cannot grow or shrink at runtime. | author's opinion |
| ch08 | 70 | best practice | **Tip:** Use `.at()` while developing and debugging. | author's guidance; rationale in the text |
| ch08 | 118 | popularity | `std::vector` is the workhorse container of C++. | folklore; no canonical source |
| ch08 | 155 | popularity | The **initializer list** syntax with `{}` is the most common way to create a vector with specific values. | folklore; no canonical source |
| ch08 | 203 | best practice | Always check that the vector is not empty first using `.empty()` or `.size()`. | author's guidance; rationale in the text |
| ch08 | 280 | empirical | When the vector runs out of room, it allocates a larger block of memory (a constant factor larger --- g++ doubles, MSVC grows by 1.5x) and copies everything over. | attributed to implementations in the text; verifiable in libstdc++/MSVC sources |
| ch08 | 309 | empirical | This is intentional --- if you are going to refill it, there is no point in freeing the memory just to reallocate it. | design rationale; no primary source |
| ch08 | 407 | opinion | The simplest and most modern way to iterate is the **range-based for loop**: | author's opinion |
| ch08 | 453 | best practice | Avoid plain `auto` (without `&`) for anything larger than a primitive type --- it makes a copy of each element, which can be wasteful. | author's guidance; rationale in the text |
| ch08 | 502 | historical | This is a deliberate design choice in C++ called a "half-open range." | added [Dijkstra, EWD831](https://www.cs.utexas.edu/users/EWD/transcriptions/EWD08xx/EWD831.html) |
| ch08 | 522 | opinion | This is one of the best uses of `auto`. | author's opinion |
| ch08 | 569 | empirical | **Better performance**: the standard library implementations are usually faster than what most of us would write by hand, and they take advantage of optimizations the compiler can apply because the operation is named. | widely accepted; hard to source rigorously |
| ch08 | 571 | popularity | Here are the most common ones you will see in everyday code. | folklore; no canonical source |
| ch08 | 655 | popularity | There is almost always a named operation that does what you want, and using it makes your intent obvious to the next reader. | folklore; no canonical source |
| ch09 | 37 | opinion | Once you learn one, you know them all. | author's opinion |
| ch09 | 113 | best practice | **Tip:** Prefer `std::format` (Chapter 10) for new code. | author's guidance; rationale in the text |
| ch09 | 250 | opinion | **Tip:** String streams are great for converting between strings and numbers. | author's opinion |
| ch09 | 313 | best practice | **Tip:** Always check if a file opened successfully before using it. | author's guidance; rationale in the text |
| ch09 | 329 | popularity | The most common pattern is reading line by line with `std::getline`: | folklore; no canonical source |
| ch09 | 392 | best practice | You should call `.close()` when you are done with a file. | author's guidance; rationale in the text |
| ch09 | 404 | best practice | **Tip:** While files close automatically when the stream goes out of scope, calling `.close()` explicitly makes your intent clear and ensures data is flushed immediately. | author's guidance; rationale in the text |
| ch09 | 488 | popularity | The most common recoverable failure is a type mismatch during extraction: asking `>>` for an `int` when the next token is not a number. | folklore; no canonical source |
| ch09 | 533 | best practice | **Trap:** Do not loop on `while (!file.eof())`. | author's guidance; rationale in the text |
| ch09 | 538 | popularity | Streams can be configured to throw exceptions on failure instead of setting flags --- every stream has an `exceptions()` member that selects which flags should throw --- but checking states is the idiomatic default for I/O. | folklore; no canonical source |
| ch10 | 15 | opinion | Mixing text and values with lots of `<<` operators gets hard to read quickly. | author's opinion |
| ch10 | 223 | best practice | If your compiler supports C++20 or later, prefer `std::format` for any non-trivial formatting. | author's guidance; rationale in the text |
| ch10 | 265 | opinion | These are the modern replacements for `std::cout <<`. | author's opinion |
| ch10 | 270 | empirical | Not all compilers support them yet. | verifiable against [cppreference compiler support](https://en.cppreference.com/w/cpp/compiler_support) |
| ch11 | 8 | popularity | A struct like that --- data members only, no functions --- is a **plain struct**, usually called a **Plain Old Data (POD)** struct. | added [cppreference: PODType](https://en.cppreference.com/w/cpp/named_req/PODType) |
| ch11 | 79 | popularity | You could use either one, but by convention `class` is used when you want to bundle data with behavior. | folklore; no canonical source |
| ch11 | 110 | best practice | **Tip:** Not every private member needs a getter and setter. | author's guidance; rationale in the text |
| ch11 | 186 | best practice | This is a **member initializer list**, and it is the preferred way to initialize members in C++. | added [Core Guidelines C.49](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rc-initialize) |
| ch11 | 190 | empirical | For complex types like `std::string`, the initializer list is more efficient because it avoids default-constructing the member only to immediately overwrite it. | verifiable against the toolchain/standard |
| ch11 | 263 | best practice | **Tip:** Delegate from the simplest constructors *to* the most complete one. | author's guidance; rationale in the text |
| ch11 | 307 | best practice | As a rule of thumb, mark single-argument constructors `explicit` unless you specifically want implicit conversion. | added [Core Guidelines C.46](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rc-explicit) |
| ch11 | 310 | popularity | Surprise conversions almost always come from single-argument constructors (a multi-parameter constructor can still be invoked implicitly from a braced list like `{"Torn", 1997}`, but that is much harder to do by accident), so `explicit` matters most on single-argument constructors. | folklore; no canonical source |
| ch11 | 414 | best practice | You should mark every member function that does not change the object as `const`. | added [Core Guidelines Con.2](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rconst-fct) |
| ch11 | 564 | opinion | Overloading keeps your interface clean: one verb for one concept, regardless of how many ways you can call it. | author's opinion |
| ch11 | 588 | historical | Before C++11, raw **pointers** were used constantly in C++. | well-known history; no single source |
| ch11 | 590 | popularity | Modern C++ has largely moved away from raw pointers in favor of references and smart pointers (Chapter 13), which is why we have made it this far without discussing them. | folklore; no canonical source |
| ch11 | 830 | popularity | **Tip:** Most compilers support `#pragma once` as a simpler alternative to include guards. | folklore; no canonical source |
| ch11 | 925 | best practice | This is the preferred style for class-wide constants. | author's guidance; rationale in the text |
| ch11 | 960 | best practice | Prefer `static constexpr` when the value is known at compile time. | author's guidance; rationale in the text |
| ch11 | 976 | opinion | Static members get tempting as a way to bolt loose functions or global variables onto an existing class, and that temptation usually leads to bad design. | author's opinion |
| ch11 | 980 | opinion | A "utility class" that is never instantiated is almost always a namespace wearing a costume. | author's opinion |
| ch11 | 990 | opinion | It is a reasonable design and not really a bug, but it also reads like the kind of function that ends up as a static member more by association than by necessity. | author's opinion |
| ch11 | 991 | best practice | When choosing between "static member function on `X`" and "free function in a namespace near `X`," lean toward the free function unless the operation is genuinely tied to the class. | author's guidance; rationale in the text |
| ch11 | 1162 | popularity | The most common use of `explicit` conversion operators is `explicit operator bool()`. | folklore; no canonical source |
| ch11 | 1187 | best practice | **Tip:** Prefer `explicit` on conversion operators. | added [Core Guidelines C.164](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#ro-conversion) |
| ch12 | 8 | opinion | You would have to thread error codes back through every function in the chain, and every caller would have to check the return value --- tedious and easy to get wrong. | author's opinion |
| ch12 | 177 | best practice | Always catch specific types first and use `catch (...)` only as a safety net. | author's guidance; rationale in the text |
| ch12 | 180 | best practice | **Tip:** Always catch exceptions by `const` reference (`const std::exception &e`). | added [Core Guidelines E.15](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#re-exception-ref) |
| ch12 | 239 | best practice | This automatic cleanup during stack unwinding is why destructors are so important --- and why you should manage resources through objects rather than raw `new`/`delete`. | author's guidance; rationale in the text |
| ch12 | 243 | best practice | Never throw from a destructor. | added [Core Guidelines E.16](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#re-never-fail) |
| ch12 | 260 | empirical | `noexcept` is not just documentation --- the compiler uses it to generate more efficient code. | verifiable against the toolchain/standard |
| ch12 | 266 | best practice | **Tip:** Mark functions `noexcept` when you are certain they will not throw. | added [Core Guidelines F.6](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rf-noexcept) |
| ch12 | 280 | opinion | They are best for truly exceptional situations --- file not found, out of memory, network failure. | author's opinion |
| ch12 | 281 | empirical | For errors that are a normal part of a function's contract (like parsing invalid user input), the overhead of exception handling can be unnecessary. | verifiable against the toolchain/standard |
| ch12 | 358 | best practice | A good rule of thumb: if the caller is *likely* to handle the error immediately, use `std::expected`. | author's guidance; rationale in the text |
| ch12 | 359 | best practice | If the error should propagate up several layers, use exceptions. | author's guidance; rationale in the text |
| ch12 | 464 | popularity | The standard exception types in `<stdexcept>` cover most common error categories. | folklore; no canonical source |
| ch13 | 116 | best practice | Do not use it. | author's guidance; rationale in the text |
| ch13 | 139 | best practice | **Tip:** Prefer stack allocation whenever possible. | added [Core Guidelines R.5](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rr-scoped) |
| ch13 | 253 | historical | Historically C++ used `NULL` to indicate a pointer to nothing. | well-known history; no single source |
| ch13 | 255 | popularity | C still uses `NULL`, and many older C++ code bases do too, but `nullptr` is preferred in modern C++ because it can be distinguished from an `int`. | folklore; no canonical source |
| ch13 | 266 | empirical | Dereferencing a null pointer is undefined behavior --- your program will almost certainly crash. | hedged in text; UB per the standard |
| ch13 | 276 | popularity | **Tip:** Modern C++ reduces the need for raw pointers significantly. | folklore; no canonical source |
| ch13 | 338 | popularity | Manual memory management with `new` and `delete` is notoriously error-prone. | folklore; no canonical source |
| ch13 | 339 | popularity | Two of the most common bugs are **memory leaks** and **dangling pointers**. | folklore; no canonical source |
| ch13 | 369 | best practice | **Trap:** After `delete`, set the pointer to `nullptr` if you plan to keep the pointer variable around. | author's guidance; rationale in the text |
| ch13 | 373 | popularity | These problems are why modern C++ strongly discourages using raw `new` and `delete`. | added [Core Guidelines R.11](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rr-newdelete) |
| ch13 | 425 | best practice | Always prefer `make_unique` over `new`. | added [Core Guidelines R.23](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rr-make_unique) |
| ch13 | 443 | best practice | **Tip:** `std::unique_ptr` should be your default choice for heap allocation. | added [Core Guidelines R.21](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rr-unique) |
| ch13 | 444 | empirical | It has essentially zero overhead compared to a raw pointer --- the compiler generates nearly identical code, but with automatic cleanup. | verifiable by inspecting codegen |
| ch13 | 501 | best practice | `std::make_shared` is the preferred way to create a `shared_ptr`, just as `make_unique` is for `unique_ptr`. | added [Core Guidelines R.22](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rr-make_shared) |
| ch13 | 504 | best practice | **Tip:** Use `shared_ptr` only when you truly need shared ownership. | backed by R.21, cited at ch13:442 |
| ch13 | 583 | opinion | That check-then-use pattern is the only safe way to access whatever a `weak_ptr` points at. | author's opinion |
| ch13 | 612 | best practice | **Trap:** Never `delete` a pointer obtained from `.get()`. | author's guidance; rationale in the text |
| ch13 | 680 | empirical | A `std::string` typically contains a pointer to a heap-allocated character buffer, a length, and a capacity --- all stored on the stack: | implementation detail; hedged with "typically" (SSO varies) |
| ch13 | 829 | best practice | **Tip:** Prefer `std::move` when passing a `shared_ptr` that the caller no longer needs. | author's guidance; rationale in the text |
| ch13 | 836 | empirical | In practice, the compiler applies **copy elision** (also called **return value optimization**, or RVO) to avoid copies entirely. | verifiable: C++17 guarantees elision for prvalues |
| ch13 | 849 | best practice | **Tip:** Do not write `return std::move(local);` from a function. | added [Core Guidelines F.48](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rf-return-move-local) |
| ch14 | 28 | best practice | If your class manages a resource (like raw heap memory), and you write any one of these five, you almost certainly need to write *all* five. | added [Core Guidelines C.21](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rc-five) |
| ch14 | 30 | historical | (Before C++11 added move semantics there were only three special members to worry about --- destructor, copy constructor, copy assignment --- and the same advice was called the **Rule of Three**.) | added Cline & Lomow, C++ FAQs (1995); see also [cppreference: rule of three/five/zero](https://en.cppreference.com/w/cpp/language/rule_of_three) |
| ch14 | 116 | popularity | The standard fix is the **copy-and-swap idiom**: build a temporary copy first, then swap it with `*this`. | folklore; no canonical source |
| ch14 | 180 | historical | Before C++11, the workaround for the second problem was to declare the unwanted function `private` and never define it. | well-known history; no single source |
| ch14 | 264 | opinion | This is much better than making a function private and leaving it undefined, which was the pre-C++11 workaround and produced cryptic linker errors instead. | author's opinion |
| ch14 | 274 | popularity | This is closely related to **RAII** (Resource Acquisition Is Initialization), a fundamental C++ pattern where you acquire resources in the constructor and release them in the destructor. | folklore; no canonical source |
| ch14 | 301 | best practice | **Tip:** Follow the Rule of Zero whenever you can. | added [Core Guidelines C.20](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#rc-zero); the coining source [Fernandes, Rule of Zero](https://isocpp.org/blog/2012/11/rule-of-zero) is cited at the definition (ch14:271) |
| ch14 | 468 | best practice | **Tip:** Use `friend` sparingly. | author's guidance; rationale in the text |
| ch14 | 471 | best practice | Prefer member functions or public interfaces when possible, and reserve `friend` for cases like `operator<<` where there is no alternative. | author's guidance; rationale in the text |
| ch15 | 73 | best practice | **Tip:** Prefer `return` from `main()` when possible. | author's guidance; rationale in the text |
| ch15 | 151 | popularity | **Tip:** In practice, you rarely need to write `extern "C"` declarations yourself. | folklore; no canonical source |
| ch15 | 261 | popularity | `static_cast` is the most common cast. | folklore; no canonical source |
| ch15 | 341 | opinion | This is rarely needed and usually a sign that something in the design should be reconsidered. | author's opinion |
| ch15 | 359 | popularity | The main legitimate use is interfacing with old C APIs that take non-const pointers but promise not to modify the data. | folklore; no canonical source |
| ch15 | 377 | opinion | This is the most dangerous cast and should be used rarely. | author's opinion |
| ch15 | 423 | best practice | The C++ named casts are preferred because: | backed by ES.49, cited at ch15:433 |
| ch15 | 433 | best practice | Never use C-style casts in new C++ code. | added [Core Guidelines ES.49](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#res-casts-named) |
| ch15 | 447 | popularity | The most common use of `<chrono>` is measuring how long a piece of code takes to run. | folklore; no canonical source |
| ch15 | 448 | best practice | For this, `std::chrono::steady_clock` is the right clock because it never jumps forward or backward. | author's guidance; rationale in the text |
| ch15 | 578 | popularity | The trig functions take **radians**, not degrees --- this is a constant source of beginner bugs. | folklore; no canonical source |
| ch15 | 631 | best practice | **Tip:** Reach for `std::numbers::pi` instead of `3.14159...` typed by hand --- the constant is precise to the full width of the type, and a future reader does not have to count the digits to confirm you didn't typo one. | author's guidance; rationale in the text |
| ch15 | 645 | opinion | It is worth pausing and treating UB as a topic in its own right, because it is the single biggest difference between C++ and most other languages. | author's opinion |
| ch15 | 665 | historical | The short answer is performance: when the compiler can assume that programs do not exhibit UB, it gets to skip a lot of runtime checks --- bounds, signedness, alignment --- that would otherwise slow every program down. | added [Lattner, What Every C Programmer Should Know About UB](https://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html) |
| ch15 | 687 | popularity | The two debuggers you will run into most often are **gdb** (GNU Debugger; commonly installed alongside GCC) and **lldb** (the LLVM debugger; Clang's counterpart). | folklore; no canonical source |
| ch15 | 717 | empirical | **Reproduce, then break.** Set a breakpoint *just before* the line you suspect, run the program, then use `next`/`step` and `print` to walk the failure live. This is faster than scattering print statements and recompiling. | author's experience |
| ch15 | 721 | empirical | **Tip:** Most IDEs (VS Code, CLion, Qt Creator) drive gdb or lldb under a graphical interface; Visual Studio ships its own debugger with the same mental model. | verifiable against IDE documentation |
| ch15 | 723 | opinion | Learn the command-line basics first; the GUI is just a thin layer on top. | author's opinion |
| ch15 | 766 | empirical | `rand()` produces low-quality random numbers on many systems. | added [Lavavej, rand() Considered Harmful](https://learn.microsoft.com/en-us/events/goingnative-2013/rand-considered-harmful) |
| ch15 | 771 | best practice | **Trap:** Avoid `rand()` and `srand()` in new C++ code. | backed by the rand() citation at ch15:766 |
| ch15 | 830 | empirical | **`std::random_device rd`** provides a seed from your operating system's entropy source --- truly unpredictable. | hedged by the text at ch15:841-843 |
| ch15 | 831 | empirical | **`std::mt19937 gen(rd())`** creates a Mersenne Twister engine seeded with that random value. This engine produces high-quality pseudo-random numbers. | verifiable against the toolchain/standard |
| ch15 | 836 | best practice | **Tip:** Create the engine once and reuse it. | author's guidance; rationale in the text |
| ch15 | 843 | empirical | In practice, on Linux, macOS, and Windows, it reads from the OS entropy pool and is fine for seeding. | verifiable against implementation documentation |
| ch15 | 882 | popularity | The `<random>` header provides many other distributions (Bernoulli, Poisson, etc.), but uniform and normal cover most practical needs. | folklore; no canonical source |
