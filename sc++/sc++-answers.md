---
title: "Starting C++ — Answer Key"
toc: true
toc-depth: 2
colorlinks: true
header-includes:
  - \usepackage[most]{tcolorbox}
---

# Chapter 1: Introduction

**1. What does the following program print?**

```cpp
#include <iostream>

int main()
{
    std::cout << "A" << "B" << std::endl;
    std::cout << "C" << std::endl;
    return 0;
}
```

It prints:

```
AB
C
```

The first line chains `"A"` and `"B"` together on the same line, then `std::endl` ends the line.
The second line prints `"C"` on a new line.

**2. What is wrong with the following program?**

```cpp
#include <iostream>

int main()
{
    std::cout << "Here we are now" << std::endl
    return 0;
}
```

There is a missing semicolon at the end of the `std::cout` line.
The line `std::cout << "Here we are now" << std::endl` needs a `;` after `std::endl`.
Without it, the compiler sees `std::endl return` which is not valid C++.

**3. Why does `std::cout` have `std::` in front of it? What would happen if you removed the `std::` without adding a `using namespace std;` directive?**

`std::cout` lives in the `std` namespace, which is where the C++ standard library places all of its names.
The `std::` prefix tells the compiler to look for `cout` inside the `std` namespace.
If you removed `std::` without adding `using namespace std;`, the compiler would not know where to find `cout` and would report an error saying `cout` was not declared.

**4. When you compile a program with `c++ -o hello hello.cpp`, what does the `-o hello` part do? What would happen if you left it out?**

The `-o hello` flag tells the compiler to name the output executable `hello`.
If you left it out, the compiler would use the default output name, which is typically `a.out` on Linux and macOS.

**5. Consider the following program:**

```cpp
#include <iostream>

int main(int argc, char *argv[])
{
    std::cout << argv[2] << std::endl;
    return 0;
}
```

**What happens if you run it with `./program alpha beta gamma`?**
It prints `beta`.
`argv[0]` is `./program`, `argv[1]` is `alpha`, `argv[2]` is `beta`, and `argv[3]` is `gamma`.

**What happens if you run it with `./program alpha`?**
This is undefined behavior.
`argc` is 2, so `argv[2]` is out of bounds.
The program might crash, print garbage, or do something else unpredictable.

**6. If `argc` is 4, how many arguments did the user provide on the command line (not counting the program name)?**

3 arguments.
`argc` counts all arguments including the program name (`argv[0]`), so the user provided `argc - 1 = 3` arguments.

**7. Write a program that asks for the user's name and favorite number, then prints a message using both.**

```cpp
#include <iostream>
#include <string>

int main()
{
    std::string name;
    int number;

    std::cout << "What is your name? ";
    std::getline(std::cin, name);

    std::cout << "What is your favorite number? ";
    std::cin >> number;

    std::cout << "Hola, " << name << "! Your favorite number is "
              << number << "." << std::endl;

    return 0;
}
```

# Chapter 2: Variables

**1. On a system where `int` is 4 bytes, what is `sizeof(scores)` for `int scores[10]`?**

40 bytes.
Each `int` is 4 bytes, and the array has 10 elements, so `sizeof(scores)` is `4 * 10 = 40`.

**2. What does the following program print?**

```cpp
#include <iostream>

int main()
{
    char c = 'C';
    c = c + 3;
    std::cout << c << std::endl;
    return 0;
}
```

It prints:

```
F
```

`'C'` has ASCII value 67.
Adding 3 gives 70, which is the ASCII value of `'F'`.

**3. What is wrong with the following code?**

```cpp
int data[3] = {10, 20, 30};
std::cout << data[3] << std::endl;
```

The array `data` has 3 elements with valid indices 0, 1, and 2.
`data[3]` is an out-of-bounds access, which is undefined behavior.
The last valid element is `data[2]`.

**4. Consider the following declarations:**

```cpp
const int *p1;
int *const p2;
```

**Which one prevents you from changing the value being pointed to?**
`const int *p1` prevents you from changing the value being pointed to.
You cannot write `*p1 = 42`.

**Which one prevents you from changing where the pointer points?**
`int *const p2` prevents you from changing where the pointer points.
You cannot write `p2 = &other_variable`.

**5. What does the following program print?**

```cpp
#include <iostream>

struct Punto {
    int x;
    int y;
};

int main()
{
    Punto a = {3, 7};
    Punto b = a;
    b.x = 10;
    std::cout << a.x << " " << b.x << std::endl;
    return 0;
}
```

It prints:

```
3 10
```

When `b = a` is executed, all members of `a` are copied into `b`.
Modifying `b.x` does not affect `a.x` because `b` has its own copy of the data.

**6. Why is it important to initialize variables before using them? What could happen if you read from an uninitialized `int`?**

An uninitialized variable contains whatever garbage data was previously in that memory location.
Reading from an uninitialized `int` is undefined behavior.
The value could be anything — zero, a large number, a negative number — and it may be different each time you run the program.
This makes bugs extremely hard to track down because the program may appear to work sometimes and fail other times.

**7. If `short` is 2 bytes, what is the maximum value an `unsigned short` can hold? How does this differ from a signed `short`?**

An `unsigned short` with 2 bytes (16 bits) can hold values from 0 to 65,535 (2^16 - 1).
A signed `short` with 2 bytes can hold values from -32,768 to 32,767 (-2^15 to 2^15 - 1).
The signed version uses one bit for the sign, which halves the positive range but allows negative values.

**8. Write a program that declares a structure to hold information about a car (make, model, year) and creates an array of 3 cars. Print out each car's information.**

```cpp
#include <iostream>
#include <string>

struct Car {
    std::string make;
    std::string model;
    int year;
};

int main()
{
    Car cars[3] = {
        {"Honda", "Civic", 1995},
        {"Toyota", "Corolla", 1998},
        {"Ford", "Mustang", 1994}
    };

    int count = sizeof(cars) / sizeof(cars[0]);

    for (int i = 0; i < count; i++) {
        std::cout << cars[i].year << " " << cars[i].make
                  << " " << cars[i].model << std::endl;
    }

    return 0;
}
```

**9. What does `std::numeric_limits<uint8_t>::max()` return? What about `std::numeric_limits<double>::min()` — is it a large negative number?**

`std::numeric_limits<uint8_t>::max()` returns `255` — the largest value an 8-bit unsigned integer can hold.

`std::numeric_limits<double>::min()` is *not* a large negative number.
It returns the smallest *positive* normalized `double` value (approximately 2.2e-308).
To get the most negative `double`, use `std::numeric_limits<double>::lowest()`.

# Chapter 3: Strings

**1. What is the difference between `std::cin >> str` and `std::getline(std::cin, str)`? When would you use each one?**

`std::cin >> str` reads one word at a time, stopping at the first whitespace character (space, tab, or newline).
`std::getline(std::cin, str)` reads an entire line of input, including spaces, until it hits a newline.

Use `std::cin >>` when you want to read a single word or token.
Use `std::getline()` when you need to read input that may contain spaces, such as a full name or a sentence.

**2. What does the following code print?**

```cpp
std::string a = "Ice";
std::string b = a + " " + a + " Baby";
std::cout << b << std::endl;
std::cout << b.size() << std::endl;
```

It prints:

```
Ice Ice Baby
12
```

The string `b` is built by concatenating `"Ice"`, `" "`, `"Ice"`, and `" Baby"`, producing `"Ice Ice Baby"` which has 12 characters.

**3. What is `std::string("Hola").at(4)`? What about `std::string("Hola")[4]`?**

`std::string("Hola").at(4)` throws a `std::out_of_range` exception.
The string `"Hola"` has indices 0 through 3, so index 4 is out of bounds and `.at()` catches this.

`std::string("Hola")[4]` accesses the null terminator character `'\0'`.
The `[]` operator does not perform bounds checking, and `std::string` stores a null terminator at position `size()`, so `[4]` returns `'\0'`.

**4. What is the value of `pos` after this code runs?**

```cpp
std::string s = "MMMBop ba duba dop";
size_t pos = s.find("dop");
```

`pos` is 15.
The substring `"dop"` starts at index 15 in the string `"MMMBop ba duba dop"`.

**5. Where is the bug in this code?**

```cpp
std::string greeting = "Hello, " + "world!";
std::cout << greeting << std::endl;
```

You cannot concatenate two string literals with `+`.
Both `"Hello, "` and `"world!"` are C-style string literals (character arrays), not `std::string` objects.
At least one side of `+` must be a `std::string`.
Fix it by making one side a `std::string`:

```cpp
std::string greeting = std::string("Hello, ") + "world!";
```

**6. Where is the bug in this program?**

```cpp
#include <iostream>
#include <string>

int main()
{
    int count;
    std::string name;
    std::cout << "how many? ";
    std::cin >> count;
    std::cout << "your name? ";
    std::getline(std::cin, name);
    std::cout << name << ": " << count << std::endl;
    return 0;
}
```

After `std::cin >> count` reads the integer, the newline character from pressing Enter is left in the input buffer.
The subsequent `std::getline()` sees that leftover newline and immediately returns an empty string without waiting for user input.
Fix it by adding `std::cin.ignore()` between the `>>` and `getline()` calls:

```cpp
std::cin >> count;
std::cin.ignore();
std::getline(std::cin, name);
```

**7. What does this code print?**

```cpp
std::string s = "Bailamos";
for (char c : s) {
    if (c == 'a') {
        std::cout << '@';
    } else {
        std::cout << c;
    }
}
std::cout << std::endl;
```

It prints:

```
B@il@mos
```

The loop replaces every lowercase `'a'` with `'@'`.
The `'B'` is uppercase and not affected.

**8. If `std::stoi("42abc")` returns `42`, what do you think `std::stoi("abc42")` does?**

`std::stoi("abc42")` throws a `std::invalid_argument` exception.
`std::stoi` starts parsing from the beginning of the string.
`"42abc"` starts with valid digits so it parses `42` and stops at `'a'`.
`"abc42"` starts with non-digit characters so there is nothing valid to parse, and it throws an exception.

**9. Write a program that asks the user for their full name using `std::getline()`, then prints the number of characters in their name and their name in reverse.**

```cpp
#include <iostream>
#include <string>

int main()
{
    std::string name;

    std::cout << "Enter your full name: ";
    std::getline(std::cin, name);

    std::cout << "Your name has " << name.size() << " characters." << std::endl;

    std::cout << "Reversed: ";
    for (int i = static_cast<int>(name.size()) - 1; i >= 0; i--) {
        std::cout << name[i];
    }
    std::cout << std::endl;

    return 0;
}
```

# Chapter 4: Expressions

**1. What is the difference between `7 / 2` and `7.0 / 2` in C++? Why does it matter?**

`7 / 2` performs integer division and produces `3`.
The fractional part is discarded because both operands are integers.

`7.0 / 2` performs floating-point division and produces `3.5`.
Because at least one operand is a floating-point type (`7.0` is a `double`), the other operand is promoted to `double` before the division.

This matters because integer division silently drops the decimal part, which can lead to incorrect results if you expect a fractional answer.

**2. What does the following code print?**

```cpp
int a = 10;
int b = a++;
int c = ++a;
std::cout << a << " " << b << " " << c << std::endl;
```

It prints:

```
12 10 12
```

- `b = a++`: postfix returns the current value of `a` (10) and then increments `a` to 11. So `b` is 10, `a` is 11.
- `c = ++a`: prefix increments `a` to 12 first, then returns the new value. So `c` is 12, `a` is 12.

**3. What is the value of each expression?**

- `17 % 5` = **2** (17 = 3 * 5 + 2)
- `20 % 4` = **0** (20 = 5 * 4 + 0)
- `3 % 7` = **3** (3 = 0 * 7 + 3, since 3 is less than 7)

**4. What does this expression evaluate to?**

```cpp
int x = 0;
bool result = (x != 0) && (100 / x > 5);
```

`result` is `false`.

It does not crash because of short-circuit evaluation.
The left side `(x != 0)` evaluates to `false`.
Since `&&` requires both sides to be true and the left side is already `false`, the right side `(100 / x > 5)` is never evaluated.
The division by zero never happens.

**5. Where is the bug?**

```cpp
int x = 5;
if (x = 10) {
    std::cout << "x is 10" << std::endl;
}
```

The condition uses `=` (assignment) instead of `==` (comparison).
`x = 10` assigns 10 to `x` and then the expression evaluates to 10, which is non-zero and therefore `true`.
The `if` block always executes regardless of `x`'s original value.
The fix is to use `==`:

```cpp
if (x == 10) {
```

**6. Where is the bug?**

```cpp
int flags = 0b1010;
if (flags & 0b0010 == 0b0010) {
    std::cout << "bit is set" << std::endl;
}
```

The `==` operator has higher precedence than `&`.
So the expression is parsed as `flags & (0b0010 == 0b0010)`, which evaluates to `flags & 1`, not `(flags & 0b0010) == 0b0010`.
The fix is to add parentheses:

```cpp
if ((flags & 0b0010) == 0b0010) {
```

**7. What does this code print?**

```cpp
int score = 85;
std::string grade = (score >= 90) ? "A"
                  : (score >= 80) ? "B"
                  : (score >= 70) ? "C"
                  : "F";
std::cout << grade << std::endl;
```

It prints:

```
B
```

`score` is 85.
The first condition `score >= 90` is false, so it moves to the next.
The second condition `score >= 80` is true, so `grade` is set to `"B"`.

**8. What is `0b1100 & 0b1010`? What is `0b1100 | 0b1010`? What is `0b1100 ^ 0b1010`?**

- `0b1100 & 0b1010` = `0b1000` (AND: a bit is 1 only if both bits are 1)
- `0b1100 | 0b1010` = `0b1110` (OR: a bit is 1 if either bit is 1)
- `0b1100 ^ 0b1010` = `0b0110` (XOR: a bit is 1 if the bits are different)

**9. Write a short program that asks the user for an integer and prints whether it is even or odd, positive or negative (or zero).**

```cpp
#include <iostream>

int main()
{
    int n;

    std::cout << "Enter an integer: ";
    std::cin >> n;

    if (n % 2 == 0) {
        std::cout << n << " is even" << std::endl;
    } else {
        std::cout << n << " is odd" << std::endl;
    }

    if (n > 0) {
        std::cout << n << " is positive" << std::endl;
    } else if (n < 0) {
        std::cout << n << " is negative" << std::endl;
    } else {
        std::cout << n << " is zero" << std::endl;
    }

    return 0;
}
```

# Chapter 5: Control Flow

**1. Think about it: When would you choose a `do-while` loop over a `while` loop?**

You would choose a `do-while` loop when the loop body must execute at least once before the condition is tested.
A classic example is an input validation loop where you want to ask the user for input and then check if it is valid.
With a `while` loop you would have to duplicate the prompt before the loop to set up the first test, but a `do-while` handles this naturally.
Another example is a menu system: you always want to display the menu at least once before checking if the user chose to quit.

**2. What does this print?**

```cpp
for (int i = 0; i < 5; i++) {
    if (i == 3)
        continue;
    std::cout << i << " ";
}
std::cout << "\n";
```

It prints:

```
0 1 2 4
```

The loop iterates from 0 to 4.
When `i` is 3, `continue` skips the rest of the loop body (the `std::cout`), so 3 is not printed.

**3. What does this print?**

```cpp
int x = 2;
switch (x) {
case 1:
    std::cout << "uno ";
case 2:
    std::cout << "dos ";
case 3:
    std::cout << "tres ";
    break;
default:
    std::cout << "other ";
}
std::cout << "\n";
```

It prints:

```
dos tres
```

`x` is 2, so execution jumps to `case 2`.
There is no `break` after `case 2`, so execution falls through into `case 3`, printing `"tres "`.
The `break` in `case 3` stops the fall-through.

**4. Where is the bug?**

```cpp
int i;
int total = 0;
for (i = 0; i < 10; i++);
{
    total += i;
}
std::cout << "Total: " << total << "\n";
```

There is a stray semicolon at the end of the `for` line: `for (i = 0; i < 10; i++);`.
The semicolon makes the `for` loop's body an empty statement, so the loop runs 10 times doing nothing.
The block `{ total += i; }` is a separate block that runs once after the loop finishes, when `i` is 10.
The program prints `Total: 10` instead of the intended `Total: 45`.
The fix is to remove the semicolon after the `for` statement.

**5. Calculation: How many times does the body of this loop execute?**

```cpp
int count = 0;
int i = 10;
do {
    count++;
    i--;
} while (i > 10);
```

The body executes **1 time**.
A `do-while` loop always executes the body at least once before testing the condition.
After the first iteration, `i` is 9, and the condition `i > 10` is false, so the loop stops.
`count` is 1.

**6. What does this print?**

```cpp
for (int i = 1; i <= 20; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
        std::cout << "both ";
    } else if (i % 3 == 0) {
        std::cout << "tres ";
    } else if (i % 5 == 0) {
        std::cout << "cinco ";
    }
}
std::cout << "\n";
```

It prints:

```
tres cinco tres tres cinco tres both tres cinco
```

The numbers from 1 to 20 that are divisible by 3 or 5:

- 3: tres
- 5: cinco
- 6: tres
- 9: tres
- 10: cinco
- 12: tres
- 15: both (divisible by both 3 and 5)
- 18: tres
- 20: cinco

Numbers not divisible by 3 or 5 produce no output.

**7. Where is the bug?**

```cpp
int n = 0;
while (n != 10) {
    std::cout << n << " ";
    n += 3;
}
```

`n` starts at 0 and increases by 3 each iteration: 0, 3, 6, 9, 12, 15, ...
The value 10 is never reached, so the condition `n != 10` is always true and the loop runs forever.
The fix is to use `<` instead of `!=`:

```cpp
while (n < 10) {
```

This makes the loop safe even if `n` skips over the exact target.

**8. Write a program that asks the user for a number between 1 and 7, prints the day of the week, and uses a `do-while` loop to keep asking until the user enters 0 to quit.**

```cpp
#include <iostream>

int main()
{
    int choice;

    do {
        std::cout << "Enter a day (1-7, 0 to quit): ";
        std::cin >> choice;

        switch (choice) {
        case 1:
            std::cout << "Monday" << std::endl;
            break;
        case 2:
            std::cout << "Tuesday" << std::endl;
            break;
        case 3:
            std::cout << "Wednesday" << std::endl;
            break;
        case 4:
            std::cout << "Thursday" << std::endl;
            break;
        case 5:
            std::cout << "Friday" << std::endl;
            break;
        case 6:
            std::cout << "Saturday" << std::endl;
            break;
        case 7:
            std::cout << "Sunday" << std::endl;
            break;
        case 0:
            std::cout << "Adios!" << std::endl;
            break;
        default:
            std::cout << "Invalid number. Try 1-7 or 0 to quit." << std::endl;
            break;
        }
    } while (choice != 0);

    return 0;
}
```

# Chapter 6: Functions

**1. Think about it: Why does C++ pass arguments by value by default instead of by reference? What advantage does this give you?**

Pass-by-value gives you a guarantee that the function cannot modify the caller's variable.
When you pass by value, the function gets its own copy, so you can reason about your code locally — you know that calling a function will not change your variables unexpectedly.
This makes code easier to understand and debug because you do not need to look inside a function to know whether it modifies its arguments.

**2. What does this print?**

```cpp
void mystery(int a, int &b) {
    a = a + 10;
    b = b + 10;
}

int main() {
    int x = 5, y = 5;
    mystery(x, y);
    std::cout << x << " " << y << "\n";
    return 0;
}
```

It prints:

```
5 15
```

`a` is passed by value, so modifying it inside `mystery` does not affect `x`.
`b` is passed by reference, so adding 10 to `b` modifies `y` directly.

**3. Calculation: What does `factorial(6)` return?**

`factorial(6)` returns **720**.

6! = 6 * 5 * 4 * 3 * 2 * 1 = 720.

**4. Where is the bug?**

```cpp
int countdown(int n) {
    return n + countdown(n - 1);
}
```

There is no base case.
The function calls itself forever (with decreasing values of `n` passing through 0 and into negative numbers) until the stack overflows and the program crashes.
The fix is to add a base case:

```cpp
int countdown(int n) {
    if (n <= 0) {
        return 0;
    }
    return n + countdown(n - 1);
}
```

**5. What does this print?**

```cpp
void greet(const std::string &name) {
    std::cout << "Hola, " << name << "\n";
}

void greet(const std::string &name, int times) {
    for (int i = 0; i < times; i++) {
        std::cout << "Hola, " << name << "! ";
    }
    std::cout << "\n";
}

int main() {
    greet("Mack");
    greet("Mack", 3);
    return 0;
}
```

It prints:

```
Hola, Mack
Hola, Mack! Hola, Mack! Hola, Mack!
```

The first call matches the one-parameter overload.
The second call matches the two-parameter overload, which prints the greeting 3 times on one line.

**6. Where is the bug?**

```cpp
void set_volume(int volume = 5, const std::string &song) {
    std::cout << song << " at " << volume << "\n";
}
```

Default parameters must appear at the end of the parameter list.
Here, `volume` has a default value but `song` (which comes after it) does not.
This is a compilation error.
The fix is to reorder the parameters:

```cpp
void set_volume(const std::string &song, int volume = 5) {
    std::cout << song << " at " << volume << "\n";
}
```

**7. What does this print?**

```cpp
int apply(int (*func)(int, int), int a, int b) {
    return func(a, b);
}

int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

int main() {
    std::cout << apply(add, 3, 4) << "\n";
    std::cout << apply(mul, 3, 4) << "\n";
    return 0;
}
```

It prints:

```
7
12
```

`apply(add, 3, 4)` calls `add(3, 4)` which returns 3 + 4 = 7.
`apply(mul, 3, 4)` calls `mul(3, 4)` which returns 3 * 4 = 12.

**8. What does this print?**

```cpp
struct Volume {
    int level;
};

Volume operator+(const Volume &a, const Volume &b) {
    return Volume{a.level + b.level};
}

bool operator>(const Volume &a, const Volume &b) {
    return a.level > b.level;
}

int main() {
    Volume a{5};
    Volume b{6};
    Volume c = a + b;
    std::cout << c.level << std::endl;
    std::cout << (a > b) << std::endl;
    return 0;
}
```

It prints:

```
11
0
```

`a + b` calls `operator+`, which adds the levels: 5 + 6 = 11.
`a > b` calls `operator>`, which compares 5 > 6, which is false (0).

**9. Why should you not overload `&&` and `||`? What behavior do the built-in versions have that overloaded versions lose?**

The built-in `&&` and `||` use **short-circuit evaluation**: the right operand is only evaluated if the left operand does not already determine the result.
For example, `ptr != nullptr && ptr->valid()` is safe because if `ptr` is null, the right side is never evaluated.

When you overload `&&` or `||`, both operands are always evaluated before the operator function is called, because function arguments are evaluated before the function runs.
This means `ptr != nullptr && ptr->valid()` would crash if `ptr` is null, because `ptr->valid()` would be evaluated regardless.

**10. Write a program with `is_even` and `count_if` functions.**

```cpp
#include <iostream>

bool is_even(int n) {
    return n % 2 == 0;
}

int count_if(const int arr[], int size, bool (*predicate)(int)) {
    int count = 0;
    for (int i = 0; i < size; i++) {
        if (predicate(arr[i])) {
            count++;
        }
    }
    return count;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int size = sizeof(numbers) / sizeof(numbers[0]);

    int evens = count_if(numbers, size, is_even);
    std::cout << "Even numbers: " << evens << std::endl;

    return 0;
}
```

This prints `Even numbers: 5` because there are 5 even numbers (2, 4, 6, 8, 10) in the array.

**11. Where is the bug?**

The function `double_it` is defined (not just declared) in the header file.
If two `.cpp` files both `#include "helpers.h"`, the linker sees two definitions of `double_it` and reports a "multiple definition" error, violating the one-definition rule.

Fix it by adding the `inline` keyword:

```cpp
inline int double_it(int n) {
    return n * 2;
}
```

**12. What does the compiler do with the following code?**

The compiler produces a warning because `compute` is marked `[[nodiscard]]` and the return value of `compute(6, 7)` is discarded.
The program still compiles, but the warning tells you that ignoring the result is almost certainly a bug.

# Chapter 7: Containers

**1. Think about it: Why does `std::array` require the size as part of its type while `std::vector` does not? What trade-off does this create?**

`std::array` stores its elements directly inside the object (on the stack), so the compiler needs to know the size at compile time to allocate the right amount of space.
The size is part of the type, which means `std::array<int, 5>` and `std::array<int, 10>` are different types and cannot be assigned to each other.

`std::vector` stores its elements on the heap, and the size can change at runtime with `push_back` and `pop_back`.
It does not need the size in its type.

The trade-off is that `std::array` is faster (no heap allocation) and has zero overhead, but it is inflexible — you must know the size at compile time.
`std::vector` is more flexible but has a small overhead from heap allocation and potential reallocations.

**2. What does this print?**

```cpp
std::vector<int> v = {10, 20, 30};
v.push_back(40);
v.pop_back();
v.pop_back();
std::cout << v.size() << " " << v.back() << "\n";
```

It prints:

```
2 20
```

Starting with `{10, 20, 30}`, `push_back(40)` makes it `{10, 20, 30, 40}`.
The first `pop_back()` removes 40: `{10, 20, 30}`.
The second `pop_back()` removes 30: `{10, 20}`.
The size is 2 and `back()` returns the last element, which is 20.

**3. Calculation: If a `std::vector<int>` has a capacity of 8 and a size of 5, how many more elements can you `push_back` before it needs to reallocate memory?**

3 more elements.
The vector has room for 8 elements (capacity) and currently holds 5 (size), so it can accept 8 - 5 = 3 more elements before it needs to grow.

**4. Where is the bug?**

```cpp
std::vector<int> scores;
scores.push_back(95);
scores.push_back(87);
scores.push_back(91);

for (int i = 0; i <= scores.size(); i++) {
    std::cout << scores[i] << "\n";
}
```

The loop condition uses `<=` instead of `<`.
`scores.size()` is 3, so valid indices are 0, 1, and 2.
When `i` is 3, `scores[3]` is an out-of-bounds access (undefined behavior).
The fix is to use `<`:

```cpp
for (int i = 0; i < scores.size(); i++) {
```

**5. What does this print?**

```cpp
std::array<int, 4> a = {5, 10, 15, 20};
for (auto it = a.begin(); it != a.end(); ++it) {
    std::cout << *it << " ";
}
std::cout << "\n";
```

It prints:

```
5 10 15 20
```

The iterator loop visits each element from `begin()` to `end()`, printing each one.

**6. Think about it: Why is `for (auto x : vec)` (without `&`) generally a bad idea for vectors of strings? When would it be acceptable?**

Without `&`, each element is copied into `x` on every iteration.
For `std::string`, this means allocating memory and copying the string data for each element, which is wasteful and slow.

It would be acceptable for small, cheap-to-copy types like `int`, `char`, or `double`, where copying is trivially fast.
It could also be acceptable if you intentionally need a copy to modify independently of the original.

**7. Where is the bug?**

```cpp
std::vector<std::string> playlist = {"Wannabe", "No Diggity"};
std::cout << playlist.at(2) << "\n";
```

The vector has 2 elements at indices 0 and 1.
`playlist.at(2)` is out of bounds and will throw a `std::out_of_range` exception, crashing the program.
The last valid index is 1.

**8. Calculation: A `std::vector<double>` contains 3 elements and has a capacity of 4. You call `push_back` 5 times. What is the size? What is the capacity?**

After 5 `push_back` calls, the size is 3 + 5 = **8**.

For capacity, starting at 4:

- Push 1 (size 4, capacity 4): fits
- Push 2 (size 5, capacity 4): exceeds capacity, doubles to 8
- Push 3 (size 6, capacity 8): fits
- Push 4 (size 7, capacity 8): fits
- Push 5 (size 8, capacity 8): fits

The final capacity is **8**.

**9. What does this print?**

```cpp
std::vector<int> v = {1, 2, 3};
v.clear();
std::cout << v.size() << " " << v.empty() << "\n";
```

It prints:

```
0 1
```

`v.clear()` removes all elements, making the size 0.
`v.empty()` returns `true`, which prints as `1`.

**10. Write a program that reads numbers from the user (enter -1 to stop), stores them in a `std::vector<int>`, and prints them in reverse order.**

```cpp
#include <iostream>
#include <vector>

int main()
{
    std::vector<int> numbers;
    int n;

    std::cout << "Enter numbers (-1 to stop):" << std::endl;

    while (std::cin >> n && n != -1) {
        numbers.push_back(n);
    }

    std::cout << "In reverse:" << std::endl;
    for (int i = static_cast<int>(numbers.size()) - 1; i >= 0; i--) {
        std::cout << numbers[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
```

**11. What does this print?**

The vector starts as `{10, 20, 30, 40, 50}`.
After `insert(v.begin() + 2, 25)`, it becomes `{10, 20, 25, 30, 40, 50}`.
After `erase(v.begin())`, it becomes `{20, 25, 30, 40, 50}`.

It prints: `20 25 30 40 50`

**12. Calculation:** What is the size and capacity after calling `reserve(100)` on an empty `std::vector<int>`, then calling `push_back` 3 times?

The size is 3 (three elements were added).
The capacity is at least 100 (the `reserve` call preallocated room for 100 elements, and adding 3 elements does not exceed that, so no reallocation occurs).

# Chapter 8: I/O Streams

**1. What does the following program print?**

```cpp
#include <sstream>
#include <iostream>

int main()
{
    std::ostringstream oss;
    oss << 10 << " + " << 20 << " = " << 10 + 20;
    std::cout << oss.str() << std::endl;
    return 0;
}
```

It prints:

```
10 + 20 = 30
```

The `ostringstream` builds the string piece by piece.
The expression `10 + 20` is evaluated to 30 before being streamed.

**2. What does this program print?**

```cpp
#include <sstream>
#include <iostream>
#include <string>

int main()
{
    std::istringstream iss("100 hola 3.14");
    int n;
    std::string s;
    double d;

    iss >> n >> s >> d;
    std::cout << d << " " << n << " " << s << std::endl;
    return 0;
}
```

It prints:

```
3.14 100 hola
```

The `>>` operator extracts values in order from the string: `n` gets 100, `s` gets "hola", `d` gets 3.14.
The `cout` statement prints them in a different order: `d`, `n`, `s`.

**3. What is wrong with this code?**

```cpp
#include <fstream>
#include <iostream>

int main()
{
    std::ifstream infile("data.txt");
    std::string line;

    while (std::getline(infile, line)) {
        std::cout << line << std::endl;
    }

    return 0;
}
```

The code does not check whether the file opened successfully before reading from it.
If `data.txt` does not exist, `infile` will be in a failed state, `std::getline` will immediately return false, and the program will silently produce no output with no error message.
The fix is to check the stream after opening:

```cpp
std::ifstream infile("data.txt");
if (!infile) {
    std::cerr << "Could not open data.txt" << std::endl;
    return 1;
}
```

**4. What is wrong with this file-writing code?**

```cpp
#include <fstream>

int main()
{
    std::ofstream out;
    out << "Yo me la paso bien" << std::endl;
    out.close();
    return 0;
}
```

The `std::ofstream` is declared but never given a filename.
The stream is not connected to any file, so writing to it does nothing.
The fix is to pass a filename to the constructor or call `.open()`:

```cpp
std::ofstream out("output.txt");
```

**5. Why is it useful that string streams, file streams, and `std::cout`/`std::cin` all share the same `<<` and `>>` interface?**

Because they share the same interface, code written to work with one type of stream can work with any type of stream.
For example, a function that writes data using `<<` on an `std::ostream&` reference can write to the screen (`std::cout`), to a file (`std::ofstream`), or to a string (`std::ostringstream`) without any changes.
This makes code more flexible and reusable.

**6. Write a program that reads three song names from the user, builds a single string with them separated by ` / ` using an `std::ostringstream`, writes it to `favorites.txt`, then reads the file back and prints its contents.**

```cpp
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

int main()
{
    std::ostringstream oss;

    for (int i = 0; i < 3; i++) {
        std::string song;
        std::cout << "Song name: ";
        std::getline(std::cin, song);
        if (i > 0) {
            oss << " / ";
        }
        oss << song;
    }

    std::ofstream outfile("favorites.txt");
    if (!outfile) {
        std::cerr << "Could not open favorites.txt" << std::endl;
        return 1;
    }
    outfile << oss.str() << std::endl;
    outfile.close();

    std::ifstream infile("favorites.txt");
    if (!infile) {
        std::cerr << "Could not read favorites.txt" << std::endl;
        return 1;
    }

    std::string line;
    while (std::getline(infile, line)) {
        std::cout << line << std::endl;
    }
    infile.close();

    return 0;
}
```

**7. What does this program print?**

It prints:

```
true
3.1
```

`std::boolalpha` makes the `bool` value `true` print as `true` instead of `1`.
`std::fixed` combined with `std::setprecision(1)` formats the `double` with exactly 1 digit after the decimal point.

**8. What happens if you open an `std::ofstream` with `std::ios::app` and write to it? How does this differ from the default behavior?**

With `std::ios::app`, new data is appended to the end of the file.
The existing content is preserved.

By default, `std::ofstream` opens with `std::ios::out | std::ios::trunc`, which truncates (erases) the file before writing.
Any existing content is lost.

# Chapter 9: std::format and std::print

**1. What does `std::format("{:>8.2f}", 3.1)` produce? How many characters wide is the result?**

It produces `"    3.10"`.
The format specifier `>8.2f` means: right-align in a field 8 characters wide, with 2 decimal places.
`3.1` formatted with 2 decimal places becomes `3.10`, which is 4 characters.
Right-aligned in 8 characters, it is padded with 4 spaces on the left.
The result is **8 characters wide**.

**2. Why might you prefer `std::format` over chaining `<<` operators with `std::cout`?**

1. **Readability:** A format string like `std::format("{} scored {} points", name, score)` is much easier to read than `std::cout << name << " scored " << score << " points"`. The format string shows the complete output pattern in one place.

2. **Formatting control:** Width, alignment, and precision are specified concisely inside `{}` placeholders (e.g., `{:>10.2f}`), rather than using verbose manipulators like `std::setw`, `std::setprecision`, and `std::setfill`.

**3. What is the difference between `std::print` and `std::println`?**

`std::print` prints formatted output without a trailing newline.
`std::println` prints formatted output followed by a newline.
They both use the same format string syntax as `std::format`.

**4. What does `std::format("{:*^20}", "Hola")` produce?**

It produces `"********Hola********"`.
The format specifier `*^20` means: center-align in a field 20 characters wide, filling with `*` characters.
"Hola" is 4 characters, so it gets 8 `*` characters on each side.

**5. What is wrong with this code?**

```cpp
std::string result = std::format("{} scored {1} points", name, score);
```

You cannot mix implicit (`{}`) and indexed (`{1}`) argument references in the same format string.
The fix is to use either all implicit or all indexed:

```cpp
std::string result = std::format("{} scored {} points", name, score);
// or
std::string result = std::format("{0} scored {1} points", name, score);
```

**6. Write a program that asks for three song names and scores, writes them to a file, reads the file back, and prints a formatted table.**

```cpp
#include <fstream>
#include <format>
#include <iostream>
#include <sstream>
#include <string>

int main()
{
    std::ofstream outfile("rankings.txt");
    if (!outfile) {
        std::cerr << "Could not open rankings.txt for writing" << std::endl;
        return 1;
    }

    for (int i = 0; i < 3; i++) {
        std::string song;
        double score;

        std::cout << "Song name: ";
        std::getline(std::cin, song);
        std::cout << "Score: ";
        std::cin >> score;
        std::cin.ignore();

        outfile << song << "|" << score << std::endl;
    }
    outfile.close();

    std::ifstream infile("rankings.txt");
    if (!infile) {
        std::cerr << "Could not open rankings.txt for reading" << std::endl;
        return 1;
    }

    std::cout << std::format("{:<25} {:>6}", "Song", "Score") << std::endl;
    std::cout << std::string(32, '-') << std::endl;

    std::string line;
    while (std::getline(infile, line)) {
        size_t sep = line.find('|');
        std::string song = line.substr(0, sep);
        double score = std::stod(line.substr(sep + 1));
        std::cout << std::format("{:<25} {:>6.1f}", song, score) << std::endl;
    }

    infile.close();
    return 0;
}
```

# Chapter 10: Exceptions

**1. What does the following program print?**

```cpp
#include <iostream>
#include <stdexcept>

void step3() { throw std::runtime_error("oops"); }
void step2() { step3(); }
void step1() { step2(); }

int main()
{
    try {
        step1();
        std::cout << "A" << std::endl;
    } catch (const std::runtime_error &e) {
        std::cout << "B: " << e.what() << std::endl;
    }
    std::cout << "C" << std::endl;
    return 0;
}
```

It prints:

```
B: oops
C
```

`step1()` calls `step2()`, which calls `step3()`, which throws.
The exception propagates back through `step2` and `step1` to the `catch` block in `main`.
`"A"` is never printed because the rest of the `try` block is skipped.
After the `catch` block handles the exception, execution continues normally and `"C"` is printed.

**2. What is wrong with this code?**

```cpp
try {
    int n = std::stoi(input);
} catch (const std::out_of_range &e) {
    std::cout << "out of range" << std::endl;
} catch (const std::exception &e) {
    std::cout << "error" << std::endl;
} catch (const std::invalid_argument &e) {
    std::cout << "bad input" << std::endl;
}
```

The `catch (const std::invalid_argument &e)` block will never execute.
`std::invalid_argument` derives from `std::exception`, and `catch` blocks are tried in order.
The `catch (const std::exception &e)` block matches any `std::exception` (including `std::invalid_argument`), so it catches the exception before the more specific handler gets a chance.
The fix is to put more specific `catch` blocks before more general ones — move `std::invalid_argument` above `std::exception`.

**3. Why should you always catch exceptions by `const` reference rather than by value?**

Catching by value makes a copy of the exception object, which can **slice** it.
If the thrown exception is a derived type (like `std::out_of_range`) and you catch by value as `std::exception`, the copy loses the derived class's data — you get only the base class portion.
Catching by `const` reference avoids the copy and preserves the full object, including any derived-class behavior.
The `const` part signals that you do not intend to modify the exception.

**4. What does the following program print?**

```cpp
#include <iostream>
#include <stdexcept>
#include <string>

struct Amp {
    std::string name;
    Amp(const std::string &n) : name(n) {
        std::cout << name << " on" << std::endl;
    }
    ~Amp() {
        std::cout << name << " off" << std::endl;
    }
};

void soundcheck() {
    Amp a("Marshall");
    Amp b("Fender");
    throw std::runtime_error("feedback!");
}

int main()
{
    try {
        soundcheck();
    } catch (...) {
        std::cout << "handled" << std::endl;
    }
    return 0;
}
```

It prints:

```
Marshall on
Fender on
Fender off
Marshall off
handled
```

The two `Amp` objects are constructed in order.
When the exception is thrown, the stack unwinds and destroys them in reverse order — `Fender` first, then `Marshall`.
After stack unwinding, the `catch (...)` block runs.

**5. Will this code compile? If so, what happens when `play()` is called?**

```cpp
void load(const std::string &file) {
    throw std::runtime_error("file not found");
}

void play() noexcept {
    load("track01.wav");
}
```

Yes, it compiles.
The compiler does not check whether a `noexcept` function actually avoids throwing — `noexcept` is a promise, not a compile-time guarantee.
When `play()` is called, `load()` throws `std::runtime_error`.
Because `play()` is marked `noexcept`, the exception cannot escape it, so the program calls `std::terminate()` and crashes immediately — no chance to catch the exception.

**6. What is the output of this program?**

```cpp
#include <expected>
#include <iostream>
#include <string>

std::expected<int, std::string> divide(int a, int b) {
    if (b == 0) {
        return std::unexpected("division by zero");
    }
    return a / b;
}

int main()
{
    auto r1 = divide(10, 3);
    auto r2 = divide(10, 0);

    if (r1) std::cout << *r1 << std::endl;
    if (!r2) std::cout << r2.error() << std::endl;

    return 0;
}
```

It prints:

```
3
division by zero
```

`divide(10, 3)` returns the expected value `3` (integer division truncates).
`divide(10, 0)` returns an unexpected error `"division by zero"`.
The boolean check `if (r1)` is true because `r1` holds a value; `if (!r2)` is true because `r2` holds an error.

**7. When would you use `std::expected` instead of throwing an exception? Give an example scenario for each.**

Use `std::expected` when failure is a *normal, expected outcome* that the caller will handle immediately.
For example, parsing user input: if you ask the user for a number and they type "abc", that is not exceptional — it is a routine case.
Returning `std::expected<int, std::string>` lets the caller inspect the error and try again.

Use exceptions when failure is *rare and should propagate* up several layers.
For example, opening a configuration file that the program requires: if the file is missing, the error should propagate up to a high-level handler that can report the problem and shut down gracefully.
Threading error codes through every intermediate function would be tedious and error-prone.

**8. Write a function `safe_sqrt` that returns `std::expected<double, std::string>`.**

```cpp
#include <cmath>
#include <expected>
#include <iostream>
#include <string>

std::expected<double, std::string> safe_sqrt(double x) {
    if (x < 0) {
        return std::unexpected("cannot take square root of negative number");
    }
    return std::sqrt(x);
}

int main()
{
    auto r1 = safe_sqrt(25.0);
    if (r1) {
        std::cout << "sqrt(25) = " << *r1 << std::endl;
    }

    auto r2 = safe_sqrt(-4.0);
    if (!r2) {
        std::cout << "Error: " << r2.error() << std::endl;
    }

    return 0;
}
```

Output:

```
sqrt(25) = 5
Error: cannot take square root of negative number
```

# Chapter 11: Classes

**1. What is the difference between a `struct` and a `class` in C++? Why would you choose one over the other?**

The only technical difference is the default access level.
Members of a `struct` are `public` by default, while members of a `class` are `private` by default.

By convention, `struct` is used for simple data holders with public members (plain old data).
`class` is used when you want to encapsulate data with behavior — bundling private data with public member functions that control access.

**2. What does the following program print?**

```cpp
#include <iostream>
#include <string>

class Band {
private:
    std::string name;
    int formed;

public:
    Band(const std::string &n, int y) : name(n), formed(y) {
        std::cout << name << " arrives" << std::endl;
    }

    ~Band() {
        std::cout << name << " exits" << std::endl;
    }
};

int main()
{
    Band a("Metallica", 1981);
    Band b("Soundgarden", 1984);
    std::cout << "show time" << std::endl;
    return 0;
}
```

It prints:

```
Metallica arrives
Soundgarden arrives
show time
Soundgarden exits
Metallica exits
```

Objects are constructed in order of declaration.
Destructors are called in reverse order when the objects go out of scope at the end of `main()`.
So `b` (Soundgarden) is destroyed before `a` (Metallica).

**3. What is wrong with the following class?**

```cpp
class Counter {
private:
    int count;

public:
    Counter() : count(0) {}

    void increment() const {
        count++;
    }

    int get_count() const { return count; }
};
```

The `increment()` function is marked `const`, but it modifies the member variable `count`.
A `const` member function promises not to modify the object, so `count++` inside a `const` function is a compilation error.
The fix is to remove `const` from `increment()`:

```cpp
void increment() {
    count++;
}
```

**4. Why should you prefer member initializer lists over assignment in the constructor body? Give an example of a situation where the initializer list is required.**

Member initializer lists initialize members directly, while assignment in the constructor body first default-constructs the members and then assigns new values.
For complex types like `std::string`, the initializer list avoids the wasted work of constructing a default value that is immediately overwritten.

An initializer list is *required* for `const` members and reference members because they cannot be assigned to after construction:

```cpp
class Example {
    const int id;
    int &ref;
public:
    // Must use initializer list — cannot assign to const or ref in body
    Example(int i, int &r) : id(i), ref(r) {}
};
```

**5. If a class has three `int` members and a `std::string` member, how many bytes minimum does an object of that class occupy on a system where `int` is 32 bits and `std::string` is 32 bytes?**

Three `int` members at 4 bytes each = 12 bytes.
One `std::string` at 32 bytes.
Total minimum: 12 + 32 = **44 bytes** (ignoring padding).

**6. What does the following code output?**

```cpp
#include <iostream>
#include <string>

class Song {
private:
    std::string title;
public:
    Song(const std::string &t) : title(t) {}

    bool operator==(const Song &other) const {
        return title == other.title;
    }
};

int main()
{
    Song a("All Star");
    Song b("All Star");
    Song c("Enter Sandman");

    std::cout << (a == b) << std::endl;
    std::cout << (a == c) << std::endl;
    return 0;
}
```

It prints:

```
1
0
```

`a == b` compares titles: `"All Star" == "All Star"` is true, which prints as 1.
`a == c` compares titles: `"All Star" == "Enter Sandman"` is false, which prints as 0.

**7. What is the bug in this code?**

```cpp
class Player {
private:
    std::string name;
    int score;

public:
    Player(const std::string &name, int score) {
        name = name;
        score = score;
    }
};
```

The constructor parameters have the same names as the member variables, so the parameters shadow the members.
The line `name = name` will not compile because the parameter `name` is `const std::string &` — you cannot assign to a const reference.
Even if both parameters were non-const, the assignments would just assign each parameter to itself without ever setting the members.

The fix is to use `this->` or, better yet, a member initializer list:

```cpp
Player(const std::string &name, int score) : name(name), score(score) {}
```

**8. What does the following program print?**

```cpp
#include <iostream>
#include <string>

class Radio {
public:
    void play(const std::string &song) {
        std::cout << "Playing: " << song << std::endl;
    }

    void play(const std::string &song, int volume) {
        std::cout << "Playing: " << song << " at volume " << volume << std::endl;
    }

    void play(int station) {
        std::cout << "Tuned to station " << station << std::endl;
    }
};

int main()
{
    Radio r;
    r.play("Torn");
    r.play(98);
    r.play("Basket Case", 11);
    return 0;
}
```

It prints:

```
Playing: Torn
Tuned to station 98
Playing: Basket Case at volume 11
```

The compiler matches each call to the overload whose parameters match the arguments.
`r.play("Torn")` matches the `string` overload, `r.play(98)` matches the `int` overload, and `r.play("Basket Case", 11)` matches the `string, int` overload.

**9. What is wrong with the following code?**

```cpp
class Speaker {
public:
    void set_volume(int v) {
        volume = v;
    }

    void set_volume(int v, int max = 100) {
        volume = (v > max) ? max : v;
    }

private:
    int volume;
};
```

The call `set_volume(50)` is ambiguous.
It could match either `set_volume(int)` or `set_volume(int, int)` (using the default value of 100 for `max`).
The compiler cannot decide which one to call and will refuse to compile the code.
The fix is to remove one of the overloads or change the default parameter design so the signatures do not overlap.

**10. Why must default parameters appear at the end of the parameter list? What happens if you try to put a default parameter before a non-default one?**

Default parameters must appear at the end because the compiler fills in defaults from right to left.
If a non-default parameter came after a default one, there would be no way to skip the default and supply the later argument.

For example, `void f(int a = 10, int b)` would make `f(5)` ambiguous — is 5 the value for `a` or `b`?
The compiler rejects this as an error.

# Chapter 12: Special Members and Friends

**1. Explain the difference between the Rule of Five and the Rule of Zero. Which one should you prefer and why?**

The **Rule of Five** says that if your class defines any one of the five special member functions (destructor, copy constructor, copy assignment, move constructor, move assignment), you should define all five.
This is necessary when your class manages a resource directly (like raw heap memory with `new`/`delete`).

The **Rule of Zero** says that you should design your classes so that they do not need to define any special member functions.
Instead, use standard library types (`std::string`, `std::vector`, `std::unique_ptr`) that manage their own resources.
The compiler-generated defaults will then do the right thing.

You should prefer the **Rule of Zero** because it results in less code, fewer bugs, and classes that are easier to maintain.
Only fall back to the Rule of Five when you have no choice but to manage a resource manually.

**2. A coworker writes a class with a move constructor but `std::vector` keeps copying objects instead of moving them during reallocation. What is wrong with the move constructor?**

```cpp
class Track {
private:
    std::string title;
    std::vector<int> samples;

public:
    Track(const std::string &t) : title(t) {}

    Track(Track &&other)
        : title(std::move(other.title)),
          samples(std::move(other.samples)) {}
};
```

The move constructor is missing `noexcept`.
`std::vector` will only move elements during reallocation if the move constructor promises not to throw.
Without `noexcept`, the vector falls back to copying because a failed move mid-reallocation would leave the vector in a broken state — some elements moved, others lost.
The fix:

```cpp
Track(Track &&other) noexcept
    : title(std::move(other.title)),
      samples(std::move(other.samples)) {}
```

**3. What does `= default` do when applied to a special member function? Why would you write `Song() = default;` instead of just omitting the default constructor?**

`= default` tells the compiler to generate the default version of that special member function.

You need `Song() = default;` when you have already defined another constructor (like a parameterized one).
Defining any constructor suppresses the compiler's automatic generation of the default constructor.
Writing `= default` brings it back without you having to write the body yourself.

**4. What does the following code do, and why is it useful?**

```cpp
class Connection {
public:
    Connection(int fd) : fd_(fd) {}
    Connection(const Connection &) = delete;
    Connection &operator=(const Connection &) = delete;
private:
    int fd_;
};
```

The `= delete` on the copy constructor and copy assignment operator prevents `Connection` objects from being copied.
Any attempt to copy a `Connection` will produce a compile-time error.

This is useful because copying a `Connection` would result in two objects managing the same file descriptor.
When both are destroyed, the file descriptor would be closed twice, which is a bug.
Deleting the copy operations forces the caller to use move semantics or pass by reference.

**5. Why does `operator<<` for output have to be a free function (or a friend) rather than a member function of your class?**

For `std::cout << myObject` to work, `operator<<` needs `std::ostream` as its left operand.
If `operator<<` were a member function of your class, the syntax would be `myObject << std::cout`, which is backwards.
The left operand of a binary operator determines which class's member function is called, and you cannot add member functions to `std::ostream` (you do not own it).
So `operator<<` must be a free function, and if it needs access to private members, it must be declared as a `friend`.

**6. What does the following program print?**

```cpp
#include <iostream>
#include <string>

class Vault {
private:
    std::string secret;

public:
    Vault(const std::string &s) : secret(s) {}

    friend void peek(const Vault &v);
};

void peek(const Vault &v) {
    std::cout << v.secret << std::endl;
}

int main()
{
    Vault v("Vogue");
    peek(v);
    return 0;
}
```

It prints:

```
Vogue
```

The free function `peek` is declared as a `friend` of `Vault`, so it can access the private member `secret` directly.

**7. If class `A` declares class `B` as a friend, and class `B` declares class `C` as a friend, can `C` access `A`'s private members? Why or why not?**

No.
Friendship is not transitive.
`B` being a friend of `A` means `B` can access `A`'s privates.
`C` being a friend of `B` means `C` can access `B`'s privates.
But that does not give `C` any access to `A`.
For `C` to access `A`'s private members, `A` would need to declare `C` as a friend directly.

**8. Write a class called `Album` with private members, a parameterized constructor, a `const` print function, an overloaded `==` operator, and a friend `operator<<`.**

```cpp
#include <iostream>
#include <string>

class Album {
private:
    std::string title;
    std::string artist;
    int track_count;

public:
    Album(const std::string &t, const std::string &a, int tc)
        : title(t), artist(a), track_count(tc) {}

    void print() const {
        std::cout << title << " by " << artist
                  << " (" << track_count << " tracks)" << std::endl;
    }

    bool operator==(const Album &other) const {
        return title == other.title && artist == other.artist
            && track_count == other.track_count;
    }

    friend std::ostream &operator<<(std::ostream &os, const Album &a);
};

std::ostream &operator<<(std::ostream &os, const Album &a) {
    os << a.title << " by " << a.artist
       << " (" << a.track_count << " tracks)";
    return os;
}

int main()
{
    Album a("Nevermind", "Nirvana", 12);
    Album b("Tragic Kingdom", "No Doubt", 14);
    Album c("Nevermind", "Nirvana", 12);

    std::cout << a << std::endl;
    std::cout << b << std::endl;

    std::cout << (a == b) << std::endl;  // 0 (false)
    std::cout << (a == c) << std::endl;  // 1 (true)

    return 0;
}
```

# Chapter 13: Memory Management

**1. What is the difference between stack and heap memory? Give one situation where you would need to use the heap.**

Stack memory is automatically managed — variables are created when declared and destroyed when they go out of scope.
Stack allocation is fast but limited in size and lifetime.

Heap memory is manually managed (or managed through smart pointers).
It persists until explicitly freed and can be much larger than the stack.

You would need the heap when you need memory to outlive the current scope (e.g., creating an object inside a function and returning a pointer to it), or when the size of the data is not known at compile time (e.g., reading an unknown number of records from a file).

**2. What does the following program print?**

```cpp
#include <iostream>
#include <memory>

int main()
{
    auto p = std::make_shared<int>(99);
    auto q = p;
    auto r = p;

    std::cout << p.use_count() << std::endl;

    q.reset();
    std::cout << p.use_count() << std::endl;

    r.reset();
    std::cout << p.use_count() << std::endl;

    return 0;
}
```

It prints:

```
3
2
1
```

After creating `p`, `q`, and `r` all pointing to the same object, the reference count is 3.
`q.reset()` releases q's ownership, dropping the count to 2.
`r.reset()` releases r's ownership, dropping the count to 1.
Only `p` still owns the object.

**3. What is the bug in the following code?**

```cpp
void play() {
    int *volumes = new int[3];
    volumes[0] = 7;
    volumes[1] = 9;
    volumes[2] = 11;
    delete volumes;
}
```

The array was allocated with `new int[3]` (array `new`), but freed with `delete` (non-array `delete`).
When you allocate with `new[]`, you must free with `delete[]`.
Using plain `delete` on an array is undefined behavior.
The fix:

```cpp
delete[] volumes;
```

**4. Why can you not copy a `std::unique_ptr`? What should you do instead if you want to transfer ownership?**

A `std::unique_ptr` represents sole ownership of a resource.
If you could copy it, two `unique_ptr`s would own the same memory, and both would try to delete it when destroyed, causing a double-free bug.

To transfer ownership, use `std::move`:

```cpp
std::unique_ptr<int> a = std::make_unique<int>(42);
std::unique_ptr<int> b = std::move(a);  // ownership transferred to b
// a is now nullptr
```

**5. After `std::move(a)` is called, is it safe to use `a`? What state is `a` in?**

After `std::move(a)`, `a` is in a valid but unspecified state.
It is safe to assign a new value to `a` or to destroy it, but you should not read its value or call methods that depend on its contents.
For `std::string`, the moved-from string is typically empty.
For `std::unique_ptr`, the moved-from pointer is `nullptr`.

**6. What is wrong with the following code?**

```cpp
#include <memory>
#include <iostream>

int main()
{
    int *raw = new int(42);
    std::unique_ptr<int> a(raw);
    std::unique_ptr<int> b(raw);

    std::cout << *a << std::endl;
    std::cout << *b << std::endl;
    return 0;
}
```

Both `a` and `b` are constructed from the same raw pointer, so they both think they own the same memory.
When they go out of scope, both will try to `delete` the same pointer, resulting in a double-free bug (undefined behavior).
This is why you should use `std::make_unique` instead of constructing `unique_ptr` from raw pointers, and never give the same raw pointer to two smart pointers.

**7. If a `std::shared_ptr` is copied 4 times (so there are 5 `shared_ptr`s total), what is the reference count? How many need to be destroyed before the object is freed?**

The reference count is **5**.
All 5 `shared_ptr`s must be destroyed (or reset) before the object is freed.
The object is deleted when the last `shared_ptr` owning it is destroyed, which brings the reference count from 1 to 0.

**8. Write a program with `std::unique_ptr` that demonstrates moving ownership.**

```cpp
#include <iostream>
#include <memory>
#include <string>

int main()
{
    std::unique_ptr<std::string> first = std::make_unique<std::string>("Wannabe");
    std::cout << "first: " << *first << std::endl;

    std::unique_ptr<std::string> second = std::move(first);
    std::cout << "second: " << *second << std::endl;

    if (!first) {
        std::cout << "first is empty (nullptr)" << std::endl;
    }

    return 0;
}
```

Output:

```
first: Wannabe
second: Wannabe
first is empty (nullptr)
```

# Chapter 14: Odds and Ends

**1. What does the following program print if the file `data.txt` does not exist?**

```cpp
#include <cstdlib>
#include <fstream>
#include <iostream>

void read_file()
{
    std::ifstream f("data.txt");
    if (!f) {
        std::cout << "A" << std::endl;
        exit(EXIT_FAILURE);
    }
    std::cout << "B" << std::endl;
}

int main()
{
    read_file();
    std::cout << "C" << std::endl;
    return EXIT_SUCCESS;
}
```

It prints:

```
A
```

The file does not exist, so `!f` is true.
`"A"` is printed, then `exit(EXIT_FAILURE)` terminates the program immediately.
Neither `"B"` nor `"C"` is ever printed.

**2. What is name mangling, and why does C++ do it but C does not?**

Name mangling is the process by which the C++ compiler encodes a function's name along with its parameter types into a unique symbol in the compiled output.
For example, `void play(int)` might become `_Z4playi`.

C++ does this because it supports function overloading — multiple functions can have the same name but different parameter types.
The mangled names ensure each overload has a unique symbol so the linker can tell them apart.

C does not mangle names because C does not support function overloading.
Each function name is unique, so the compiler stores it as-is.

**3. A coworker gets a linker error about an undefined symbol when calling a C library function. What is the fix?**

```cpp
// my_program.cpp
#include <iostream>

void c_library_init();

int main()
{
    c_library_init();
    std::cout << "Ready" << std::endl;
    return 0;
}
```

The C++ compiler mangles the name `c_library_init` when looking for it, but the C library stored it without mangling.
The fix is to declare the function with `extern "C"`:

```cpp
extern "C" void c_library_init();
```

This tells the C++ compiler to use C-style (unmangled) naming for this function.

**4. What is the value of `x` after this code runs?**

```cpp
uint8_t x = 250;
x = x + 10;
```

`x` is **4**.

`uint8_t` can hold values from 0 to 255.
250 + 10 = 260, which overflows.
For unsigned types, overflow wraps around: 260 % 256 = 4.

**5. What does the following program print?**

```cpp
#include <iostream>

int main()
{
    char c = 48;
    std::cout << c << std::endl;
    std::cout << static_cast<int>(c) << std::endl;
    return 0;
}
```

It prints:

```
0
48
```

48 is the ASCII value of the character `'0'`.
When printed as a `char`, it displays the character `0`.
When cast to `int` and printed, it displays the numeric value `48`.

**6. Explain why this C-style cast is dangerous and what C++ cast you should use instead.**

```cpp
void* ptr = get_some_pointer();
int* ip = (int*)ptr;
```

The C-style cast `(int*)ptr` silently converts a `void*` to an `int*` with no type checking.
If `ptr` actually points to a `double`, a `std::string`, or something else entirely, you will get undefined behavior when you dereference `ip`.
The C-style cast gives no indication of how dangerous this operation is.

You should use `static_cast` if you are confident about the actual type:

```cpp
int* ip = static_cast<int*>(ptr);
```

`static_cast` is more restrictive and makes the intent clear.
If you need to reinterpret the bits of one pointer type as another, use `reinterpret_cast`, which explicitly signals the danger.

**7. What is the difference between `static_cast<int>(3.14)` and `reinterpret_cast<int>(3.14)`? Will the second one even compile?**

`static_cast<int>(3.14)` performs a meaningful conversion: it converts the `double` value 3.14 to the `int` value 3 by truncating the decimal part.

`reinterpret_cast<int>(3.14)` will **not compile**.
`reinterpret_cast` works on pointers and references, not on values.
It reinterprets the bit pattern of one type as another, but you cannot `reinterpret_cast` a floating-point value directly to an integer value.

**8. What does the `#ifdef __cplusplus` guard accomplish in a C/C++ shared header? When would the code inside the `#ifdef` be skipped?**

The `#ifdef __cplusplus` guard wraps `extern "C" { ... }` around function declarations.
When the header is compiled by a C++ compiler, `__cplusplus` is defined, so the `extern "C"` block is included, preventing name mangling.
When the header is compiled by a C compiler, `__cplusplus` is not defined, so the `extern "C"` block is skipped entirely (since C does not understand `extern "C"` syntax).

This allows the same header to work correctly in both C and C++ code.

**9. Write a program that takes an `int` and prints it as a `char`, and takes a `char` and prints its integer value. Use `static_cast` for both conversions.**

```cpp
#include <iostream>

int main()
{
    int value = 65;
    char letter = 'Z';

    std::cout << "int " << value << " as char: "
              << static_cast<char>(value) << std::endl;
    std::cout << "char '" << letter << "' as int: "
              << static_cast<int>(letter) << std::endl;

    return 0;
}
```

Output:

```
int 65 as char: A
char 'Z' as int: 90
```

**10. What does the following program print?**

```cpp
#include <chrono>
#include <iostream>

int main()
{
    using namespace std::chrono;

    auto d = seconds(5) + milliseconds(750);
    std::cout << duration_cast<seconds>(d).count() << std::endl;

    return 0;
}
```

It prints:

```
5
```

`seconds(5) + milliseconds(750)` produces a duration of 5750 milliseconds.
`duration_cast<seconds>` truncates toward zero, giving 5 seconds (not 6).
The fractional 750 milliseconds is discarded.

**11. Why should you use `std::chrono::steady_clock` instead of `std::chrono::system_clock` when measuring how long a piece of code takes to run?**

`steady_clock` is guaranteed to never be adjusted — it always moves forward at a constant rate.
`system_clock` represents the system's wall clock, which can jump forward or backward when the clock is adjusted (e.g., NTP synchronization, daylight saving time changes, or manual adjustments).
If `system_clock` jumps during your measurement, you could get a negative elapsed time or an incorrectly large one.
`steady_clock` avoids this problem entirely.

**12. What is wrong with this code for generating a random number between 1 and 100?**

```cpp
#include <cstdlib>
#include <iostream>

int main()
{
    int r = rand() % 100 + 1;
    std::cout << r << std::endl;

    return 0;
}
```

There are two problems:

1. `srand()` is never called, so `rand()` uses the same default seed every time the program runs, producing the same "random" number.
2. Even with `srand()`, `rand() % 100` introduces bias — if `RAND_MAX` is not evenly divisible by 100, some values are slightly more likely than others.

The proper C++ approach is to use `<random>` with `std::mt19937` and `std::uniform_int_distribution<int>(1, 100)`.

**13. Write a program that uses `<random>` to simulate rolling two six-sided dice 10 times and prints each roll.**

```cpp
#include <iostream>
#include <random>

int main()
{
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> die(1, 6);

    for (int i = 0; i < 10; ++i) {
        int d1 = die(gen);
        int d2 = die(gen);
        std::cout << "Roll " << (i + 1) << ": " << d1 << " + " << d2
                  << " = " << (d1 + d2) << std::endl;
    }

    return 0;
}
```

Sample output:

```
Roll 1: 3 + 5 = 8
Roll 2: 1 + 6 = 7
Roll 3: 4 + 4 = 8
Roll 4: 2 + 1 = 3
Roll 5: 6 + 3 = 9
Roll 6: 5 + 2 = 7
Roll 7: 1 + 4 = 5
Roll 8: 3 + 6 = 9
Roll 9: 2 + 2 = 4
Roll 10: 4 + 5 = 9
```

**14. Write a program that generates 10 random values using `std::normal_distribution` with a mean of 100 and a standard deviation of 15.**

```cpp
#include <iostream>
#include <random>

int main()
{
    std::random_device rd;
    std::mt19937 gen(rd());
    std::normal_distribution<double> dist(100.0, 15.0);

    for (int i = 0; i < 10; ++i) {
        std::cout << dist(gen) << " ";
    }
    std::cout << std::endl;

    return 0;
}
```

Most values will be close to 100.
About 68% of values should fall between 85 and 115 (within one standard deviation of the mean), and about 95% should fall between 70 and 130 (within two standard deviations).
