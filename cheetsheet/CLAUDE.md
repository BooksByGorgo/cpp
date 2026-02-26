# project description

cheet sheet to compactly remember key topics for modern c++ students

# area information

1. start with topic title and very concise summary of usages
2. show includes
3. list common function and operator signatures and a concise summary of what they do in a table format. highlight any common traps
4. for functions that return an important value, include the return type in the description
5. highlight any common general traps
6. highlight common idioms
7. avoid examples except for very confusing concepts

# formatting

- `make` or `make all` -- builds both full page and booklet PDFs
- `make cheetsheet.pdf` -- full page only
- `make cheetsheet-booklet.pdf` -- 2-up booklet for folding/stapling (letter paper)
- `make clean` -- removes both PDFs
- use normal-sized bold `\textbf{}` for the title, not a pandoc title
- use `geometry: margin=0.75in` and `fontsize: 10pt` in the YAML header
- keep table signatures short enough to fit in LaTeX columns at 0.75in margins
- if a signature is too long for a table, abbreviate it in the table and show the full version below
- use `·` (middle dot) to show whitespace padding in format spec result examples
- avoid HTML entities (`&rarr;` etc.); use LaTeX math equivalents (`$\rightarrow$`, `$\equiv$`)
- when abbreviating `std::` prefixes in tables to save space, add a note below the table (e.g. "all types above are in `std::`")

# content directions

- include function return types in the description column for functions with important return values (e.g. `size_t`, `bool`, `iterator`, `T &`)
- iostreams section should include a compact table of standard streams (`cin`, `cout`, `cerr`) with descriptions
- functions section should show return types in the code example signatures (e.g. `int sum(int a, int b)`, `std::string greet(...)`)
- function parameter passing table should distinguish pass patterns from return patterns
- include both range algorithms (`std::ranges::`) and classic iterator-pair algorithms
- algorithms section should include sort with comparator and projection, `ranges::find`, `back_inserter`, and `ranges::shuffle`
- algorithms section should include a table of common predicates/comparators (`std::less`, `std::greater`, `<cctype>` character classifiers); non-predicate utilities like `toupper`/`tolower` go below the table as a note
- strings section should include conversions (all `sto*` variants and `to_string`), `npos`, `append`/`+=`, `insert`, and C++20/23 methods (`starts_with`, `ends_with`, `contains`)
- iostreams section should include `getline` variants, `ostringstream`, `eof()` trap, and `std::ws`
- vectors section should include `clear`, `resize`, `pop_back`, `capacity`, `data`, and a `std::span` subsection
- structures section should include `enum class`, `operator<<` overload, `friend`, `static` members, `operator== = default`, `operator<=> = default`, designated initializers, and structured bindings
- operators section should include `sizeof` and `static_cast` in quick reference
- formatting section should include integer format types (`d`, `x`, `o`, `b` with `#` prefix variants), sign specifiers (`+`, space), and escaped braces `{{`/`}}`
- lambdas section should include `[this]` capture, init-capture `[x = std::move(p)]`, generic lambdas with `auto` params, and trailing return type
- random section should include `bernoulli_distribution`
- unique_ptr section traps should cover `return std::move()` pessimization
- unique_ptr section does not cover special member functions (not in this class)
- exceptions section should include try/catch/throw syntax, common exception types table, `noexcept`, `std::expected` with `std::unexpected`, and custom exceptions via inheritance

# topics

1. table of common data types with typename, #include, description of use
2. operator precedence table and quick reference with `sizeof`, `static_cast`
3. formatting: `println`/`print`/`format` signatures, format spec table with integer/sign types
4. functions: by value, by reference, const, return types
5. iostreams: standard streams, getline, ostringstream, operations, file streams, file modes
6. strings with string_view, all `sto*` conversions, C++20/23 methods
7. arrays, vectors, and span
8. algorithms: range algorithms with sort/comparator/projection, classic algorithms, erase, predicates/comparators
9. lambdas: capture syntax, `[this]`, init-capture, generic lambdas, `std::function`
10. ranges: views, pipe syntax, converting to containers
11. random numbers: seed, engine, distribution
12. structures and classes: enum class, operator overloads, friend, static, `<=>`, designated initializers, structured bindings
13. unique_ptr and move: smart pointers, move semantics
14. exceptions and expectations: try/catch/throw, exception types, noexcept, `std::expected`
