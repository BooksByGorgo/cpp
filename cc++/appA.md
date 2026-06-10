
\appendix

# Build Systems and Tooling

\index{build system}

Throughout this book you have compiled programs with a single `g++` command.
That works for small programs, but real projects have dozens or hundreds of source files, external dependencies, and platform-specific requirements.
A **build system** automates compilation so you do not have to type long commands or remember which files changed.
This appendix covers CMake (the most widely used C++ build system), compiler flags, sanitizers, static analysis, and basic debugging.

## CMake Basics

\index{CMake}

CMake is a **build system generator** --- it reads a `CMakeLists.txt` file and generates the actual build files (Makefiles on Linux/macOS, Visual Studio projects on Windows).

### A Minimal Project

Create a directory with two files:

```
my_project/
  CMakeLists.txt
  main.cpp
```

`CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyProject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(myapp main.cpp)
```

`main.cpp`:

```cpp
#include <iostream>

int main() {
    std::cout << "Built with CMake!\n";
    return 0;
}
```

Build it:

```bash
cmake -B build
cmake --build build
./build/myapp
```

`cmake -B build` generates the build files into a `build/` directory, and `cmake --build build` runs the underlying build tool for you.
You may also see the older two-step form `mkdir build && cd build && cmake ..` followed by `make`; it does the same thing.

### Multiple Source Files

```cmake
add_executable(myapp
    main.cpp
    playlist.cpp
    audio.cpp
)
```

### Libraries

```cmake
# Create a library
add_library(audio audio.cpp codec.cpp)

# Link it to the executable
add_executable(myapp main.cpp)
target_link_libraries(myapp PRIVATE audio)
```

`PRIVATE` means `audio` is only needed by `myapp`, not by anything that uses `myapp`.
Use `PUBLIC` if the dependency is also needed by consumers of the target.

### Compiler Warnings

```cmake
target_compile_options(myapp PRIVATE -Wall -Wextra -pedantic)
```

The flags above are GCC and Clang spellings.
MSVC uses `/W4` for the same general "everyday warnings" level (and does not have a direct equivalent of `-pedantic`).
For a portable CMakeLists.txt that picks the right flags per compiler, use a generator expression:

```cmake
target_compile_options(myapp PRIVATE
    $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-Wall -Wextra -pedantic>
    $<$<CXX_COMPILER_ID:MSVC>:/W4>)
```

### Including Headers

```cmake
target_include_directories(myapp PRIVATE ${CMAKE_SOURCE_DIR}/include)
```

### External Dependencies with `find_package`

\index{CMake!find\_package}

```cmake
find_package(Threads REQUIRED)
target_link_libraries(myapp PRIVATE Threads::Threads)
```

For popular libraries (Boost, OpenSSL, etc.), CMake provides built-in `Find` modules.
For others, use `FetchContent` to download them:

```cmake
include(FetchContent)
FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 10.2.1
)
FetchContent_MakeAvailable(fmt)
target_link_libraries(myapp PRIVATE fmt::fmt)
```

::: {.tip}
**Tip:** CMake has a steep learning curve, but it is the de facto standard for C++ projects.
Start with the basics above and learn more as your projects grow.
:::

## Compiler Flags and Warnings

\index{compiler flags}

The compiler flags you choose affect correctness, performance, and debuggability.

### Warning Flags

Always compile with warnings enabled:

```bash
g++ -Wall -Wextra -pedantic -Werror main.cpp
```

| Flag | Effect |
|------|--------|
| `-Wall` | Enable most common warnings |
| `-Wextra` | Enable additional warnings |
| `-pedantic` | Warn about non-standard extensions |
| `-Werror` | Treat warnings as errors |

::: {.tip}
**Tip:** Use `-Werror` in CI/CD pipelines to prevent warnings from accumulating.
In development, you may want warnings without the hard stop.
:::

### Standard Selection

```bash
g++ -std=c++23 main.cpp   # C++23
g++ -std=c++20 main.cpp   # C++20
g++ -std=c++17 main.cpp   # C++17
```

### Optimization Levels

| Flag | Effect |
|------|--------|
| `-O0` | No optimization (fastest compile, best debugging) |
| `-O1` | Basic optimization |
| `-O2` | Standard optimization (good for release) |
| `-O3` | Aggressive optimization |
| `-Os` | Optimize for size |
| `-Og` | Optimize for debugging |

### Debug Information

```bash
g++ -g main.cpp           # Include debug symbols
g++ -g -O0 main.cpp       # Debug build (best for debuggers)
g++ -O2 -DNDEBUG main.cpp # Release build (disables assert)
```

## Sanitizers

\index{sanitizer}

Sanitizers are compiler features that instrument your code to detect bugs at run time.
They add overhead but catch problems that are otherwise invisible.

### AddressSanitizer (ASan)

\index{AddressSanitizer}

Detects memory errors: buffer overflows, use-after-free, double-free, memory leaks:

```bash
g++ -fsanitize=address -g main.cpp -o main
./main
```

If your program has a memory bug, ASan prints a detailed error report with the exact location.

### UndefinedBehaviorSanitizer (UBSan)

\index{UndefinedBehaviorSanitizer}

Detects undefined behavior: signed integer overflow, null pointer dereference, misaligned access:

```bash
g++ -fsanitize=undefined -g main.cpp -o main
```

### ThreadSanitizer (TSan)

\index{ThreadSanitizer}

Detects data races in multithreaded programs (Chapter 10):

```bash
g++ -fsanitize=thread -g main.cpp -o main -pthread
```

::: {.tip}
**Tip:** Run your tests with sanitizers regularly.
Many bugs --- especially memory and threading bugs --- are silent until they corrupt data or crash under production load.
Sanitizers catch them early.
:::

### Combining Sanitizers

You can combine ASan and UBSan:

```bash
g++ -fsanitize=address,undefined -g main.cpp
```

But ASan and TSan cannot be used together --- they instrument memory differently.

## Static Analysis

\index{static analysis}

Static analysis examines your code without running it, catching bugs that the compiler's warnings miss.

### clang-tidy

\index{clang-tidy}

`clang-tidy` is the most popular C++ linter.
It checks for common mistakes, style issues, and modernization opportunities:

```bash
clang-tidy main.cpp -- -std=c++23
```

Passing flags after `--` works for one file.
Real projects let CMake write a `compile_commands.json` so clang-tidy sees the exact flags every file is compiled with:

```bash
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Useful check categories:

| Category | What it checks |
|----------|---------------|
| `bugprone-*` | Common bug patterns |
| `modernize-*` | Suggest modern C++ replacements |
| `performance-*` | Performance issues |
| `readability-*` | Code readability |
| `cppcoreguidelines-*` | C++ Core Guidelines compliance |

### cppcheck

\index{cppcheck}

`cppcheck` is a standalone static analyzer:

```bash
cppcheck --enable=all main.cpp
```

It catches issues like unused variables, null pointer dereferences, and resource leaks.

### Compiler Warnings as Analysis

With `-Wall -Wextra -pedantic -Werror`, the compiler itself is a basic static analyzer.
Start there before adding external tools.

## Debugging with gdb/lldb

\index{gdb}
\index{lldb}

When your program crashes or produces wrong results, a debugger lets you step through the code line by line, inspect variables, and examine the call stack.

### Basic gdb Commands

```bash
g++ -g -O0 main.cpp -o main
gdb ./main
```

| Command | Effect |
|---------|--------|
| `run` | Start the program |
| `break main` | Set a breakpoint at `main` |
| `break file.cpp:42` | Breakpoint at line 42 |
| `next` | Execute next line (step over) |
| `step` | Step into function call |
| `continue` | Run until next breakpoint |
| `print x` | Print the value of `x` |
| `backtrace` | Show the call stack |
| `info locals` | Show local variables |
| `quit` | Exit gdb |

### lldb

`lldb` is the LLVM debugger, used primarily on macOS.
Its commands are similar:

| gdb | lldb |
|-----|------|
| `run` | `run` |
| `break main` | `breakpoint set --name main` |
| `next` | `next` |
| `step` | `step` |
| `print x` | `frame variable x` or `p x` |
| `backtrace` | `thread backtrace` |

### Debugging Tips

- Compile with `-g -O0` for the best debugging experience.
  Optimizations can reorder code and eliminate variables.
- Use `valgrind` as an alternative to ASan for memory debugging:
  `valgrind ./main`
- Core dumps: if a program crashes, the OS can save a core dump.
  Load it with `gdb ./main core` to examine the state at the time of the crash.

::: {.tip}
**Tip:** Learn to use a debugger early.
`std::cout` debugging is tempting but slow and unreliable.
A debugger shows you exactly what is happening, where, and why.
:::

## Package Managers

\index{package manager}
\index{vcpkg}
\index{conan}

For most languages, "install dependency X" is one command.
C++ historically had no equivalent --- you found the source, built it yourself, hoped it interoperated with your toolchain, and remembered to update it later.
Two modern package managers, **vcpkg** and **Conan**, make it almost as smooth as `pip` or `cargo`.

### vcpkg

\index{vcpkg}

`vcpkg` (from Microsoft) builds dependencies from source and integrates with CMake.
A typical workflow:

```
# one-time setup
git clone https://github.com/microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh

# install a package
./vcpkg/vcpkg install fmt boost-asio

# point CMake at vcpkg's toolchain file
cmake -B build -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake
```

In your `CMakeLists.txt`, you then `find_package` and `target_link_libraries` as if the dependency had been installed system-wide:

```cmake
find_package(fmt CONFIG REQUIRED)
target_link_libraries(myapp PRIVATE fmt::fmt)
```

`vcpkg` shines when you want a consistent toolchain across Windows, Linux, and macOS, and when you are already using CMake.

### Conan

\index{conan}

`conan` is a Python-based package manager that downloads pre-built binaries when available and falls back to source builds when not.
It is not tied to CMake, has a large central package index (Conan Center), and is a common choice in cross-platform projects that already use Python tooling.

Install it once with `pip`:

```bash
pip install conan
```

Declare your dependencies in a `conanfile.txt`:

```ini
[requires]
fmt/10.2.1
boost/1.84.0

[generators]
CMakeDeps
CMakeToolchain
```

Then fetch them:

```bash
conan install . --output-folder=build --build=missing
```

Both tools generate the CMake glue you need; the choice usually comes down to which one your team already uses.

::: {.tip}
**Tip:** If you are starting a new project today, pick one package manager and document it in your README.
"Just install Boost yourself" is the answer that wastes hours of every new contributor's first day.
:::

::: {.tip}
**Wut:** C++ standardization has not adopted a single package manager.
Both `vcpkg` and `Conan` work fine; C++20 modules improve compilation and encapsulation, but they say nothing about how libraries are distributed, so a package manager is still your problem to pick.
:::

## Documentation with Doxygen

\index{Doxygen}

Doxygen reads specially formatted comments in your code and generates HTML / PDF / man-page documentation.
You write the comments where the code is; Doxygen extracts function signatures, class hierarchies, file lists, and inheritance graphs automatically.

The basic comment style is `///` (or `/** ... */`) directly above the entity you are documenting:

```cpp
#include <string>

/// Add two integers.
///
/// \param a The first addend.
/// \param b The second addend.
/// \return  The sum of \p a and \p b.
int add(int a, int b);

/// A music track in a playlist.
///
/// Tracks remember their title, artist, and release year.
class Track {
public:
    /// Construct a track.
    /// \param title  The song's title.
    /// \param artist The performer.
    /// \param year   The release year.
    Track(std::string title, std::string artist, int year);

    /// \return `true` if the track was released in the 2000s.
    bool is_2000s() const noexcept;
};
```

To generate docs, run `doxygen -g` once to create a default `Doxyfile`, edit it (set `PROJECT_NAME`, `INPUT`, `OUTPUT_DIRECTORY`, and `RECURSIVE = YES`), then run `doxygen` --- the HTML lands in the `OUTPUT_DIRECTORY` you configured.

Useful Doxygen commands:

- `\param name description`
- `\return description`
- `\throws ExceptionType description`
- `\see other_function`
- `\note ...` and `\warning ...`
- `\code ... \endcode` for embedded examples
- `\brief one-line summary` (some teams prefer brief-only over full prose)

::: {.tip}
**Tip:** Doxygen is most valuable for *library* code that other people will call.
Application code that only your team reads is usually better served by a `README.md` and well-named identifiers.
The marginal value of Doxygen drops fast when no one looks at the generated HTML.
:::

::: {.tip}
**Wut:** Doxygen will *parse* a project even if you have not written any documentation comments --- it generates pages for every class and function based on declarations alone.
The output is mostly empty pages, which is not very useful, but it is a fast way to verify your build is producing the right symbols.
:::

## Key Points

- **CMake** is the standard C++ build system.
  `CMakeLists.txt` defines targets, sources, and dependencies.
- Use `add_executable` for programs, `add_library` for libraries, and `target_link_libraries` to connect them.
- **Compiler flags**: `-Wall -Wextra -pedantic` for warnings, `-std=c++23` for the standard, `-O2` for release, `-g -O0` for debug.
- **Sanitizers** catch runtime bugs: ASan (memory), UBSan (undefined behavior), TSan (data races).
  Use them in testing.
- **Static analysis** tools like `clang-tidy` and `cppcheck` catch bugs without running the code.
- **gdb/lldb** let you step through code, set breakpoints, and inspect variables.
  Compile with `-g -O0` for best results.
- **Package managers** (vcpkg, Conan) make C++ dependencies installable in one command and integrate with CMake; pick one per project and document it in the README.
- **Doxygen** turns specially formatted `///` comments into browseable HTML / PDF docs; valuable for library code, less useful for application code.

## Exercises

1. **Think about it:** Why is CMake called a "build system generator" rather than a "build system"?
What does it generate?

2. **Write a CMakeLists.txt** for a project with `main.cpp`, `audio.cpp`, and `audio.h`.
Set the C++ standard to 23 and enable `-Wall -Wextra -pedantic`.

3. **Think about it:** Why should you compile with `-Wall -Wextra -pedantic` from the start of a project rather than adding them later?

4. **Think about it:** You have a program with a buffer overflow that only corrupts memory silently.
Which sanitizer would catch it?
What compiler flag would you use?

5. **Think about it:** AddressSanitizer and ThreadSanitizer cannot be used together.
Why might that be?
How would you test for both memory and threading bugs?

6. **Write a gdb session** (sequence of commands) that:
    - Sets a breakpoint at `main`
    - Runs the program
    - Steps through three lines
    - Prints a local variable called `count`
    - Continues to the end

7. **Think about it:** What is the difference between `-O0`, `-O2`, and `-O3`?
When would you use each?

8. **Where is the bug?**

    ```cmake
    add_executable(myapp main.cpp)
    target_link_libraries(myapp fmt)
    ```

    What is missing compared to the example in this chapter?

9. **Think about it:** Why does the text recommend running tests with sanitizers enabled?
What kinds of bugs do sanitizers catch that tests alone miss?

10. **Set up a project** with CMake that has a `main.cpp` and a `math_utils.cpp`/`math_utils.h` library.
The library should have a function `int factorial(int n)`.
Build it with CMake, run it, and then compile with AddressSanitizer enabled and verify it runs cleanly.

11. **Think about it:** Why does C++ rely on third-party package managers (vcpkg, Conan) instead of having a built-in one like Python's `pip` or Rust's `cargo`?
What problem would a built-in package manager have to solve that the language committee has so far avoided?

12. **Write a small project** with one header `track.h` and one source `track.cpp` defining a `Track` class.
Document the class and its public methods with `///` Doxygen comments.
Run `doxygen -g` to generate a `Doxyfile`, edit `INPUT` and `RECURSIVE`, run `doxygen`, and open the generated `html/index.html`.
What does the generated documentation contain that was not literally typed in the comments?

13. **What does this do?** This program is compiled with `g++ -fsanitize=address -g sum.cpp` and run.
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
