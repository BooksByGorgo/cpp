\newpage

# Appendix A: Standard Library Reference

\index{standard library!reference}

This appendix is a quick reference for the standard library containers, algorithms, and utilities most commonly used alongside the data structures in this book.
For full documentation, consult cppreference.com.

## Containers

\index{std::vector}
\index{std::list}
\index{std::deque}
\index{std::stack}
\index{std::queue}
\index{std::priority\_queue}
\index{std::unordered\_map}
\index{std::map}

| Container | Header | Description | Key operations |
|-----------|--------|-------------|----------------|
| `std::vector<T>` | `<vector>` | Growable array | `push_back`, `pop_back`, `operator[]`, `at`, `size`, `empty`, `begin/end` |
| `std::list<T>` | `<list>` | Doubly linked list | `push_front`, `push_back`, `pop_front`, `pop_back`, `insert`, `erase` |
| `std::forward_list<T>` | `<forward_list>` | Singly linked list | `push_front`, `pop_front`, `insert_after`, `erase_after` |
| `std::deque<T>` | `<deque>` | Double-ended queue | `push_front`, `push_back`, `pop_front`, `pop_back`, `operator[]` |
| `std::array<T,N>` | `<array>` | Fixed-size array | `operator[]`, `at`, `size`, `begin/end` |
| `std::stack<T>` | `<stack>` | LIFO adapter | `push`, `pop`, `top`, `empty`, `size` |
| `std::queue<T>` | `<queue>` | FIFO adapter | `push`, `pop`, `front`, `back`, `empty`, `size` |
| `std::priority_queue<T>` | `<queue>` | Max-heap | `push`, `pop`, `top`, `empty`, `size` |
| `std::set<T>` | `<set>` | Sorted unique values | `insert`, `erase`, `find`, `count` |
| `std::map<K,V>` | `<map>` | Sorted key-value pairs | `operator[]`, `at`, `insert`, `erase`, `find` |
| `std::unordered_set<T>` | `<unordered_set>` | Hash set | `insert`, `erase`, `find`, `count` |
| `std::unordered_map<K,V>` | `<unordered_map>` | Hash map | `operator[]`, `at`, `insert`, `erase`, `find` |

### `std::vector<T>` Quick Reference

```cpp
#include <vector>

std::vector<int> v;
v.push_back(1);            // append: O(1) amortized
v.pop_back();              // remove last: O(1)
v[i];                      // access (no bounds check): O(1)
v.at(i);                   // access (bounds check): O(1)
v.front();                 // first element: O(1)
v.back();                  // last element: O(1)
v.size();                  // number of elements: O(1)
v.empty();                 // true if no elements: O(1)
v.capacity();              // allocated capacity: O(1)
v.reserve(n);              // pre-allocate n slots
v.resize(n);               // resize to n elements
v.clear();                 // remove all elements: O(n)
v.insert(v.begin() + i, x); // insert at position: O(n)
v.erase(v.begin() + i);   // erase at position: O(n)
```

### `std::stack<T>` Quick Reference

```cpp
#include <stack>

std::stack<int> s;
s.push(x);      // push
s.pop();        // pop (does not return value)
s.top();        // access top (does not pop)
s.empty();      // true if empty
s.size();       // number of elements
```

### `std::queue<T>` Quick Reference

```cpp
#include <queue>

std::queue<int> q;
q.push(x);      // enqueue
q.pop();        // dequeue (does not return value)
q.front();      // access front (does not dequeue)
q.back();       // access back
q.empty();      // true if empty
q.size();       // number of elements
```

### `std::priority_queue<T>` Quick Reference

```cpp
#include <queue>

// Max-heap (default)
std::priority_queue<int> max_pq;

// Min-heap
std::priority_queue<int, std::vector<int>, std::greater<int>> min_pq;

max_pq.push(x);  // insert
max_pq.pop();    // remove max (does not return value)
max_pq.top();    // access max (does not remove)
max_pq.empty();  // true if empty
max_pq.size();   // number of elements
```

### `std::unordered_map<K,V>` Quick Reference

```cpp
#include <unordered_map>

std::unordered_map<std::string, int> m;
m["key"] = value;             // insert or update
m.at("key");                  // access (throws if missing)
m.find("key");                // returns iterator, or end() if missing
m.count("key");               // 0 or 1
m.erase("key");               // remove
m.size();                     // number of entries
m.empty();                    // true if no entries
m.reserve(n);                 // pre-allocate for n entries
```

## Algorithms

\index{std::sort}
\index{std::find}
\index{std::copy}

Key algorithms from `<algorithm>`:

```cpp
#include <algorithm>

std::sort(v.begin(), v.end());             // sort ascending: O(n log n)
std::sort(v.begin(), v.end(), cmp);        // sort with custom comparator
std::reverse(v.begin(), v.end());          // reverse in place: O(n)
std::find(v.begin(), v.end(), val);        // linear search: O(n)
std::binary_search(v.begin(), v.end(), val); // binary search (sorted): O(log n)
std::copy(src.begin(), src.end(), dst.begin()); // copy range: O(n)
std::fill(v.begin(), v.end(), val);        // fill with value: O(n)
std::min_element(v.begin(), v.end());      // pointer to min: O(n)
std::max_element(v.begin(), v.end());      // pointer to max: O(n)
std::count(v.begin(), v.end(), val);       // count occurrences: O(n)
std::count_if(v.begin(), v.end(), pred);   // count where pred is true: O(n)
std::transform(src.begin(), src.end(), dst.begin(), f); // apply f: O(n)
std::remove_if(v.begin(), v.end(), pred);  // move non-matching to front: O(n)
```

## Smart Pointers

\index{unique\_ptr}
\index{shared\_ptr}
\index{weak\_ptr}

```cpp
#include <memory>

// Exclusive ownership: auto-deleted when out of scope
std::unique_ptr<T> p = std::make_unique<T>(args...);
p.get();         // raw pointer (non-owning)
p.reset();       // delete and set to null
p.release();     // release ownership, return raw pointer
std::move(p);    // transfer ownership

// Shared ownership: reference counted
std::shared_ptr<T> s = std::make_shared<T>(args...);
s.use_count();   // reference count

// Non-owning reference to shared_ptr
std::weak_ptr<T> w = s;
w.lock();        // returns shared_ptr (null if expired)
```

## Utility Types

\index{std::optional}
\index{std::variant}
\index{std::pair}

```cpp
#include <optional>
std::optional<T> opt;          // no value
std::optional<T> opt{value};   // has value
opt.has_value();               // true if has value
*opt;                          // access value (undefined if empty)
opt.value();                   // access value (throws if empty)
opt.value_or(default);         // value or default if empty

#include <variant>
std::variant<int, std::string> v = 42;
std::get<int>(v);              // access as int
std::holds_alternative<int>(v); // true if int
std::visit(visitor, v);        // call visitor with active type

#include <utility>
std::pair<int, std::string> p{1, "one"};
p.first;       // 1
p.second;      // "one"
auto [a, b] = p;  // structured binding (C++17)
```

## Timing and Benchmarking

\index{timing}
\index{benchmarking}

```cpp
#include <chrono>

auto start = std::chrono::high_resolution_clock::now();
// ... code to time ...
auto end = std::chrono::high_resolution_clock::now();
auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
std::cout << duration.count() << " us\n";
```

## Common Type Traits

\index{type traits}

```cpp
#include <type_traits>

std::is_integral_v<T>          // true for int, long, etc.
std::is_floating_point_v<T>    // true for float, double
std::is_pointer_v<T>           // true for pointer types
std::is_same_v<T, U>           // true if T and U are the same type
std::is_base_of_v<Base, Derived> // true if Derived inherits from Base
std::remove_reference_t<T>     // removes reference qualifier
std::decay_t<T>                // removes cv-qualifiers and references
```
