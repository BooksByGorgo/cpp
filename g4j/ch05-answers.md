# Chapter 5: Functions --- Answers

**Exercise 1** (Think about it):
Go returns errors as values rather than throwing exceptions.
A Java checked exception forces the caller to handle it --- the compiler will not let you ignore it.
Go's multi-return error is also explicit, but you can discard it with `_` or simply not assign the second return value.
Does Go's approach give you the same safety guarantee as Java's checked exceptions?
What is gained and what is lost by each approach?

Java's checked exceptions provide a compiler-enforced contract: if a method declares `throws IOException`, the caller must either catch it or declare that it also throws it.
There is no way to silently ignore a checked exception in Java without at least writing a catch block (even an empty one is conspicuous).

Go does not provide that same guarantee.
You can write `result, _ := divide(a, b)` or even `result := somePackage.Lookup(key)` if you know (or ignore) that `Lookup` returns `(string, error)` but only assign one variable --- though the compiler will reject an assignment that captures the wrong number of values, it will happily accept `_` for any of them.

**What Go gains:**

- Error handling is explicit code, not a separate control-flow mechanism.
  Errors flow through the same call stack as regular values, which makes them easier to wrap, annotate, and inspect.
- There is no distinction between checked and unchecked exceptions to manage.
  In Java, many APIs force you to wrap checked exceptions in `RuntimeException` just to use them in lambdas or streams.
- Errors are plain values you can store, compare, pass around, and test --- no reflection required.

**What Java gains:**

- The compiler can prove at build time that every failure path is addressed.
  Go relies on code review and tools like `errcheck` to catch ignored errors.
- Stack traces are attached to exceptions automatically; in Go you must explicitly wrap errors with `fmt.Errorf("...: %w", err)` to build a chain.

In practice, Go's approach leads to more explicit error-handling code and fewer "surprise" failures from unchecked exceptions --- but it also produces more repetitive `if err != nil` checks that disciplined engineers must not skip.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func makeAdder(n int) func(int) int {
    return func(x int) int {
        return x + n
    }
}

func main() {
    add5 := makeAdder(5)
    add10 := makeAdder(10)
    fmt.Println(add5(3))
    fmt.Println(add10(3))
    fmt.Println(add5(add10(1)))
}
```

Output:
```
8
13
16
```

`makeAdder(5)` returns a closure that captures `n = 5`.
`makeAdder(10)` returns a separate closure that captures `n = 10`.
Each closure has its own independent copy of `n` because each call to `makeAdder` creates a new variable.

`add5(3)` returns `3 + 5 = 8`.
`add10(3)` returns `3 + 10 = 13`.
`add5(add10(1))` evaluates inside-out: `add10(1)` returns `1 + 10 = 11`, then `add5(11)` returns `11 + 5 = 16`.

---

**Exercise 3** (Calculation):
Given the function below, what values are printed by the three `fmt.Println` calls?
Trace the value of `total` at each step.

```go
package main

import "fmt"

func running(start int) func(int) int {
    total := start
    return func(n int) int {
        total += n
        return total
    }
}

func main() {
    acc := running(100)
    fmt.Println(acc(10))
    fmt.Println(acc(20))
    fmt.Println(acc(-5))
}
```

Output:
```
110
130
125
```

`running(100)` creates a closure that captures `total`, initialised to `100`.
The same `total` variable is shared across all calls through `acc` because the closure captures it by reference --- it is the same memory location every time.

- `acc(10)`: `total = 100 + 10 = 110`; returns and prints `110`.
- `acc(20)`: `total = 110 + 20 = 130`; returns and prints `130`.
- `acc(-5)`: `total = 130 + (-5) = 125`; returns and prints `125`.

This is a running total (accumulator) implemented with a closure.
Each call modifies and returns the accumulated value.

---

**Exercise 4** (Where is the bug?):
The following code tries to build a slice of greeting functions, one for each name in a list, using a Go 1.21 module.

```go
package main

import "fmt"

func main() {
    names := []string{"benson", "amara", "priya"}
    greets := make([]func(), len(names))
    for i, name := range names {
        greets[i] = func() { fmt.Println("hola,", name) }
    }
    for _, g := range greets {
        g()
    }
}
```

**The bug:** Under Go 1.21 semantics, the `for range` loop reuses the same `i` and `name` variables for every iteration.
All three closures capture the same `name` variable --- not a copy of its value, but a reference to the single loop variable.
By the time any of the closures run, the loop has finished and `name` holds the last value: `"priya"`.

Actual output under Go 1.21:
```
hola, priya
hola, priya
hola, priya
```

Expected output:
```
hola, benson
hola, amara
hola, priya
```

**Fix 1 (works in all Go versions):** Create a new local variable inside the loop body to shadow the loop variable:

```go
for i, name := range names {
    name := name // create a new variable for this iteration
    greets[i] = func() { fmt.Println("hola,", name) }
}
```

**Fix 2 (works in Go 1.22+):** Update the `go` directive in `go.mod` to `go 1.22` or later.
The language change makes each loop iteration create its own variable automatically, so all existing closure-in-loop code behaves correctly without any source changes.

---

**Exercise 5** (Write a program):
Write a function `pipeline(fns ...func(int) int) func(int) int` that takes any number of `func(int) int` functions and returns a new function that applies them in order.

```go
package main

import "fmt"

// pipeline returns a function that applies each fn in fns left to right.
func pipeline(fns ...func(int) int) func(int) int {
    return func(x int) int {
        result := x
        for _, fn := range fns {
            result = fn(result) // apply each transform in sequence
        }
        return result
    }
}

func main() {
    double  := func(n int) int { return n * 2 }   // multiply by 2
    addTen  := func(n int) int { return n + 10 }  // add 10
    square  := func(n int) int { return n * n }   // square the value

    // double then addTen: (3*2)+10 = 16
    p1 := pipeline(double, addTen)
    fmt.Println(p1(3)) // 16

    // addTen then double: (3+10)*2 = 26
    p2 := pipeline(addTen, double)
    fmt.Println(p2(3)) // 26

    // double then square: (3*2)^2 = 36
    p3 := pipeline(double, square)
    fmt.Println(p3(3)) // 36

    // empty pipeline --- identity
    p4 := pipeline()
    fmt.Println(p4(7)) // 7
}
```

Key points in this solution:

- `pipeline` is variadic: it accepts any number of `func(int) int` values.
- Inside the returned closure, `fns` is captured by reference --- the same `[]func(int) int` slice the outer call built.
- The order of application matters: `pipeline(double, addTen)` and `pipeline(addTen, double)` produce different results for the same input.
- An empty `pipeline()` call returns an identity function because the loop body never executes.
