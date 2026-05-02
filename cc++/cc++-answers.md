---
title: "Gorgo Continuing C++ -- Answer Key"
toc: true
toc-depth: 2
colorlinks: true
header-includes:
  - \usepackage[most]{tcolorbox}
---

\newpage

# Chapter 1: Object-Oriented Programming

**1.** C++ does not make all functions virtual by default because virtual dispatch has a cost --- each call goes through a vtable pointer, preventing inlining and adding indirection.
Most functions do not need polymorphic behavior, so making them virtual would add overhead for no benefit.
Requiring `virtual` to be explicit also communicates intent: it tells the reader that this function is meant to be overridden.

**2.** Output: `B`

`ptr` is a `A*` pointing to a `B` object.
Since `who()` is virtual, the call resolves to `B::who()` at run time.

**3.** The destructor of `Base` is not virtual.
When `delete b` is called on a `Base*` pointing to a `Derived` object, only `Base::~Base()` runs.
`Derived::~Derived()` never runs, so `data_` is never deleted --- a memory leak.
Fix: make the destructor virtual: `virtual ~Base() { ... }`.

**4.** Use an abstract class when there is no sensible default behavior for the base class.
`Shape::area()` returning 0.0 is meaningless --- making it pure virtual forces every derived class to provide a real implementation.
A regular base class with defaults is appropriate when most derived classes share the same behavior and only a few need to override.

**5.** Output:
```
Meow
...
```

`c.sound()` calls `Cat::sound()` which returns `"Meow"`.
`Animal a = c;` slices the `Cat` down to an `Animal`, so `a.sound()` calls `Animal::sound()` which returns `"..."`.

**6.** Minimum `sizeof(C)` is 12 bytes.
`A` has `int x` (4 bytes), `B` adds `int y` (4 bytes), `C` adds `int z` (4 bytes).
With no padding: 4 + 4 + 4 = 12.

**7.** `Square::area()` is missing the `override` keyword.
Without `override`, if the base signature changes (e.g., becomes non-const), this would silently create a new function instead of overriding the virtual one.
Adding `override` would cause a compiler error if the signatures don't match.

**8.** Output: `1 2 3 4 `

Constructors run base-first: `Base()` prints `1`, then `Derived()` prints `2`.
Destructors run derived-first: `~Derived()` prints `3`, then `~Base()` prints `4`.

**9.** Inheritance is clearly right for an "is-a" relationship where polymorphism is needed --- e.g., `Circle` is a `Shape`, and you want to store different shapes in a container and call `area()` on each.
Composition is better for "has-a" relationships --- e.g., a `Car` has an `Engine`, but a `Car` is not an `Engine`.
Making `Car` inherit from `Engine` would be nonsensical.

**10.** (Program exercise --- no single answer.
The program should define `MediaPlayer` with a pure virtual `play()`, at least two derived classes, store them in a `vector<unique_ptr<MediaPlayer>>`, and call `play()` polymorphically.)

# Chapter 2: Templates

**1.** Templates (static polymorphism) resolve at compile time --- no runtime overhead, but the types must be known at compile time, and you cannot store different template instantiations in the same container.
Virtual functions (dynamic polymorphism) resolve at run time --- they have vtable overhead but allow runtime flexibility (storing different types in one container).
Templates are faster; virtual functions are more flexible.

**2.** Output:
```
7
Hola mundo
```

`add(3, 4)` instantiates `add<int>` returning 7.
`add(string("Hola"), string(" mundo"))` instantiates `add<std::string>` which concatenates the strings.

**3.** The call `max_of(3, 4.5)` fails to compile because `T` cannot be deduced --- `3` is `int` and `4.5` is `double`.
The compiler cannot choose which type `T` should be.
Fix: `max_of<double>(3, 4.5)` or use two template parameters.

**4.** Three instantiations: `identity<int>`, `identity<double>`, and `identity<std::string>`.
The calls `identity(1)`, `identity(2)`, and `identity(42)` all use `identity<int>` --- the same instantiation.

**5.** Output: `15`

The fold expression `(args + ...)` expands to `1 + (2 + (3 + (4 + 5)))` = 15.

**6.** Templates must be in headers because the compiler generates code for each instantiation at the point of use.
If the definition is in a `.cpp` file, other translation units cannot see it, and the linker will report "undefined reference" errors for the instantiations they need.

**7.** CTAD deduces `T` as `const char*`, not `std::string`.
`h.get()` returns `const char*`, which works for printing, but is likely not what the programmer intended --- the pointer points to a string literal with static storage, so it is safe, but operations like concatenation or comparison would behave differently than with `std::string`.
Add a deduction guide or explicitly write `Holder<std::string> h("Lose Yourself")`.

**8.** Output:
```
int
general
general
```

`describe(42)` matches the `int` specialization.
`describe(3.14)` uses the general template (no `double` specialization).
`describe("hello")` uses the general template (no `const char*` specialization).

**9.** Output: `5`

There are 5 arguments: `1` (int), `"two"` (const char*), `3.0` (double), `'4'` (char), `true` (bool).

**10.** (Program exercise --- no single answer.
The program should define `Pair<T,U>` with `first`, `second`, a constructor, and `print()`.
A deduction guide `Pair(const char*, int) -> Pair<std::string, int>` enables the CTAD usage shown.)

**11. Leading vs trailing return type with reference returns.**

Output: `99` (when the program compiles).

`first_leading` uses leading-`auto` return-type deduction.
The deduction rules for plain `auto` strip references: `v.front()` returns an `int&`, but `auto` deduces `int`, so the function returns by *value*.
`first_leading(v) = 99;` therefore tries to assign to a temporary `int` --- a compile error in `(a)` ("assignment to rvalue").

`first_trailing` spells the return type explicitly as `-> int&`, so it returns the actual reference into the vector.
`first_trailing(v) = 99;` succeeds in `(b)` and writes `99` into the vector's first element.

The lesson: when you want to return a reference (or any specific type that `auto` would strip or wrap), spell the return type out.
The trailing form is one clean way to do that --- it lets the compiler tell you what is going on, instead of silently giving you a copy.
You could also write the same intent with leading-form `auto&` or by spelling the type up front.

# Chapter 3: The Standard Template Library

**1.** `operator[]` inserts a default value because the alternative (throwing) would make the common pattern `map[key] = value` fail for new keys.
You would need to call `insert` or check `find` before every assignment.
The current design makes insertion and access share the same syntax, at the cost of accidental insertion on read.

**2.** Output: `a1b2c3`

`std::map` stores entries sorted by key.
The keys are "a", "b", "c" in alphabetical order.

**3.** `scores["Charlie"]` inserts a default `int` (0) because "Charlie" does not exist in the map.
After this line, the map has three entries and `charlie_score` is 0.
This is a bug if the intent was to check whether Charlie has a score --- use `find()` or `contains()` instead.

**4.** Output: `4`

The set contains unique values only: {1, 3, 4, 5}.
Duplicates (1, 5, 3) are ignored.

**5.** log$_2$(1,000,000) $\approx$ 20.
A lookup requires approximately 20 comparisons.

**6.** Use `std::map` when: (1) you need sorted iteration (e.g., printing entries in alphabetical order), or (2) you need range queries (e.g., "find all keys between A and M").
`std::unordered_map` cannot do either efficiently.

**7.** Output:
```
20
10
```

After pushing 10, 20, 30: stack is [10, 20, 30] (top = 30).
After `pop()`: stack is [10, 20] (top = 20).
Print `top()`: 20.
After `pop()`: stack is [10] (top = 10).
Print `top()`: 10.

**8.** The programmer expects `smallest` to be 5 (the smallest element), but `priority_queue` is a **max-heap** by default.
`top()` returns 15 (the largest), not 5.
Fix: use `std::priority_queue<int, std::vector<int>, std::greater<int>>` for a min-heap.

**9.** Output: `3`

`std::multiset` allows duplicates.
The set contains {1, 2, 3, 3, 4, 5, 5, 5, 6, 9}.
`count(5)` returns 3.

**10.** (Program exercise --- no single answer.
The program should read words in a loop, store counts in a map, and print sorted results.)

**11. Output: `4 3 2 1`**.

`d` after the two pushes is `{1, 2, 3, 4}`.
`crbegin` is a const reverse iterator pointing at the *last* element (`4`).
Incrementing it walks toward the front, so the loop prints `4 3 2 1`.

**12. Where is the bug in the erase loop?**

`v.erase(it)` invalidates `it`, so the next `++it` in the `for` header reads a dangling iterator --- undefined behavior, and on most implementations it skips the element right after the one you erased *and* may eventually walk off the end.

Fix #1, use the iterator that `erase` returns:

```cpp
for (auto it = v.begin(); it != v.end(); ) {
    if (*it % 2 == 0) {
        it = v.erase(it);
    } else {
        ++it;
    }
}
```

Fix #2, let the algorithm do it (C++20):

```cpp
std::erase_if(v, [](int n) { return n % 2 == 0; });
```

The algorithm form is preferred --- one line, hard to misuse, no chance of leaking the invalidated iterator.

**13. Iterator category of `std::map<std::string, int>::iterator`.**

It is a **bidirectional** iterator: you can `++it`, `--it`, and dereference, but you cannot do `it + 5` or compute distances in O(1).
`std::sort` requires *random-access* iterators, so the call does not even compile on a `map`.

The conceptual reason is deeper: a `map` is *already* sorted by key, by definition.
What people usually mean by "sort a map" is "sort the entries by *value*."
The standard answer is to copy the entries into a `std::vector<std::pair<Key, Value>>`, then sort *that* with a custom comparator:

```cpp
std::vector<std::pair<std::string, int>> rows(m.begin(), m.end());
std::sort(rows.begin(), rows.end(),
          [](const auto& a, const auto& b) { return a.second < b.second; });
```

**14. Where is the bug in the `unordered_set<Point>` example?**

Two missing pieces:

- `Point` has no `operator==`, so `unordered_set` cannot tell two `Point`s apart in a bucket.
- `Point` has no `std::hash` specialization, so the container does not know how to bucket a `Point` in the first place.

The smallest fix:

```cpp
struct Point {
    int x, y;
    bool operator==(const Point&) const = default;
};

template<>
struct std::hash<Point> {
    std::size_t operator()(const Point& p) const noexcept {
        return std::hash<int>{}(p.x) ^ (std::hash<int>{}(p.y) << 1);
    }
};
```

Defaulting `operator==` is the C++20 shortcut that compares both members.
The combined hash is naive but adequate for an example; a real codebase would use a proper hash-combine helper.

# Chapter 4: Ranges, Algorithms, and Lambdas

**1.** The iterator version is kept for backward compatibility and because it supports subranges (sorting only part of a container).
`std::ranges::sort` requires a full range, while `std::sort(it1, it2)` can sort any contiguous subrange.
Removing the iterator version would break existing code.

**2.** Output: `8 5`

After sorting: {1, 2, 3, 5, 8, 9}.
`find` returns an iterator to 8 (index 4).
`*(it - 1)` is the element before 8, which is 5.

**3.** Output: `3`

`count_if` counts elements where `n % 2 != 0` (odd numbers).
The odd numbers in {1, 2, 3, 4, 5} are 1, 3, 5 --- count is 3.

**4.** `doubled` is empty (size 0), so `doubled.begin()` points nowhere.
`std::transform` writes past the end of `doubled` --- undefined behavior.
Fix: create `doubled` with the right size: `std::vector<int> doubled(nums.size());`.

**5.** `x` = 33.
`accumulate` starts with 10 and adds each element: 10 + 4 + 7 + 2 + 9 + 1 = 33.

**6.** Output: `15 30`

The lambda captures `factor` (3) by value.
`multiply(5)` = 5 * 3 = 15.
`multiply(10)` = 10 * 3 = 30.

**7.** The lambda captures `total` **by value** (`[total]`), not by reference.
The lambda modifies its own copy of `total`, but the original `total` in `main` stays 0.
Fix: capture by reference: `[&total]`.

**8.** Views are lazy, which means they avoid unnecessary work --- if you only need the first few results from a large dataset, lazy evaluation skips processing the rest.
Upfront processing would be better when you need all results and want to cache them, or when the transformation is expensive and you will iterate the results multiple times (views recompute each time).

**9.** Output: `4 5 6 `

`filter` keeps elements > 3: {4, 5, 6, 7, 8}.
`take(3)` takes the first 3: {4, 5, 6}.

**10.** (Program exercise --- no single answer.
The program should sort, filter >70, compute average, and find min/max using algorithms and/or views.)

**11. Output: `1 2 3 4 5 6 9`**.

`std::unique` only collapses *adjacent* equal elements.
After sorting, `v` becomes `{1, 1, 2, 3, 3, 4, 5, 5, 6, 9}` and the duplicates are now neighbors, so `unique` collapses them to `{1, 2, 3, 4, 5, 6, 9}` (with the tail still containing the old values until you `erase` it).

If you delete the sort line, `unique` only collapses the *adjacent* `1, 1` (positions 3 and 4 in the original) and leaves every other duplicate alone --- you would end up with something like `{3, 1, 4, 1, 5, 9, 2, 6, 5, 3}` minus exactly one of the consecutive `1`s.
The combination of "sort, then unique, then erase" is the canonical full-deduplication idiom.

**12. Where is the bug in `std::remove`?**

The program prints `1 3 4 4 ` (or similar --- the trailing element values are unspecified).
`std::remove` does *not* shrink the container.
It compacts the elements you keep to the front and returns an iterator at the new logical end.
The space after that iterator still contains old values (or moved-from values), and `v.size()` is unchanged.

The two canonical fixes:

```cpp
auto end = std::remove(v.begin(), v.end(), 2);
v.erase(end, v.end());                        // erase-remove

std::erase(v, 2);                             // C++20 one-liner
```

Modern code prefers the C++20 form because there is no temptation to forget the `erase` step.

**13. Output: `3`**.

`lower_bound(v, 3)` returns an iterator to the first element *not less than* 3 --- the first `3`.
`upper_bound(v, 3)` returns an iterator to the first element *greater than* 3 --- the `5`.
The distance between them is the count of `3`s in the sorted range, which is `3`.

This is the same pair `std::map::equal_range` uses, and it is the standard way to find every occurrence of a value in a sorted range without writing a loop.

**14. Calculation: sum of 1..10 via `iota` + `accumulate`.**

```cpp
#include <numeric>
#include <vector>

int main() {
    std::vector<int> v(10);
    std::iota(v.begin(), v.end(), 1);                    // 1, 2, ..., 10
    int sum = std::accumulate(v.begin(), v.end(), 0);    // 55
    return sum;
}
```

`55` matches `n(n+1)/2 = 10 * 11 / 2 = 55`.
That is Gauss's identity for the sum of the first `n` positive integers --- the program is just computing it the long way.

**15. Output:**

```
0: Crazy
1: Toxic
2: Hey Ya
```

`views::enumerate` (C++23) produces, for each step, a tuple-like value of `(index, element)`.
The structured binding `[i, name]` peels those two pieces apart into named variables.
This replaces the older indexed-loop idiom (`for (int i = 0; i < v.size(); ++i)`) with something both safer (no off-by-one) and more composable (you can pipe `enumerate` into other views).

# Chapter 5: Enums, constexpr, and Compile-Time Programming

**1.** Requiring `static_cast` prevents accidental mixing of enums with integers.
Without it, you could write `if (color == 2)` or `int x = color + 1`, which compiles but is often wrong.
Scoped enums force you to be explicit about conversions, catching bugs like comparing a `Color` to a `TrafficLight` value.

**2.** Output: `3`

`Suit::Hearts = 0`, `Diamonds = 1`, `Clubs = 2`, `Spades = 3`.
`static_cast<int>(Suit::Spades)` is 3.

**3.** `p == 2` does not compile because `enum class Priority` does not implicitly convert to `int`.
Fix: `if (p == Priority::High)`.

**4.** `result` = 1024.
`power(2, 10)` computes 2^10 = 1024.

**5.** `constexpr` functions *can* run at compile time but also work at run time.
`consteval` functions *must* run at compile time --- calling them with run-time values is a compile error.
Use `constexpr` for functions that should work in both contexts.
Use `consteval` when a function only makes sense at compile time (e.g., computing lookup table entries).

**6.** `compute(n)` fails to compile because `n` is read from `std::cin` at run time, but `consteval` requires compile-time arguments.
Fix: change `consteval` to `constexpr`, or make `n` a `constexpr` value.

**7.** Output:
```
10
3.14
```

`check(5)`: `std::is_integral_v<int>` is true, so it prints `5 * 2 = 10`.
`check(3.14)`: `std::is_integral_v<double>` is false, so it prints `3.14`.

**8.** `constinit` exists because `constexpr` makes a variable `const` (immutable).
`constinit` guarantees compile-time initialization without making the variable immutable.
This solves the static initialization order fiasco for globals that need to be modified after initialization.

**9.** No bug.
The code is valid C++17.
`get_pair()` returns a `StringPair`, and the structured binding unpacks it.
`"Hola"` and `"mundo"` are implicitly converted to `std::string`.

**10.** (Program exercise --- no single answer.
The program should define `constexpr` Fahrenheit-to-Celsius, use `static_assert` for 212->100 and 32->0, define `enum class Season`, and print temperatures.)

**11. `<bit>` operations on `0xF0`.**

`0xF0` in binary is `0000 0000 0000 0000 0000 0000 1111 0000` (32-bit unsigned).

- `popcount` counts the 1-bits: `4`.
- `countl_zero` counts leading zeros from the most significant bit: `24`.
- `countr_zero` counts trailing zeros from the least significant bit: `4`.
- `has_single_bit` is `true` only if exactly one bit is set; `0xF0` has four bits set, so the answer is `0`.

Output: `4 24 4 0`.

**12. `[[nodiscard]]` warning.**

The compiler flags line `(a)`, the bare call `parse("123")`, because `parse` is marked `[[nodiscard]]` and the return value is being thrown away.
Line `(b)` assigns the result to `n`, which counts as using it.

If you genuinely need to discard the result --- for instance when calling a side-effect-only API for its other behavior --- the canonical silencer is to assign it to a `std::ignore`-style cast:

```cpp
(void) parse("123");           // explicit "I do not want this value"
std::ignore = parse("123");    // C++ idiom in code that already uses tuples
```

Either form acknowledges the discard, which is what `[[nodiscard]]` is asking for.
The warning is not asking you to *use* the value --- only to *say so* when you don't.

**13. Why are `[[likely]]` / `[[unlikely]]` only hints?**

Two reasons.

First, the compiler knows things you do not.
It can profile-guided-optimize from real run data (PGO) and re-pick the layout, knows the target CPU's branch prediction strategy, can see how the surrounding loop body interacts with cache lines, and may have inlined the function into a context where your hint is wrong.
A "force" annotation would lock the compiler into a layout it has good reason to override.

Second, the hints are mostly useful in inner loops where the cost of *being wrong* is small (a few extra branch mispredictions) but the cost of being *right* is real (better instruction layout, fewer cache misses).
Trusting the user with a hard directive turns a small win into a possible regression every time the assumption ages out of date.
Hints let the compiler use them when they help, and ignore them when they don't.

# Chapter 6: Advanced Strings

**1.** `string_view` is better because it works with both `std::string` and `const char*` without copies.
`const std::string&` requires the caller to have a `std::string` --- passing a `const char*` would create a temporary.
The main risk of `string_view` is that it does not own the data, so if the underlying string is destroyed, the view becomes dangling.

**2.** Output:
```
aqui
4
```

`remove_prefix(6)` removes the first 6 characters ("Estoy "), leaving "aqui" with size 4.

**3.** `get_greeting()` returns a `string_view` to a local `std::string`.
The string is destroyed when the function returns, and the view becomes a dangling pointer.
Accessing it is undefined behavior.
Fix: return `std::string` instead.

**4.** Output: `7`

`regex_search` finds the first match of `\d+` (one or more digits) in the text.
The first sequence of digits is "7" (in "Track 7").

**5.** `std::stoi("0xFF", nullptr, 16)` returns 255.
`0xFF` in base 16 is 15*16 + 15 = 255.

**6.** `from_chars`/`to_chars` use error codes instead of exceptions to avoid the overhead of exception handling.
Setting up a try/catch block has a cost (even if no exception is thrown on some implementations), and throwing/catching is very expensive.
For code that parses millions of values (like a data file or network protocol), this overhead matters.

**7.** `std::stoi` throws `std::invalid_argument` because "not a number" cannot be parsed as an integer.
The program crashes with an unhandled exception.
Fix: wrap in try/catch or validate the input first.

**8.** Output: `One More Time`

The regex captures three groups: `(.+)` for artist, `(.+)` for title, `(\d+)` for year.
`m[2]` is the second capture group: "One More Time".

**9.** Alternatives include RE2 (Google's fast regex library), PCRE2 (Perl-compatible regular expressions), Hyperscan (Intel's high-performance regex engine), and CTRE (compile-time regular expressions in C++).
These libraries are optimized for speed and can be orders of magnitude faster than `std::regex`.

**10.** (Program exercise --- no single answer.
The program should parse "Name:Score" entries, convert scores, and compute the average.)

# Chapter 7: Utilities

**1.** A magic value like -1 or "" can be confused with a legitimate value.
Is -1 an error or a valid negative score?
Is "" an error or an empty name?
`std::optional` explicitly distinguishes "no value" from "a value that happens to be zero/empty."
It makes the intent clear and prevents bugs from accidentally using sentinel values as real data.

**2.** Output:
```
42
7
```

`opt` is empty, so `value_or(42)` returns 42.
After `opt = 7`, `value_or(42)` returns the actual value: 7.

**3.** `*name` dereferences an empty optional --- undefined behavior.
Fix: check `if (name)` first, or use `name.value()` which throws `bad_optional_access`.

**4.** Output:
```
0
1
```

After `v = "changed"`, the active type is `std::string`.
`holds_alternative<int>` is false (0), `holds_alternative<std::string>` is true (1).

**5.** Use `std::any` when the set of possible types is not known at compile time --- for example, a plugin system where plugins can store arbitrary configuration values.
The host application does not know what types the plugins will use, so `variant` (which requires listing all types) is not feasible.

**6.** `a = 10`, `b = 20`, `c = 30`, `d = 40`.
`std::make_tuple(10, 20, 30, 40)` creates a tuple, and the structured binding unpacks each element in order.

**7.** `std::get<int>(v)` throws `std::bad_variant_access` because the active type is `double`, not `int`.
Fix: use `std::get<double>(v)` or check with `holds_alternative<int>` first.

**8.** Output: `2006`

The structured binding `auto [title, year] = p;` creates **copies** of `p.first` and `p.second`.
`year = 2007` modifies the copy, not `p.second`.
`p.second` is still 2006.

**9.** Named structs have descriptive field names: `result.artist` is clearer than `std::get<0>(result)`.
Tuples are convenient for quick returns of 2-3 values and do not require defining a new type.
For larger returns or for types used across multiple functions, a named struct is more maintainable.

**10.** (Program exercise --- no single answer.
The program should parse "rgb(r,g,b)" and return `optional<tuple<int,int,int>>`.)

**11. Move-assign using `std::exchange`.**

```cpp
#include <utility>

Buffer& move_assign(Buffer& dst, Buffer&& src) noexcept {
    delete[] dst.data_;
    dst.data_ = std::exchange(src.data_, nullptr);
    dst.size_ = std::exchange(src.size_, 0);
    return dst;
}
```

`std::exchange` is cleaner than the read-then-write form because it makes the "take from `src` and reset `src`" intent obvious in one line, and it never names the temporary that holds the old value.
The alternative is verbose:

```cpp
dst.data_ = src.data_;
src.data_ = nullptr;
dst.size_ = src.size_;
src.size_ = 0;
```

That works but spreads the take-and-reset over two lines per field, and a careless reader might forget to reset one of them and leave a double-free landmine.
With `exchange`, the reset *is* the assignment.

**12. The thread copies the int.**

Output: `0`.

`std::thread`'s constructor is a *template* that deduces every parameter type by value.
Even though `inc` takes `int&`, the thread template stores its arguments as values --- so `count` is *copied* into the thread, the worker increments its own private copy, and `main`'s `count` is never touched.

The one-character fix is to wrap `count` with `std::ref`:

```cpp
std::thread t(inc, std::ref(count));
```

`std::ref` produces a `std::reference_wrapper<int>`, which the thread template stores by value but which forwards into the function call as the original reference.
The same fix applies to `std::async`, `std::bind`, and any other template that captures arguments by value when you actually want a reference.

**13. Output: `3 2`**.

`std::vector<int> a(3, 5);` calls the (size, value) constructor: a vector of size 3, each element `5`.
`std::vector<int> b{3, 5};` calls the `std::initializer_list<int>` constructor: a vector with the elements `3` and `5`, size 2.

The braces flip the choice because *any* constructor that takes `std::initializer_list<T>` is preferred over other constructors when the call site uses `{}` --- a deliberate language rule, but a frequent source of surprise.
The lesson: if you mean "n copies of x," use parentheses; if you mean "these specific elements," use braces.

**14. `Track` with custom `operator<<`.**

```cpp
#include <iostream>
#include <string>

class Track {
    std::string title_;
    int         year_;
public:
    Track(std::string title, int year) : title_(std::move(title)), year_(year) {}

    friend std::ostream& operator<<(std::ostream& os, const Track& t) {
        return os << t.title_ << " (" << t.year_ << ")";
    }
};

int main() {
    Track t{"Crazy in Love", 2003};
    std::cout << t << "\n";
    return 0;
}
```

The `friend` declaration *inside* the class is what lets the non-member `operator<<` see the private `title_` and `year_`.
Without it, you would have to expose getters or make `title_` / `year_` public --- both leak information the rest of the program does not need.

The Chapter 8 hidden-friends idiom takes the same `friend` declaration but places the function definition *inline* inside the class.
That keeps the function out of the surrounding namespace's lookup until ADL needs it (when someone writes `std::cout << t`), which dramatically improves overload-resolution times in big codebases.
For new code, prefer hidden friends; the standalone non-member form is fine for textbooks and small programs.

# Chapter 8: Namespaces and the Preprocessor

**1.** `using namespace std;` in a header makes all of `std`'s names visible in every file that includes the header.
For example, if a project also has a function called `count` or a class called `array`, they would collide with `std::count` or `std::array`, causing ambiguous name errors --- or worse, silently calling the wrong function.

**2.** Output: `1 2`

`a::x` is 1, `a::b::x` is 2.
The inner namespace `b` has its own `x` that shadows `a::x` within `a::b`.

**3.** `count` in file1.cpp is in an anonymous namespace, giving it internal linkage --- it is only visible within file1.cpp.
`extern int count` in file2.cpp tries to link to a global `count`, which does not exist.
This causes a linker error.

**4.** Inline namespaces are useful for API versioning.
A library can release v2 as an inline namespace so existing users get the new version by default, while users who need the old behavior can explicitly qualify `mylib::v1::function()`.
This allows gradual migration without breaking existing code.

**5.** Output: `11`

`DOUBLE(3 + 4)` expands to `3 + 4 * 2` (text substitution), which is `3 + 8 = 11`, not `14`.
Fix: `#define DOUBLE(x) ((x) * 2)` which expands to `((3 + 4) * 2) = 14`.

**6.** `using namespace std;` in a header file.
This pollutes the namespace of every file that includes `utils.h`.
Fix: use `std::string` explicitly in the header.

**7.** Modules compile faster (parsed once, not re-included everywhere), provide better isolation (macros do not leak), and make include order irrelevant.
The industry has not fully adopted them because compiler and build system support is still maturing, the ecosystem has decades of header-based code, and migration requires significant effort.

**8.** Output:
```
42
42
```

Both `outer::value` and `outer::inner::value` refer to the same variable.
`inner` is an inline namespace, so its contents are accessible directly from `outer`.

**9.** `MAX(3+1, 2+3)` expands to `((3+1) > (2+3) ? (3+1) : (2+3))` = `(4 > 5 ? 4 : 5)` = `5`.
The parentheses in the macro protect against precedence issues, so this one works correctly.

**10.** (Program exercise --- no single answer.
The program should define `music::rock::top_song()` and `music::pop::top_song()`, use `using`, and include an anonymous namespace helper.)

**11. Output: `<Mr. Brightside>`**.

The compiler resolves the unqualified `<<` by **argument-dependent lookup** (ADL).
The right operand of `<<` has type `mylib::Track`, so the compiler also searches `mylib` for an `operator<<` that takes `(std::ostream&, const Track&)`.
It finds `mylib::operator<<` and uses it.

Without ADL, you would have to write `mylib::operator<<(std::cout, t)` every time you wanted to print a `Track`, or pull the operator into the global namespace --- both worse than the rule we have.

**12. Bug: ADL needs a named namespace.**

The program *does* compile because the anonymous namespace's contents are also injected into the enclosing namespace (the global one here).
The `operator<<` is therefore visible to ordinary unqualified lookup at the call site, with no ADL needed.

If you move the operator into a named namespace `silent { ... }`, ordinary lookup at the call site no longer sees it, and ADL cannot help either: ADL searches the namespaces of the *argument types*.
The argument type is `Loud`, which is in the *global* namespace --- not in `silent`.
So neither lookup pathway finds the operator, and the call fails to compile.

The lesson is the same one the chapter recommends: define a type's free-function operators (and other functions you intend ADL to find) in the *same namespace as the type*.
For a global type, you can define them globally; for a namespaced type, define them in that namespace.

**13. Why hidden friends speed up compilation.**

When `operator<<` is a free function in some namespace, every translation unit that does `std::cout << x` for *any* type considers every visible `operator<<` overload during overload resolution.
A namespace with hundreds of streamable types contributes hundreds of candidates to that lookup, even though only one will match.
The cost is paid at every call site, in every translation unit, on every compile.

A hidden friend lives *inside* the class.
It is invisible to ordinary lookup and only appears when ADL specifically searches the class's namespace because one of the arguments has that class's type.
That means each `<<` call only sees the operators relevant to its argument types, not every operator the project has ever defined.
On large codebases, the savings can be a measurable fraction of compile time --- this is the main reason the standard library and Boost moved to hidden friends in their own implementations.

# Chapter 9: RAII and Resource Management

**1.** RAII is important because C++ uses deterministic destruction --- destructors run at predictable times (scope exit), even during exception unwinding.
This guarantees cleanup without explicit finally blocks.
In Java/Python, try/finally requires the programmer to remember cleanup code, and forgetting it causes leaks.
RAII makes leak-free code the default rather than something you must actively maintain.

**2.** If `process(fp)` throws, `fclose(fp)` is never called --- the file handle leaks.
Fix: wrap the file handle in an RAII class (like the `FileHandle` class in the chapter) or use `std::unique_ptr<FILE, ...>` with a custom deleter.

**3.** Move constructors should be `noexcept` because the standard library (e.g., `std::vector` during reallocation) falls back to copying if move might throw, to maintain the strong exception guarantee.
A non-noexcept move constructor means `vector::push_back` copies instead of moves, which can be dramatically slower.

**4.** `Connection c2 = c1;` copies `c1`, giving both `c1` and `c2` their own connection.
But the class has no user-defined copy constructor, so the compiler generates a memberwise copy.
If `Connection` holds a handle or pointer, both objects will try to disconnect the same resource in their destructors --- double cleanup.
Fix: delete the copy constructor/assignment, or implement them properly.

**5.** `fclose` is called exactly once.
`f1` is moved to `f2`, setting `f1`'s internal pointer to null.
When both go out of scope, `f1`'s deleter sees null (no close), and `f2`'s deleter closes the file.

**6.** The basic guarantee ensures no leaks and valid state but allows partial changes --- sufficient for most operations where the caller can handle an inconsistent state.
The strong guarantee (rollback on failure) is needed when partial modifications would leave the system in a confusing state --- e.g., a bank transfer that debits one account but fails to credit the other.

**7.** `ptr.release()` releases ownership (returns the raw pointer and sets the unique_ptr to null) but does **not** free the memory.
The returned pointer is ignored, causing a memory leak.
If the intent was to free the memory, simply let the `unique_ptr` go out of scope --- it will call `delete[]` automatically.

**8.** Output: `C B A `

Scope guards are destroyed in reverse order of construction (LIFO, like all local variables).
`g3` runs first ("C"), then `g2` ("B"), then `g1` ("A").

**9.** `unique_ptr` includes the deleter in its type to avoid overhead --- the deleter is stored as part of the object (zero-size for stateless deleters like function pointers).
`shared_ptr` stores the deleter in a separate control block (type-erased) so that `shared_ptr<T>` has a uniform type regardless of the deleter.
This lets you store `shared_ptr`s with different deleters in the same container, at the cost of a heap allocation for the control block.

**10.** (Program exercise --- no single answer.
The program should use `unique_ptr<int, ...>` with a `free`-calling deleter for `malloc`'d memory.)

**11. Where is the bug in `CacheError`?**

It compiles but inherits from `std::exception` directly --- which means *you* are responsible for the `what()` plumbing and the storage for the message string.
That works, but it duplicates code the standard library already wrote.

The recommended form derives from `std::runtime_error`:

```cpp
class CacheError : public std::runtime_error {
public:
    explicit CacheError(const std::string& key)
        : std::runtime_error("cache miss: " + key) {}
};
```

What you bought:

- The base class stores the message and implements `what()` --- no member, no override needed.
- Callers can `catch (const std::runtime_error& e)` to grab any "expected at runtime" failure (network, cache, config) in one block, in addition to the original `catch (const CacheError& e)`.
- The destructor is correctly `noexcept` for free.

The original form is not *wrong*, just unnecessarily wordy.
For domain-specific error data (a port number, a key, a status code), keep the extra members; just inherit from `std::runtime_error` for the boilerplate.

**12. Why function-local `static` for the Meyers singleton?**

Two reasons.

First, **lazy initialization**.
A namespace-scope `static Logger global_logger;` is constructed before `main` runs, regardless of whether anyone calls into the singleton.
A function-local `static` is constructed the first time the function is called --- so a singleton you never reach pays no cost.

Second, **predictable order**.
Two namespace-scope `static`s in different translation units have unspecified relative initialization order ("static initialization order fiasco"); if one depends on the other, you can get a use-before-init crash that disappears as soon as you change the link order.
Function-local `static`s are initialized in the order their functions are first called, so dependencies between singletons resolve naturally.

C++11 added a third reason: the standard now *requires* function-local `static` initialization to be thread-safe.
Two threads racing to call `instance()` for the first time will not produce two instances and will not corrupt the construction --- the language guarantees the first thread runs the initialization while the second waits.
Before C++11, you needed double-checked locking; now you do not.

**13. Output: `1 0 1 0`**.

- `typeid(a1) == typeid(Cat)`: `a1` is a reference to a polymorphic type, so `typeid` reports the *dynamic* type, which is `Cat`. **1**.
- `typeid(a1) == typeid(Dog)`: same `a1`, dynamic type is `Cat`, not `Dog`. **0**.
- `typeid(*a2) == typeid(Dog)`: `*a2` dereferences the polymorphic pointer; dynamic type is `Dog`. **1**.
- `typeid(a2) == typeid(Dog*)`: `a2` itself is *not* polymorphic (a pointer is not a polymorphic class type), so `typeid` reports the static type, which is `Animal*`, not `Dog*`. **0**.

The fourth case is the trap: `typeid` only does runtime lookup when applied to a *polymorphic class* lvalue --- a pointer is not a polymorphic class, so the rule does not kick in.
Dereferencing the pointer brings you back into polymorphic-class territory, which is why `*a2` works correctly.

**14. Type deductions for `auto` and `decltype`.**

| Variable                    | Type        | Why |
|:----------------------------|:------------|:----|
| (a) `auto a = cref;`        | `int`       | `auto` strips top-level `const` and `&`, so the deduced type is the bare `int`. |
| (b) `auto& b = cref;`       | `const int&`| `auto&` only drops the deduced "value vs reference" wrapper; const is preserved through the explicit `&`. |
| (c) `decltype(cref) c = cref;` | `const int&` | `decltype` of a *named* lvalue reference yields the reference type exactly as declared --- no stripping. |
| (d) `decltype(x) d = cref;` | `int`       | `decltype(x)` is the type of the *declaration* of `x`, which is `int`. The initializer's type is irrelevant. |

The rule of thumb: `auto` "thinks like a function parameter" (strips top-level cv and references), `decltype` "thinks like a type query" (preserves whatever the expression's type actually is).
For perfectly-forward-style code where you need to capture the exact type of an expression --- including reference and const --- reach for `decltype`.

# Chapter 10: Concurrency

**1.** A joinable thread owns a system thread.
If the `std::thread` destructor runs while the thread is still joinable, the program calls `std::terminate` --- a deliberate crash.
This prevents the accidental situation where a thread continues running with references to destroyed local variables.
You must explicitly choose: `join()` to wait, or `detach()` to let it run independently.

**2.** Data race on `total`.
Both threads read and write `total` without synchronization.
The result is undefined --- it could be 100, 200, 300, or anything else.
Fix: use `std::atomic<int>` for `total`, or protect it with a mutex.

**3.** `lock_guard` is designed for the common case: lock at construction, unlock at destruction, nothing else.
Its simplicity prevents misuse.
`unique_lock` adds `unlock()` and `lock()` because some patterns require it --- condition variables need the lock to be released while waiting, and some algorithms need to unlock temporarily for non-critical work.

**4.** Output: `6`

Each thread increments `x` three times atomically.
Two threads × 3 increments = 6.
The exact interleaving varies, but the final value is always 6 because atomic operations are indivisible.

**5.** `thread_a` locks m1 then m2.
`thread_b` locks m2 then m1.
If thread_a locks m1 and thread_b locks m2 simultaneously, each waits for the other's lock --- deadlock.
Fix: lock in the same order in both threads, or use `std::scoped_lock lock(m1, m2)`.

**6.** Use `std::async` when you want a result from a background computation.
It handles thread creation, exception propagation, and result retrieval automatically.
Use `std::thread` when you need control over the thread's lifetime, want to detach it, or need to manage multiple threads in a thread pool.

**7.** `result` = 42.
`std::launch::deferred` means the lambda runs lazily when `fut.get()` is called.
6 * 7 = 42.

**8.** If `some_condition()` returns true, the function returns with the mutex still locked --- deadlock.
`mtx.unlock()` is never called on that path.
Fix: use `std::lock_guard<std::mutex> lock(mtx)` at the top of the function --- it unlocks automatically on any exit path.

**9.** `std::atomic` is faster for simple operations (counter increment, flag toggle) because it uses hardware-level atomic instructions (like `lock xadd` on x86) with no context switches.
A mutex involves kernel calls when contended, which is much more expensive.
Prefer a mutex when you need to protect multiple variables or a complex data structure --- atomics only protect individual values.

**10.** (Program exercise --- no single answer.
The program should split a vector into quarters, use `async` to sum each quarter, collect results with `future::get()`, and print the total.)

**11. Where is the bug in the polling worker?**

The conceptual bug is the worker sleeps for 60 seconds at a time and only checks the flag *between* sleeps.
When `main` flips `stop_flag`, the worker is in the middle of a 60-second `sleep_for` and does not notice until the sleep ends.

Two fixes:

- **Shorter polling interval**: `sleep_for(std::chrono::milliseconds(100))` and check between each --- still polling, but with a bounded latency.
- **`std::jthread` with a stop token**: the worker never sleeps for a long time without a wakeable wait.

```cpp
#include <chrono>
#include <thread>

void worker(std::stop_token token) {
    while (!token.stop_requested()) {
        // do a small chunk of work, then yield
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
}

int main() {
    std::jthread t(worker);                  // stop token wired up by jthread
    // ...
    return 0;                                 // jthread destructor calls request_stop() and join()
}
```

The cleanest version uses `std::condition_variable_any::wait_for` with the stop token, so the wait is interrupted immediately when `request_stop()` is called.
For everyday code, the short-sleep loop above is good enough.

**12. Why `scoped_lock(mtx1, mtx2)` cannot deadlock.**

The classic two-mutex deadlock:

- Thread A acquires `mtx1`, then tries to acquire `mtx2`.
- Thread B acquires `mtx2`, then tries to acquire `mtx1`.
- Each thread holds one mutex and waits for the other. Neither can proceed --- deadlock.

`scoped_lock` avoids this by *trying* to lock all the mutexes and, if any of them is already held, releasing the ones it already holds and starting over.
The exact algorithm (`std::lock`) iterates until it can grab them all simultaneously.
That backoff turns the deadlock window into a brief pause: at most one thread is making no progress at any moment, and progress always resumes once the other thread releases its mutex.

The trade-off: when both threads contend on the same pair of mutexes, you can do more work than a strict ordering would.
For low-contention workloads the cost is negligible; for high-contention workloads, the right answer is usually to redesign so you do not need two locks at once.

# Chapter 11: The Filesystem Library

**1.** `+` on strings just concatenates characters.
`"/home/user" + "music"` would produce `"/home/usermusic"` --- no separator.
The `/` operator is overloaded to insert the correct path separator, giving `"/home/user/music"`.
It also handles edge cases like trailing separators.

**2.** Output:
```
"report"
".pdf"
"docs"
```

`stem()` is the filename without extension: "report".
`extension()` includes the dot: ".pdf".
`parent_path().filename()` is the last component of the parent: "docs".

**3.** `file_size("maybe_missing.txt")` throws `filesystem_error` if the file does not exist.
Fix: check `fs::exists()` first, or use the `error_code` overload:
`auto size = fs::file_size("maybe_missing.txt", ec);`

**4.** `directory_iterator` lists entries in a single directory (non-recursive).
`recursive_directory_iterator` walks the entire directory tree, descending into subdirectories.
Use `directory_iterator` when you only care about immediate children.
Use `recursive_directory_iterator` when you need to find files anywhere in a tree (e.g., finding all `.cpp` files in a project).

**5.** Output: `"/home/user/music/track.mp3"`

`lexically_normal()` resolves `.` (current directory) and `..` (parent directory), simplifying the path.

**6.** Three directories: `b`, `c`, and `d`.
`/a` already exists, so `create_directories` creates `b` inside `a`, `c` inside `b`, and `d` inside `c`.

**7.** `create_directory` only creates one level.
If `/new_project` does not exist, creating `/new_project/src/main` fails because the parent `/new_project/src` does not exist.
Fix: use `fs::create_directories("/new_project/src/main")`.

**8.** `remove_all` returns the count so you can verify the operation --- e.g., if you expect to remove a directory with 100 files and the count is 3, something is wrong.
It is also useful for logging and diagnostics.

**9.** The second `copy_file` throws `filesystem_error` because `b.txt` already exists and the default option is `copy_options::none` (fail if destination exists).
Fix: use `fs::copy_file("a.txt", "b.txt", fs::copy_options::overwrite_existing)`.

**10.** (Program exercise --- no single answer.
The program should take a directory argument, use `recursive_directory_iterator`, and count files, directories, and total bytes.)

# Chapter 12: Best Practices and Common Idioms

**1.** Starting with `const` is safer because you can only forget to add mutability, not accidentally add it.
If everything is const by default, the compiler catches any attempt to modify something that should not change.
Going the other way (adding `const` later), you might miss variables that should have been const, allowing bugs where values are accidentally modified.

**2.** Follow the Rule of Zero when your class uses only standard library types (string, vector, smart pointers) that manage themselves.
Follow the Rule of Five when your class directly manages a resource (raw pointer, file descriptor, etc.).
The decision: if you are writing a destructor, you need all five.
If you are not, you likely need zero.

**3.** `Data b = a;` uses the compiler-generated copy constructor, which copies the raw pointer `ptr_`.
Now `a.ptr_` and `b.ptr_` point to the same memory.
When `a` and `b` are destroyed, both destructors call `delete[] ptr_` on the same address --- double free (undefined behavior).
Fix: define a copy constructor that allocates new memory and copies the contents, or delete the copy constructor and use smart pointers.

**4.** CRTP (static): resolved at compile time, no vtable overhead, the compiler can inline calls.
But you cannot store different CRTP-derived types in the same container.
Virtual functions (dynamic): resolved at run time, vtable overhead, but you can store `Base*` pointers to any derived type in a single container.
Choose CRTP for performance-critical code where types are known at compile time.
Choose virtual functions when you need run-time flexibility.

**5.** Output: `45.14`

`auto x = 42` deduces `int`.
`auto y = 3.14` deduces `double`.
`auto z = x + y`: `int + double` promotes to `double`, so `z` is `45.14`.

**6.** `unique_ptr` needs the complete type (including the destructor) to destroy the object.
In the header, `Impl` is only forward-declared (incomplete type).
If the compiler generates the destructor in the header, it cannot call `Impl`'s destructor.
You get a compile error about an incomplete type.
Defining `~Playlist() = default;` in the `.cpp` file (where `Impl` is complete) solves this.

**7.** `add_to_vector` takes the vector by **value**, not by reference.
It modifies a copy, not the original.
`data.size()` is still 3 after the call.
Fix: `void add_to_vector(std::vector<int>& v, int x)`.

**8.** Comments explaining "what" are redundant because the code already says what it does.
`// increment counter` above `counter++` adds no information.
Comments explaining "why" provide context the code cannot: `// skip the first element because it's a header row` explains intent.
Good: `// Use stable_sort to preserve relative order of equal-rated songs`.
Bad: `// Sort the songs`.

**9.** Zero.
Both `std::vector<std::string>` and `std::unique_ptr<Widget>` manage their own resources.
The compiler-generated destructor, copy (if applicable), and move operations all do the right thing.
This is the Rule of Zero.
(Note: `unique_ptr` makes the class non-copyable by default, which is probably correct.)

**10.** (Program exercise --- no single answer.
The program should define `Printable<Derived>` with CRTP, `Song` and `Album` derived classes with `to_string()`, and demonstrate `print()`.)

# Appendix A: Build Systems and Tooling

**1.** CMake generates platform-specific build files (Makefiles, Visual Studio projects, Ninja files).
The actual building is done by those tools (make, msbuild, ninja).
CMake is a meta-build system --- it describes *what* to build, and the native build tool determines *how*.

**2.**
```cmake
cmake_minimum_required(VERSION 3.20)
project(AudioApp LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(audioapp main.cpp audio.cpp)
target_include_directories(audioapp PRIVATE ${CMAKE_SOURCE_DIR})
target_compile_options(audioapp PRIVATE -Wall -Wextra -pedantic)
```

**3.** Adding warnings to an existing project often produces hundreds of warnings from code that already works.
Developers either disable the warnings (defeating the purpose) or spend days fixing them.
Starting with warnings from day one means you fix each warning as it appears --- a small incremental cost instead of a large batch.

**4.** AddressSanitizer catches buffer overflows.
Use `-fsanitize=address -g`.

**5.** ASan and TSan both instrument memory accesses but in incompatible ways --- they would interfere with each other's tracking.
To test for both, run your test suite twice: once with `-fsanitize=address` and once with `-fsanitize=thread`.

**6.**
```
break main
run
next
next
next
print count
continue
```

**7.** `-O0`: no optimization, fastest compile, best for debugging (variables are not optimized away).
`-O2`: standard optimization, good balance of speed and compilation time, used for most release builds.
`-O3`: aggressive optimization, may increase binary size with auto-vectorization and function inlining; use when maximum performance matters and you have tested thoroughly.

**8.** Missing `PRIVATE` (or `PUBLIC`/`INTERFACE`) keyword in `target_link_libraries`.
Also, `fmt` should be `fmt::fmt` if using FetchContent.
Corrected: `target_link_libraries(myapp PRIVATE fmt::fmt)`.

**9.** Sanitizers detect bugs that tests alone miss because many bugs (buffer overflows, data races, use-after-free) produce correct-looking output most of the time.
A test might pass 99% of the time and only fail under specific memory layouts or thread scheduling.
Sanitizers instrument every access and catch the bug deterministically, regardless of whether the test output looks correct.

**10.** (Program exercise --- no single answer.
The program should have CMakeLists.txt, main.cpp, math_utils.cpp/h with factorial, build with CMake, and run with ASan.)

**11. Why no built-in C++ package manager?**

The combinatorial space.
A package manager has to pick a *single* answer for: which compiler is canonical, which standard library, which version of the language, which ABI, which build system, which platform conventions for headers and libraries.
C++ deliberately does not pick: GCC, Clang, MSVC, libstdc++, libc++, MS STL, Make, CMake, Bazel, Meson, and a dozen other combinations are all valid targets, and the language committee has been reluctant to anoint one as "the" tooling.

A built-in package manager would have to either pick (alienating the rest) or model the cross-product (which is what `vcpkg` and `Conan` already do, with config files describing each binary).
Other languages with built-in tooling --- Rust, Go, Python --- effectively legislate one of these choices, which C++ is structurally unable to do without forking the ecosystem.

The current state ("two community-driven options, both supported, neither blessed") is a compromise that lets C++ be the lingua franca of every platform without picking sides.

**12. Doxygen project: what does the generated HTML contain that you did not type?**

Quite a lot:

- **Inheritance and collaboration diagrams** for each class (auto-generated from the `: public Base` lines).
- **File lists** organized by directory, with one page per file showing every declaration in that file.
- **Class index** alphabetized, plus a hierarchy view.
- **Member function index** alphabetized, with a "called by / calls" graph if you enable Graphviz support.
- **Cross-references**: every mention of `Track` in another comment becomes a hyperlink to the `Track` class page.
- **Source code browser** that links from declarations to definitions and back.
- **Search box** indexed across the whole project.

You typed a few `///` lines per class; Doxygen turned them into a fully-navigable mini-website plus a complete API index.
That is the value proposition: write documentation where the code is, get a browseable structure for free.

# Appendix B: Testing

**1.** Shared state means one test can affect another --- a test that modifies a global variable can cause the next test to fail (or pass incorrectly).
This makes failures order-dependent and non-reproducible, which makes debugging much harder.
Independent tests can run in any order and even in parallel.

**2.**
```cpp
TEST(PalindromeTest, Racecar) {
    EXPECT_TRUE(is_palindrome("racecar"));
}

TEST(PalindromeTest, Hello) {
    EXPECT_FALSE(is_palindrome("hello"));
}

TEST(PalindromeTest, EmptyString) {
    EXPECT_TRUE(is_palindrome(""));
}
```

**3.** `EXPECT_EQ` reports the failure and continues running the rest of the test --- useful when multiple independent checks are in one test.
`ASSERT_EQ` stops the test immediately --- necessary when the rest of the test would crash or be meaningless if this check fails (e.g., checking that a pointer is non-null before dereferencing it).

**4.** The test assumes `SetUp()` adds songs in a specific order: "Hey Ya!", "Toxic", "Crazy".
If `SetUp()` changes the order (or if the fixture is modified later), `EXPECT_EQ(playlist[0], "Toxic")` breaks.
The fix: either sort the expected values, or test more robustly (e.g., check that the erased element is no longer present).

**5.** TDD is most useful when requirements are clear and testable --- e.g., writing a parser, a math library, or fixing a reported bug (write a test that reproduces it first).
TDD is less useful for exploratory or prototype code where the API and behavior are still being discovered --- you would constantly rewrite tests as the design evolves.

**6.**
```cpp
TEST_CASE("clamp restricts values to range", "[clamp]") {
    SECTION("value below range returns lo") {
        REQUIRE(clamp(-5, 0, 100) == 0);
    }

    SECTION("value in range returns value") {
        REQUIRE(clamp(50, 0, 100) == 50);
    }

    SECTION("value above range returns hi") {
        REQUIRE(clamp(200, 0, 100) == 100);
    }
}
```

**7.** Without virtual functions, the compiler resolves calls at compile time --- there is no mechanism to intercept or replace behavior.
Google Mock's `MOCK_METHOD` works by overriding virtual functions.
If the function is not virtual, the mock class cannot override it, and the test will call the real implementation instead of the mock.

**8.** The test checks three properties of a default-constructed `std::string`: that `empty()` is true, `size()` is 0, and it compares equal to `""`.
These are redundant (if one is true, the others must be), but together they document the expected behavior of an empty string.

**9.** Writing tests after the code often leads to tests that only cover the "happy path" --- the cases the developer already knows work.
Writing tests alongside the code forces you to think about edge cases and failure modes as you write, producing better test coverage.
It also means the code is designed to be testable from the start.

**10.**
```cpp
class MockLogger : public Logger {
public:
    MOCK_METHOD(void, log, (const std::string& message), (override));
    MOCK_METHOD(int, message_count, (), (const, override));
};

class App {
public:
    App(Logger& logger) : logger_(logger) {}
    void run() { logger_.log("Starting"); }
private:
    Logger& logger_;
};

TEST(AppTest, RunLogsStarting) {
    MockLogger mock;
    EXPECT_CALL(mock, log("Starting")).Times(1);

    App app(mock);
    app.run();
}
```
