# gaps between sc++ and CMPE30 introducing C++ text

topics covered in `~/git/courses/cmpe30/s26/text/CMPE30_Introducing_CPP_Text.txt` but not in sc++.

## significant gaps

1. **lambdas** — lambda syntax (`[](){}`), capture groups (by value `[x]`, by reference `[&x]`, capture all `[=]`/`[&]`, mixed `[first, &second]`), `mutable` lambdas, using lambdas as predicates in algorithms, assigning to variables with `auto`, each lambda having a unique type

2. **standard library algorithms** — `std::sort`, `std::ranges::sort` with custom comparators, `std::accumulate` (`<numeric>`), `std::ranges::find_if`, `std::ranges::count_if`, `std::erase_if`, `std::remove_if` and the erase-remove idiom, `std::ranges::generate`/`std::generate_n`, `std::back_inserter`, `std::ranges::minmax`, binary predicates (`std::greater`, `std::ranges::greater`), unary predicates as a concept, using `<algorithm>` and `<numeric>` headers

3. **ranges and views** — `std::views::filter`, `std::views::take_while`, `take`, `skip`, `skip_while`, pipe operator (`|`) for composing views, lazy evaluation of views, `std::ranges::to<std::vector>` for materializing views

4. **inheritance and polymorphism** — base and derived classes, abstract base classes with pure virtual functions, virtual functions, virtual destructors, object slicing when passing derived objects by value, `override` keyword, using derived classes polymorphically through base class pointers/references

5. **`std::variant`, `std::optional`, `std::any`** — `std::variant` as a type-safe union, `std::visit` for visiting variants with a callable, `std::optional` for values that may or may not be present, `std::any` as a type-erased container, handling `std::bad_variant_access`

6. **templates** — writing function and class templates, template specialization (e.g., specializing `std::hash`), template type deduction

7. **`std::unordered_map`** — hash-based associative containers, lookup tables, adding equality operators for use in hash containers, associative containers generally

8. **`std::function`** — `std::function<void()>` and similar wrappers for storing and passing callable objects, using `std::function` as a parameter type instead of function pointers

## smaller gaps

9. **`std::string_view`** — non-owning view of a string, how views are invalidated when the underlying string changes, passing `std::string_view` to functions instead of `const std::string&`

10. **`std::deque`** — double-ended queue with `push_front`, when to use `deque` vs `vector` based on performance characteristics

11. **vector operations** — `vector::insert()` at arbitrary positions, `vector::erase()` by iterator or range, `vector::reserve()` to preallocate without constructing elements, `vector::shrink_to_fit()` to reclaim unused capacity, constructing a vector from two iterators (range constructor)

12. **indexed format arguments** — `std::format("{1} {0}", a, b)` for reordering arguments, the rule that implicit and indexed arguments cannot be mixed. the CLAUDE.md documents this but ch09 does not cover it

13. **`std::filesystem`** — `std::filesystem::path` for platform-independent paths, `std::filesystem::current_path()`, `std::filesystem::exists()`, `operator/` for joining paths, `.string()` method on paths

14. **file open modes** — `std::ios::out`, `std::ios::app`, `std::ios::in`, `std::ios::binary`, combining modes with `|` as a bitmask. sc++ covers bitwise operators in ch04 but does not connect them to file modes

15. **`std::normal_distribution`** — Gaussian random numbers, concepts of mean, standard deviation, and volatility. sc++ covers `uniform_int_distribution` and `uniform_real_distribution` but not `normal_distribution`

16. **`inline` and the one-definition rule** — `inline` keyword for functions defined in headers, ODR and why it matters, translation units

17. **`std::numeric_limits`** — finding max/min values for numeric types at compile time

18. **`[[nodiscard]]` attribute** — generating compiler warnings when a function's return value is ignored

19. **`explicit` keyword** — preventing implicit conversions on constructors and conversion operators

20. **`assert` and basic testing** — using `assert` from `<cassert>` for in-code assertions, test-driven development workflow, using `std::stringstream` to test I/O functions without keyboard interaction

21. **stream manipulators** — `std::boolalpha`, `std::setw`, `std::setprecision`, `std::fixed`, and other manipulators from `<iomanip>`. sc++ mentions `std::format` as the modern alternative but does not cover manipulators which appear in older code

22. **C-style strings in depth** — null terminator (`\0`) and how C-style strings work internally, arrays of `char*` (arrays of string pointers), `char*` decay losing size information, `""s` suffix (`std::string_literals`) to create `std::string` from a literal
