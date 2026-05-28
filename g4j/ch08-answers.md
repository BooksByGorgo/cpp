# Chapter 8: Maps and Structs --- Answers

**Exercise 1** (Think about it):
In Java, you can use any object as a `HashMap` key as long as you override `hashCode()` and `equals()`.
In Go, map key types must be **comparable** --- they must support `==` at the language level.
What are the advantages and disadvantages of Go's approach compared to Java's?
Give one example of a Java key type that you cannot use directly as a Go map key, and explain how you would work around it.

**Go's approach --- advantages:**

- The constraint is enforced by the compiler at the type level with no runtime overhead.
  There is no risk of accidentally using a type as a key when its `==` semantics are broken or inconsistent.
- There is no equivalent of the Java footgun where you override `equals` but forget `hashCode`, or vice versa, causing `HashMap` to misbehave silently.
- The programmer does not need to implement any interface or write any boilerplate; any type that supports `==` just works.

**Go's approach --- disadvantages:**

- You cannot use slices, maps, or functions as keys, even if you have a meaningful notion of equality for them.
  In Java, if you implement `hashCode()` and `equals()` on a wrapper, you can use any object as a key.
- There is no way to customise the equality semantics for a key type.
  In Java, you can make two objects with different memory addresses compare as equal by overriding `equals()`.
  In Go, `==` on a struct compares field-by-field; you cannot override that.

**Example:** A `[]byte` slice is a common Java key (as a `byte[]` wrapped in a class with a custom `hashCode`).
In Go, `[]byte` is not comparable and cannot be a map key directly.
The idiomatic workaround is to convert the slice to `string` first: a `string` is comparable, and a `string([]byte{...})` conversion is a well-defined operation.

```go
key := string([]byte{0x01, 0x02, 0x03})
m := map[string]int{}
m[key] = 42
```

This works because Go allows `string(b)` for any `[]byte` `b`, and the resulting string compares by byte content, which is the equality you typically want.

---

**Exercise 2** (What does this print?):

```go
package main

import "fmt"

func main() {
    type Artist struct {
        Name string
    }
    type Song struct {
        Artist
        Title string
    }

    s := Song{
        Artist: Artist{Name: "Peso Pluma"},
        Title:  "La Bebé",
    }

    s.Name = "Natanael Cano"
    fmt.Println(s.Title, "by", s.Name)
    fmt.Println(s.Artist.Name)
}
```

Output:
```
La Bebé by Natanael Cano
Natanael Cano
```

`s.Name = "Natanael Cano"` modifies the `Name` field of the embedded `Artist` value through the promoted field path.
`s.Name` and `s.Artist.Name` refer to the same field; they are two ways to express the same memory location.
After the assignment, both `s.Name` and `s.Artist.Name` return `"Natanael Cano"`.

The first `fmt.Println` prints `"La Bebé by Natanael Cano"` because `s.Title` is `"La Bebé"` and `s.Name` (promoted from `Artist`) is now `"Natanael Cano"`.
The second `fmt.Println` prints `"Natanael Cano"` because `s.Artist.Name` is the same field accessed through the explicit path.

Key takeaway: embedding promotes fields; the promoted shorthand and the explicit path are identical at runtime.

---

**Exercise 3** (Calculation):
Given the following map and operations, what does `len(m)` return after the final line?

```go
m := map[string]int{
    "pop":       1,
    "rock":      2,
    "jazz":      3,
    "classical": 4,
}
delete(m, "rock")
delete(m, "country") // key does not exist
m["hip-hop"] = 5
m["jazz"] = 99
```

`len(m)` returns **4**.

Trace:

1. After the literal, `m` has 4 entries: `pop`, `rock`, `jazz`, `classical`.
2. `delete(m, "rock")` removes `rock` --- 3 entries remain.
3. `delete(m, "country")` is a no-op; `country` is not in the map --- still 3 entries.
4. `m["hip-hop"] = 5` inserts a new key --- 4 entries.
5. `m["jazz"] = 99` updates an existing key; this does **not** change the count --- still 4 entries.

Final map: `{"pop": 1, "jazz": 99, "classical": 4, "hip-hop": 5}`.
`len(m)` is `4`.

---

**Exercise 4** (Where is the bug?):
The following function is supposed to count how many tracks in a catalog have a BPM above a threshold, but it always returns 0.

```go
package main

import "fmt"

func countFast(catalog map[string]int, threshold int) int {
    var count int
    for track := range catalog {
        if catalog[track] > threshold {
            count++
        }
    }
    return count
}

func main() {
    catalog := map[string]int{
        "Gasoline":      148,
        "Industry Baby": 160,
        "Numb":           72,
    }
    fmt.Println(countFast(nil, 100))
}
```

The bug is that `countFast` is called with `nil` instead of `catalog`.

`main` creates `catalog` but then passes `nil` (not `catalog`) to `countFast`.
A nil map has zero entries, so `for track := range nil` never executes, and `count` stays at `0`.

Reading from a nil map is safe in Go --- `catalog[track]` on a nil map returns `0` --- but iterating over a nil map yields no iterations at all, so the loop body never runs.

The fix is to pass the actual map:

```go
fmt.Println(countFast(catalog, 100))
```

With the correct call, the function returns `2` (`"Gasoline"` at 148 and `"Industry Baby"` at 160 both exceed the threshold of 100).

A secondary improvement: the loop uses `for track := range catalog` and then does a second map lookup `catalog[track]`.
This works, but the idiomatic form uses the value directly from the range:

```go
for _, bpm := range catalog {
    if bpm > threshold {
        count++
    }
}
```

This is one lookup per iteration instead of two.

---

**Exercise 5** (Write a program):
Define a `Song` struct with fields `Title string`, `Artist string`, and `Plays int`.
Build a slice of at least four `Song` values.
Write `topN(songs []Song, n int) []Song` that returns the `n` most-played songs in descending order.
Use `slices.SortFunc` and `cmp.Compare`.

```go
package main

import (
    "cmp"
    "fmt"
    "slices"
)

type Song struct {
    Title  string
    Artist string
    Plays  int
}

// topN returns the n most-played songs in descending order by Plays.
// If n >= len(songs), all songs are returned.
func topN(songs []Song, n int) []Song {
    // work on a copy so the original slice is not reordered
    result := make([]Song, len(songs))
    copy(result, songs)

    // sort descending: negate the comparison to reverse order
    slices.SortFunc(result, func(a, b Song) int {
        return cmp.Compare(b.Plays, a.Plays) // b before a for descending
    })

    if n > len(result) {
        n = len(result)
    }
    return result[:n]
}

func main() {
    songs := []Song{
        {Title: "Blinding Lights",    Artist: "The Weeknd",      Plays: 4_000_000_000},
        {Title: "Stay",               Artist: "The Kid LAROI",   Plays: 2_200_000_000},
        {Title: "Unholy",             Artist: "Sam Smith",       Plays: 2_000_000_000},
        {Title: "Save Your Tears",    Artist: "The Weeknd",      Plays: 1_800_000_000},
        {Title: "Golden Hour",        Artist: "JVKE",            Plays:   900_000_000},
    }

    fmt.Println("Top 3:")
    for _, s := range topN(songs, 3) {
        fmt.Printf("  %-28s %d plays\n", s.Title, s.Plays)
    }
}
```

Output:
```
Top 3:
  Blinding Lights             4000000000 plays
  Stay                        2200000000 plays
  Unholy                      2000000000 plays
```

Notes on the solution:

- `copy(result, songs)` prevents `slices.SortFunc` from mutating the caller's slice.
  If the caller passes a slice they intend to use in original order, an in-place sort would be a surprising side effect.
- `cmp.Compare(b.Plays, a.Plays)` with arguments reversed produces descending order.
  `cmp.Compare(a.Plays, b.Plays)` would sort ascending.
- The `n > len(result)` guard avoids a slice-bounds panic when the caller asks for more songs than exist.
