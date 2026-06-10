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

**1.** **Think about it:** Why does C++ require you to explicitly write `virtual` on a function instead of making all member functions virtual by default, the way Java and Python do?

**Answer:** C++ does not make all functions virtual by default because virtual dispatch has a cost --- each call goes through a vtable pointer, preventing inlining and adding indirection.
Most functions do not need polymorphic behavior, so making them virtual would add overhead for no benefit.
Requiring `virtual` to be explicit also communicates intent: it tells the reader that this function is meant to be overridden.

**2.** **What does this print?**

```cpp
class A {
public:
    virtual ~A() = default;
    virtual std::string who() const { return "A"; }
};

class B : public A {
public:
    std::string who() const override { return "B"; }
};

A* ptr = new B();
std::cout << ptr->who() << "\n";
delete ptr;
```

**Answer:** Output: `B`

`ptr` is a `A*` pointing to a `B` object.
Since `who()` is virtual, the call resolves to `B::who()` at run time.

**3.** **Where is the bug?**

```cpp
class Base {
public:
    ~Base() { std::cout << "Base destroyed\n"; }
    virtual void greet() const { std::cout << "Hola\n"; }
};

class Derived : public Base {
public:
    ~Derived() { delete data_; }
    void greet() const override { std::cout << "Buenos dias\n"; }
private:
    int* data_ = new int(42);
};

Base* b = new Derived();
delete b;
```

**Answer:** The destructor of `Base` is not virtual.
When `delete b` is called on a `Base*` pointing to a `Derived` object, only `Base::~Base()` runs.
`Derived::~Derived()` never runs, so `data_` is never deleted --- a memory leak.
Fix: make the destructor virtual: `virtual ~Base() { ... }`.

**4.** **Think about it:** When would you use an abstract class instead of a regular base class with default implementations?

**Answer:** Use an abstract class when there is no sensible default behavior for the base class.
`Shape::area()` returning 0.0 is meaningless --- making it pure virtual forces every derived class to provide a real implementation.
A regular base class with defaults is appropriate when most derived classes share the same behavior and only a few need to override.

**5.** **What does this print?**

```cpp
class Animal {
public:
    virtual ~Animal() = default;
    virtual std::string sound() const { return "..."; }
};

class Cat : public Animal {
public:
    std::string sound() const override { return "Meow"; }
};

Cat c;
Animal a = c;
std::cout << c.sound() << "\n";
std::cout << a.sound() << "\n";
```

**Answer:** Output:

```
Meow
...
```

`c.sound()` calls `Cat::sound()` which returns `"Meow"`.
`Animal a = c;` slices the `Cat` down to an `Animal`, so `a.sound()` calls `Animal::sound()` which returns `"..."`.

**6.** **Calculation:** Given this hierarchy:

```cpp
class A { int x; };
class B : public A { int y; };
class C : public B { int z; };
```

Assuming `int` is 4 bytes with no padding, what is the minimum `sizeof(C)`?

**Answer:** Minimum `sizeof(C)` is 12 bytes.
`A` has `int x` (4 bytes), `B` adds `int y` (4 bytes), `C` adds `int z` (4 bytes).
With no padding: 4 + 4 + 4 = 12.

**7.** **Where is the bug?**

```cpp
class Shape {
public:
    virtual double area() const = 0;
};

class Square : public Shape {
public:
    Square(double side) : side_(side) {}
    double area() const { return side_ * side_; }
private:
    double side_;
};
```

**Answer:** `Square::area()` is missing the `override` keyword, and `Shape` is missing a virtual destructor.
Without `override`, the code works today but is fragile: if the base signature later changes (say, `area()` loses its `const`), `Square::area()` silently stops overriding anything.
Because `Shape::area()` is pure virtual, `Square` would then become abstract, and the failure surfaces as a confusing "cannot instantiate abstract class" error at whatever call site happens to create a `Square` --- not at the function that caused it.
Writing `override` turns that fragile situation into an immediate, clearly-worded compiler error right at the declaration.
The missing virtual destructor means `delete` through a `Shape*` would be undefined behavior; add `virtual ~Shape() = default;`.

**8.** **What does this print?**

```cpp
class Base {
public:
    Base() { std::cout << "1 "; }
    virtual ~Base() { std::cout << "4 "; }
};

class Derived : public Base {
public:
    Derived() { std::cout << "2 "; }
    ~Derived() override { std::cout << "3 "; }
};

{ Derived d; }
```

**Answer:** Output: `1 2 3 4 `

Constructors run base-first: `Base()` prints `1`, then `Derived()` prints `2`.
Destructors run derived-first: `~Derived()` prints `3`, then `~Base()` prints `4`.

**9.** **Think about it:** The text recommends preferring composition over inheritance.
Give an example of a situation where inheritance is clearly the right choice and another where composition would be better.

**Answer:** Inheritance is clearly right for an "is-a" relationship where polymorphism is needed --- e.g., `Circle` is a `Shape`, and you want to store different shapes in a container and call `area()` on each.
Composition is better for "has-a" relationships --- e.g., a `Car` has an `Engine`, but a `Car` is not an `Engine`.
Making `Car` inherit from `Engine` would be nonsensical.

**10.** **Write a program** that defines an abstract `MediaPlayer` class with a pure virtual `play()` method and at least two derived classes (e.g., `MP3Player` and `StreamPlayer`).
Store them in a `std::vector` of `std::unique_ptr<MediaPlayer>` and call `play()` on each.

**Answer:** This is a program exercise --- no single answer.
The program should define `MediaPlayer` with a pure virtual `play()`, at least two derived classes, store them in a `vector<unique_ptr<MediaPlayer>>`, and call `play()` polymorphically.

# Chapter 2: Templates

**1.** **Think about it:** Templates generate code at compile time, while virtual functions dispatch at run time.
What are the trade-offs between these two approaches to polymorphism?

**Answer:** Templates (static polymorphism) resolve at compile time --- no runtime overhead, but the types must be known at compile time, and you cannot store different template instantiations in the same container.
Virtual functions (dynamic polymorphism) resolve at run time --- they have vtable overhead but allow runtime flexibility (storing different types in one container).
Templates are faster; virtual functions are more flexible.

**2.** **What does this print?**

```cpp
template<typename T>
T add(T a, T b) { return a + b; }

std::cout << add(3, 4) << "\n";
std::cout << add(std::string("Hola"), std::string(" mundo")) << "\n";
```

**Answer:** Output:

```
7
Hola mundo
```

`add(3, 4)` instantiates `add<int>` returning 7.
`add(string("Hola"), string(" mundo"))` instantiates `add<std::string>` which concatenates the strings.

**3.** **Where is the bug?**

```cpp
template<typename T>
T max_of(T a, T b) {
    return (a > b) ? a : b;
}

std::cout << max_of(3, 4.5) << "\n";
```

**Answer:** The call `max_of(3, 4.5)` fails to compile because `T` cannot be deduced --- `3` is `int` and `4.5` is `double`.
The compiler cannot choose which type `T` should be.
Fix: `max_of<double>(3, 4.5)` or use two template parameters.

**4.** **Calculation:** How many template instantiations are generated by this code?

```cpp
template<typename T>
T identity(T x) { return x; }

identity(1);
identity(2);
identity(3.0);
identity(std::string("test"));
identity(42);
```

**Answer:** Three instantiations: `identity<int>`, `identity<double>`, and `identity<std::string>`.
The calls `identity(1)`, `identity(2)`, and `identity(42)` all use `identity<int>` --- the same instantiation.

**5.** **What does this print?**

```cpp
template<typename... Args>
auto sum(Args... args) {
    return (args + ...);
}

std::cout << sum(1, 2, 3, 4, 5) << "\n";
```

**Answer:** Output: `15`

The fold expression `(args + ...)` expands to `1 + (2 + (3 + (4 + 5)))` = 15.

**6.** **Think about it:** Why must template definitions live in header files?
What would happen if you put a template function's definition in a `.cpp` file and tried to use it from another `.cpp` file?

**Answer:** Templates must be in headers because the compiler generates code for each instantiation at the point of use.
If the definition is in a `.cpp` file, other translation units cannot see it, and the linker will report "undefined reference" errors for the instantiations they need.

**7.** **Where is the bug?**

```cpp
template<typename T>
class Holder {
public:
    Holder(T val) : value_(val) {}
    T get() const { return value_; }
private:
    T value_;
};

Holder h = "Lose Yourself";
std::cout << h.get() << "\n";
```

What type does CTAD deduce for `T`?
Is this likely what the programmer intended?

**Answer:** CTAD deduces `T` as `const char*`, not `std::string`.
`h.get()` returns `const char*`, which works for printing, but is likely not what the programmer intended --- the pointer points to a string literal with static storage, so it is safe, but operations like concatenation or comparison would behave differently than with `std::string`.
Add a deduction guide or explicitly write `Holder<std::string> h("Lose Yourself")`.

**8.** **What does this print?**

```cpp
template<typename T>
void describe(T) { std::cout << "general\n"; }

template<>
void describe<int>(int) { std::cout << "int\n"; }

describe(42);
describe(3.14);
describe("hello");
```

**Answer:** Output:

```
int
general
general
```

`describe(42)` matches the `int` specialization.
`describe(3.14)` uses the general template (no `double` specialization).
`describe("hello")` uses the general template (no `const char*` specialization).

**9.** **Calculation:** What does `sizeof...(args)` return for this call?

```cpp
template<typename... Args>
int count(Args... args) { return sizeof...(args); }

std::cout << count(1, "two", 3.0, '4', true) << "\n";
```

**Answer:** Output: `5`

There are 5 arguments: `1` (int), `"two"` (const char*), `3.0` (double), `'4'` (char), `true` (bool).

**10.** **Write a program** that defines a class template `Pair<T, U>` with two members `first` and `second`, a constructor, and a `print()` method.
Test it with `Pair<std::string, int>` storing song names and release years.
Add a deduction guide so that `Pair("I Gotta Feeling", 2009)` deduces `Pair<std::string, int>`.

**Answer:** This is a program exercise --- no single answer.
The program should define `Pair<T,U>` with `first`, `second`, a constructor, and `print()`.
A deduction guide `Pair(const char*, int) -> Pair<std::string, int>` enables the CTAD usage shown.

**11.** **What does this print?**
And which return type does each function actually return?

```cpp
#include <iostream>
#include <vector>

auto first_leading(std::vector<int>& v) {
    return v.front();
}

auto first_trailing(std::vector<int>& v) -> int& {
    return v.front();
}

int main() {
    std::vector<int> v = {1, 2, 3};
    first_leading(v) = 99;       // (a)
    first_trailing(v) = 99;      // (b)
    std::cout << v.front() << "\n";
    return 0;
}
```

Which assignment compiles, which one does not, and why?
What does this say about when to spell the return type explicitly with the trailing form?

**Answer:** Line `(a)` does not compile; line `(b)` does.
`first_leading` uses leading-`auto` return-type deduction.
The deduction rules for plain `auto` strip references: `v.front()` returns an `int&`, but `auto` deduces `int`, so the function returns by *value*.
`first_leading(v) = 99;` therefore tries to assign to a temporary `int` --- a compile error in `(a)` ("assignment to rvalue").

`first_trailing` spells the return type explicitly as `-> int&`, so it returns the actual reference into the vector.
`first_trailing(v) = 99;` succeeds in `(b)` and writes `99` into the vector's first element, so the program prints `99` once line `(a)` is removed.

The lesson: when you want to return a reference (or any specific type that `auto` would strip or wrap), spell the return type out.
The trailing form is one clean way to do that --- it lets the compiler tell you what is going on, instead of silently giving you a copy.
You could also write the same intent with leading-form `auto&` or by spelling the type up front.

# Chapter 3: The Standard Template Library

**1.** **Think about it:** Why does `std::map::operator[]` insert a default value when the key is missing, instead of throwing an exception?
What would the implications be if it threw instead?

**Answer:** `operator[]` inserts a default value because the alternative (throwing) would make the common pattern `map[key] = value` fail for new keys.
You would need to call `insert` or check `find` before every assignment.
The current design makes insertion and access share the same syntax, at the cost of accidental insertion on read.

**2.** **What does this print?**

```cpp
std::map<std::string, int> m;
m["b"] = 2;
m["a"] = 1;
m["c"] = 3;

for (const auto& [k, v] : m) {
    std::cout << k << v;
}
std::cout << "\n";
```

**Answer:** Output: `a1b2c3`

`std::map` stores entries sorted by key.
The keys are "a", "b", "c" in alphabetical order.

**3.** **Where is the bug?**

```cpp
std::map<std::string, int> scores;
scores["Alice"] = 95;
scores["Bob"] = 87;

int charlie_score = scores["Charlie"];
std::cout << "Charlie: " << charlie_score << "\n";
```

**Answer:** `scores["Charlie"]` inserts a default `int` (0) because "Charlie" does not exist in the map.
After this line, the map has three entries and `charlie_score` is 0.
This is a bug if the intent was to check whether Charlie has a score --- use `find()` or `contains()` instead.

**4.** **What does this print?**

```cpp
std::set<int> s = {5, 3, 1, 4, 1, 5, 3};
std::cout << s.size() << "\n";
```

**Answer:** Output: `4`

The set contains unique values only: {1, 3, 4, 5}.
Duplicates (1, 5, 3) are ignored.

**5.** **Calculation:** A `std::map<std::string, int>` has 1,000,000 entries.
Approximately how many comparisons does a lookup require?
(Hint: O(log n) with base 2.)

**Answer:** log$_2$(1,000,000) $\approx$ 20.
A lookup requires approximately 20 comparisons.

**6.** **Think about it:** When would you choose `std::map` over `std::unordered_map`?
Give two concrete scenarios.

**Answer:** Use `std::map` when: (1) you need sorted iteration (e.g., printing entries in alphabetical order), or (2) you need range queries (e.g., "find all keys between A and M").
`std::unordered_map` cannot do either efficiently.

**7.** **What does this print?**

```cpp
std::stack<int> s;
s.push(10);
s.push(20);
s.push(30);
s.pop();
std::cout << s.top() << "\n";
s.pop();
std::cout << s.top() << "\n";
```

**Answer:** Output:

```
20
10
```

After pushing 10, 20, 30: stack is [10, 20, 30] (top = 30).
After `pop()`: stack is [10, 20] (top = 20).
Print `top()`: 20.
After `pop()`: stack is [10] (top = 10).
Print `top()`: 10.

**8.** **Where is the bug?**

```cpp
std::priority_queue<int> pq;
pq.push(5);
pq.push(15);
pq.push(10);

int smallest = pq.top();
std::cout << "Smallest: " << smallest << "\n";
```

**Answer:** The programmer expects `smallest` to be 5 (the smallest element), but `priority_queue` is a **max-heap** by default.
`top()` returns 15 (the largest), not 5.
Fix: use `std::priority_queue<int, std::vector<int>, std::greater<int>>` for a min-heap.

**9.** **What does this print?**

```cpp
std::multiset<int> ms = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5};
std::cout << ms.count(5) << "\n";
```

**Answer:** Output: `3`

`std::multiset` allows duplicates, so all 11 elements are stored.
The multiset contains {1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9}.
`count(5)` returns 3.

**10.** **Write a program** that reads words from the user (one per line, until they type "done") and uses a `std::map<std::string, int>` to count how many times each word was entered.
Print the word counts in alphabetical order.

**Answer:** This is a program exercise --- no single answer.
The program should read words in a loop, store counts in a map, and print sorted results.

**11.** **What does this print?**

```cpp
#include <deque>
#include <iostream>

int main() {
    std::deque<int> d = {2, 3};
    d.push_front(1);
    d.push_back(4);
    for (auto it = d.crbegin(); it != d.crend(); ++it) {
        std::cout << *it << " ";
    }
    std::cout << "\n";
    return 0;
}
```

**Answer:** Output: `4 3 2 1 `

`d` after the two pushes is `{1, 2, 3, 4}`.
`crbegin` is a const reverse iterator pointing at the *last* element (`4`).
Incrementing it walks toward the front, so the loop prints `4 3 2 1`.

**12.** **Where is the bug?**

```cpp
#include <vector>

int main() {
    std::vector<int> v = {1, 2, 3, 4, 5};
    for (auto it = v.begin(); it != v.end(); ++it) {
        if (*it % 2 == 0) {
            v.erase(it);
        }
    }
    return 0;
}
```

What goes wrong on the first even element?
Rewrite the loop two ways: once using the value `erase` returns, and once using a single call to a C++20 algorithm.

**Answer:** `v.erase(it)` invalidates `it`, so the next `++it` in the `for` header reads a dangling iterator --- undefined behavior, and on most implementations it skips the element right after the one you erased *and* may eventually walk off the end.

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

**13.** **Think about it:** Which iterator category does `std::map<std::string, int>::iterator` belong to?
Why can you not call `std::sort` on a `std::map`'s iterators, and what is the alternative if you really want to "sort" a map?

**Answer:** It is a **bidirectional** iterator: you can `++it`, `--it`, and dereference, but you cannot do `it + 5` or compute distances in O(1).
`std::sort` requires *random-access* iterators, so the call does not even compile on a `map`.

The conceptual reason is deeper: a `map` is *already* sorted by key, by definition.
What people usually mean by "sort a map" is "sort the entries by *value*."
The standard answer is to copy the entries into a `std::vector<std::pair<Key, Value>>`, then sort *that* with a custom comparator:

```cpp
std::vector<std::pair<std::string, int>> rows(m.begin(), m.end());
std::sort(rows.begin(), rows.end(),
          [](const auto& a, const auto& b) { return a.second < b.second; });
```

**14.** **Where is the bug?**

```cpp
#include <unordered_set>

struct Point { int x, y; };

int main() {
    std::unordered_set<Point> seen;
    seen.insert({1, 2});
    return 0;
}
```

What two things is the program missing?
Add the smallest changes that make it compile and behave correctly.

**Answer:** Two missing pieces:

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

**1.** **Think about it:** Why do you think the standard library provides both `std::sort(v.begin(), v.end())` and `std::ranges::sort(v)`?
If the ranges version is simpler, why keep the iterator version?

**Answer:** The iterator version is kept for backward compatibility --- decades of existing code call it, and removing it would break that code.
The ranges version is not just shorter: it adds projections, concept-checked arguments, and much clearer error messages when you pass something unsortable.
Both forms handle subranges --- ranges algorithms also accept iterator-sentinel pairs --- so the difference is convenience and safety, not capability.

**2.** **What does this print?**

```cpp
std::vector<int> v = {5, 3, 8, 1, 9, 2};
std::sort(v.begin(), v.end());
auto it = std::find(v.begin(), v.end(), 8);
std::cout << *it << " " << *(it - 1) << "\n";
```

**Answer:** Output: `8 5`

After sorting: {1, 2, 3, 5, 8, 9}.
`find` returns an iterator to 8 (index 4).
`*(it - 1)` is the element before 8, which is 5.

**3.** **What does this print?**

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
auto result = std::count_if(v.begin(), v.end(),
    [](int n) { return n % 2 != 0; });
std::cout << result << "\n";
```

**Answer:** Output: `3`

`count_if` counts elements where `n % 2 != 0` (odd numbers).
The odd numbers in {1, 2, 3, 4, 5} are 1, 3, 5 --- count is 3.

**4.** **Where is the bug?**

```cpp
std::vector<int> nums = {10, 20, 30};
std::vector<int> doubled;

std::transform(nums.begin(), nums.end(), doubled.begin(),
    [](int n) { return n * 2; });
```

**Answer:** `doubled` is empty (size 0), so `doubled.begin()` points nowhere.
`std::transform` writes past the end of `doubled` --- undefined behavior.
Fix: create `doubled` with the right size: `std::vector<int> doubled(nums.size());`.

**5.** **Calculation:** Given this code:

```cpp
std::vector<int> v = {4, 7, 2, 9, 1};
int x = std::accumulate(v.begin(), v.end(), 10);
```

What is the value of `x`?

**Answer:** `x` = 33.
`accumulate` starts with 10 and adds each element: 10 + 4 + 7 + 2 + 9 + 1 = 33.

**6.** **What does this print?**

```cpp
int factor = 3;
auto multiply = [factor](int n) { return n * factor; };
std::cout << multiply(5) << " " << multiply(10) << "\n";
```

**Answer:** Output: `15 30`

The lambda captures `factor` (3) by value.
`multiply(5)` = 5 * 3 = 15.
`multiply(10)` = 10 * 3 = 30.

**7.** **Where is the bug?**

```cpp
std::vector<int> nums = {1, 2, 3, 4, 5};
int total = 0;

std::for_each(nums.begin(), nums.end(), [total](int n) mutable {
    total += n;
});

std::cout << "Total: " << total << "\n";
```

**Answer:** Output: `Total: 0`

The lambda captures `total` **by value** (`[total]`), and `mutable` only lets the lambda modify its own private copy.
The code compiles and the increments accumulate inside the lambda's copy of `total`; the `total` in the enclosing scope stays 0.
Fix: capture by reference (`[&total]`) and drop the `mutable`.

**8.** **Think about it:** Views are "lazy" --- they do not process elements until you iterate.
Why is this an advantage?
Can you think of a situation where processing all elements upfront would be better?

**Answer:** Views are lazy, which means they avoid unnecessary work --- if you only need the first few results from a large dataset, lazy evaluation skips processing the rest.
Upfront processing would be better when you need all results and want to cache them, or when the transformation is expensive and you will iterate the results multiple times (views recompute each time).

**9.** **What does this print?** (Assume C++20)

```cpp
std::vector<int> v = {1, 2, 3, 4, 5, 6, 7, 8};
for (int n : v
        | std::views::filter([](int n) { return n > 3; })
        | std::views::take(3)) {
    std::cout << n << " ";
}
std::cout << "\n";
```

**Answer:** Output: `4 5 6 `

`filter` keeps elements > 3: {4, 5, 6, 7, 8}.
`take(3)` takes the first 3: {4, 5, 6}.

**10.** **Write a program** that stores a list of test scores in a `std::vector<int>`, then uses algorithms and/or views to:

- Sort the scores
- Print only scores above 70
- Print the average score
- Print the highest and lowest scores

**Answer:** This is a program exercise --- no single answer.
The program should sort, filter >70, compute average, and find min/max using algorithms and/or views.

**11.** **What does this print?**

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

int main() {
    std::vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
    std::sort(v.begin(), v.end());
    auto end = std::unique(v.begin(), v.end());
    v.erase(end, v.end());
    for (int n : v) std::cout << n << " ";
    std::cout << "\n";
    return 0;
}
```

Why is the call to `std::sort` essential here?
What does `v` look like if you delete the sort line?

**Answer:** Output: `1 2 3 4 5 6 9 `

`std::unique` only collapses *adjacent* equal elements.
After sorting, `v` becomes `{1, 1, 2, 3, 3, 4, 5, 5, 6, 9}` and the duplicates are now neighbors, so `unique` collapses them to `{1, 2, 3, 4, 5, 6, 9}` (with the tail still containing the old values until you `erase` it).

If you delete the sort line, nothing changes at all: `{3, 1, 4, 1, 5, 9, 2, 6, 5, 3}` has no *adjacent* duplicates, so `unique` removes nothing and the output is the original sequence unchanged.
The combination of "sort, then unique, then erase" is the canonical full-deduplication idiom.

**12.** **Where is the bug?**

```cpp
std::vector<int> v = {1, 2, 3, 4};
std::remove(v.begin(), v.end(), 2);
for (int n : v) std::cout << n << " ";
```

What does the program print, what was the programmer probably expecting, and what is the canonical fix?

**Answer:** The program prints `1 3 4 4 ` (or similar --- the trailing element values are unspecified).
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

**13.** **What does this print?**

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

int main() {
    std::vector<int> sorted = {1, 3, 3, 3, 5, 7, 9};
    auto lo = std::lower_bound(sorted.begin(), sorted.end(), 3);
    auto hi = std::upper_bound(sorted.begin(), sorted.end(), 3);
    std::cout << (hi - lo) << "\n";
    return 0;
}
```

Explain the difference between `lower_bound` and `upper_bound`.

**Answer:** Output: `3`

`lower_bound(v, 3)` returns an iterator to the first element *not less than* 3 --- the first `3`.
`upper_bound(v, 3)` returns an iterator to the first element *greater than* 3 --- the `5`.
The distance between them is the count of `3`s in the sorted range, which is `3`.

This is the same pair `std::map::equal_range` uses, and it is the standard way to find every occurrence of a value in a sorted range without writing a loop.

**14.** **Calculation:** Use `std::iota` (from `<numeric>`) to fill a `std::vector<int>` of size 10 with `1, 2, ..., 10`.
Then use `std::accumulate` (also `<numeric>`) to sum it.
What value does it produce, and why does it match the formula `n(n+1)/2`?

**Answer:**

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

**15.** **What does this print?** (Assume C++23)

```cpp
#include <iostream>
#include <ranges>
#include <string>
#include <vector>

int main() {
    std::vector<std::string> tracks = {"Crazy", "Toxic", "Hey Ya"};
    for (auto [i, name] : std::views::enumerate(tracks)) {
        std::cout << i << ": " << name << "\n";
    }
    return 0;
}
```

What two things does `views::enumerate` produce for each step?
Why does the structured binding `[i, name]` work?

**Answer:** Output:

```
0: Crazy
1: Toxic
2: Hey Ya
```

`views::enumerate` (C++23) produces, for each step, a tuple-like value of `(index, element)`.
The structured binding `[i, name]` peels those two pieces apart into named variables.
This replaces the older indexed-loop idiom (`for (int i = 0; i < v.size(); ++i)`) with something both safer (no off-by-one) and more composable (you can pipe `enumerate` into other views).

# Chapter 5: Enums, constexpr, and Compile-Time Programming

**1.** **Think about it:** Why does `enum class` require `static_cast` to convert to `int`, when the old `enum` converted implicitly?
What bugs does this prevent?

**Answer:** Requiring `static_cast` prevents accidental mixing of enums with integers.
Without it, you could write `if (color == 2)` or `int x = color + 1`, which compiles but is often wrong.
Scoped enums force you to be explicit about conversions, catching bugs like comparing a `Color` to a `TrafficLight` value.

**2.** **What does this print?**

```cpp
enum class Suit : int { Hearts = 0, Diamonds, Clubs, Spades };
int x = static_cast<int>(Suit::Spades);
std::cout << x << "\n";
```

**Answer:** Output: `3`

`Suit::Hearts = 0`, `Diamonds = 1`, `Clubs = 2`, `Spades = 3`.
`static_cast<int>(Suit::Spades)` is 3.

**3.** **Where is the bug?**

```cpp
enum class Priority { Low, Medium, High };

void handle(Priority p) {
    if (p == 2) {
        std::cout << "High priority!\n";
    }
}
```

**Answer:** `p == 2` does not compile because `enum class Priority` does not implicitly convert to `int`.
Fix: `if (p == Priority::High)`.

**4.** **Calculation:** What is the value of `result`?

```cpp
constexpr int power(int base, int exp) {
    int result = 1;
    for (int i = 0; i < exp; ++i) {
        result *= base;
    }
    return result;
}

constexpr int result = power(2, 10);
```

**Answer:** `result` = 1024.
`power(2, 10)` computes 2^10 = 1024.

**5.** **Think about it:** What is the practical difference between `constexpr` and `consteval`?
When would you use one over the other?

**Answer:** `constexpr` functions *can* run at compile time but also work at run time.
`consteval` functions *must* run at compile time --- calling them with run-time values is a compile error.
Use `constexpr` for functions that should work in both contexts.
Use `consteval` when a function only makes sense at compile time (e.g., computing lookup table entries).

**6.** **Where is the bug?**

```cpp
consteval int compute(int x) { return x * x; }

int main() {
    int n;
    std::cin >> n;
    int result = compute(n);
    std::cout << result << "\n";
    return 0;
}
```

**Answer:** `compute(n)` fails to compile because `n` is read from `std::cin` at run time, but `consteval` requires compile-time arguments.
Fix: change `consteval` to `constexpr`, or make `n` a `constexpr` value.

**7.** **What does this print?**

```cpp
template<typename T>
void check(T value) {
    if constexpr (std::is_integral_v<T>) {
        std::cout << value * 2 << "\n";
    } else {
        std::cout << value << "\n";
    }
}

check(5);
check(3.14);
```

**Answer:** Output:

```
10
3.14
```

For `check(5)`, `std::is_integral_v<int>` is true, so it prints `5 * 2 = 10`.
For `check(3.14)`, the condition is false for `double`, so it prints `3.14`.

**8.** **Think about it:** Why does `constinit` exist as a separate keyword from `constexpr`?
What problem does it solve that `constexpr` does not?

**Answer:** `constinit` exists because `constexpr` makes a variable `const` (immutable).
`constinit` guarantees compile-time initialization without making the variable immutable.
This solves the static initialization order fiasco for globals that need to be modified after initialization.

**9.** **Where is the bug?**

```cpp
using StringPair = std::pair<std::string, std::string>;

StringPair get_pair() {
    return {"Hola", "mundo"};
}

auto [a, b] = get_pair();
std::cout << a << " " << b << "\n";
```

(Trick question --- is there actually a bug?)

**Answer:** No bug.
The code is valid C++17.
`get_pair()` returns a `StringPair`, and the structured binding unpacks it.
`"Hola"` and `"mundo"` are implicitly converted to `std::string`.

**10.** **Write a program** that defines a `constexpr` function to convert Fahrenheit to Celsius (`(f - 32) * 5 / 9.0`).
Use `static_assert` to verify that `212` F is `100.0` C and `32` F is `0.0` C.
Then define an `enum class Season { Spring, Summer, Fall, Winter }` and a `constexpr` function that returns a typical temperature for each season.
Print all four seasons and their temperatures.

**Answer:** This is a program exercise --- no single answer.
The program should define `constexpr` Fahrenheit-to-Celsius, use `static_assert` for 212->100 and 32->0, define `enum class Season`, and print temperatures.

**11.** **What does this print?**

```cpp
#include <bit>
#include <cstdint>
#include <iostream>

int main() {
    std::uint32_t x = 0xF0;
    std::cout << std::popcount(x)        << " "
              << std::countl_zero(x)     << " "
              << std::countr_zero(x)     << " "
              << std::has_single_bit(x)  << "\n";
    return 0;
}
```

Walk through each value before you compile.

**Answer:** Output: `4 24 4 0`

`0xF0` in binary is `0000 0000 0000 0000 0000 0000 1111 0000` (32-bit unsigned).

- `popcount` counts the 1-bits: `4`.
- `countl_zero` counts leading zeros from the most significant bit: `24`.
- `countr_zero` counts trailing zeros from the least significant bit: `4`.
- `has_single_bit` is `true` only if exactly one bit is set; `0xF0` has four bits set, so the answer is `0`.

**12.** **Where is the bug?**

```cpp
[[nodiscard]] int parse(const std::string& s);

int main() {
    parse("123");                          // (a)
    int n = parse("456");                  // (b)
    return n;
}
```

Which line does the compiler flag, and what is the right way to silence the warning if you genuinely do not need the result?

**Answer:** The compiler flags line `(a)`, the bare call `parse("123")`, because `parse` is marked `[[nodiscard]]` and the return value is being thrown away.
Line `(b)` assigns the result to `n`, which counts as using it.

If you genuinely need to discard the result --- for instance when calling a side-effect-only API for its other behavior --- there are two canonical silencers: a `(void)` cast, or assignment to `std::ignore`:

```cpp
(void) parse("123");           // explicit "I do not want this value"
std::ignore = parse("123");    // reads naturally in code that already uses tuples
```

Either form acknowledges the discard, which is what `[[nodiscard]]` is asking for.
The warning is not asking you to *use* the value --- only to *say so* when you don't.

**13.** **Think about it:** `[[likely]]` and `[[unlikely]]` are *hints*.
Why does the language not provide a way to *force* one branch order over another?
What information does the compiler have that you might not?

**Answer:** Two reasons.

First, the compiler knows things you do not.
It can profile-guided-optimize from real run data (PGO) and re-pick the layout, knows the target CPU's branch prediction strategy, can see how the surrounding loop body interacts with cache lines, and may have inlined the function into a context where your hint is wrong.
A "force" annotation would lock the compiler into a layout it has good reason to override.

Second, the hints are mostly useful in inner loops where the cost of *being wrong* is small (a few extra branch mispredictions) but the cost of being *right* is real (better instruction layout, fewer cache misses).
Trusting the user with a hard directive turns a small win into a possible regression every time the assumption ages out of date.
Hints let the compiler use them when they help, and ignore them when they don't.

# Chapter 6: Advanced Strings

**1.** **Think about it:** Why is `std::string_view` a better function parameter type than `const std::string&` for functions that only read the string?
What is the main risk of using `string_view`?

**Answer:** `string_view` is better because it works with both `std::string` and `const char*` without copies.
`const std::string&` requires the caller to have a `std::string` --- passing a `const char*` would create a temporary.
The main risk of `string_view` is that it does not own the data, so if the underlying string is destroyed, the view becomes dangling.

**2.** **What does this print?**

```cpp
std::string_view sv = "Estoy aqui";
sv.remove_prefix(6);
std::cout << sv << "\n";
std::cout << sv.size() << "\n";
```

**Answer:** Output:

```
aqui
4
```

`remove_prefix(6)` removes the first 6 characters ("Estoy "), leaving "aqui" with size 4.

**3.** **Where is the bug?**

```cpp
std::string_view get_greeting() {
    std::string s = "Buenos dias";
    return s;
}

std::cout << get_greeting() << "\n";
```

**Answer:** `get_greeting()` returns a `string_view` to a local `std::string`.
The string is destroyed when the function returns, and the view becomes a dangling pointer.
Accessing it is undefined behavior.
Fix: return `std::string` instead.

**4.** **What does this print?**

```cpp
std::regex pattern(R"(\d+)");
std::string text = "Track 7 of 12";
std::smatch match;

if (std::regex_search(text, match, pattern)) {
    std::cout << match[0] << "\n";
}
```

**Answer:** Output: `7`

`regex_search` finds the first match of `\d+` (one or more digits) in the text.
The first sequence of digits is "7" (in "Track 7").

**5.** **Calculation:** What does `std::stoi("0xFF", nullptr, 16)` return?

**Answer:** 255.
With base 16, `std::stoi` accepts and skips an optional `0x` (or `0X`) prefix --- that is why the parse does not stop at the `x`.
`FF` in base 16 is 15*16 + 15 = 255.

**6.** **Think about it:** Why do `std::from_chars` and `std::to_chars` not use exceptions?
What advantage does this give for performance-critical code?

**Answer:** With modern "zero-cost" exception handling, a try/catch block costs essentially nothing until an exception is actually thrown --- but throwing and unwinding are very expensive.
`from_chars` reports failure through an error code, so the failure path is as cheap as the success path --- important when parsing untrusted input where failures are common.
It also performs no allocation and no locale lookups, and it works in code built with `-fno-exceptions`.
For code that parses millions of values (like a data file or network protocol), these properties matter.

**7.** **Where is the bug?**

```cpp
std::string s = "not a number";
int n = std::stoi(s);
std::cout << n << "\n";
```

**Answer:** `std::stoi` throws `std::invalid_argument` because "not a number" cannot be parsed as an integer.
The program crashes with an unhandled exception.
Fix: wrap in try/catch or validate the input first.

**8.** **What does this print?**

```cpp
std::string entry = "Daft Punk - One More Time (2000)";
std::regex re(R"((.+) - (.+) \((\d+)\))");
std::smatch m;
std::regex_match(entry, m, re);
std::cout << m[2] << "\n";
```

**Answer:** Output: `One More Time`

The regex captures three groups: `(.+)` for artist, `(.+)` for title, `(\d+)` for year.
`m[2]` is the second capture group: "One More Time".

**9.** **Think about it:** The `<regex>` library can be slow for complex patterns.
What alternatives exist in the C++ ecosystem for high-performance regex matching?

**Answer:** Alternatives include RE2 (Google's fast regex library), PCRE2 (Perl-compatible regular expressions), Hyperscan (Intel's high-performance regex engine), and CTRE (compile-time regular expressions in C++).
These libraries are optimized for speed and can be orders of magnitude faster than `std::regex`.

**10.** **Write a program** that takes a list of strings in the format "Name:Score" (e.g., "Alice:95", "Bob:87") stored in a `std::vector<std::string>`.
Use `std::regex` or `string_view::find` to parse each entry, convert the score to an `int`, and print the name and score.
Also print the average score.

**Answer:** This is a program exercise --- no single answer.
The program should parse "Name:Score" entries, convert scores, and compute the average.

# Chapter 7: Utilities

**1.** **Think about it:** Why is `std::optional` better than returning a magic value like `-1` or an empty string to indicate "no result"?

**Answer:** A magic value like -1 or "" can be confused with a legitimate value.
Is -1 an error or a valid negative score?
Is "" an error or an empty name?
`std::optional` explicitly distinguishes "no value" from "a value that happens to be zero/empty."
It makes the intent clear and prevents bugs from accidentally using sentinel values as real data.

**2.** **What does this print?**

```cpp
std::optional<int> opt;
std::cout << opt.value_or(42) << "\n";
opt = 7;
std::cout << opt.value_or(42) << "\n";
```

**Answer:** Output:

```
42
7
```

`opt` is empty, so `value_or(42)` returns 42.
After `opt = 7`, `value_or(42)` returns the actual value: 7.

**3.** **Where is the bug?**

```cpp
std::optional<std::string> name;
std::cout << *name << "\n";
```

**Answer:** `*name` dereferences an empty optional --- undefined behavior.
Fix: check `if (name)` first, or use `name.value()` which throws `bad_optional_access`.

**4.** **What does this print?**

```cpp
std::variant<int, std::string> v = 42;
v = "changed";
std::cout << std::holds_alternative<int>(v) << "\n";
std::cout << std::holds_alternative<std::string>(v) << "\n";
```

**Answer:** Output:

```
0
1
```

After `v = "changed"`, the active type is `std::string`.
`holds_alternative<int>` is false (0), `holds_alternative<std::string>` is true (1).

**5.** **Think about it:** When would you use `std::any` instead of `std::variant`?
Give a concrete example.

**Answer:** Use `std::any` when the set of possible types is not known at compile time --- for example, a plugin system where plugins can store arbitrary configuration values.
The host application does not know what types the plugins will use, so `variant` (which requires listing all types) is not feasible.

**6.** **Calculation:** Given:

```cpp
auto t = std::make_tuple(10, 20, 30, 40);
auto [a, b, c, d] = t;
```

What are the values of `a`, `b`, `c`, and `d`?

**Answer:** `a` = 10, `b` = 20, `c` = 30, `d` = 40.
`std::make_tuple(10, 20, 30, 40)` creates a tuple, and the structured binding unpacks each element in order.

**7.** **Where is the bug?**

```cpp
std::variant<int, double, std::string> v = 3.14;
int x = std::get<int>(v);
```

**Answer:** `std::get<int>(v)` throws `std::bad_variant_access` because the active type is `double`, not `int`.
Fix: use `std::get<double>(v)` or check with `holds_alternative<int>` first.

**8.** **What does this print?**

```cpp
std::pair p(std::string("Naive"), 2006);
auto [title, year] = p;
year = 2007;
std::cout << p.second << "\n";
```

**Answer:** Output: `2006`

The structured binding `auto [title, year] = p;` creates **copies** of `p.first` and `p.second`.
`year = 2007` modifies the copy, not `p.second`.
`p.second` is still 2006.

**9.** **Think about it:** The text suggests using a named struct instead of a large tuple for function return values.
Why?
What are the advantages of each approach?

**Answer:** Named structs have descriptive field names: `result.artist` is clearer than `std::get<0>(result)`.
Tuples are convenient for quick returns of 2-3 values and do not require defining a new type.
For larger returns or for types used across multiple functions, a named struct is more maintainable.

**10.** **Write a program** that defines a function `parse_color` which takes a string like `"rgb(255,128,0)"` and returns `std::optional<std::tuple<int, int, int>>`.
Return `std::nullopt` if the format is wrong.
Test it with valid and invalid inputs, and use structured bindings to unpack successful results.

**Answer:** Here is a worked sketch:

```cpp
#include <iostream>
#include <optional>
#include <regex>
#include <string>
#include <tuple>

std::optional<std::tuple<int, int, int>> parse_color(const std::string& s) {
    static const std::regex re(R"(rgb\((\d+),(\d+),(\d+)\))");
    std::smatch m;
    if (!std::regex_match(s, m, re)) {
        return std::nullopt;
    }
    return std::tuple{std::stoi(m[1]), std::stoi(m[2]), std::stoi(m[3])};
}

int main() {
    for (std::string input : {"rgb(255,128,0)", "rgb(1,2)", "cmyk(0,0,0,1)"}) {
        if (auto color = parse_color(input)) {
            auto [r, g, b] = *color;
            std::cout << input << " -> " << r << " " << g << " " << b << "\n";
        } else {
            std::cout << input << " -> invalid\n";
        }
    }
    return 0;
}
```

The regex captures the three digit groups; any format mismatch returns `std::nullopt` instead of a sentinel value.
The caller tests the optional in the `if`, then unpacks the tuple with a structured binding.
A production version would also range-check each component against 0--255 and return `std::nullopt` if one is out of range.

**11.** **Write a `move_assign` function** that uses `std::exchange` to write the canonical move-assignment body:

```cpp
struct Buffer {
    int*        data_  = nullptr;
    std::size_t size_  = 0;
    // ... constructors, destructor that delete[]s data_ ...
};

Buffer& move_assign(Buffer& dst, Buffer&& src) noexcept;
```

The function should:

- free `dst`'s existing storage,
- take `src`'s `data_` pointer (replacing it with `nullptr` in `src`),
- take `src`'s `size_` (replacing it with `0` in `src`), and
- return a reference to `dst`.

Use `std::exchange` for the two takes-and-replaces in a single line each.
Why is `std::exchange` cleaner here than reading + writing the source manually?

**Answer:**

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

**12.** **Where is the bug?**

```cpp
#include <iostream>
#include <thread>

void inc(int& n) { ++n; }

int main() {
    int count = 0;
    std::thread t(inc, count);
    t.join();
    std::cout << count << "\n";
    return 0;
}
```

This program does not compile.
Why does the compiler reject it, what is the fix, and what does the program print once it is fixed?

**Answer:** `std::thread` decay-copies its arguments into storage owned by the new thread, so what it passes to `inc` is a copy (an rvalue) --- and `void inc(int&)` cannot bind a non-const lvalue reference to that.
g++ rejects the program with `static assertion failed: std::thread arguments must be invocable after conversion to rvalues`.

The fix is to wrap the argument in `std::ref` (from `<functional>`):

```cpp
std::thread t(inc, std::ref(count));
```

`std::ref` produces a `std::reference_wrapper<int>`, which the thread machinery still copies by value but which forwards into the call as the original reference.
Once fixed, the program prints `1` --- the `join()` happens before the read, so there is no race.
The same fix applies to `std::async`, `std::bind`, and any other template that copies its arguments when you actually want a reference.

**13.** **What does this print?**

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> a(3, 5);
    std::vector<int> b{3, 5};
    std::cout << a.size() << " " << b.size() << "\n";
    return 0;
}
```

Why do `(3, 5)` and `{3, 5}` give different vectors?

**Answer:** Output: `3 2`

`std::vector<int> a(3, 5);` calls the (size, value) constructor: a vector of size 3, each element `5`.
`std::vector<int> b{3, 5};` calls the `std::initializer_list<int>` constructor: a vector with the elements `3` and `5`, size 2.

The braces flip the choice because *any* constructor that takes `std::initializer_list<T>` is preferred over other constructors when the call site uses `{}` --- a deliberate language rule, but a frequent source of surprise.
The lesson: if you mean "n copies of x," use parentheses; if you mean "these specific elements," use braces.

**14.** **Write a `Track` class** with private `title` and `year` members and define `operator<<` so this works:

```cpp
Track t{"Crazy in Love", 2003};
std::cout << t << "\n";
```

Mention what the `friend` declaration inside the class buys you here, and how the chapter on hidden friends in Chapter 8 changes the recommendation.

**Answer:**

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
That keeps the function invisible to ordinary lookup until ADL needs it (when someone writes `std::cout << t`), which keeps overload sets small, improves error messages, and blocks unwanted implicit conversions; the effect on compile times is real but modest.
For new code, prefer hidden friends; the standalone non-member form is fine for textbooks and small programs.

**15.** **Where is the bug?**
The intent is for `wait_a_bit` to pause for half a second.
What does this code actually do, and what is the one-line fix?

```cpp
#include <chrono>
#include <thread>
void wait_a_bit() {
    std::this_thread::sleep_for(std::chrono::milliseconds{500000});
}
```

**Answer:** `std::chrono::milliseconds{500000}` is a perfectly valid duration --- the bug is its magnitude.
500000 milliseconds is **500 seconds** (8 minutes 20 seconds), not half a second; the intent was 500 milliseconds.
The one-line fix is `std::chrono::milliseconds{500}`, or better, the chrono UDL:

```cpp
std::this_thread::sleep_for(500ms);   // requires using namespace std::chrono_literals;
```

The `ms` suffix makes the unit obvious at the call site --- exactly the kind of magnitude mistake the UDL exists to prevent.

**16.** **What does this print, and which line fails to compile?**

```cpp
#include <chrono>
#include <print>
using namespace std::chrono_literals;

auto a = 1s + 250ms;
auto b = 24h - 30min;
auto c = 5 + 250ms;            // ?
std::println("{} {}", a.count(), b.count());
```

**Answer:** Lines `a` and `b` compile.
`a` is `1250ms` (chrono converts `1s` to `1000ms` and adds), and `b` is `1410min` (chrono converts `24h` to `1440min` and subtracts).
The `std::println` would print `1250 1410`.

Line `c` does **not** compile.
There is no `operator+` between a plain `int` and `std::chrono::milliseconds` --- the chrono types deliberately refuse to mix with raw numbers so that "5 *what*?" cannot slip through.
To fix it you would have to spell out the unit: `5ms + 250ms` or `std::chrono::milliseconds{5} + 250ms`.

**17.** **Write your own UDL** for angles in degrees that converts to radians at compile time:

```cpp
constexpr double operator""_deg(long double v) { /* ... */ }

constexpr double right_angle = 90.0_deg;   // pi / 2
```

Then write `std::sin(right_angle)` and confirm it produces approximately `1.0`.

**Answer:**

```cpp
#include <cmath>
#include <numbers>
#include <print>

constexpr double operator""_deg(long double v) {
    return static_cast<double>(v) * std::numbers::pi / 180.0;
}

int main() {
    constexpr double right_angle = 90.0_deg;
    std::println("sin(90 deg) = {}", std::sin(right_angle));   // 1
}
```

The conversion happens at compile time because both `std::numbers::pi` and the operator function are `constexpr`, so `right_angle` is a compile-time constant equal to `pi / 2`.
`std::sin` then evaluates to approximately `1.0` at run time.

**18.** **Think about it:**
The standard library reserves UDL suffixes that do *not* start with an underscore (e.g. `s`, `ms`, `h`, `sv`).
Why does forcing user-defined suffixes to start with `_` matter for forward compatibility?

**Answer:** The standard library reserves all UDL suffixes that do *not* start with an underscore.
That reservation is what lets future C++ standards add new built-in suffixes (a future `USD` for currency, say, or a `bits` literal for bitsets) without silently breaking existing user code.

If your code defines `operator""USD` and a future standard adds `USD` to `std`, the two would collide --- and the language's lookup rules might pick the standard version, changing the behavior of your program.
By forcing user-defined suffixes to start with `_`, the language guarantees that user-space and standard-library suffixes can never collide, no matter what new suffixes the standard adds.

# Chapter 8: Namespaces and the Preprocessor

**1.** **Think about it:** Why is `using namespace std;` in a header file dangerous?
Give a specific example of a name collision it could cause.

**Answer:** `using namespace std;` in a header makes all of `std`'s names visible in every file that includes the header.
For example, if a project also has a function called `count` or a class called `array`, they would collide with `std::count` or `std::array`, causing ambiguous name errors --- or worse, silently calling the wrong function.

**2.** **What does this print?**

```cpp
namespace a {
    int x = 1;
    namespace b {
        int x = 2;
    }
}

std::cout << a::x << " " << a::b::x << "\n";
```

**Answer:** Output: `1 2`

`a::x` is 1, `a::b::x` is 2.
The inner namespace `b` has its own `x` that shadows `a::x` within `a::b`.

**3.** **Where is the bug?**

```cpp
// file1.cpp
namespace { int count = 0; }

// file2.cpp
extern int count;
void increment() { count++; }
```

**Answer:** `count` in file1.cpp is in an anonymous namespace, giving it internal linkage --- it is only visible within file1.cpp.
`extern int count` in file2.cpp tries to link to a global `count`, which does not exist.
This causes a linker error.

**4.** **Think about it:** When would you use an inline namespace?
Describe a real-world scenario where it would be useful.

**Answer:** Inline namespaces are useful for API versioning.
A library can release v2 as an inline namespace so existing users get the new version by default, while users who need the old behavior can explicitly qualify `mylib::v1::function()`.
This allows gradual migration without breaking existing code.

**5.** **What does this print?**

```cpp
#define DOUBLE(x) x * 2

int result = DOUBLE(3 + 4);
std::cout << result << "\n";
```

**Answer:** Output: `11`

`DOUBLE(3 + 4)` expands to `3 + 4 * 2` (text substitution), which is `3 + 8 = 11`, not `14`.
Fix: `#define DOUBLE(x) ((x) * 2)` which expands to `((3 + 4) * 2) = 14`.

**6.** **Where is the bug?** (And what is the fix?)

```cpp
// utils.h
using namespace std;

string format(int x);
```

**Answer:** `using namespace std;` in a header file.
This pollutes the namespace of every file that includes `utils.h`.
Fix: use `std::string` explicitly in the header.

**7.** **Think about it:** What advantages do C++20 modules have over traditional headers?
Why hasn't the industry fully adopted them yet?

**Answer:** Modules compile faster (parsed once, not re-included everywhere), provide better isolation (macros do not leak), and make include order irrelevant.
The industry has not fully adopted them because compiler and build system support is still maturing, the ecosystem has decades of header-based code, and migration requires significant effort.

**8.** **What does this print?**

```cpp
namespace outer {
    inline namespace inner {
        int value = 42;
    }
}

std::cout << outer::value << "\n";
std::cout << outer::inner::value << "\n";
```

**Answer:** Output:

```
42
42
```

Both `outer::value` and `outer::inner::value` refer to the same variable.
`inner` is an inline namespace, so its contents are accessible directly from `outer`.

**9.** **Calculation:** Given the macro:

```cpp
#define MAX(a, b) ((a) > (b) ? (a) : (b))
```

What is the value of `MAX(3+1, 2+3)`?

**Answer:** `MAX(3+1, 2+3)` expands to `((3+1) > (2+3) ? (3+1) : (2+3))` = `(4 > 5 ? 4 : 5)` = `5`.
The parentheses in the macro protect against precedence issues, so this one works correctly.

**10.** **Write a program** that defines a namespace `music` with sub-namespaces `rock` and `pop`, each containing a function `top_song()` that returns a different string.
Use a `using` declaration to bring one into scope and call both.
Add an anonymous namespace with a helper function used by both sub-namespaces.

**Answer:** This is a program exercise --- no single answer.
The program should define `music::rock::top_song()` and `music::pop::top_song()`, use `using`, and include an anonymous namespace helper.

**11.** **What does this print, and why does it compile?**

```cpp
#include <iostream>
#include <string>

namespace mylib {
    struct Track { std::string title; };

    std::ostream& operator<<(std::ostream& os, const Track& t) {
        return os << "<" << t.title << ">";
    }
}

int main() {
    mylib::Track t{"Mr. Brightside"};
    std::cout << t << "\n";
    return 0;
}
```

Where does the compiler find `operator<<`?
What is the name of the lookup rule that makes the call work without `mylib::operator<<(std::cout, t)`?

**Answer:** Output: `<Mr. Brightside>`

The compiler resolves the unqualified `<<` by **argument-dependent lookup** (ADL).
The right operand of `<<` has type `mylib::Track`, so the compiler also searches `mylib` for an `operator<<` that takes `(std::ostream&, const Track&)`.
It finds `mylib::operator<<` and uses it.

Without ADL, you would have to write `mylib::operator<<(std::cout, t)` every time you wanted to print a `Track`, or pull the operator into the global namespace --- both worse than the rule we have.

**12.** **Where is the bug?**

```cpp
#include <iostream>
#include <string>

struct Loud {
    std::string s;
};

namespace { std::ostream& operator<<(std::ostream& os, const Loud& l) {
    return os << l.s;
} }

int main() {
    Loud x{"BEYONCE"};
    std::cout << x << "\n";
    return 0;
}
```

The program compiles --- but if you move the `operator<<` definition into a namespace `silent { ... }` instead of the anonymous namespace, the call no longer compiles.
Explain the difference in terms of ADL.

**Answer:** The program *does* compile because the anonymous namespace's contents are also injected into the enclosing namespace (the global one here).
The `operator<<` is therefore visible to ordinary unqualified lookup at the call site, with no ADL needed.

If you move the operator into a named namespace `silent { ... }`, ordinary lookup at the call site no longer sees it, and ADL cannot help either: ADL searches the namespaces of the *argument types*.
The argument type is `Loud`, which is in the *global* namespace --- not in `silent`.
So neither lookup pathway finds the operator, and the call fails to compile.

The lesson is the same one the chapter recommends: define a type's free-function operators (and other functions you intend ADL to find) in the *same namespace as the type*.
For a global type, you can define them globally; for a namespaced type, define them in that namespace.

**13.** **Think about it:** In a 100-file project, every translation unit that does any output has to consider every visible `operator<<` overload during overload resolution.
Why might converting `operator<<` definitions from "free function in namespace" to "hidden friend in the class" measurably speed up compilation?

**Answer:** When `operator<<` is a free function in some namespace, every translation unit that does `std::cout << x` for *any* type considers every visible `operator<<` overload during overload resolution.
A namespace with hundreds of streamable types contributes hundreds of candidates to that lookup, even though only one will match.
The cost is paid at every call site, in every translation unit, on every compile.

A hidden friend lives *inside* the class.
It is invisible to ordinary lookup and only appears when ADL specifically searches the class's namespace because one of the arguments has that class's type.
That means each `<<` call only sees the operators relevant to its argument types, not every operator the project has ever defined.
On large codebases, the savings can be a measurable fraction of compile time --- this is the main reason the standard library and Boost moved to hidden friends in their own implementations.

# Chapter 9: RAII and Resource Management

**1.** **Think about it:** Why is RAII considered one of the most important patterns in C++?
How does it compare to try/finally in languages like Java and Python?

**Answer:** RAII is important because C++ uses deterministic destruction --- destructors run at predictable times (scope exit), even during exception unwinding.
This guarantees cleanup without explicit finally blocks.
In Java/Python, try/finally requires the programmer to remember cleanup code, and forgetting it causes leaks.
RAII makes leak-free code the default rather than something you must actively maintain.

**2.** **What happens here?**

```cpp
void risky() {
    FILE* fp = fopen("data.txt", "r");
    process(fp);  // might throw
    fclose(fp);
}
```

What goes wrong if `process` throws an exception?
How would you fix it with RAII?

**Answer:** If `process(fp)` throws, `fclose(fp)` is never called --- the file handle leaks.
Fix: wrap the file handle in an RAII class (like the `FileHandle` class in the chapter) or use `std::unique_ptr<FILE, ...>` with a custom deleter.

**3.** **Think about it:** Why should move constructors and move assignment operators be `noexcept`?
What happens if they are not?

**Answer:** Move constructors should be `noexcept` because the standard library (e.g., `std::vector` during reallocation) falls back to copying if move might throw, to maintain the strong exception guarantee.
A non-noexcept move constructor means `vector::push_back` copies instead of moves, which can be dramatically slower.

**4.** **Where is the bug?**

```cpp
class Connection {
public:
    Connection() { connect(); }
    ~Connection() { disconnect(); }
};

void transfer() {
    Connection c1;
    Connection c2 = c1;  // copy
    // ... work ...
}
```

**Answer:** `Connection c2 = c1;` invokes the compiler-generated copy constructor, which does a memberwise copy and does **not** call `connect()`.
Both objects now share the state of a single connection, and when `c1` and `c2` are destroyed, `disconnect()` runs twice for one `connect()` --- double cleanup.
If `Connection` holds a handle or pointer, both destructors try to release the same resource.
Fix: delete the copy constructor/assignment, or implement them properly.

**5.** **Calculation:** How many times is `fclose` called?

```cpp
{
    auto d = [](FILE* f) { fclose(f); };
    std::unique_ptr<FILE, decltype(d)> f1(fopen("a.txt", "r"), d);
    auto f2 = std::move(f1);
}
```

**Answer:** `fclose` is called exactly once.
`f1` is moved to `f2`, setting `f1`'s internal pointer to null.
When the scope ends, `f1`'s stored pointer is null, so its destructor never invokes the deleter at all; `f2`'s destructor invokes the deleter, which closes the file.

**6.** **Think about it:** What is the difference between the basic guarantee and the strong guarantee?
Give an example where the basic guarantee is sufficient and one where you would want the strong guarantee.

**Answer:** The basic guarantee ensures no leaks and valid state but allows partial changes --- sufficient for most operations where the caller can handle an inconsistent state.
The strong guarantee (rollback on failure) is needed when partial modifications would leave the system in a confusing state --- e.g., a bank transfer that debits one account but fails to credit the other.

**7.** **Where is the bug?**

```cpp
void process() {
    auto ptr = std::make_unique<int[]>(100);
    // ... do work ...
    ptr.release();  // "release" the memory
}
```

**Answer:** `ptr.release()` releases ownership (returns the raw pointer and sets the unique_ptr to null) but does **not** free the memory.
The returned pointer is ignored, causing a memory leak.
If the intent was to free the memory, simply let the `unique_ptr` go out of scope --- it will call `delete[]` automatically.

**8.** **What does this print?**

```cpp
{
    ScopeGuard g1([]() { std::cout << "A "; });
    ScopeGuard g2([]() { std::cout << "B "; });
    ScopeGuard g3([]() { std::cout << "C "; });
}
```

(Using the ScopeGuard class from this chapter.)

**Answer:** Output: `C B A `

Scope guards are destroyed in reverse order of construction (LIFO, like all local variables).
`g3` runs first ("C"), then `g2` ("B"), then `g1` ("A").

**9.** **Think about it:** Why does `shared_ptr` not include the deleter in its type, while `unique_ptr` does?
What design trade-off does this represent?

**Answer:** `unique_ptr` includes the deleter in its type to avoid overhead --- the deleter is stored as part of the object (zero-size for stateless deleters like function pointers).
`shared_ptr` stores the deleter in a separate control block (type-erased) so that `shared_ptr<T>` has a uniform type regardless of the deleter.
This lets you store `shared_ptr`s with different deleters in the same container, at the cost of a heap allocation for the control block.

**10.** **Write a program** that wraps `malloc`/`free` in a `unique_ptr` with a custom deleter.
Allocate an array of 10 integers, fill them with values, print them, and verify the memory is freed by printing a message in the deleter.

**Answer:** This is a program exercise --- no single answer.
The program should use `unique_ptr<int, ...>` with a `free`-calling deleter for `malloc`'d memory.

**11.** **Where is the bug?**

```cpp
class CacheError : public std::exception {
public:
    CacheError(const std::string& key) : key_("cache miss: " + key) {}
    const char* what() const noexcept override { return key_.c_str(); }
private:
    std::string key_;
};
```

The class compiles, but it is missing the small refinement that the chapter recommends.
Rewrite it the recommended way and explain what you bought.

**Answer:** It compiles but inherits from `std::exception` directly --- which means *you* are responsible for the `what()` plumbing and the storage for the message string.
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

**12.** **Think about it:** The Meyers singleton uses a function-local `static`.
Why is the function form preferred over a `static` data member at namespace scope?
Mention what changed in C++11 that made this idiom safe in multithreaded programs.

**Answer:** Two reasons.

First, **lazy initialization**.
A namespace-scope `static Logger global_logger;` is constructed before `main` runs, regardless of whether anyone calls into the singleton.
A function-local `static` is constructed the first time the function is called --- so a singleton you never reach pays no cost.

Second, **predictable order**.
Two namespace-scope `static`s in different translation units have unspecified relative initialization order ("static initialization order fiasco"); if one depends on the other, you can get a use-before-init crash that disappears as soon as you change the link order.
Function-local `static`s are initialized in the order their functions are first called, so dependencies between singletons resolve naturally.

C++11 added a third reason: the standard now *requires* function-local `static` initialization to be thread-safe.
Two threads racing to call `instance()` for the first time will not produce two instances and will not corrupt the construction --- the language guarantees the first thread runs the initialization while the second waits.
Before C++11, you needed double-checked locking; now you do not.

**13.** **What does this print?**

```cpp
#include <iostream>
#include <typeinfo>

class Animal { public: virtual ~Animal() = default; };
class Cat : public Animal {};
class Dog : public Animal {};

int main() {
    Cat   c;
    Animal& a1 = c;
    Animal* a2 = new Dog();

    std::cout << (typeid(a1) == typeid(Cat))   << " "
              << (typeid(a1) == typeid(Dog))   << " "
              << (typeid(*a2) == typeid(Dog))  << " "
              << (typeid(a2) == typeid(Dog*))  << "\n";

    delete a2;
    return 0;
}
```

Pay attention to which expressions are dereferenced and which are not.

**Answer:** Output: `1 0 1 0`

- `typeid(a1) == typeid(Cat)`: `a1` is a reference to a polymorphic type, so `typeid` reports the *dynamic* type, which is `Cat`. **1**.
- `typeid(a1) == typeid(Dog)`: same `a1`, dynamic type is `Cat`, not `Dog`. **0**.
- `typeid(*a2) == typeid(Dog)`: `*a2` dereferences the polymorphic pointer; dynamic type is `Dog`. **1**.
- `typeid(a2) == typeid(Dog*)`: `a2` itself is *not* polymorphic (a pointer is not a polymorphic class type), so `typeid` reports the static type, which is `Animal*`, not `Dog*`. **0**.

The fourth case is the trap: `typeid` only does runtime lookup when applied to a *polymorphic class* lvalue --- a pointer is not a polymorphic class, so the rule does not kick in.
Dereferencing the pointer brings you back into polymorphic-class territory, which is why `*a2` works correctly.

**14.** **What is the deduced type of each variable?**

```cpp
int        x = 5;
const int& cref = x;

auto           a = cref;      // (a)
auto&          b = cref;      // (b)
decltype(cref) c = cref;      // (c)
decltype(x)    d = cref;      // (d)
```

Explain the rules behind each deduction.

**Answer:**

| Variable                    | Type        | Why |
|:----------------------------|:------------|:----|
| (a) `auto a = cref;`        | `int`       | `auto` strips top-level `const` and `&`, so the deduced type is the bare `int`. |
| (b) `auto& b = cref;`       | `const int&`| `auto&` only drops the deduced "value vs reference" wrapper; const is preserved through the explicit `&`. |
| (c) `decltype(cref) c = cref;` | `const int&` | `decltype` of a *named* lvalue reference yields the reference type exactly as declared --- no stripping. |
| (d) `decltype(x) d = cref;` | `int`       | `decltype(x)` is the type of the *declaration* of `x`, which is `int`. The initializer's type is irrelevant. |

The rule of thumb: `auto` "thinks like a function parameter" (strips top-level cv and references), `decltype` "thinks like a type query" (preserves whatever the expression's type actually is).
For perfectly-forward-style code where you need to capture the exact type of an expression --- including reference and const --- reach for `decltype`.

# Chapter 10: Concurrency

**1.** **Think about it:** Why must every `std::thread` be either joined or detached?
What happens if you destroy a joinable thread?

**Answer:** A joinable thread owns a system thread.
If the `std::thread` destructor runs while the thread is still joinable, the program calls `std::terminate` --- a deliberate crash.
This prevents the accidental situation where a thread continues running with references to destroyed local variables.
You must explicitly choose: `join()` to wait, or `detach()` to let it run independently.

**2.** **Where is the bug?**

```cpp
int total = 0;

void add(int n) { total += n; }

std::thread t1(add, 100);
std::thread t2(add, 200);
t1.join();
t2.join();

std::cout << total << "\n";
```

**Answer:** Data race on `total`.
Both threads read and write `total` without synchronization.
The result is undefined --- it could be 100, 200, 300, or anything else.
Fix: use `std::atomic<int>` for `total`, or protect it with a mutex.

**3.** **Think about it:** Why does `std::lock_guard` not have `unlock()` and `lock()` methods, while `std::unique_lock` does?
When would you need the extra flexibility?

**Answer:** `lock_guard` is designed for the common case: lock at construction, unlock at destruction, nothing else.
Its simplicity prevents misuse.
`unique_lock` adds `unlock()` and `lock()` because some patterns require it --- condition variables need the lock to be released while waiting, and some algorithms need to unlock temporarily for non-critical work.

**4.** **What does this program print?**

```cpp
std::atomic<int> x(0);

std::thread t1([&]() { x++; x++; x++; });
std::thread t2([&]() { x++; x++; x++; });
t1.join();
t2.join();

std::cout << x << "\n";
```

**Answer:** Output: `6`

Each thread increments `x` three times atomically.
Two threads × 3 increments = 6.
The exact interleaving varies, but the final value is always 6 because atomic operations are indivisible --- no increment is ever lost.

**5.** **Where is the deadlock?**

```cpp
std::mutex m1, m2;

void thread_a() {
    std::lock_guard<std::mutex> lock1(m1);
    std::lock_guard<std::mutex> lock2(m2);
    // ...
}

void thread_b() {
    std::lock_guard<std::mutex> lock1(m2);
    std::lock_guard<std::mutex> lock2(m1);
    // ...
}
```

How would you fix it?

**Answer:** `thread_a` locks m1 then m2.
`thread_b` locks m2 then m1.
If thread_a locks m1 and thread_b locks m2 simultaneously, each waits for the other's lock --- deadlock.
Fix: lock in the same order in both threads, or use `std::scoped_lock lock(m1, m2)`.

**6.** **Think about it:** When should you use `std::async` instead of creating a `std::thread` manually?
What are the advantages?

**Answer:** Use `std::async` when you want a result from a background computation.
It handles thread creation, exception propagation, and result retrieval automatically.
Use `std::thread` when you need control over the thread's lifetime, want to detach it, or need to manage multiple threads in a thread pool.

**7.** **What value does `result` hold?**

```cpp
auto fut = std::async(std::launch::deferred, []() { return 6 * 7; });
// ... other work ...
int result = fut.get();
```

**Answer:** `result` = 42.
`std::launch::deferred` means the lambda runs lazily when `fut.get()` is called.
6 * 7 = 42.

**8.** **Where is the bug?**

```cpp
std::mutex mtx;

void process() {
    mtx.lock();
    if (some_condition()) {
        return;  // oops
    }
    // ... more work ...
    mtx.unlock();
}
```

**Answer:** If `some_condition()` returns true, the function returns with the mutex still locked --- deadlock.
`mtx.unlock()` is never called on that path.
Fix: use `std::lock_guard<std::mutex> lock(mtx)` at the top of the function --- it unlocks automatically on any exit path.

**9.** **Think about it:** Why is `std::atomic` faster than using a mutex for simple counters?
When would you still prefer a mutex over an atomic?

**Answer:** `std::atomic` is faster for simple operations (counter increment, flag toggle) because it uses hardware-level atomic instructions (like `lock xadd` on x86) with no context switches.
A mutex involves kernel calls when contended, which is much more expensive.
Prefer a mutex when you need to protect multiple variables or a complex data structure --- atomics only protect individual values.

**10.** **Write a program** that uses four threads to compute the sum of a large vector (1 million elements).
Each thread should sum one quarter of the vector.
Use `std::async` and `std::future` to collect the partial sums, then print the total.

**Answer:** This is a program exercise --- no single answer.
The program should split a vector into quarters, use `async` to sum each quarter, collect results with `future::get()`, and print the total.

**11.** **Where is the bug?**

```cpp
#include <atomic>
#include <chrono>
#include <thread>

std::atomic<bool> stop_flag{false};

void worker() {
    while (!stop_flag) {
        std::this_thread::sleep_for(std::chrono::seconds(60));
    }
}

int main() {
    std::thread t(worker);
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    stop_flag = true;
    t.join();
    return 0;
}
```

The program waits almost a full minute before exiting.
What is the conceptual problem with the polling design, and how would you rewrite the worker using `std::jthread` and a stop token?

**Answer:** The worker only checks the flag *between* sleeps, and each sleep lasts 60 seconds.
`main` sleeps 100 ms and then sets `stop_flag` --- by that point the worker is already inside its 60-second `sleep_for`, so it cannot observe the change until the sleep ends.
The program really does wait almost a full minute: a sleeping thread cannot observe a flag promptly, and the shutdown latency is bounded by the sleep length.

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
    return 0;                                // jthread dtor calls request_stop() and join()
}
```

The cleanest version uses `std::condition_variable_any::wait_for` with the stop token, so the wait is interrupted immediately when `request_stop()` is called.
For everyday code, the short-sleep loop above is good enough.

**12.** **Think about it:** `std::scoped_lock(mtx1, mtx2)` uses a deadlock-avoidance algorithm internally.
Why is hand-rolled "lock `mtx1`, then lock `mtx2`" prone to deadlock when two threads call it from opposite sides?
Sketch the interleaving that causes the deadlock and explain why `scoped_lock` cannot deadlock the same way.

**Answer:** The classic two-mutex deadlock:

- Thread A acquires `mtx1`, then tries to acquire `mtx2`.
- Thread B acquires `mtx2`, then tries to acquire `mtx1`.
- Each thread holds one mutex and waits for the other. Neither can proceed --- deadlock.

`scoped_lock` defers to `std::lock`, which is guaranteed to acquire all the mutexes without deadlocking.
A typical implementation *tries* to lock all the mutexes and, if any of them is already held, releases the ones it already acquired and starts over, iterating until it can grab them all.
That back-off means a thread never holds one mutex while blocking indefinitely on another: at most one thread is making no progress at any moment, and progress always resumes once the other thread releases its mutex.

The trade-off: under heavy contention the retry loop can waste work --- a thread may acquire and release the same mutexes several times before it wins, burning CPU that a strict global lock ordering would not.
For low-contention workloads the cost is negligible; for high-contention workloads, the right answer is usually to redesign so you do not need two locks at once.

**13.** **Calculate:** A `std::atomic<int> counter` starts at 10.
Eight threads each perform 25000 `counter.fetch_add(1)` calls, and all eight are joined.
What is the final value of `counter`?
Would the result be deterministic if `counter` were a plain `int` instead?

**Answer:** 10 + 8 * 25000 = **200010**.
The result is deterministic because `fetch_add` is atomic --- each increment is indivisible, so no increment is ever lost, regardless of how the threads interleave.

With a plain `int`, eight threads writing without synchronization is a data race --- undefined behavior.
In practice increments get lost when two threads read the same old value and both write back old + 1, so the observed value is indeterminate (typically well below 200010), and the standard makes no promises at all about what the program does.

# Chapter 11: The Filesystem Library

**1.** **Think about it:** Why does `std::filesystem::path` use `/` as the concatenation operator instead of `+`?
What would go wrong with `+`?

**Answer:** `+` on strings just concatenates characters.
`"/home/user" + "music"` would produce `"/home/usermusic"` --- no separator.
The `/` operator is overloaded to insert the correct path separator, giving `"/home/user/music"`.
It also handles edge cases like trailing separators.

**2.** **What does this print?**

```cpp
fs::path p = "/home/user/docs/report.pdf";
std::cout << p.stem() << "\n";
std::cout << p.extension() << "\n";
std::cout << p.parent_path().filename() << "\n";
```

**Answer:** Output:

```
"report"
".pdf"
"docs"
```

`stem()` is the filename without extension: "report".
`extension()` includes the dot: ".pdf".
Calling `filename()` on the parent path gives its last component: "docs".

**3.** **Where is the bug?**

```cpp
auto size = fs::file_size("maybe_missing.txt");
std::cout << "Size: " << size << "\n";
```

**Answer:** `file_size("maybe_missing.txt")` throws `filesystem_error` if the file does not exist.
Fix: check `fs::exists()` first, or use the `error_code` overload:
`auto size = fs::file_size("maybe_missing.txt", ec);`

**4.** **Think about it:** What is the difference between `directory_iterator` and `recursive_directory_iterator`?
When would you use each?

**Answer:** `directory_iterator` lists entries in a single directory (it does not recurse).
The recursive variant walks the entire directory tree, descending into subdirectories.
Use `directory_iterator` when you only care about immediate children.
Use the recursive form when you need to find files anywhere in a tree (e.g., finding all `.cpp` files in a project).

**5.** **What does this print?**

```cpp
fs::path p = "/home/user/./docs/../music/track.mp3";
std::cout << p.lexically_normal() << "\n";
```

**Answer:** Output: `"/home/user/music/track.mp3"`

`lexically_normal()` resolves `.` (current directory) and `..` (parent directory), simplifying the path.

**6.** **Calculation:** You call `create_directories("/a/b/c/d")` on a system where only `/a` exists.
How many new directories are created?

**Answer:** Three directories: `b`, `c`, and `d`.
`/a` already exists, so `create_directories` creates `b` inside `a`, `c` inside `b`, and `d` inside `c`.

**7.** **Where is the bug?**

```cpp
fs::create_directory("/new_project/src/main");
```

(Assume `/new_project` does not exist yet.)

**Answer:** `create_directory` only creates one level.
If `/new_project` does not exist, creating `/new_project/src/main` fails because the parent `/new_project/src` does not exist.
Fix: use `fs::create_directories("/new_project/src/main")`.

**8.** **Think about it:** Why does `remove_all` return the number of entries removed?
When would this be useful?

**Answer:** `remove_all` returns the count so you can verify the operation --- e.g., if you expect to remove a directory with 100 files and the count is 3, something is wrong.
It is also useful for logging and diagnostics.

**9.** **What happens?**

```cpp
fs::copy_file("a.txt", "b.txt");
fs::copy_file("a.txt", "b.txt");
```

What happens on the second call?
How would you fix it?

**Answer:** The second `copy_file` throws `filesystem_error` because `b.txt` already exists and the default option is `copy_options::none` (fail if destination exists).
Fix: use `fs::copy_file("a.txt", "b.txt", fs::copy_options::overwrite_existing)`.

**10.** **Write a program** that takes a directory path as a command-line argument and prints a summary: the total number of files, the total number of directories, and the total size of all regular files in bytes.
Use `recursive_directory_iterator` to walk the tree.

**Answer:** This is a program exercise --- no single answer.
The program should take a directory argument, use `recursive_directory_iterator`, and count files, directories, and total bytes.

# Chapter 12: Best Practices and Common Idioms

**1.** **Think about it:** Why does the text recommend starting with `const` and removing it only when needed, rather than the other way around?

**Answer:** Starting with `const` is safer because you can only forget to add mutability, not accidentally add it.
If everything is const by default, the compiler catches any attempt to modify something that should not change.
Going the other way (adding `const` later), you might miss variables that should have been const, allowing bugs where values are accidentally modified.

**2.** **Think about it:** When should you follow the Rule of Zero vs. the Rule of Five?
How do you decide?

**Answer:** Follow the Rule of Zero when your class uses only standard library types (string, vector, smart pointers) that manage themselves.
Follow the Rule of Five when your class directly manages a resource (raw pointer, file descriptor, etc.).
The decision: if you are writing a destructor, you need all five.
If you are not, you likely need zero.

**3.** **Where is the bug?**

```cpp
class Data {
public:
    Data(int n) : ptr_(new int[n]), size_(n) {}
    ~Data() { delete[] ptr_; }
private:
    int* ptr_;
    int size_;
};

Data a(10);
Data b = a;
```

**Answer:** `Data b = a;` uses the compiler-generated copy constructor, which copies the raw pointer `ptr_`.
Now `a.ptr_` and `b.ptr_` point to the same memory.
When `a` and `b` are destroyed, both destructors call `delete[] ptr_` on the same address --- double free (undefined behavior).
Fix: define a copy constructor that allocates new memory and copies the contents, or delete the copy constructor and use smart pointers.

**4.** **Think about it:** What are the trade-offs between CRTP (static polymorphism) and virtual functions (dynamic polymorphism)?
When would you choose each?

**Answer:** CRTP (static): resolved at compile time, no vtable overhead, the compiler can inline calls.
But you cannot store different CRTP-derived types in the same container.
Virtual functions (dynamic): resolved at run time, vtable overhead, but you can store `Base*` pointers to any derived type in a single container.
Choose CRTP for performance-critical code where types are known at compile time.
Choose virtual functions when you need run-time flexibility.

**5.** **What does this print?**

```cpp
auto x = 42;
auto y = 3.14;
auto z = x + y;
std::cout << z << "\n";
```

**Answer:** Output: `45.14`

`auto x = 42` deduces `int`.
`auto y = 3.14` deduces `double`.
`auto z = x + y`: `int + double` promotes to `double`, so `z` is `45.14`.

**6.** **Think about it:** Why must the PIMPL destructor be defined in the `.cpp` file?
What error do you get if you let the compiler generate it in the header?

**Answer:** `unique_ptr` needs the complete type (including the destructor) to destroy the object.
In the header, `Impl` is only forward-declared (incomplete type).
If the compiler generates the destructor in the header, it cannot call `Impl`'s destructor.
You get a compile error about an incomplete type.
Defining `~Playlist() = default;` in the `.cpp` file (where `Impl` is complete) solves this.

**7.** **Where is the problem?**

```cpp
void add_to_vector(std::vector<int> v, int x) {
    v.push_back(x);
}

std::vector<int> data = {1, 2, 3};
add_to_vector(data, 4);
std::cout << data.size() << "\n";
```

**Answer:** `add_to_vector` takes the vector by **value**, not by reference.
It modifies a copy, not the original.
`data.size()` is still 3 after the call.
Fix: `void add_to_vector(std::vector<int>& v, int x)`.

**8.** **Think about it:** The code review checklist mentions checking that comments explain "why" not "what."
Why is this distinction important?
Give an example of a bad comment and a good one for the same code.

**Answer:** Comments explaining "what" are redundant because the code already says what it does.
`// increment counter` above `counter++` adds no information.
Comments explaining "why" provide context the code cannot: `// skip the first element because it's a header row` explains intent.
Good: `// Use stable_sort to preserve relative order of equal-rated songs`.
Bad: `// Sort the songs`.

**9.** **Calculation:** A class has a `std::vector<std::string>` member and a `std::unique_ptr<Widget>` member.
How many special member functions should you write for this class?

**Answer:** Zero.
Both `std::vector<std::string>` and `std::unique_ptr<Widget>` manage their own resources.
The compiler-generated destructor, copy (if applicable), and move operations all do the right thing.
This is the Rule of Zero.
(Note: `unique_ptr` makes the class non-copyable by default, which is probably correct.)

**10.** **Write a program** that uses the CRTP to create a `Printable<Derived>` base class with a `print()` method that calls `Derived::to_string()`.
Create two derived classes (e.g., `Song` and `Album`) that each implement `to_string()`.
Demonstrate calling `print()` on instances of each.

**Answer:** This is a program exercise --- no single answer.
The program should define `Printable<Derived>` with CRTP, `Song` and `Album` derived classes with `to_string()`, and demonstrate `print()`.

# Appendix A: Build Systems and Tooling

**1.** **Think about it:** Why is CMake called a "build system generator" rather than a "build system"?
What does it generate?

**Answer:** CMake generates platform-specific build files (Makefiles, Visual Studio projects, Ninja files).
The actual building is done by those tools (make, msbuild, ninja).
CMake is a meta-build system --- it describes *what* to build, and the native build tool determines *how*.

**2.** **Write a CMakeLists.txt** for a project with `main.cpp`, `audio.cpp`, and `audio.h`.
Set the C++ standard to 23 and enable `-Wall -Wextra -pedantic`.

**Answer:**

```cmake
cmake_minimum_required(VERSION 3.20)
project(AudioApp LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(audioapp main.cpp audio.cpp)
target_include_directories(audioapp PRIVATE ${CMAKE_SOURCE_DIR})
target_compile_options(audioapp PRIVATE -Wall -Wextra -pedantic)
```

**3.** **Think about it:** Why should you compile with `-Wall -Wextra -pedantic` from the start of a project rather than adding them later?

**Answer:** Adding warnings to an existing project often produces hundreds of warnings from code that already works.
Developers either disable the warnings (defeating the purpose) or spend days fixing them.
Starting with warnings from day one means you fix each warning as it appears --- a small incremental cost instead of a large batch.

**4.** **Think about it:** You have a program with a buffer overflow that only corrupts memory silently.
Which sanitizer would catch it?
What compiler flag would you use?

**Answer:** AddressSanitizer catches buffer overflows.
Use `-fsanitize=address -g`.

**5.** **Think about it:** AddressSanitizer and ThreadSanitizer cannot be used together.
Why might that be?
How would you test for both memory and threading bugs?

**Answer:** ASan and TSan both instrument memory accesses but in incompatible ways --- they would interfere with each other's tracking.
To test for both, run your test suite twice: once with `-fsanitize=address` and once with `-fsanitize=thread`.

**6.** **Write a gdb session** (sequence of commands) that:

- Sets a breakpoint at `main`
- Runs the program
- Steps through three lines
- Prints a local variable called `count`
- Continues to the end

**Answer:**

```
break main
run
next
next
next
print count
continue
```

**7.** **Think about it:** What is the difference between `-O0`, `-O2`, and `-O3`?
When would you use each?

**Answer:** `-O0`: no optimization, fastest compile, best for debugging (variables are not optimized away).
`-O2`: standard optimization, good balance of speed and compilation time, used for most release builds.
`-O3`: aggressive optimization, may increase binary size with auto-vectorization and function inlining; use when maximum performance matters and you have tested thoroughly.

**8.** **Where is the bug?**

```cmake
add_executable(myapp main.cpp)
target_link_libraries(myapp fmt)
```

What is missing compared to the example in this chapter?

**Answer:** Missing `PRIVATE` (or `PUBLIC`/`INTERFACE`) keyword in `target_link_libraries`.
Also, `fmt` should be `fmt::fmt` if using FetchContent.
Corrected: `target_link_libraries(myapp PRIVATE fmt::fmt)`.

**9.** **Think about it:** Why does the text recommend running tests with sanitizers enabled?
What kinds of bugs do sanitizers catch that tests alone miss?

**Answer:** Sanitizers detect bugs that tests alone miss because many bugs (buffer overflows, data races, use-after-free) produce correct-looking output most of the time.
A test might pass 99% of the time and only fail under specific memory layouts or thread scheduling.
Sanitizers instrument every access and catch the bug deterministically, regardless of whether the test output looks correct.

**10.** **Set up a project** with CMake that has a `main.cpp` and a `math_utils.cpp`/`math_utils.h` library.
The library should have a function `int factorial(int n)`.
Build it with CMake, run it, and then compile with AddressSanitizer enabled and verify it runs cleanly.

**Answer:** This is a program exercise --- no single answer.
The program should have CMakeLists.txt, main.cpp, math_utils.cpp/h with factorial, build with CMake, and run with ASan.

**11.** **Think about it:** Why does C++ rely on third-party package managers (vcpkg, Conan) instead of having a built-in one like Python's `pip` or Rust's `cargo`?
What problem would a built-in package manager have to solve that the language committee has so far avoided?

**Answer:** The combinatorial space.
A package manager has to pick a *single* answer for: which compiler is canonical, which standard library, which version of the language, which ABI, which build system, which platform conventions for headers and libraries.
C++ deliberately does not pick: GCC, Clang, MSVC, libstdc++, libc++, MS STL, Make, CMake, Bazel, Meson, and a dozen other combinations are all valid targets, and the language committee has been reluctant to anoint one as "the" tooling.

A built-in package manager would have to either pick (alienating the rest) or model the cross-product (which is what `vcpkg` and `Conan` already do, with config files describing each binary).
Other languages with built-in tooling --- Rust, Go, Python --- effectively legislate one of these choices, which C++ is structurally unable to do without forking the ecosystem.

The current state ("two community-driven options, both supported, neither blessed") is a compromise that lets C++ be the lingua franca of every platform without picking sides.

**12.** **Write a small project** with one header `track.h` and one source `track.cpp` defining a `Track` class.
Document the class and its public methods with `///` Doxygen comments.
Run `doxygen -g` to generate a `Doxyfile`, edit `INPUT` and `RECURSIVE`, run `doxygen`, and open the generated `html/index.html`.
What does the generated documentation contain that was not literally typed in the comments?

**Answer:** Quite a lot:

- **File lists** organized by directory, with one page per file showing every declaration in that file.
- **Class index** alphabetized, plus a hierarchy view.
- **Member function index** alphabetized.
- **Cross-references**: every mention of `Track` in another comment becomes a hyperlink to the `Track` class page.
- **Source code browser** that links from declarations to definitions and back.
- **Search box** indexed across the whole project.

This `Track` class has no base class, so it gets no inheritance diagram.
For projects that do have class hierarchies, Doxygen can also generate inheritance and collaboration diagrams --- but only when Graphviz is installed and `HAVE_DOT = YES` is set in the Doxyfile (the default is `NO`).

You typed a few `///` lines per class; Doxygen turned them into a fully-navigable mini-website plus a complete API index.
That is the value proposition: write documentation where the code is, get a browseable structure for free.

**13.** **What does this do?** This program is compiled with `g++ -fsanitize=address -g sum.cpp` and run.
What does AddressSanitizer report, and does the program print anything?

```cpp
#include <iostream>

int main() {
    int* data = new int[4]{2, 4, 6, 8};
    int sum = 0;
    for (int i = 0; i <= 4; ++i) {
        sum += data[i];
    }
    std::cout << sum << '\n';
    delete[] data;
    return 0;
}
```

**Answer:** The loop condition `i <= 4` runs `i` from 0 through 4, but `data` has only four elements (indices 0 through 3).
The iteration with `i == 4` reads `data[4]`, one element past the end of the heap array.
AddressSanitizer aborts the program with a heap-buffer-overflow report: `READ of size 4` at an address `0 bytes after` the 16-byte region, with a stack trace pointing at the `sum += data[i];` line.
The program prints nothing --- ASan kills it before `std::cout` runs, and the process exits with code 1.

# Appendix B: Testing

**1.** **Think about it:** Why should tests be independent of each other?
What problems can arise when tests share state?

**Answer:** Shared state means one test can affect another --- a test that modifies a global variable can cause the next test to fail (or pass incorrectly).
This makes failures order-dependent and non-reproducible, which makes debugging much harder.
Independent tests can run in any order and even in parallel.

**2.** **Write a test** (using Google Test syntax) for a function `bool is_palindrome(const std::string& s)` that checks if a string reads the same forwards and backwards.
Include tests for "racecar" (true), "hello" (false), and "" (true).

**Answer:**

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

**3.** **Think about it:** What is the difference between `EXPECT_EQ` and `ASSERT_EQ` in Google Test?
When would you choose one over the other?

**Answer:** `EXPECT_EQ` reports the failure and continues running the rest of the test --- useful when multiple independent checks are in one test.
`ASSERT_EQ` stops the test immediately --- necessary when the rest of the test would crash or be meaningless if this check fails (e.g., checking that a pointer is non-null before dereferencing it).

**4.** **Where is the bug?**

```cpp
TEST_F(PlaylistTest, CanRemoveSong) {
    playlist.erase(playlist.begin());
    ASSERT_EQ(playlist.size(), 2u);
    EXPECT_EQ(playlist[0], "Toxic");
}
```

(Hint: what if the `SetUp` adds songs in a different order than expected?)

**Answer:** As written, the test actually passes: `SetUp()` pushes "Hey Ya!", "Toxic", "Crazy", so after erasing the first element, `playlist[0]` really is "Toxic".
The bug is fragility, not failure: the assertions are coupled to the exact order in which `SetUp()` happens to add songs.
If `SetUp()` later changes the order (or the fixture gains another song), the test breaks even though `erase` still works perfectly.
The fix: assert what the operation actually promises --- that the erased element is no longer present --- or compare the playlist against a full expected vector stated explicitly in the test.

**5.** **Think about it:** When is TDD most useful?
When is it less useful?
Give an example of each.

**Answer:** TDD is most useful when requirements are clear and testable --- e.g., writing a parser, a math library, or fixing a reported bug (write a test that reproduces it first).
TDD is less useful for exploratory or prototype code where the API and behavior are still being discovered --- you would constantly rewrite tests as the design evolves.

**6.** **Write a Catch2 test** for a function `int clamp(int value, int lo, int hi)` that restricts a value to a range.
Use sections to test: value below range, value in range, and value above range.

**Answer:**

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

**7.** **Think about it:** Why does mocking require interfaces (abstract classes)?
What happens if you try to mock a class with no virtual functions?

**Answer:** Without virtual functions, the compiler resolves calls at compile time --- there is no mechanism to intercept or replace behavior.
Google Mock's `MOCK_METHOD` works by overriding virtual functions.
If the function is not virtual, the mock class cannot override it, and the test will call the real implementation instead of the mock.

**8.** **What does this test check?**

```cpp
TEST(StringTest, EmptyString) {
    std::string s;
    EXPECT_TRUE(s.empty());
    EXPECT_EQ(s.size(), 0u);
    EXPECT_EQ(s, "");
}
```

**Answer:** The test checks three properties of a default-constructed `std::string`: that `empty()` is true, `size()` is 0, and it compares equal to `""`.
These are redundant (if one is true, the others must be), but together they document the expected behavior of an empty string.

**9.** **Think about it:** The text says "write tests alongside your code, not after."
Why is writing tests after the code is finished less effective?

**Answer:** Writing tests after the code often leads to tests that only cover the "happy path" --- the cases the developer already knows work.
Writing tests alongside the code forces you to think about edge cases and failure modes as you write, producing better test coverage.
It also means the code is designed to be testable from the start.

**10.** **Write a mock** (using Google Mock syntax) for this interface and a test that uses it:

```cpp
class Logger {
public:
    virtual ~Logger() = default;
    virtual void log(const std::string& message) = 0;
    virtual int message_count() const = 0;
};
```

Write a class `App` that takes a `Logger&` and has a `run()` method that calls `log("Starting")`.
Test that `run()` calls `log` exactly once with the message "Starting".

**Answer:**

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

**11.** **Calculate:** A Catch2 `TEST_CASE` contains a setup line followed by two `SECTION` blocks.
When the test binary runs, how many times does the setup line execute, and how many times does each `SECTION` body execute?

**Answer:** The setup line executes **twice**, and each `SECTION` body executes **once**.
Catch2 runs the `TEST_CASE` from the top once per `SECTION`, entering exactly one section on each pass.
That is the point of sections: every section sees fresh state from the setup code, without needing a fixture class.
