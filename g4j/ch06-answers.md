# Chapter 6: Pointers --- Answers

**Exercise 1** (Think about it): In Java, you can mutate the fields of an object passed to a method, but you cannot change which object the caller's variable refers to.
In Go, you can do neither with a plain struct value parameter, but you can do both with a pointer parameter.
What is the deeper rule that unifies these two behaviors, and what does it tell you about how Go and Java model "passing by reference"?

The unifying rule is: **a function can only affect the caller through a pointer** (or reference) **to the thing the caller cares about**.

In Java, every object variable already is a hidden pointer to heap memory.
When you pass an object to a method, you pass a copy of the reference --- the method shares the same underlying object, so field mutations are visible to the caller.
But the reference itself is passed by value, so reassigning the parameter inside the method (`c = new Counter()`) does not change the caller's variable.
Java gives you reference semantics for objects without exposing the pointer.

In Go, everything --- including structs --- is passed by value by default.
A struct parameter is a copy of the whole struct; mutating its fields inside the function leaves the caller's copy unchanged.
If you want the Java-like "shared object" behavior, you pass a `*MyStruct`.
Now you have an explicit pointer to the same memory, and you can mutate fields or even replace the entire struct value with `*p = MyStruct{...}`.

The models are consistent once you see the underlying mechanism: Java hides the pointer for objects; Go exposes it uniformly for everything.
Neither language is "passing by reference" in the C++ sense of a reference binding to the caller's variable --- both copy something at the call site.
The difference is what that something is.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func double(n *int) {
    *n *= 2
}

func main() {
    a := 5
    b := &a
    double(b)
    fmt.Println(a)
    fmt.Println(*b)
}
```

Output:
```
10
10
```

`b` holds the address of `a`, so `b` and `&a` point to the same integer.
`double(b)` passes that pointer to `double`, which multiplies the value at that address by 2: `5 * 2 = 10`.
After `double` returns, `a` is `10` because it is the same memory that was modified.
`*b` dereferences `b`, which still points to `a`, so it also yields `10`.
There is only one integer in memory; `a` and `*b` are two names for the same location.

---

**Exercise 3** (Calculation): Given the following declarations:

```go
x := 100
p := &x
q := p
*q = 200
```

What are the values of `x`, `*p`, and `*q` after these four lines?
How many distinct integers are stored in memory?

After these four lines:

| Expression | Value |
|------------|-------|
| `x`        | `200` |
| `*p`       | `200` |
| `*q`       | `200` |

Only **one** distinct integer is stored in memory.

`p := &x` makes `p` point to `x`.
`q := p` copies the pointer value itself (the address), so `q` now points to the same `x`.
`*q = 200` writes `200` to the memory location that `q` points to, which is `x`.
All three expressions (`x`, `*p`, `*q`) refer to the same memory location, so they all read `200`.
Assigning one pointer variable to another (`q := p`) never copies the pointed-to integer --- it copies only the address.

---

**Exercise 4** (Where is the bug?): The following code tries to append a suffix to a string through a pointer.

```go
package main

import "fmt"

func addExcitement(s *string) {
    s += "!"
}

func main() {
    msg := "Bad Guy"
    addExcitement(&msg)
    fmt.Println(msg)
}
```

The bug is on the line `s += "!"`.
`s` is a `*string` --- a pointer to a string.
You cannot use `+=` to concatenate a string onto a pointer; that operation does not even compile.
The compiler reports: `invalid operation: s += "!" (mismatched types *string and untyped string)`.

The intent was to modify the string that `s` points to.
The correct approach is to dereference `s` first, then concatenate, then write the result back:

```go
func addExcitement(s *string) {
    *s += "!"   // dereference to get the string, concatenate, write back
}
```

With this fix the program prints:
```
Bad Guy!
```

The general rule: `s` is the pointer (the address); `*s` is the value at that address.
Any operation that should work on the string must operate on `*s`, not on `s` itself.

---

**Exercise 5** (Write a program): Write a function `increment(n *int)` that adds one to the integer pointed to by `n`.
Then write a second function `incrementBy(n *int, delta int)` that adds `delta` to the integer.
In `main`, declare an integer variable, call both functions on it, and print the value after each call to confirm the changes took effect.

```go
package main

import "fmt"

func increment(n *int) {
    *n++   // dereference n and add one to the value it points to
}

func incrementBy(n *int, delta int) {
    *n += delta   // dereference n and add delta to the value it points to
}

func main() {
    score := 0
    fmt.Println(score)     // 0

    increment(&score)
    fmt.Println(score)     // 1

    incrementBy(&score, 9)
    fmt.Println(score)     // 10

    incrementBy(&score, -3)
    fmt.Println(score)     // 7
}
```

Output:
```
0
1
10
7
```

`increment` takes `*n++`, which is parsed as `(*n)++` --- it increments the integer at the address `n` holds.
`incrementBy` uses `*n += delta` to add an arbitrary amount.
Because both functions receive a pointer to `score`, every write through `*n` updates the original `score` variable in `main`.
