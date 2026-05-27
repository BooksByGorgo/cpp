# C++ / Java Side-by-Side

\index{C++ vs Java}

## Program Structure

\index{program structure}
\index{entry point}
\index{namespace}
\index{package}
\index{import}
\index{include}
\index{preprocessor}

| Concept | C++ | Java |
|---|---|---|
| File organization | `.h` (declarations) + `.cpp` (definitions) | Single `.java` file per public class |
| Entry point | `int main(int argc, char** argv)` | `public static void main(String[] args)` |
| Namespace | `namespace foo { }` / `using namespace foo;` | `package foo.bar;` (one per file, must match directory) |
| Import / include | `#include <header>` | `import foo.bar.Baz;` / `import foo.bar.*;` |
| Preprocessor | `#define`, `#ifdef`, `#pragma once` | None --- use constants and interfaces |
| Global functions | Allowed at file scope | None --- must be `static` methods in a class |
| Global variables | Allowed at file scope | None --- must be `static` fields in a class |

## Types

\index{primitive types}
\index{boolean}
\index{char}
\index{int}
\index{long}
\index{float}
\index{double}
\index{auto}
\index{var}
\index{nullptr}
\index{null}
\index{string}
\index{pointer}
\index{reference}

| Concept | C++ | Java |
|---|---|---|
| Boolean | `bool` | `boolean` (primitive) / `Boolean` (wrapper) |
| Character | `char` (8-bit, implementation-defined sign) | `char` (16-bit UTF-16 code unit) / `Character` |
| Integer | `int` (platform-dependent size) | `int` (guaranteed 32-bit) / `Integer` |
| Long integer | `long` / `long long` | `long` (guaranteed 64-bit) / `Long` |
| Float | `float` | `float` / `Float` |
| Double | `double` | `double` / `Double` |
| Unsigned integer | `unsigned int`, `uint32_t` | None (use `long` or `Integer.toUnsignedXxx()`) |
| Size type | `size_t` | None (use `int` or `long`) |
| Pointer / reference | Raw pointers (`T*`), references (`T&`) | Reference types only (no address-of, no deref) |
| Type inference | `auto x = expr;` (any scope) | `var x = expr;` (local variables only, Java 10+) |
| Null pointer | `nullptr` | `null` |
| Immutable string | `const std::string` / `std::string_view` | `String` (always immutable) |
| Mutable string | `std::string` | `StringBuilder` / `StringBuffer` |
| String view | `std::string_view` | `CharSequence` (interface) |

## Memory Management

\index{memory management}
\index{garbage collection}
\index{RAII}
\index{destructor}
\index{try-with-resources}
\index{unique\_ptr}
\index{shared\_ptr}
\index{weak\_ptr}
\index{WeakReference}
\index{AutoCloseable}

| Concept | C++ | Java |
|---|---|---|
| Allocation | `new` / `malloc` | `new` (GC manages deallocation) |
| Deallocation | `delete` / `free` | None --- garbage collector handles it |
| Stack allocation | `Foo f;` (constructor runs on scope entry) | Not available --- objects always on heap |
| Deterministic cleanup | RAII: destructor runs at end of scope | `try`-with-resources (`AutoCloseable`) |
| Unique ownership | `std::unique_ptr<T>` | No direct equivalent; use try-with-resources |
| Shared ownership | `std::shared_ptr<T>` (ref-counted) | All GC references; GC decides when to free |
| Weak reference | `std::weak_ptr<T>` | `WeakReference<T>` |
| Placement new | `new (ptr) T(args)` | None |
| Manual C-style | `malloc` / `free` | None (use `sun.misc.Unsafe` at your own risk) |

## OOP

\index{OOP}
\index{inheritance}
\index{virtual}
\index{friend}
\index{access modifiers}
\index{final}
\index{override}
\index{abstract}
\index{interface}
\index{this}

| Concept | C++ | Java |
|---|---|---|
| Class inheritance | Single (`class D : public B`) | Single (`class D extends B`) |
| Multiple inheritance | Allowed for classes | Interfaces only (`implements A, B`) |
| Virtual dispatch | Opt-in: `virtual` keyword required | Opt-out: all non-`final`/non-`private`/non-`static` methods are virtual |
| Friend access | `friend class Foo;` / `friend void f();` | None (use package-private or inner classes) |
| `public` | Same access as C++ | Same |
| `private` | Same | Same |
| `protected` | Subclasses + same package (C++: subclasses only) | Subclasses + same package |
| Package-private | None | Default (no modifier) --- accessible within the package |
| Prevent subclassing | `final` class | `final` class |
| Prevent overriding | `final` on virtual method | `final` on method |
| Override annotation | `override` keyword (C++11) | `@Override` annotation (compile-time check) |
| Pure virtual method | `virtual void f() = 0;` | `abstract void f();` |
| Abstract class | Class with at least one pure virtual | `abstract class` |
| Interface | Pure virtual base class (with multiple inheritance) | `interface` (default/static methods allowed since Java 8) |
| Self reference | `this` (pointer) | `this` (reference) |

## Generics vs Templates

\index{generics}
\index{templates}
\index{type erasure}
\index{wildcards}
\index{concepts}
\index{bounded type parameters}

| Concept | C++ | Java |
|---|---|---|
| Syntax | `template<typename T> class Foo { };` | `class Foo<T> { }` |
| Instantiation | Code generated per concrete type at compile time | Single compiled class; type erased at runtime |
| Runtime type info | Full --- `typeid(T)`, `sizeof(T)` work | Erased --- `T` not available at runtime |
| `sizeof(T)` | Available | None at runtime (use `Unsafe` or agents) |
| Specialization | `template<> class Foo<int> { };` | None |
| Non-type parameters | `template<int N>` | None |
| Variadic | `template<typename... Ts>` | Varargs only (`T... args`) |
| Constraint (C++20) | `requires` / concepts | Bounded type parameter: `<T extends Foo>` |
| Upper bound | `template<typename T> requires std::derived_from<T, Foo>` | `<T extends Foo>` |
| Lower bound | None | `<? super Foo>` (wildcard) |
| Wildcard | None | `<?>`, `<? extends T>`, `<? super T>` |

## Exception Handling

\index{exceptions}
\index{checked exceptions}
\index{unchecked exceptions}
\index{noexcept}
\index{finally}
\index{throws}
\index{try-with-resources}

| Concept | C++ | Java |
|---|---|---|
| No-throw guarantee | `noexcept` / `noexcept(expr)` | None |
| Checked exceptions | None --- all exceptions are unchecked | Checked exceptions must be declared or caught |
| Unchecked exceptions | All exceptions | Subclasses of `RuntimeException` |
| `finally` block | None (use RAII / destructors) | `finally { }` block |
| Exception pointer | `std::exception_ptr` | `Throwable` reference |
| Custom exceptions | Extend `std::exception`, override `what()` | Extend `Exception` (checked) or `RuntimeException` (unchecked) |
| Exception specification | Removed in C++17 | `throws IOException, SQLException` on method signature |
| Re-throw | `throw;` (rethrows current exception) | `throw e;` (resets stack trace) / use `throw;` pattern with `initCause` |

## Concurrency

\index{concurrency}
\index{thread}
\index{mutex}
\index{synchronized}
\index{atomic}
\index{condition variable}
\index{future}
\index{virtual threads}
\index{ExecutorService}

| Concept | C++ | Java |
|---|---|---|
| Thread | `std::thread` | `Thread` / `Runnable` |
| Mutex | `std::mutex` + `std::lock_guard` | `synchronized` block / `ReentrantLock` |
| Atomic integer | `std::atomic<int>` | `AtomicInteger` |
| Atomic reference | `std::atomic<T*>` | `AtomicReference<T>` |
| Condition variable | `std::condition_variable` | `Object.wait()` / `Object.notify()` / `Condition` |
| Future / promise | `std::future<T>` / `std::promise<T>` | `Future<T>` / `CompletableFuture<T>` |
| Thread pool | `std::async` (limited) | `ExecutorService` / `Executors.newFixedThreadPool()` |
| Lightweight concurrency | Coroutines (C++20, stackless) | Virtual threads (Java 21, `Thread.ofVirtual()`) |
| Memory ordering | `std::memory_order` on atomics | Java Memory Model, `volatile` keyword |

## Standard Library Containers

\index{containers}
\index{ArrayList}
\index{LinkedList}
\index{ArrayDeque}
\index{HashMap}
\index{TreeMap}
\index{HashSet}
\index{TreeSet}
\index{PriorityQueue}
\index{Optional}

| C++ | Java |
|---|---|
| `std::vector<T>` | `ArrayList<T>` |
| `std::list<T>` | `LinkedList<T>` (rarely preferred; use `ArrayDeque`) |
| `std::deque<T>` | `ArrayDeque<T>` |
| `std::map<K,V>` | `TreeMap<K,V>` (sorted) |
| `std::unordered_map<K,V>` | `HashMap<K,V>` |
| `std::set<T>` | `TreeSet<T>` (sorted) |
| `std::unordered_set<T>` | `HashSet<T>` |
| `std::stack<T>` | `Deque<T>` --- use `ArrayDeque<T>` |
| `std::queue<T>` | `Queue<T>` --- use `ArrayDeque<T>` |
| `std::priority_queue<T>` | `PriorityQueue<T>` |
| `std::optional<T>` | `Optional<T>` |
| `std::string` | `String` (immutable) + `StringBuilder` (mutable) |
| `std::array<T,N>` | `T[]` (fixed-size array) |
| `std::tuple<A,B,C>` | Record (`record Triple(A a, B b, C c) {}`) or `Object[]` |
| `std::pair<A,B>` | Record or `Map.Entry<A,B>` |

## Functional Programming

\index{functional programming}
\index{lambda}
\index{method reference}
\index{Stream API}
\index{functional interface}
\index{std::function}
\index{ranges}

| Concept | C++ | Java |
|---|---|---|
| Lambda syntax | `[capture](params) -> R { body }` | `(params) -> expr` or `(params) -> { body }` |
| Capture | Explicit: `[x]`, `[&x]`, `[=]`, `[&]` | Implicit: effectively-final locals captured automatically |
| Callable wrapper | `std::function<R(Args...)>` | Functional interface (e.g., `Function<T,R>`, `Predicate<T>`) |
| Partial application | `std::bind(&f, arg1, _1)` | Method reference or lambda wrapping |
| Method reference | N/A (use lambdas or `std::mem_fn`) | `Class::method`, `instance::method`, `Class::new` |
| Lazy sequence | Ranges (C++20): `views::filter`, `views::transform` | Stream API: `.stream().filter().map()` |
| Map | `std::transform(begin, end, out, fn)` | `stream.map(fn)` |
| Filter | `std::copy_if(begin, end, out, pred)` | `stream.filter(pred)` |
| Reduce | `std::reduce` / `std::accumulate` | `stream.reduce(identity, accumulator)` |
| Collect to list | Manual loop or `std::back_inserter` | `stream.collect(Collectors.toList())` |
| Group by | Manual with `std::map` | `stream.collect(Collectors.groupingBy(fn))` |
| Parallel | `std::execution::par` on algorithms | `stream.parallel()` |

## I/O

\index{I/O}
\index{file I/O}
\index{filesystem}
\index{Path}
\index{Files}
\index{memory-mapped files}
\index{printf}

| Concept | C++ | Java |
|---|---|---|
| Text file read | `std::ifstream` | `FileReader` / `BufferedReader` / `Files.readString()` |
| Text file write | `std::ofstream` | `FileWriter` / `BufferedWriter` / `Files.writeString()` |
| Binary I/O | `std::fstream` with `binary` flag | `FileInputStream` / `FileOutputStream` / `FileChannel` |
| Filesystem path | `std::filesystem::path` | `java.nio.file.Path` |
| Copy file | `std::filesystem::copy()` | `Files.copy(src, dst)` |
| Delete file | `std::filesystem::remove()` | `Files.delete(path)` |
| Directory iteration | `std::filesystem::directory_iterator` | `Files.list(path)` (returns `Stream<Path>`) |
| Recursive walk | `std::filesystem::recursive_directory_iterator` | `Files.walk(path)` |
| Memory-mapped file | `mmap()` (POSIX) | `FileChannel.map()` → `MappedByteBuffer` |
| Formatted print | `printf` / `std::format` (C++20) | `System.out.printf()` / `String.format()` / `formatted()` |

## Build and Tooling

\index{build tools}
\index{Maven}
\index{Gradle}
\index{JAR}
\index{classpath}
\index{CMake}
\index{make}

| Concept | C++ | Java |
|---|---|---|
| Build system | `make` / CMake / Meson | Maven (`pom.xml`) / Gradle (`build.gradle`) |
| Static library | `.a` (Linux) / `.lib` (Windows) | JAR (all Java archives are equivalent) |
| Shared library | `.so` (Linux) / `.dll` (Windows) | JAR + `ClassLoader` |
| Package manager | `vcpkg` / Conan / pkg-config | Maven Central / Gradle plugins (auto-downloaded) |
| Header files | Required for declarations | None --- one `.java` file per public class |
| Precompiled headers | `.pch` files | None --- use the module system (JPMS) for isolation |
| Compile single file | `g++ -o foo foo.cpp` | `javac Foo.java` |
| Run | `./foo` | `java Foo` / `java -cp app.jar com.example.Main` |
| Packaging | Executable binary | `java -jar app.jar` (fat JAR) or native image (GraalVM) |
| Dependency metadata | `CMakeLists.txt` / `conanfile.txt` | `pom.xml` (Maven) / `build.gradle` (Gradle) |

## Miscellaneous Quick Reference

\index{operator overloading}
\index{multiple return values}
\index{typedef}
\index{constexpr}
\index{sizeof}
\index{default arguments}
\index{function pointers}
\index{const}

| Concept | C++ | Java |
|---|---|---|
| Operator overloading | Yes --- `operator+`, `operator==`, etc. | No --- only `+` is overloaded for `String` concatenation |
| Multiple return values | `std::pair` / `std::tuple` / structured bindings | `record`, array, or `List` |
| Type alias | `typedef OldName NewName;` / `using NewName = OldName;` | None --- use the full type name or an inner class |
| Const member function | `void f() const;` (does not modify `*this`) | None --- use `final` fields and immutable design |
| Compile-time constant | `constexpr int N = 42;` | `static final int N = 42;` |
| Runtime size of type | `sizeof(T)` | None at runtime (use `Instrumentation` API or `Unsafe`) |
| Default arguments | `void f(int x = 0);` | None --- use method overloading |
| Function pointer | `void (*fp)(int)` | Functional interface / method reference |
| Inline assembly | `asm("...")` | None (use JNI for native code) |
| Conditional compilation | `#ifdef DEBUG` | None --- use constants: `if (DEBUG) { }` (JIT eliminates dead branch) |
| `static_assert` | `static_assert(cond, "msg")` | None at compile time (use annotation processors) |
| Bit fields | `struct { unsigned x : 3; }` | None --- use masks and shifts manually |
