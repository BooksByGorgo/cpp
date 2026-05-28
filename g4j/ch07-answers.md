# Chapter 7: Slices --- Answers

**Exercise 1** (Think about it): In Java, an `ArrayList<Integer>` holds references to `Integer` objects on the heap.
A Go `[]int` holds the integers directly in the backing array.
What are the performance implications of this difference?
When would you feel the difference most?

A Java `ArrayList<Integer>` stores a pointer (reference) to each boxed `Integer` object, and each `Integer` object lives somewhere on the heap.
Iterating over the list means following a pointer for every element, and those `Integer` objects may be scattered around memory --- poor cache locality.
Each `Integer` also carries object header overhead (typically 16 bytes) even though the actual integer value is just 4 bytes.

A Go `[]int` stores the integer values **directly** and **contiguously** in the backing array.
Iterating is a sequential scan through a flat region of memory: the CPU prefetcher handles this extremely well.
There is no per-element allocation overhead and no pointer chasing.

You feel the difference most in:

- **Tight loops** that process large slices: the sequential memory access pattern is cache-friendly, and modern CPUs can vectorize flat integer arrays.
- **Memory usage**: a Go `[]int` of a million elements is roughly 8 MB (64-bit ints).
  A Java `ArrayList<Integer>` of a million elements is the list's pointer array (8 MB of references) plus a million `Integer` objects on the heap (at least 16 MB more), for a minimum of 24 MB --- and GC pressure from all those small objects.
- **GC pauses**: the Go garbage collector has no pointers to trace inside a `[]int`, so it scans the array in constant time.
  A Java `ArrayList<Integer>` forces the GC to follow a million references.

The trade-off is that Go's approach works for slices of value types (`int`, `float64`, structs).
For slices of interfaces or pointers, Go has the same indirection that Java does.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func main() {
    a := []int{10, 20, 30, 40, 50}
    b := a[1:4]
    b[0] = 99
    b = append(b, 77)
    fmt.Println(a)
    fmt.Println(b)
}
```

Output:
```
[10 99 30 40 77]
[99 30 40 77]
```

Step by step:

1. `a` is created with backing array `[10, 20, 30, 40, 50]`, len=5, cap=5.

2. `b := a[1:4]` creates a slice header pointing at `a[1]`, len=3, cap=4 (from index 1 to the end of `a`'s backing array).
   `b` sees `[20, 30, 40]`.

3. `b[0] = 99` writes `99` to the backing array at `a`'s index 1.
   Now the backing array is `[10, 99, 30, 40, 50]`.
   `a` sees `[10, 99, 30, 40, 50]` and `b` sees `[99, 30, 40]`.

4. `b = append(b, 77)`: `b` has len=3, cap=4, so there is room for one more element without reallocation.
   `append` writes `77` to the backing array at `a`'s index 4 (the element after `b`'s current last element), and returns a new slice header with len=4.
   The backing array is now `[10, 99, 30, 40, 77]`.
   `a` still has len=5 and sees `[10, 99, 30, 40, 77]`.
   `b` now has len=4 and sees `[99, 30, 40, 77]`.

Both the `b[0] = 99` write and the `append(b, 77)` write go through to the shared backing array and are visible through `a`.
This is the classic slice aliasing trap.

---

**Exercise 3** (Calculation):

```go
s := make([]int, 3, 8)
s = append(s, 1, 2)
```

After the first line: `len(s) = 3`, `cap(s) = 8`.
The backing array has eight slots; the first three are zero.

After the second line: `append` needs to add two elements to a slice with len=3 and cap=8.
Since 3 + 2 = 5 ≤ 8, there is enough room in the existing backing array.
No new backing array is allocated.
`append` writes `1` and `2` at indices 3 and 4, and returns a new header with len=5.

Final values: `len(s) = 5`, `cap(s) = 8`.
No new backing array is allocated because the capacity was sufficient.

---

**Exercise 4** (Where is the bug?):

```go
package main

import "fmt"

func removeFirst(s []int) []int {
    return s[1:]
}

func main() {
    data := []int{1, 2, 3, 4, 5}
    trimmed := removeFirst(data)
    trimmed[0] = 99
    fmt.Println(data)
    fmt.Println(trimmed)
}
```

Output:
```
[1 99 3 4 5]
[99 3 4 5]
```

The bug is that `s[1:]` returns a sub-slice that **shares the backing array** with `data`.
`trimmed` points at `data[1]`, so `trimmed[0]` is the same memory location as `data[1]`.
Assigning `trimmed[0] = 99` visibly changes `data[1]`.

The programmer likely intended `trimmed` to be an independent copy of the data with the first element removed.
The fix is to use `copy`:

```go
func removeFirst(s []int) []int {
    if len(s) == 0 {
        return nil
    }
    result := make([]int, len(s)-1)
    copy(result, s[1:])
    return result
}
```

With this fix, `trimmed[0] = 99` does not affect `data` at all, and `fmt.Println(data)` prints `[1 2 3 4 5]`.

Alternatively, if you want the three-index form to at least prevent accidental `append` overwrites (while still sharing memory for reads), you could write `s[1:len(s):len(s)]`.
But if true independence is required, `copy` is the right tool.

---

**Exercise 5** (Write a program):

```go
package main

import "fmt"

func unique(s []string) []string {
    seen := make(map[string]bool)
    result := make([]string, 0, len(s))
    for _, v := range s {
        if !seen[v] {
            seen[v] = true
            result = append(result, v)
        }
    }
    return result
}

func main() {
    input := []string{"pop", "indie", "pop", "R&B", "indie"}
    out := unique(input)
    fmt.Println(out) // [pop indie R&B]

    // Confirm independence: modifying out does not touch input.
    out[0] = "classical"
    fmt.Println(input[0]) // pop --- unchanged
    fmt.Println(out[0])   // classical
}
```

Output:
```
[pop indie R&B]
pop
classical
```

The `seen` map tracks which strings have already been added.
The first time a value appears, it is added to `result` and recorded in `seen`; subsequent occurrences are skipped.

`result` is built with `append` onto a freshly allocated slice (`make([]string, 0, len(s))`), so it has its own backing array and is fully independent of `input`.
Modifying an element of `result` does not affect `input`.

Pre-allocating with `cap=len(s)` is an optimization: in the worst case (all elements are distinct) `result` will grow to exactly `len(s)` elements, so pre-allocating avoids repeated reallocation.
