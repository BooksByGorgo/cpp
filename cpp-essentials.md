# comprehensive list of concepts and APIs every good C++ programmer should know

> compiled from academic and industry sources including: stroustrup's *a tour of C++* (3rd ed), the C++ Core Guidelines (stroustrup & sutter), the google C++ style guide, chromium style guide, ACM/IEEE/AAAI CS2023 curriculum guidelines, cppreference, the stackoverflow definitive C++ book guide, and industry interview question compilations.

each entry is tagged with a level:

- **[F]** foundational -- every beginner must learn this
- **[I]** intermediate -- working programmer territory
- **[A]** advanced -- senior developer / library author
- **[E]** expert -- language lawyer / framework designer

and a suggested textbook mapping:

- **sc++** = starting C++ (introductory)
- **cc++** = continuing C++ (intermediate)
- **mc++** = mastering C++ (advanced/capstone)

---

## 1. language fundamentals

| concept                    | what it is / why it matters                                                                                                                 | level   | book      |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------- | --------- |
| types and type system      | built-in types (int, double, char, bool), type sizes, signed/unsigned, fixed-width types (`<cstdint>`)                                      | [F]     | sc++      |
| variables and declarations | declaration vs definition, scope, lifetime, storage duration (automatic, static, dynamic, thread-local)                                     | [F]     | sc++      |
| arithmetic and expressions | operator precedence, integer division, modulus, implicit conversions, integer promotion rules                                               | [F]     | sc++      |
| constants                  | `const`, `constexpr` (C++11), `consteval` (C++20), `constinit` (C++20), compile-time vs runtime constants                                   | [F]/[A] | sc++/mc++ |
| type conversions           | implicit narrowing, `static_cast`, `dynamic_cast`, `const_cast`, `reinterpret_cast`, C-style casts (avoid)                                  | [F]     | sc++      |
| `auto` and type deduction  | `auto` variables (C++11), `decltype`, `decltype(auto)`, when to use and when not to                                                         | [F][I]  | sc++/cc++ |
| structured bindings        | `auto [x, y] = pair;` (C++17), works with arrays, structs, tuples                                                                           | [I]     | cc++      |
| initialization forms       | direct, copy, list/brace (uniform), designated initializers (C++20), most vexing parse                                                      | [F]/[I] | sc++/cc++ |
| pointers                   | address-of (`&`), dereference (`*`), pointer arithmetic, null pointers (`nullptr`), void pointers                                           | [F]     | sc++      |
| references                 | lvalue references (`&`), rvalue references (`&&`, C++11), dangling references, reference collapsing                                         | [F]/[A] | sc++/mc++ |
| arrays                     | C-style arrays, decay to pointer, multidimensional arrays, `std::array` (prefer over raw)                                                   | [F]     | sc++      |
| control flow               | if/else, switch, loops (for, while, do-while, range-for), break/continue, `if` with initializer (C++17)                                     | [F]     | sc++      |
| undefined behavior         | what it is, common sources (signed overflow, null deref, use-after-free, uninitialized reads, ODR violations), why the compiler exploits it | [F]     | sc++      |
| attributes                 | `[[nodiscard]]`, `[[maybe_unused]]`, `[[deprecated]]`, `[[fallthrough]]`, `[[likely]]`/`[[unlikely]]` (C++20)                               | [I]     | cc++      |
| bit manipulation           | bitwise operators, bit fields, `<bit>` header (C++20): `bit_cast`, `popcount`, `countl_zero`, `has_single_bit`                              | [I]/[A] | cc++/mc++ |

## 2. functions and modularity

| concept                               | what it is / why it matters                                                                                                     | level   | book      |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------- | --------- |
| function declarations and definitions | prototypes, header/source separation, ODR                                                                                       | [F]     | sc++      |
| parameter passing                     | by value, by reference, by const reference, by pointer -- when to use each (Core Guidelines F.16)                               | [F]     | sc++      |
| return values                         | return by value (rely on copy elision / NRVO), return by reference (careful with lifetime), structured returns via tuple/struct | [F]/[I] | sc++/cc++ |
| function overloading                  | same name, different parameter lists, overload resolution rules                                                                 | [F]     | sc++      |
| default arguments                     | syntax, interaction with overloading, when to prefer overloads instead                                                          | [F]     | sc++      |
| `inline` functions                    | hint to compiler, ODR implications, `inline` variables (C++17)                                                                  | [F]     | sc++      |
| `noexcept`                            | specifier and operator, impact on move operations and performance, conditional noexcept                                         | [F]     | sc++      |
| trailing return types                 | `auto foo() -> int`, required for some template/lambda cases                                                                    | [I]     | cc++      |
| lambda expressions                    | capture by value `[=]`, by reference `[&]`, init captures (C++14), generic lambdas (C++14/C++20), mutable, immediately invoked  | [I]     | cc++      |
| `std::function`                       | type-erased callable wrapper, overhead vs templates, when to use                                                                | [I]     | cc++      |
| separate compilation                  | translation units, linkage (internal/external), include guards, `#pragma once`                                                  | [F]     | sc++      |
| namespaces                            | named, unnamed/anonymous, `using` declarations vs directives, inline namespaces, ADL                                            | [F]/[I] | sc++/cc++ |
| modules                               | `import`/`export` (C++20), module partitions, replacing headers, current compiler support                                       | [A]     | mc++      |
| preprocessor                          | `#include`, `#define`, `#ifdef`/`#ifndef`, `#pragma`, macro pitfalls, why to minimize macro use                                 | [F]     | sc++      |

## 3. OOP and class design

| concept                     | what it is / why it matters                                                                          | level   | book      |
| --------------------------- | ---------------------------------------------------------------------------------------------------- | ------- | --------- |
| structs vs classes          | only difference is default access (public vs private), when to use each                              | [F]     | sc++      |
| access control              | `public`, `private`, `protected`, encapsulation rationale                                            | [F]     | sc++      |
| constructors                | default, parameterized, delegating (C++11), `explicit` to prevent implicit conversions               | [F]     | sc++      |
| member initializer lists    | syntax, initialization order (declaration order, not list order), why prefer over assignment in body | [F]     | sc++      |
| destructors                 | cleanup, deterministic destruction, virtual destructors for polymorphic base classes                 | [F]     | sc++      |
| `this` pointer              | implicit pointer to current object, returning `*this` for chaining                                   | [F]     | sc++      |
| `static` members            | class-level data and functions, no `this`, inline static (C++17)                                     | [I]     | cc++      |
| `const` member functions    | promise not to modify object state, enables calling on const objects/references                      | [F]     | sc++      |
| copy constructor            | deep vs shallow copy, when compiler generates one, when to write your own                            | [F]     | sc++      |
| copy assignment operator    | self-assignment check, copy-and-swap idiom                                                           | [F]     | sc++      |
| move constructor            | transfer ownership of resources (C++11), `std::move`, leaving source in valid-but-unspecified state  | [F]     | sc++      |
| move assignment operator    | same as move constructor but for assignment                                                          | [F]     | sc++      |
| rule of zero / three / five | if you define any of destructor/copy/move, define all; if possible, define none (rule of zero)       | [F]     | sc++      |
| operator overloading        | member vs non-member, canonical forms (`operator==`, `operator<=>` (C++20)), stream operators        | [F]     | sc++      |
| `friend`                    | granting access to non-members, friend functions vs friend classes, hidden friends idiom             | [I]     | cc++      |
| enumerations                | `enum` (unscoped), `enum class` (scoped, C++11), underlying type, `using enum` (C++20)               | [F]     | sc++      |
| unions and `std::variant`   | tagged vs untagged unions, prefer `std::variant` (C++17) for type-safe discriminated unions          | [I]/[A] | cc++/mc++ |
| aggregate initialization    | aggregate types, designated initializers (C++20), brace elision                                      | [F]     | sc++      |
| nested types and typedefs   | nested classes, `typedef`, `using` aliases (prefer `using` over `typedef`)                           | [I]     | cc++      |

## 4. inheritance and polymorphism

| concept                           | what it is / why it matters                                                                          | level | book |
| --------------------------------- | ---------------------------------------------------------------------------------------------------- | ----- | ---- |
| public inheritance                | "is-a" relationship, base and derived classes, construction/destruction order                        | [I]   | cc++ |
| protected and private inheritance | "implemented-in-terms-of", rarely used, composition usually preferred                                | [A]   | mc++ |
| virtual functions                 | dynamic dispatch, vtable mechanism, declaring with `virtual` keyword                                 | [I]   | cc++ |
| `override` and `final`            | `override` catches signature mismatches at compile time (C++11), `final` prevents further overriding | [I]   | cc++ |
| pure virtual functions            | `= 0` syntax, makes class abstract, defines interface contracts                                      | [I]   | cc++ |
| abstract classes                  | cannot be instantiated, used as interface specifications                                             | [I]   | cc++ |
| virtual destructors               | required when deleting derived objects through base pointers                                         | [I]   | cc++ |
| object slicing                    | what happens when you assign derived to base by value, how to prevent it                             | [I]   | cc++ |
| `dynamic_cast` and RTTI           | runtime type identification, `typeid`, performance cost, when to avoid                               | [I]   | cc++ |
| multiple inheritance              | inheriting from multiple bases, ambiguity resolution, the diamond problem                            | [I]   | cc++ |
| virtual inheritance               | solving the diamond problem, `virtual` base classes, layout implications                             | [I]   | cc++ |
| covariant return types            | overriding virtual function can return a more-derived pointer/reference                              | [A]   | mc++ |

## 5. templates and generic programming

| concept                      | what it is / why it matters                                                                                                    | level   | book      |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------- | --------- |
| function templates           | parameterized functions, implicit and explicit instantiation, argument deduction                                               | [I]     | cc++      |
| class templates              | parameterized types, member function definitions, dependent names                                                              | [I]     | cc++      |
| template argument deduction  | how the compiler figures out template arguments, CTAD (C++17)                                                                  | [I]     | cc++      |
| template specialization      | full specialization, partial specialization (class templates only), when to use                                                | [A]     | mc++      |
| non-type template parameters | `template<int N>`, `auto` NTTP (C++17), string literal NTTP (C++20)                                                            | [I]     | cc++      |
| variadic templates           | parameter packs, pack expansion, `sizeof...`, recursive unpacking, fold expressions (C++17)                                    | [A]     | mc++      |
| `if constexpr`               | compile-time branching in templates (C++17), eliminates need for many SFINAE tricks                                            | [A]     | mc++      |
| SFINAE                       | substitution failure is not an error, `std::enable_if`, used for conditional overloads pre-C++20                               | [A]     | mc++      |
| concepts and requires        | named constraints on template parameters (C++20), `requires` clauses, `concept` definitions, standard concepts in `<concepts>` | [A]     | mc++      |
| type traits                  | `<type_traits>`: `is_integral`, `is_same`, `remove_reference`, `decay`, `conditional`, etc.                                    | [A]     | mc++      |
| CRTP                         | curiously recurring template pattern -- static polymorphism, mixin classes                                                     | [E]     | mc++      |
| tag dispatch                 | using empty types to select overloads at compile time                                                                          | [A]     | mc++      |
| template metaprogramming     | compile-time computation with templates, largely superseded by `constexpr`/`consteval`                                         | [E]     | mc++      |
| `constexpr` functions        | functions evaluated at compile time or runtime, `constexpr` vs `consteval`                                                     | [I]/[A] | cc++/mc++ |

## 6. memory management and resource handling

| concept              | what it is / why it matters                                                                                              | level | book |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------ | ----- | ---- |
| stack vs heap        | automatic vs dynamic storage, performance implications, stack overflow                                                   | [F]   | sc++ |
| `new` / `delete`     | dynamic allocation, array forms, why to avoid raw `new`/`delete` in modern C++                                           | [F]   | sc++ |
| RAII                 | resource acquisition is initialization -- the single most important C++ idiom, ties resource lifetime to object lifetime | [I]   | cc++ |
| `std::unique_ptr`    | exclusive ownership smart pointer (C++11), `std::make_unique` (C++14), custom deleters                                   | [F]   | sc++ |
| `std::shared_ptr`    | shared ownership with reference counting, `std::make_shared`, overhead, thread safety of the control block               | [F]   | sc++ |
| `std::weak_ptr`      | non-owning observer of `shared_ptr`, breaks circular references                                                          | [F]   | sc++ |
| move semantics       | transferring resources instead of copying, rvalue references, `std::move` is just a cast                                 | [F]   | sc++ |
| perfect forwarding   | `std::forward`, forwarding references (`T&&` in template context), preserving value category                             | [A]   | mc++ |
| copy elision and RVO | compiler optimization that eliminates copies, guaranteed in C++17 (prvalues)                                             | [I]   | cc++ |
| `std::optional`      | nullable value type (C++17), replaces sentinel values and output parameters                                              | [I]   | cc++ |
| `std::variant`       | type-safe union (C++17), `std::visit`, `std::holds_alternative`                                                          | [I]   | sc++ |
| `std::any`           | type-safe container for single values of any type (C++17)                                                                | [A]   | mc++ |
| `std::span`          | non-owning view over contiguous data (C++20), replaces `(pointer, size)` pairs                                           | [I]   | cc++ |
| placement new        | constructing objects at specific memory addresses, used by allocators and containers                                     | [E]   | mc++ |
| allocators           | `std::allocator`, custom allocators, PMR (`<memory_resource>`, C++17)                                                    | [E]   | mc++ |
| alignment            | `alignas`, `alignof`, why alignment matters for performance and correctness                                              | [I]   | cc++ |

## 7. STL containers, iterators, and algorithms

### 7.1 containers

| container                                           | description                                                       | level | book |
| --------------------------------------------------- | ----------------------------------------------------------------- | ----- | ---- |
| `std::vector`                                       | dynamic array, contiguous memory, the default container           | [F]   | sc++ |
| `std::array`                                        | fixed-size array, stack-allocated, bounds-checked `.at()`         | [F]   | sc++ |
| `std::string`                                       | dynamic character sequence, SSO (small string optimization)       | [F]   | sc++ |
| `std::string_view`                                  | non-owning view over a string (C++17), avoids copies              | [I]   | cc++ |
| `std::deque`                                        | double-ended queue, non-contiguous chunks                         | [I]   | cc++ |
| `std::list`                                         | doubly linked list, O(1) splice, poor cache locality              | [I]   | cc++ |
| `std::forward_list`                                 | singly linked list, minimal overhead                              | [I]   | cc++ |
| `std::set` / `std::map`                             | ordered associative containers (red-black tree), O(log n) lookup  | [I]   | cc++ |
| `std::multiset` / `std::multimap`                   | allow duplicate keys                                              | [I]   | cc++ |
| `std::unordered_set` / `std::unordered_map`         | hash-based containers, O(1) average lookup                        | [I]   | cc++ |
| `std::stack` / `std::queue` / `std::priority_queue` | container adaptors over deque/vector                              | [I]   | cc++ |
| `std::flat_map` / `std::flat_set`                   | sorted vector-backed containers (C++23), better cache performance | [A]   | mc++ |

### 7.2 iterators

| concept               | description                                                                          | level | book |
| --------------------- | ------------------------------------------------------------------------------------ | ----- | ---- |
| iterator categories   | input, output, forward, bidirectional, random access, contiguous (C++20)             | [I]   | cc++ |
| `begin()` / `end()`   | free functions preferred, work with both containers and raw arrays                   | [F]   | sc++ |
| `cbegin()` / `cend()` | const iterators                                                                      | [I]   | cc++ |
| reverse iterators     | `rbegin()` / `rend()`                                                                | [I]   | cc++ |
| iterator invalidation | rules vary by container -- know them for `vector`, `map`, `unordered_map` at minimum | [I]   | cc++ |
| sentinel-based ranges | C++20 ranges use sentinel types instead of requiring matching iterator types         | [A]   | mc++ |

### 7.3 algorithms (`<algorithm>`, `<numeric>`)

| algorithm                                                      | what it does                                            | level | book |
| -------------------------------------------------------------- | ------------------------------------------------------- | ----- | ---- |
| `std::sort` / `std::stable_sort`                               | sort a range, optionally with custom comparator         | [F]   | sc++ |
| `std::find` / `std::find_if`                                   | linear search                                           | [F]   | sc++ |
| `std::binary_search` / `std::lower_bound` / `std::upper_bound` | search in sorted ranges                                 | [I]   | cc++ |
| `std::transform`                                               | apply a function to each element, store results         | [I]   | cc++ |
| `std::accumulate` / `std::reduce`                              | fold/reduce over a range                                | [I]   | cc++ |
| `std::for_each`                                                | apply a function to each element                        | [F]   | sc++ |
| `std::copy` / `std::move` (algorithm)                          | copy or move elements between ranges                    | [I]   | cc++ |
| `std::remove` / `std::erase` idiom                             | remove-erase for containers, `std::erase_if` (C++20)    | [I]   | cc++ |
| `std::count` / `std::count_if`                                 | count elements satisfying a condition                   | [F]   | sc++ |
| `std::min` / `std::max` / `std::minmax` / `std::clamp`         | element comparisons, `clamp` (C++17)                    | [F]   | sc++ |
| `std::all_of` / `std::any_of` / `std::none_of`                 | predicate checks over a range                           | [I]   | cc++ |
| `std::partition` / `std::stable_partition`                     | rearrange elements by predicate                         | [I]   | cc++ |
| `std::unique`                                                  | remove consecutive duplicates                           | [I]   | cc++ |
| `std::reverse` / `std::rotate`                                 | reorder elements                                        | [I]   | cc++ |
| `std::nth_element`                                             | partial sort -- O(n) to find the nth smallest           | [A]   | mc++ |
| `std::next_permutation`                                        | generate permutations                                   | [I]   | cc++ |
| `std::iota`                                                    | fill range with incrementing values                     | [I]   | cc++ |
| `std::gcd` / `std::lcm`                                        | greatest common divisor / least common multiple (C++17) | [I]   | cc++ |

### 7.4 ranges and views (C++20)

| concept                                        | description                                              | level | book |
| ---------------------------------------------- | -------------------------------------------------------- | ----- | ---- |
| range concept                                  | anything with `begin()` and `end()` (or a sentinel)      | [I]   | cc++ |
| `std::ranges::sort`, `std::ranges::find`, etc. | range-based algorithm overloads, accept whole containers | [I]   | cc++ |
| pipe syntax                                    | `data \| views::filter(pred) \| views::transform(fn)`    | [I]   | cc++ |
| `views::filter`                                | lazy filtering                                           | [I]   | cc++ |
| `views::transform`                             | lazy mapping                                             | [I]   | cc++ |
| `views::take` / `views::drop`                  | take or skip first N elements                            | [I]   | cc++ |
| `views::split` / `views::join`                 | string/range splitting and flattening                    | [I]   | cc++ |
| `views::iota`                                  | generate sequences lazily                                | [I]   | cc++ |
| `views::zip`                                   | zip multiple ranges together (C++23)                     | [I]   | cc++ |
| `views::enumerate`                             | index + value pairs (C++23)                              | [I]   | cc++ |

## 8. standard library APIs (non-container)

### 8.1 strings and text

| API                                 | description                                                          | level | book |
| ----------------------------------- | -------------------------------------------------------------------- | ----- | ---- |
| `std::string`                       | dynamic string class, concatenation, `substr`, `find`, `c_str()`     | [F]   | sc++ |
| `std::string_view`                  | non-owning string reference (C++17), pass strings without copying    | [I]   | cc++ |
| `std::to_string`                    | numeric to string conversion                                         | [F]   | sc++ |
| `std::stoi` / `std::stod` / etc.    | string to numeric conversion                                         | [F]   | sc++ |
| `std::from_chars` / `std::to_chars` | locale-independent fast conversion (C++17)                           | [A]   | mc++ |
| `<cctype>`                          | character classification: `isalpha`, `isdigit`, `toupper`, `tolower` | [F]   | sc++ |
| `<regex>`                           | regular expressions (note: often slow, consider alternatives)        | [I]   | cc++ |

### 8.2 I/O

| API                                | description                                                                 | level | book |
| ---------------------------------- | --------------------------------------------------------------------------- | ----- | ---- |
| `<iostream>`                       | `std::cout`, `std::cin`, `std::cerr`, stream insertion/extraction operators | [F]   | sc++ |
| `<fstream>`                        | file I/O: `ifstream`, `ofstream`, `fstream`                                 | [F]   | sc++ |
| `<sstream>`                        | string streams: `istringstream`, `ostringstream`                            | [F]   | sc++ |
| `<iomanip>`                        | `setw`, `setprecision`, `setfill`, `fixed`, `hex`                           | [F]   | sc++ |
| custom `operator<<` / `operator>>` | I/O for user-defined types                                                  | [I]   | cc++ |
| `std::format`                      | python-style string formatting (C++20)                                      | [F]   | sc++ |
| `std::print` / `std::println`      | formatted output to stdout (C++23)                                          | [F]   | sc++ |

### 8.3 filesystem

| API                                                                    | description                                    | level | book |
| ---------------------------------------------------------------------- | ---------------------------------------------- | ----- | ---- |
| `std::filesystem::path`                                                | platform-independent path manipulation (C++17) | [I]   | cc++ |
| `std::filesystem::exists` / `is_regular_file` / `is_directory`         | file status queries                            | [I]   | cc++ |
| `std::filesystem::directory_iterator` / `recursive_directory_iterator` | traversing directories                         | [I]   | cc++ |
| `std::filesystem::create_directories` / `remove` / `rename` / `copy`   | file operations                                | [I]   | cc++ |
| `std::filesystem::file_size` / `last_write_time`                       | file metadata                                  | [I]   | cc++ |

### 8.4 chrono (time)

| API                                                                    | description                                                      | level | book |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------- | ----- | ---- |
| `std::chrono::duration`                                                | time spans with compile-time units (seconds, milliseconds, etc.) | [I]   | cc++ |
| `std::chrono::system_clock` / `steady_clock` / `high_resolution_clock` | clock types for wall time vs monotonic time                      | [F]   | sc++ |
| `std::chrono::time_point`                                              | a point in time relative to a clock                              | [I]   | cc++ |
| calendar types                                                         | `year`, `month`, `day`, `year_month_day` (C++20)                 | [I]   | cc++ |
| `std::chrono::duration_cast`                                           | converting between duration types                                | [I]   | cc++ |

### 8.5 utilities

| API                           | description                                                    | level   | book      |
| ----------------------------- | -------------------------------------------------------------- | ------- | --------- |
| `std::pair` / `std::tuple`    | grouping heterogeneous values, structured bindings             | [F]/[I] | sc++/cc++ |
| `std::move` / `std::forward`  | cast to rvalue / perfect forwarding                            | [F]/[A] | sc++/mc++ |
| `std::swap` / `std::exchange` | swap two values / replace and return old value                 | [I]     | cc++      |
| `std::function`               | type-erased callable wrapper                                   | [I]     | cc++      |
| `std::bind`                   | partial application (largely superseded by lambdas)            | [I]     | cc++      |
| `std::ref` / `std::cref`      | reference wrappers for passing by reference to templates       | [I]     | cc++      |
| `std::hash`                   | hash function object, specializations for custom types         | [I]     | cc++      |
| `std::initializer_list`       | brace-enclosed init lists, how they interact with constructors | [I]     | cc++      |
| `std::expected`               | error-or-value return type (C++23)                             | [F]     | sc++      |

### 8.6 error handling

| concept                                   | description                                                                                      | level | book |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------ | ----- | ---- |
| exceptions                                | `try` / `catch` / `throw`, when to use, cost model (zero-cost on happy path, expensive on throw) | [F]   | sc++ |
| `std::exception` hierarchy                | `runtime_error`, `logic_error`, `out_of_range`, `invalid_argument`, etc.                         | [F]   | sc++ |
| custom exception classes                  | deriving from `std::exception`, `what()` method                                                  | [I]   | cc++ |
| `noexcept`                                | specifier, impact on move operations, conditional `noexcept`                                     | [I]   | cc++ |
| exception safety guarantees               | no-throw, strong (rollback), basic (invariants preserved), no guarantee                          | [A]   | mc++ |
| `std::error_code` / `std::error_category` | system error reporting without exceptions                                                        | [A]   | mc++ |
| `std::expected<T, E>`                     | monadic error handling (C++23)                                                                   | [F]   | sc++ |

### 8.7 concurrency

| API                                                         | description                                                                                      | level | book |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ----- | ---- |
| `std::thread`                                               | spawning OS threads (C++11)                                                                      | [I]   | cc++ |
| `std::jthread`                                              | auto-joining thread with stop token (C++20)                                                      | [I]   | cc++ |
| `std::mutex` / `std::recursive_mutex`                       | mutual exclusion                                                                                 | [I]   | cc++ |
| `std::lock_guard` / `std::unique_lock` / `std::scoped_lock` | RAII lock wrappers, `scoped_lock` for multiple mutexes (C++17)                                   | [I]   | cc++ |
| `std::condition_variable`                                   | thread signaling / waiting                                                                       | [A]   | mc++ |
| `std::future` / `std::promise` / `std::async`               | asynchronous computation                                                                         | [A]   | mc++ |
| `std::atomic`                                               | lock-free atomic operations, memory orderings                                                    | [A]   | mc++ |
| `std::latch` / `std::barrier` / `std::counting_semaphore`   | synchronization primitives (C++20)                                                               | [A]   | mc++ |
| memory model                                                | happens-before, synchronizes-with, memory orderings (`relaxed`, `acquire`, `release`, `seq_cst`) | [E]   | mc++ |
| coroutines                                                  | `co_await`, `co_yield`, `co_return` (C++20), coroutine handle/promise, lazy generators           | [E]   | mc++ |

### 8.8 type support and metaprogramming

| API                     | description                                                                                            | level | book |
| ----------------------- | ------------------------------------------------------------------------------------------------------ | ----- | ---- |
| `sizeof` / `alignof`    | size and alignment queries                                                                             | [F]   | sc++ |
| `decltype`              | deduce the type of an expression                                                                       | [I]   | cc++ |
| `typeid` / `<typeinfo>` | runtime type information, `type_info::name()`                                                          | [I]   | cc++ |
| `<type_traits>`         | compile-time type queries and transformations (C++11)                                                  | [A]   | mc++ |
| `<concepts>`            | standard concepts: `same_as`, `integral`, `floating_point`, `invocable`, `ranges::range`, etc. (C++20) | [A]   | mc++ |
| `std::numeric_limits`   | min/max/epsilon for numeric types                                                                      | [I]   | cc++ |

### 8.9 random numbers

| API                                                                | description                                                  | level | book |
| ------------------------------------------------------------------ | ------------------------------------------------------------ | ----- | ---- |
| `std::mt19937`                                                     | mersenne twister engine (most common)                        | [F]   | sc++ |
| `std::random_device`                                               | hardware/OS entropy source for seeding                       | [F]   | sc++ |
| `std::uniform_int_distribution` / `std::uniform_real_distribution` | uniform random numbers                                       | [F]   | sc++ |
| other distributions                                                | normal, bernoulli, poisson, etc.                             | [A]   | mc++ |
| why not `rand()`                                                   | biased, global state, not thread-safe -- avoid in modern C++ | [F]   | sc++ |

### 8.10 math

| API         | description                                                            | level | book |
| ----------- | ---------------------------------------------------------------------- | ----- | ---- |
| `<cmath>`   | `sqrt`, `pow`, `abs`, `floor`, `ceil`, `round`, `fmod`, trig functions | [F]   | sc++ |
| `<numbers>` | math constants: `std::numbers::pi`, `e`, `sqrt2`, etc. (C++20)         | [F]   | sc++ |

## 9. idioms and design patterns

| idiom/pattern                     | description                                                                            | level | book |
| --------------------------------- | -------------------------------------------------------------------------------------- | ----- | ---- |
| RAII                              | tie resource lifetime to object lifetime -- the foundational C++ idiom                 | [I]   | cc++ |
| copy-and-swap                     | exception-safe assignment operator implementation                                      | [I]   | cc++ |
| pimpl (pointer to implementation) | compilation firewall, ABI stability, hide implementation details                       | [A]   | mc++ |
| NVI (non-virtual interface)       | public non-virtual calls private virtual -- controls pre/post conditions               | [A]   | mc++ |
| type erasure                      | `std::function`, `std::any`, hand-rolled -- runtime polymorphism without inheritance   | [E]   | mc++ |
| ADL (argument-dependent lookup)   | also known as Koenig lookup, how `swap(a, b)` and `operator<<` are found               | [A]   | mc++ |
| tag dispatch                      | using empty struct types to select function overloads at compile time                  | [A]   | mc++ |
| CRTP                              | static polymorphism via curiously recurring template pattern                           | [E]   | mc++ |
| factory pattern                   | creating objects without specifying exact class, `std::make_unique` is a mini-factory  | [I]   | cc++ |
| singleton                         | single instance, use with caution, prefer `static` local (Meyers singleton)            | [I]   | cc++ |
| observer / signal-slot            | event notification, `std::function` + containers of callbacks                          | [I]   | cc++ |
| strategy via lambdas              | replacing inheritance-based strategy with `std::function` or template parameter        | [I]   | cc++ |
| strong types / opaque typedefs    | wrapping primitives to prevent mixups (e.g., `Meters` vs `Feet`)                       | [A]   | mc++ |
| proxy objects                     | intermediate objects that control access or behavior (e.g., `vector<bool>::reference`) | [A]   | mc++ |
| scope guard                       | RAII wrapper for arbitrary cleanup, `std::scope_exit` proposal                         | [I]   | cc++ |

## 10. tooling and ecosystem

| tool/category      | what / why                                                                                                                                | level   | book      |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ------- | --------- |
| compilers          | GCC (`g++`), Clang (`clang++`), MSVC (`cl.exe`) -- know at least two, understand compiler flags (`-Wall`, `-Wextra`, `-std=c++20`, `-O2`) | [F]     | sc++      |
| build systems      | `make`, CMake (de facto standard), `ninja`, understanding compilation/linking pipeline                                                    | [F]/[I] | sc++/cc++ |
| debuggers          | `gdb`, `lldb` -- breakpoints, watchpoints, stack traces, core dumps                                                                       | [F]     | sc++      |
| sanitizers         | AddressSanitizer (ASan), UndefinedBehaviorSanitizer (UBSan), ThreadSanitizer (TSan), MemorySanitizer (MSan)                               | [I]     | cc++      |
| static analysis    | `clang-tidy` (with C++ Core Guidelines checks), `cppcheck`, compiler warnings as errors                                                   | [I]     | cc++      |
| formatting         | `clang-format`, `.clang-format` config files                                                                                              | [F]     | sc++      |
| package managers   | `vcpkg`, `conan` -- managing third-party dependencies                                                                                     | [I]     | cc++      |
| testing frameworks | Google Test (gtest), Catch2 -- unit testing, test fixtures, mocking                                                                       | [I]     | cc++      |
| profiling          | `perf` (Linux), Valgrind (`callgrind`), `gprof`, flame graphs                                                                             | [A]     | mc++      |
| documentation      | Doxygen, `///` doc comments                                                                                                               | [I]     | cc++      |

## 11. C++ standards evolution

### C++11 (the "modern C++" revolution)

`auto`, range-for, lambdas, `nullptr`, `enum class`, `constexpr`, move semantics, rvalue references, smart pointers (`unique_ptr`, `shared_ptr`), `std::thread`, `std::mutex`, `std::atomic`, `std::array`, `std::unordered_map`, `std::tuple`, `std::function`, variadic templates, `static_assert`, user-defined literals, `override`/`final`, uniform initialization, delegating constructors, `noexcept`, `<type_traits>`, `<chrono>`, `<random>`, `<regex>`

### C++14 (polish and convenience)

generic lambdas, return type deduction, `std::make_unique`, variable templates, binary literals (`0b`), digit separators (`1'000'000`), relaxed `constexpr`, `[[deprecated]]`

### C++17 (practical improvements)

structured bindings, `if constexpr`, `std::optional`, `std::variant`, `std::any`, `std::string_view`, `<filesystem>`, fold expressions, `inline` variables, nested namespaces, `std::byte`, `constexpr if`, class template argument deduction (CTAD), `std::scoped_lock`, `[[nodiscard]]`, `[[maybe_unused]]`, `[[fallthrough]]`, parallel algorithms execution policies, `std::from_chars`/`std::to_chars`

### C++20 (the next big leap)

concepts and `requires`, modules (`import`/`export`), coroutines (`co_await`/`co_yield`/`co_return`), ranges and views, `std::format`, `std::span`, three-way comparison (`operator<=>`), `consteval`, `constinit`, `std::jthread`, `std::latch`/`std::barrier`/`std::counting_semaphore`, `<bit>` header, `<numbers>` header, calendar and time zones in `<chrono>`, `std::source_location`, designated initializers, `using enum`

### C++23 (filling gaps)

`std::expected`, `std::print`/`std::println`, `std::flat_map`/`std::flat_set`, `std::generator`, `std::mdspan`, `views::zip`, `views::enumerate`, `views::chunk`, deducing `this`, `if consteval`, `std::stacktrace`, `import std;` / `import std.compat;`

### C++26 (in progress)

contracts (preconditions/postconditions/assertions), reflection (compile-time introspection), `std::execution` (senders/receivers), `std::simd`, `std::hive`, pattern matching (proposals), more constexpr standard library

## 12. recommended textbooks and references

### beginner / introductory

| title                                                            | author(s)            | notes                                                                                                           |
| ---------------------------------------------------------------- | -------------------- | --------------------------------------------------------------------------------------------------------------- |
| *Programming: Principles and Practice Using C++* (3rd ed)        | Bjarne Stroustrup    | stroustrup's own intro textbook, updated for C++20/23, assumes no prior experience                              |
| *C++ Primer* (5th ed)                                            | Lippman, Lajoie, Moo | comprehensive intro, covers C++11 thoroughly, widely used in universities                                       |
| *Starting Out with C++: From Control Structures through Objects* | Tony Gaddis          | popular in US community colleges and universities, very accessible                                              |
| *Accelerated C++*                                                | Koenig, Moo          | uses STL from the start, concise, covers same ground as C++ Primer in 1/4 the pages (older but still excellent) |
| *C++ How to Program*                                             | Deitel & Deitel      | heavyweight intro with extensive examples, used in many university courses                                      |

### intermediate / best practices

| title                                      | author(s)            | notes                                                                                             |
| ------------------------------------------ | -------------------- | ------------------------------------------------------------------------------------------------- |
| *A Tour of C++* (3rd ed)                   | Bjarne Stroustrup    | concise 200-page overview of all of C++20, ideal for experienced programmers from other languages |
| *Effective C++* (3rd ed)                   | Scott Meyers         | 55 specific ways to improve programs and designs, a classic                                       |
| *Effective Modern C++*                     | Scott Meyers         | 42 items on C++11/14 best practices, covers move semantics, smart pointers, lambdas, concurrency  |
| *Effective STL*                            | Scott Meyers         | 50 specific ways to improve use of the STL                                                        |
| *C++ Coding Standards*                     | Sutter, Alexandrescu | 101 rules, guidelines, and best practices                                                         |
| *Exceptional C++* / *More Exceptional C++* | Herb Sutter          | puzzle-format deep dives into exception safety, RAII, pimpl, name lookup, memory model            |
| *C++ Core Guidelines Explained*            | Rainer Grimm         | distills the Core Guidelines into a teachable format with examples                                |

### advanced / expert

| title                                        | author(s)                     | notes                                                                                 |
| -------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------- |
| *The C++ Programming Language* (4th ed)      | Bjarne Stroustrup             | the definitive reference (~1400 pages), covers C++11, written by the language creator |
| *C++ Templates: The Complete Guide* (2nd ed) | Vandevoorde, Josuttis, Gregor | the book on templates, covers C++17, deep on metaprogramming, SFINAE, concepts        |
| *Modern C++ Design*                          | Andrei Alexandrescu           | policy-based design, type lists, advanced generic programming idioms                  |
| *C++ Concurrency in Action* (2nd ed)         | Anthony Williams              | threading, atomics, memory model, lock-free data structures, updated for C++17        |
| *The C++ Standard Library* (2nd ed)          | Nicolai Josuttis              | comprehensive STL reference and tutorial                                              |
| *C++ Move Semantics: The Complete Guide*     | Nicolai Josuttis              | deep dive on move semantics, forwarding references, and all the edge cases            |
| *C++20: The Complete Guide*                  | Nicolai Josuttis              | covers modules, concepts, coroutines, ranges, and all C++20 features                  |

### reference

| title                              | author(s)                  | notes                                                                           |
| ---------------------------------- | -------------------------- | ------------------------------------------------------------------------------- |
| *cppreference.com*                 | community                  | the de facto online reference, more accurate and readable than the ISO standard |
| *ISO/IEC 14882* (the C++ standard) | ISO/WG21                   | the final arbiter, but written as a spec, not a tutorial                        |
| *C++ Core Guidelines*              | Stroustrup, Sutter, et al. | living online document at isocpp.github.io, machine-enforceable best practices  |
| *Google C++ Style Guide*           | Google                     | widely adopted industry style guide                                             |
| *Abseil C++ Tips of the Week*      | Google (Abseil team)       | short, practical articles on specific C++ topics                                |

### domain-specific

| title                               | author(s)      | notes                                                          |
| ----------------------------------- | -------------- | -------------------------------------------------------------- |
| *API Design for C++*                | Martin Reddy   | designing reusable C++ APIs, versioning, ABI compatibility     |
| *Large-Scale C++ Software Design*   | John Lakos     | physical design, dependency management, component architecture |
| *Game Programming Patterns*         | Robert Nystrom | design patterns applied to game development (free online)      |
| *Hands-On Design Patterns with C++* | Fedor Pikus    | modern patterns with C++17/20                                  |

---

*sources: stroustrup's "a tour of C++" 3rd ed, C++ Core Guidelines (isocpp.github.io), google C++ style guide, chromium C++ style guide, ACM/IEEE/AAAI CS2023 curriculum, cppreference.com, stackoverflow definitive C++ book guide, toptal/interviewbit/geeksforgeeks interview compilations, rainer grimm's "C++ Core Guidelines Explained"*
