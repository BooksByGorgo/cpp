---
title: "Gorgo Go for Java Programmers --- Answer Key"
---

# About This Answer Key

Work out the answers yourself before looking here.
The explanations are meant to help you understand *why* the answer is what it is, not just tell you *what* the answer is.

---

# Chapter 0: How to Use This Booklet

There are no exercises in Chapter 0.

---

# Chapter 1: Hello, Go

**Exercise 1** (Think about it): Go has no `protected` access modifier.
Java uses `protected` to allow subclasses in other packages to access members.
Go has no inheritance.
What Go mechanism serves a similar purpose when you want controlled access across packages, and what are its limits compared to `protected`?

Go's closest substitute is the `internal` directory convention.
Any package placed under an `internal/` directory can only be imported by code rooted at the parent of that `internal/` tree.
For example, `github.com/myorg/myapp/internal/auth` is visible to `github.com/myorg/myapp` and its subpackages, but not to any external module.

The limits are real: `internal` is a coarse, directory-level gate, not a per-symbol toggle.
You cannot mark a single exported function as "visible only to sibling packages" the way Java's `protected` marks a single method as "visible to subclasses in other packages."
If you need a symbol visible to several packages in your module but hidden from the outside world, you put it in `internal/`; everything in that subtree shares the same level of access.
There is also no concept of subclass access because Go has no subclasses --- embedding a struct gives you promoted methods, but embedding is not inheritance and carries no visibility privileges.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func main() {
    name := "Chappell Roan"
    plays := 1_500_000
    fmt.Printf("%s has %d plays\n", name, plays)
    fmt.Printf("type of plays: %T\n", plays)
    fmt.Println(fmt.Sprintf("quoted: %q", name))
}
```

Output:
```
Chappell Roan has 1500000 plays
type of plays: int
quoted: "Chappell Roan"
```

`%s` formats the string without quotes.
`%d` formats the integer in base 10; the `_` digit separator in the source literal `1_500_000` is purely cosmetic --- the value is `1500000`.
`%T` prints the Go type name, which for an integer literal assigned with `:=` is `int`.
`%q` wraps the string in double quotes and escapes any characters that need it.
`fmt.Sprintf` returns the formatted string; `fmt.Println` then prints it with a newline appended.

---

**Exercise 3** (Calculation): A Go source file imports three packages: `"fmt"`, `"os"`, and `"math"`.
The code calls `fmt.Println` and `os.Exit`, but never calls anything from `math`.
How many compiler errors does this program produce, and which import causes them?

One compiler error.
Go emits one error per unused import, not one per symbol.
The error points to the `"math"` import:

```
./main.go:5:2: "math" imported and not used
```

`"fmt"` and `"os"` are used, so they cause no error.
The build fails entirely --- there is no "compile with warnings" mode in Go.

---

**Exercise 4** (Where is the bug?):

```go
package main

import (
    "fmt"
    "math"
)

func main() {
    fmt.Println("Hello, Go!")
}
```

`"math"` is imported but never used.
The program will not compile.
The compiler produces:

```
./main.go:5:2: "math" imported and not used
```

The fix is to remove the `"math"` import.
If you were writing this in an editor with `goimports` configured to run on save, it would have removed the unused import automatically before you even tried to build.

---

**Exercise 5** (Write a program): Write a Go program that declares a `const` string with a song title of your choice and prints three lines: the title using `%s`, the title using `%q`, and the Go type of the title using `%T`.
Run it with `go run`.

```go
package main

import "fmt"

const title = "Good Luck, Babe!"

func main() {
    fmt.Printf("%s\n", title)
    fmt.Printf("%q\n", title)
    fmt.Printf("%T\n", title)
}
```

Output:
```
Good Luck, Babe!
"Good Luck, Babe!"
string
```

`const` values are untyped string constants when declared without an explicit type.
`%T` prints `string` because the constant's default type is `string`.
Note that `%q` adds the double quotes and would also escape any special characters inside the string, such as newlines or backslashes.

---

# Chapter 2: Types and Variables

**Exercise 1** (Think about it): In Java, using an uninitialized local variable is a compile error.
In Go, every variable has a zero value.
What are the benefits and potential risks of zero values?

The primary benefit is safety and predictability: there are no uninitialized reads and no undefined behavior from reading a garbage value off the stack.
You can declare a `sync.Mutex` or a `bytes.Buffer` and use it immediately without calling a constructor, because the zero value is deliberately designed to be a valid, ready-to-use state.
This is a Go idiom worth internalizing: if you design a type so that its zero value is useful, callers pay no initialization tax.

The risk is silent logic errors.
In Java, forgetting to initialize a variable is a compile-time catch.
In Go, `var count int` silently starts at `0`, `var name string` at `""`, and `var ptr *SomeType` at `nil`.
If you forget to set `ptr` before dereferencing it, you get a runtime panic, not a compile error.
Similarly, a `bool` zero value is `false`, so a field like `IsAdmin` starts as `false` --- which is the safe default --- but a field like `IsEnabled` also starts as `false`, which might not be what you want.
Zero values encourage a different discipline: design your data so that the zero state is meaningful and correct.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

type StreamingTier int

const (
    Free StreamingTier = iota
    Standard
    Premium
    Lossless
)

func main() {
    fmt.Println(Free, Standard, Premium, Lossless)
    fmt.Printf("Premium = %d\n", Premium)
}
```

Output:
```
0 1 2 3
Premium = 2
```

`iota` starts at `0` for the first constant in a `const` block and increments by `1` for each subsequent constant.
`Free` gets `0`, `Standard` gets `1`, `Premium` gets `2`, and `Lossless` gets `3`.
Because `StreamingTier` is a named type based on `int`, `%d` formats it as a plain integer.
`fmt.Println` with multiple arguments separates them with spaces and appends a newline.

---

**Exercise 3** (Calculation): What is the zero value of each of the following types: `int`, `float64`, `bool`, `string`, `*int`?

| Type      | Zero value |
|-----------|------------|
| `int`     | `0`        |
| `float64` | `0.0`      |
| `bool`    | `false`    |
| `string`  | `""` (empty string, length 0) |
| `*int`    | `nil`      |

Every variable declared with `var` and no initializer gets its type's zero value.
`nil` is the zero value for all pointer types, as well as slices, maps, channels, functions, and interfaces.
A `nil` pointer is safe to declare but will panic if you dereference it.

---

**Exercise 4** (Where is the bug?):

```go
package main

import "fmt"

func main() {
    x := 10
    x := 20
    fmt.Println(x)
}
```

`:=` requires at least one new variable on the left side.
Because `x` is already declared in the same scope, the second `:=` is a compile error:

```
./main.go:7:4: no new variables on left side of :=
```

The fix depends on intent.
To reassign `x`, use a plain `=`:

```go
x := 10
x = 20
fmt.Println(x)
```

`:=` is valid the second time only if you are introducing at least one new variable alongside the existing one, for example `x, y := 20, 30`.

---

**Exercise 5** (Write a program): Define types `Celsius` and `Fahrenheit` based on `float64`.
Write conversion functions.
Print the boiling and freezing points of water in both scales.

```go
package main

import "fmt"

type Celsius float64
type Fahrenheit float64

func CToF(c Celsius) Fahrenheit {
    return Fahrenheit(c*9/5 + 32)
}

func FToC(f Fahrenheit) Celsius {
    return Celsius((f - 32) * 5 / 9)
}

func main() {
    freezingC := Celsius(0)
    boilingC := Celsius(100)

    fmt.Printf("Freezing: %.1f°C = %.1f°F\n", freezingC, CToF(freezingC))
    fmt.Printf("Boiling:  %.1f°C = %.1f°F\n", boilingC, CToF(boilingC))

    freezingF := Fahrenheit(32)
    boilingF := Fahrenheit(212)

    fmt.Printf("Freezing: %.1f°F = %.1f°C\n", freezingF, FToC(freezingF))
    fmt.Printf("Boiling:  %.1f°F = %.1f°C\n", boilingF, FToC(boilingF))
}
```

Output:
```
Freezing: 0.0°C = 32.0°F
Boiling:  100.0°C = 212.0°F
Freezing: 32.0°F = 0.0°C
Boiling:  212.0°F = 100.0°C
```

The key insight is that `Celsius` and `Fahrenheit` are distinct types even though both are backed by `float64`.
You cannot pass a `Celsius` where a `Fahrenheit` is expected without an explicit conversion.
This is why type definitions exist: they let the compiler catch unit errors at compile time rather than at runtime.

---

# Chapter 3: Strings, Bytes, and Runes

**Exercise 1** (Think about it): If Go strings are byte sequences and not character sequences, what happens when you index into a string containing a multibyte character like `é`?
How does `for range` behave differently from `for i := 0; i < len(s); i++`?

Indexing with `s[i]` yields the byte at position `i`, not the character.
For ASCII, one byte is one character, so `s[0]` on `"cafe"` gives `'c'` as a `byte` (`uint8` value `99`).
But `é` in UTF-8 is encoded as two bytes (`0xC3 0xA9`).
If `"café"` starts at index 0, then `s[3]` is `0xC3` --- the first byte of `é` --- not the character `é` itself.
This is often surprising and is a common source of bugs when programmers index into strings that may contain non-ASCII characters.

`for i := 0; i < len(s); i++` walks byte by byte, so iterating `"café"` visits 5 bytes (c, a, f, and the two bytes of é).

`for i, r := range s` decodes the string as UTF-8 on each iteration.
`i` is the byte offset of the start of the rune, and `r` is the decoded `rune` (a full Unicode code point as `int32`).
Iterating `"café"` with range visits 4 runes: `'c'`, `'a'`, `'f'`, and `'é'`.
When `range` reaches the two-byte sequence for `é`, it decodes both bytes together and advances `i` by 2.
Use `range` when you care about characters; use byte indexing only when you are sure the string is pure ASCII or when you genuinely need to operate on raw bytes.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func main() {
    s := "café"
    fmt.Println("len:", len(s))
    fmt.Printf("s[3] = %d (0x%X)\n", s[3], s[3])

    for i, r := range s {
        fmt.Printf("index %d: %c (%d)\n", i, r, r)
    }
}
```

Output:
```
len: 5
s[3] = 195 (0xC3)
index 0: c (99)
index 1: a (97)
index 2: f (102)
index 3: é (233)
```

`"café"` is 5 bytes long: `c` `a` `f` are one byte each, and `é` is two bytes (`0xC3 0xA9`).
`s[3]` returns the byte at position 3, which is `0xC3` (decimal 195) --- the first byte of the UTF-8 encoding of `é`, not the character itself.
`range` decodes the UTF-8 properly: it sees the two bytes at position 3 as a single rune (`é`, code point U+00E9, decimal 233) and skips byte 4 entirely.
Notice that index 4 never appears in the range output because `é` occupies two byte positions (3 and 4) but is a single rune.

---

**Exercise 3** (Calculation): How many bytes does `len("Beyoncé")` return?
How many runes does `utf8.RuneCountInString("Beyoncé")` return?

`len("Beyoncé")` returns `8`.
`B`, `e`, `y`, `o`, `n`, `c` are each one byte (6 bytes total), and `é` (U+00E9) encodes to two bytes in UTF-8, giving 8 bytes.

`utf8.RuneCountInString("Beyoncé")` returns `7`.
The string contains 7 characters: `B`, `e`, `y`, `o`, `n`, `c`, and `é`.
`len` counts bytes; `utf8.RuneCountInString` counts Unicode code points.
They agree on pure ASCII strings and diverge the moment any character requires more than one byte.

---

**Exercise 4** (Where is the bug?):

```go
package main

import "fmt"

func shout(s string) string {
    result := make([]byte, len(s))
    for i := 0; i < len(s); i++ {
        result[i] = s[i] - 32
    }
    return string(result)
}

func main() {
    fmt.Println(shout("café"))
}
```

The function assumes every character is a single byte and that subtracting 32 uppercases it.
Both assumptions are wrong for non-ASCII input.

For ASCII letters, subtracting 32 from a lowercase byte gives the corresponding uppercase byte (e.g., `'a'` - 32 = `'A'`).
But `"café"` is 5 bytes, and bytes 3 and 4 are the UTF-8 encoding of `é` (0xC3 and 0xA9).
Subtracting 32 from each gives 0xA3 and 0x89, which are not a valid UTF-8 sequence for any meaningful character.
The result is garbled output or a replacement character, not `"CAFÉ"`.

The correct approach for Unicode-aware uppercasing is `strings.ToUpper`:

```go
import "strings"

func shout(s string) string {
    return strings.ToUpper(s)
}
```

Output:
```
CAFÉ
```

---

**Exercise 5** (Write a program): Write a program that reverses a string correctly --- by rune, not by byte --- and prints the result.

```go
package main

import "fmt"

func reverseString(s string) string {
    runes := []rune(s)
    for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
        runes[i], runes[j] = runes[j], runes[i]
    }
    return string(runes)
}

func main() {
    words := []string{"café", "Beyoncé", "hello"}
    for _, w := range words {
        fmt.Printf("%q -> %q\n", w, reverseString(w))
    }
}
```

Output:
```
"café" -> "éfac"
"Beyoncé" -> "écnoyeB"
"hello" -> "olleh"
```

The key step is converting the string to `[]rune` first.
This decodes the UTF-8 and gives you one `rune` per Unicode code point regardless of how many bytes each one occupies.
You then swap elements in the rune slice in place, and convert back to a `string` at the end.
Reversing the raw `[]byte` instead would shuffle the individual bytes of multibyte characters and produce invalid UTF-8.

---

# Chapter 4: Control Flow

**Exercise 1** (Think about it): Go has only one loop keyword, `for`.
Java has `for`, `while`, and `do...while`.
Is this limiting, or does it simplify the language?
Can you think of a pattern where a `do...while` loop cannot be elegantly expressed with Go's `for`?

Having one loop keyword is not limiting in practice.
Go's `for` covers all three Java forms:

- C-style `for`: `for i := 0; i < n; i++ { ... }`
- while-style: `for condition { ... }`
- infinite: `for { ... }` with a `break` inside

The `do...while` pattern --- execute the body at least once, then check the condition --- requires a small idiom in Go:

```go
for {
    // body
    if !condition {
        break
    }
}
```

This is slightly less elegant than Java's `do { ... } while (condition)` because the loop-exit logic is inside the body rather than at the bottom of the statement.
For readers scanning code quickly, the exit condition is less visible.
In practice, `do...while` is rare enough in both languages that this is a minor inconvenience.
The benefit is a smaller language: one keyword to teach, one loop construct to remember, and fewer edge cases around scoping and control flow.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func main() {
    for i := 0; i < 3; i++ {
        defer fmt.Println(i)
    }
    fmt.Println("done")
}
```

Output:
```
done
2
1
0
```

Two things are happening here.
First, `defer` runs after the surrounding function returns, so all three deferred calls happen after `fmt.Println("done")`.
Second, `defer` arguments are evaluated immediately at the point of the `defer` statement, not when the deferred call executes.
When `i` is `0`, `defer fmt.Println(0)` is registered with the value `0` baked in.
When `i` is `1`, `defer fmt.Println(1)` is registered with `1`.
When `i` is `2`, `defer fmt.Println(2)` is registered with `2`.
Deferred calls execute in LIFO (last-in, first-out) order, so the last one registered runs first: `2`, then `1`, then `0`.

---

**Exercise 3** (What does this print?):

```go
package main

import "fmt"

func grade(score int) string {
    switch {
    case score >= 90:
        return "A"
    case score >= 80:
        return "B"
    case score >= 70:
        return "C"
    default:
        return "F"
    }
}

func main() {
    fmt.Println(grade(95))
    fmt.Println(grade(83))
    fmt.Println(grade(70))
    fmt.Println(grade(55))
}
```

Output:
```
A
B
C
F
```

An expression-less `switch` is equivalent to `switch true` --- each case is a boolean expression, and the first one that evaluates to `true` wins.
Cases are evaluated top to bottom; once a match is found, the remaining cases are skipped.
There is no fallthrough, so `grade(83)` matches `score >= 80`, returns `"B"`, and never reaches `score >= 70`.
The `default` clause matches when no case is true.

---

**Exercise 4** (Where is the bug?):

```go
package main

import "fmt"

func makeMultipliers() []func(int) int {
    fns := make([]func(int) int, 3)
    factor := 1
    for i := 0; i < 3; i++ {
        factor = (i + 1) * 10
        fns[i] = func(x int) int { return x * factor }
    }
    return fns
}

func main() {
    fns := makeMultipliers()
    for _, f := range fns {
        fmt.Println(f(5))
    }
}
```

All three calls print `150`, not `50`, `100`, `150`.

The bug is that `factor` is declared outside the loop.
All three closures capture the same `factor` variable by reference.
By the time the closures run, the loop has finished and `factor` is `30` (the last value assigned).
Every closure multiplies by `30`, so `f(5)` returns `150` for all three.

The fix is to declare `factor` inside the loop so each iteration gets its own copy:

```go
for i := 0; i < 3; i++ {
    factor := (i + 1) * 10
    fns[i] = func(x int) int { return x * factor }
}
```

Now each closure captures a distinct `factor` variable, and the output is `50`, `100`, `150`.

---

**Exercise 5** (Write a program): Write a program using `defer` and `recover` to catch a panic from a function that calls `panic("something went wrong")`, print the recovered message, and continue execution normally.

```go
package main

import "fmt"

func safeRun(f func()) {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("recovered:", r)
        }
    }()
    f()
}

func riskyOperation() {
    fmt.Println("starting risky operation")
    panic("something went wrong")
}

func main() {
    fmt.Println("before safeRun")
    safeRun(riskyOperation)
    fmt.Println("after safeRun --- execution continues normally")
}
```

Output:
```
before safeRun
starting risky operation
recovered: something went wrong
after safeRun --- execution continues normally
```

`recover` only works when called directly inside a deferred function.
The deferred anonymous function runs when `riskyOperation` panics; at that point, `recover()` returns the value passed to `panic` and stops the panic from propagating up the call stack.
After `safeRun` returns normally, `main` continues.

Note that `panic` and `recover` are not Go's primary error handling mechanism --- that role belongs to returning `error` values.
Use `panic`/`recover` only for truly unrecoverable situations or at the boundary of a library to prevent a panic from escaping into caller code.
