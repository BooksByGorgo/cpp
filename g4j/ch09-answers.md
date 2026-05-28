# Chapter 9: Interfaces --- Answers

**Exercise 1** (Think about it): Go's structural typing means any package can retroactively make its types satisfy an interface defined in any other package.
In Java, if you want your `Song` class to satisfy a new interface `Playable` defined in a library you do not control, you must modify `Song`'s source.
Explain how Go's approach changes the relationship between library authors and library users.
What does this mean for extending types from packages you cannot modify?

Go's structural typing means that the author of a type and the author of an interface are completely decoupled.
If library A defines `type Track struct { ... }` and later library B defines `interface Playable { Play() }`, and `Track` already has a `Play()` method, then `Track` satisfies `Playable` automatically --- neither author needs to know about the other.

For types you cannot modify, the picture is similar: if the type already has the methods you need, you can use it directly where your interface is expected.
If it does not, you have two options: wrap the type in your own struct that adds the missing methods (the adapter pattern), or define a new named type based on the original and add methods to that.

This is a fundamental philosophical difference.
In Java, the relationship between a class and an interface is declared at write-time and embedded in the source.
In Go, the relationship is discovered at compile-time by the compiler --- it emerges from what the type does, not from what it says it is.
This makes Go code easier to extend and test, because you can define narrow interfaces in your own package that third-party types satisfy without any changes to the third-party source.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

type Celsius float64
type Fahrenheit float64

func (c Celsius) String() string {
    return fmt.Sprintf("%.1f°C", float64(c))
}

func printTemp(v fmt.Stringer) {
    fmt.Println(v.String())
}

func main() {
    c := Celsius(37.5)
    f := Fahrenheit(99.5)
    printTemp(c)
    fmt.Println(f)
}
```

Output:
```
37.5°C
99.5
```

`Celsius` has a `String() string` method, so it satisfies `fmt.Stringer`.
`printTemp` calls `v.String()` and passes the result to `fmt.Println`, which prints `37.5°C` followed by a newline.

`Fahrenheit` does **not** have a `String() string` method, so it does not satisfy `fmt.Stringer`.
`fmt.Println(f)` formats `f` using the default verb for its underlying type, which is `float64`.
The default formatting for a float is the shortest decimal representation that rounds back to the same value --- here that is `99.5`.
No degree symbol, no unit: just the number.

---

**Exercise 3** (Calculation): An interface value in Go stores two fields: a pointer to type information and a pointer to (or copy of) the data.
Given a variable declared as `var r io.Reader = &bytes.Buffer{}`, how many distinct type/value components does `r` hold?
If `r` is then assigned `nil`, describe the type and value components of the resulting interface value.

`r` holds **two** components:
- **Type:** a pointer to the runtime type descriptor for `*bytes.Buffer`.
- **Value:** a pointer to the `bytes.Buffer` value on the heap.

After `r = nil`, both components are set to `nil`:
- **Type:** `nil` (no concrete type information).
- **Value:** `nil` (no data pointer).

This is the **untyped nil** interface value.
`r == nil` is `true` after this assignment.

Contrast this with the nil trap in the chapter: if instead you wrote `var buf *bytes.Buffer = nil; r = buf`, the type component would be `*bytes.Buffer` (non-nil) and the value component would be `nil`.
That interface value is **not** nil even though `buf` is nil.

---

**Exercise 4** (Where is the bug?):

```go
package main

import "fmt"

type DBError struct{ code int }

func (e *DBError) Error() string { return fmt.Sprintf("db error %d", e.code) }

func connect(bad bool) error {
    var err *DBError
    if bad {
        err = &DBError{code: 500}
    }
    return err
}

func main() {
    e := connect(false)
    if e == nil {
        fmt.Println("connected OK")
    } else {
        fmt.Println("failed:", e)
    }
}
```

**The bug:** `connect` always returns a non-nil `error`, even when `bad` is `false`.

When `bad` is `false`, `err` is a nil `*DBError`.
The `return err` statement wraps that typed nil in an `error` interface value.
The interface value has type `*DBError` (non-nil) and value `nil`.
Because the type component is non-nil, `e == nil` evaluates to `false`, and the program prints `failed: <nil>` instead of `connected OK`.

**The fix:**

```go
func connect(bad bool) error {
    if bad {
        return &DBError{code: 500}
    }
    return nil  // untyped nil: type=nil, value=nil --- this is a true nil error
}
```

Return `nil` directly rather than returning a typed nil pointer through an interface variable.

---

**Exercise 5** (Write a program):

```go
package main

import (
    "fmt"
    "math"
)

type Shape interface {
    Area() float64      // returns the area of the shape
    Perimeter() float64 // returns the perimeter of the shape
}

type Rectangle struct {
    Width  float64
    Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.Radius
}

func printShapeInfo(s Shape) {
    fmt.Printf("Area:      %.4f\n", s.Area())
    fmt.Printf("Perimeter: %.4f\n", s.Perimeter())
}

func main() {
    r := Rectangle{Width: 4.0, Height: 3.0}
    c := Circle{Radius: 5.0}

    fmt.Println("Rectangle:")
    printShapeInfo(r)

    fmt.Println("Circle:")
    printShapeInfo(c)
}
```

Output:
```
Rectangle:
Area:      12.0000
Perimeter: 14.0000
Circle:
Area:      78.5398
Perimeter: 31.4159
```

Both `Rectangle` and `Circle` satisfy `Shape` implicitly --- no declaration required.
`printShapeInfo` accepts any `Shape`, so adding a new shape (say, `Triangle`) requires only implementing `Area()` and `Perimeter()` on it; `printShapeInfo` does not change.
This is the open/closed principle, Go style.
