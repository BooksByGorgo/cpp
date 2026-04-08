# Lecture 7+8 --- Functions

**Source:** `sc++/ch06.md`
**Duration:** 2 x 75 minutes (lectures 7 and 8)

Chapter 6 is split across two lectures:

- **Lecture 7 --- Function Basics:** declarations vs definitions, parameters and return values, pass-by-value, pass-by-reference, `const` parameters, structures as parameters, default parameters
- **Lecture 8 --- Advanced Functions:** function overloading, recursion, function pointers and callbacks, `[[nodiscard]]`, operator functions

---

# Lecture 7 --- Function Basics

## Learning Objectives

By the end of lecture 7, students should be able to:

- Distinguish a function declaration (prototype) from a definition
- Write a forward declaration when a function is called before its definition
- Explain the difference between pass-by-value and pass-by-reference
- Use `const` references to pass large types efficiently and safely
- Give a function default parameter values and list the rules for them

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch06.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 6): **What does this print?**

    ```cpp
    int x = 2;
    switch (x) {
    case 1: std::cout << "uno ";
    case 2: std::cout << "dos ";
    case 3: std::cout << "tres "; break;
    default: std::cout << "other ";
    }
    std::cout << "\n";
    ```

    - A. `uno`
    - B. `dos`
    - C. `dos tres`
    - D. `uno dos tres`
    - E. Ben got this wrong

    *Answer: C* --- case 2 matches and falls through case 3.

- Today we leave `main` behind and learn to build **reusable pieces** of code

## 1. Why Functions? (3 min)

- `main` grows fast --- functions let you break a program into named pieces
- Each function has a signature, a body, and a single return value
- You have already been using them: `main` is a function, so is `std::string::size()`, so is every `<<`

## 2. Declarations vs Definitions (8 min)

```cpp
// Declaration (prototype) --- no body, just a semicolon
int add(int a, int b);

// Definition --- has the body
int add(int a, int b) {
    return a + b;
}
```

- A **declaration** tells the compiler the signature
- A **definition** provides the actual code
- You can have many declarations but exactly **one** definition (the One Definition Rule, ODR)

### Forward Declarations

```cpp
#include <iostream>
#include <string>

void greet(const std::string &name);    // forward declaration

int main() {
    greet("Mack");
    return 0;
}

void greet(const std::string &name) {    // definition after main
    std::cout << "Return of the " << name << "!\n";
}
```

- The compiler reads top to bottom. A forward declaration lets you call a function before the compiler sees its body.

### `inline` for Header Definitions

```cpp
// helpers.h
inline int max_volume() {
    return 11;
}
```

- Defining a function in a header without `inline` violates the ODR when multiple `.cpp` files include it
- `inline` tells the linker "these are all the same definition"

::: {.tip}
**Wut:** `inline` does **not** mean "the compiler will inline the call". Modern compilers decide that on their own. `inline` is a linkage instruction.
:::

## 3. Parameters and Return Values (5 min)

```cpp
int multiply(int x, int y) {
    return x * y;
}

int result = multiply(6, 7);   // 42
```

- A function can take zero or more parameters and return at most one value
- The return type comes before the name

### `void` Functions

```cpp
void print_chorus() {
    std::cout << "I want it that way\n";
}

void check_age(int age) {
    if (age < 0) {
        std::cout << "Invalid age\n";
        return;    // early exit
    }
    std::cout << "Age: " << age << "\n";
}
```

- A `void` function returns nothing
- `return;` (with no value) can still be used to exit early

## 4. Pass-by-Value (10 min)

```cpp
void try_to_change(int x) {
    x = 999;    // modifies the local copy
}

int main() {
    int num = 42;
    try_to_change(num);
    std::cout << num << "\n";   // still 42
}
```

- **Default** behavior: the function gets a **copy**
- Changes to the parameter do not affect the caller's variable
- For small types (`int`, `char`, `double`), this is exactly what you want

## 5. Pass-by-Reference (12 min)

```cpp
void make_it_louder(int &volume) {
    volume = 11;
}

int main() {
    int vol = 5;
    make_it_louder(vol);
    std::cout << vol << "\n";   // 11
}
```

- The `&` after the type makes `volume` a **reference** --- an alias for the caller's variable
- Changes to the parameter **are** changes to the caller's variable

### Classic Example: Swap

```cpp
void swap(int &a, int &b) {
    int temp = a;
    a = b;
    b = temp;
}
```

::: {.tip}
**Tip:** Pass-by-value for small types; pass-by-reference for large types (strings, structs) to avoid copying.
:::

## 6. `const` Parameters (8 min)

```cpp
void print_song(const std::string &title) {
    std::cout << "Now playing: " << title << "\n";
    // title = "something else";   // ERROR: title is const
}
```

- `const` reference: no copy, no modification --- best of both worlds
- Communicates your intent to readers; the compiler enforces it

::: {.tip}
**Wut:** `const` references can bind to temporaries, non-`const` references cannot. `print_song("Semi-Charmed Life")` works; `modify_song("Semi-Charmed Life")` does not.
:::

Rule of thumb:

- small type --> pass by **value**
- large type you do not modify --> pass by **`const` reference**
- you need to modify the caller's variable --> pass by **non-const reference**

## 7. Structs as Parameters (5 min)

```cpp
struct Album {
    std::string title;
    std::string artist;
    int year;
    int tracks;
};

// BAD: copies the entire Album
void print_bad(Album a);

// GOOD: no copy, no modification
void print_good(const Album &a);
```

- Passing a struct by value copies **every member**
- Strings and vectors inside the struct get copied too --- can be surprisingly expensive

## 8. Default Parameters (10 min)

```cpp
void play(const std::string &song, int volume = 5) {
    std::cout << "Playing " << song << " at volume " << volume << "\n";
}

play("Return of the Mack");        // volume = 5
play("Return of the Mack", 11);    // volume = 11
```

- Default values are listed in the declaration
- Defaulted parameters **must** be at the **end** of the parameter list

```cpp
// OK
void play(const std::string &song, int volume = 5);

// ERROR: default cannot precede a non-defaulted parameter
void play(int volume = 5, const std::string &song);
```

::: {.tip}
**Trap:** Put default values in the **declaration**, not the definition, if they are separate. Specifying them in both is an error.
:::

## 9. Wrap-up Quiz (3 min)

**Q1.** What does this print?

```cpp
void mystery(int a, int &b) {
    a = a + 10;
    b = b + 10;
}

int main() {
    int x = 5, y = 5;
    mystery(x, y);
    std::cout << x << " " << y << "\n";
}
```

A. `5 5`
B. `5 15`
C. `15 5`
D. `15 15`
E. Ben got this wrong

*Answer: B* --- `a` is a copy, `b` is a reference.

**Q2.** Where is the bug?

```cpp
void set_volume(int volume = 5, const std::string &song) {
    std::cout << song << " at " << volume << "\n";
}
```

A. `volume` should be `const`
B. Default parameter must appear at the end of the parameter list
C. `song` should have a default value too
D. `void` functions cannot take parameters
E. Ben got this wrong

*Answer: B*

## 10. Assignment / Reading (1 min)

- **Read:** chapter 6, remaining sections --- function overloading, recursion, function pointers, operator functions, `[[nodiscard]]`
- **Do:** chapter 6 exercises 3, 4, 5, 7, 8, 9, 10, 12
- **Bring:** an example of a recursive function you can write on paper

## Key Points to Reinforce

- Declarations vs definitions; forward declarations are essential in multi-file programs
- Default is **pass-by-value** --- copies are cheap for ints, expensive for strings
- `&` for references; combine with `const` when you do not need to modify the argument
- Default parameters live on the right side of the parameter list

---

# Lecture 8 --- Advanced Functions

## Learning Objectives

By the end of lecture 8, students should be able to:

- Overload functions on parameter type/count
- Write a recursive function with a correct base case
- Declare and call function pointers and use them as callbacks
- Use `[[nodiscard]]` to mark functions whose return value should not be ignored
- Write operator functions for a user-defined type (and know what **not** to overload)

## Materials

- Live coding terminal with `g++` (`-std=c++23 -Wall -Wextra -pedantic`)
- A text editor projected for the class
- Copies of `sc++/ch06.md` for reference

---

## 0. Welcome and Review (5 min)

- Review multiple choice (from lecture 7): **What does this print?**

    ```cpp
    void mystery(int a, int &b) { a += 10; b += 10; }
    int main() { int x = 5, y = 5; mystery(x, y); std::cout << x << " " << y; }
    ```

    - A. `5 5`
    - B. `5 15`
    - C. `15 5`
    - D. `15 15`
    - E. Ben got this wrong

    *Answer: B*

## 1. Function Overloading (10 min)

```cpp
void display(int value) {
    std::cout << "Integer: " << value << "\n";
}

void display(const std::string &value) {
    std::cout << "String: " << value << "\n";
}

void display(double value) {
    std::cout << "Double: " << value << "\n";
}
```

- Same name, different parameter lists
- The compiler picks the best match based on argument types
- You **cannot** overload on **return type alone** --- the parameter lists must differ

## 2. Recursive Functions (15 min)

```cpp
int factorial(int n) {
    if (n <= 1) return 1;            // base case
    return n * factorial(n - 1);     // recursive case
}

factorial(5);   // 120
```

Every recursive function needs:

1. A **base case** --- the stopping condition
2. A **recursive case** --- call yourself with a smaller problem

Trace `factorial(3)` on the board:

```
factorial(3)
  -> 3 * factorial(2)
      -> 2 * factorial(1)
          -> 1 (base case)
      -> 2
  -> 6
```

::: {.tip}
**Trap:** Forgetting the base case is the #1 recursion bug. Always ask: "Under what condition does this function *not* call itself?"
:::

## 3. Function Pointers (15 min)

```cpp
int add(int a, int b)      { return a + b; }
int subtract(int a, int b) { return a - b; }

int (*operation)(int, int);   // function pointer

operation = add;
std::cout << operation(10, 3) << "\n";   // 13

operation = subtract;
std::cout << operation(10, 3) << "\n";   // 7
```

- `int (*operation)(int, int)` means "pointer to a function taking two `int`s and returning `int`"
- The parentheses around `*operation` are required

### Cleaning Up With `using`

```cpp
using MathOp = int (*)(int, int);
MathOp op = add;
```

### Callbacks

```cpp
void process_songs(const std::string songs[], int count,
                   void (*action)(const std::string &)) {
    for (int i = 0; i < count; i++) {
        action(songs[i]);
    }
}

void announce(const std::string &song) { std::cout << "Now playing: " << song << "\n"; }
void shout(const std::string &song)    { std::cout << ">> " << song << "!! <<\n"; }

process_songs(playlist, 3, announce);
process_songs(playlist, 3, shout);
```

- `process_songs` does not know what `action` does --- it just calls it
- Swap behavior by passing a different function

## 4. `[[nodiscard]]` (5 min)

```cpp
[[nodiscard]] int find_track(const std::string &playlist);

find_track("90s Jams");            // warning: ignoring return value
int pos = find_track("90s Jams");  // OK
```

- Marks a function whose return value should not be ignored
- Use it on error codes, computed results, or newly-allocated resources

## 5. Operator Functions (15 min)

Operator overloading lets you teach the compiler how `+`, `==`, `<<`, etc. work for your own types.

```cpp
struct Score {
    std::string player;
    int points;
};

Score operator+(const Score &a, const Score &b) {
    return Score{a.player + " & " + b.player, a.points + b.points};
}

bool operator>(const Score &a, const Score &b) {
    return a.points > b.points;
}

Score a{"Fly", 95};
Score b{"Intergalactic", 88};
Score combined = a + b;                 // calls operator+
if (a > b) { std::cout << a.player; }   // calls operator>
```

### `<<` for Printing

```cpp
std::ostream &operator<<(std::ostream &os, const Score &s) {
    os << s.player << ": " << s.points;
    return os;
}

std::cout << a << "\n";   // Fly: 95
```

- Returning the stream enables chaining

### Rules

- Cannot invent new operators
- Cannot change arity (binary stays binary, unary stays unary)
- Cannot change precedence or associativity
- At least one operand must be a user-defined type
- Some operators cannot be overloaded: `::`, `.`, `.*`, `?:`, `sizeof`

::: {.tip}
**Trap:** Do **not** overload `&&`, `||`, or `,`. The built-in `&&` and `||` short-circuit; overloaded versions evaluate **both** sides always.
:::

## 6. Wrap-up Quiz (4 min)

**Q1.** What is `factorial(6)`?

A. 120
B. 180
C. 720
D. 5040
E. Ben got this wrong

*Answer: C* --- 6! = 720.

**Q2.** What does this print?

```cpp
int apply(int (*f)(int, int), int a, int b) { return f(a, b); }
int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

std::cout << apply(add, 3, 4) << " " << apply(mul, 3, 4) << "\n";
```

A. `3 4`
B. `7 7`
C. `7 12`
D. `12 7`
E. Ben got this wrong

*Answer: C*

**Q3.** Why should you not overload `&&`?

A. It is not a valid operator
B. You lose short-circuit evaluation
C. The compiler rejects it
D. It makes the function pointer syntax worse
E. Ben got this wrong

*Answer: B*

## 7. Assignment / Reading (1 min)

- **Read:** chapter 7 of *Starting C++*, sections on bases, integer literals, printing in other bases, and string-to-number conversions (first half)
- **Do:** chapter 7 exercises 1, 2, 7 (base conversions, literals, octal trap)
- **Bring:** a guess at how `std::stoi("42abc")` behaves

## Key Points to Reinforce

- Overloading is based on **parameter lists**, never return type alone
- Every recursion needs a base case
- Function pointer syntax is ugly --- use `using` to alias it
- `[[nodiscard]]` prevents silently ignored return values
- Operator functions should **behave as expected** --- `+` combines, `==` compares
- Do not overload `&&`, `||`, or `,`
