# Go Concepts and Idioms Every Experienced Programmer Should Know

## Core Language

### Types and Variables
- Type inference (`:=` short declaration)
- Zero values (every type has a meaningful zero)
- `const` and `iota` for enumerations
- Type definitions vs type aliases (`type Celsius float64` vs `type = float64`)
- Named return values
- Multiple return values
- Blank identifier (`_`)
- `new` vs `make` --- `new(T)` returns a zeroed `*T`; `make` initializes slices, maps, channels
- Integer literal prefixes: `0b` binary, `0o` octal, `0x` hex, `_` digit separator (`1_000_000`)
- Built-in `clear` (Go 1.21) --- zeroes a slice or deletes all map entries
- Built-in `min` / `max` (Go 1.21) --- type-safe, variadic

### Strings, Bytes, and Runes
- Strings are immutable byte sequences, not character sequences --- `len(s)` counts bytes
- `byte` is `uint8`; `rune` is `int32` (a Unicode code point)
- `s[i]` yields a `byte`; `for range s` decodes UTF-8 runes automatically
- Raw string literals with backticks suppress all escape processing
- `rune` literals: `'⌘'` is an `int32` constant
- `unicode/utf8` package: `RuneCountInString`, `DecodeRuneInString`, `ValidString`
- Java `char` is a UTF-16 code unit; Go `rune` is a full Unicode code point --- different

### Composite Types
- **Slices** --- pointer/len/cap triplet, `append`, `copy`, `make`
- Three-index slices `a[low:high:max]` --- cap the result to prevent accidental backing-array sharing
- Slice aliasing --- re-slicing shares the backing array; `copy` into a fresh slice to break the link
- **Maps** --- comma-ok idiom (`v, ok := m[key]`), iteration order is random
- **Structs** --- value type, embedding (composition over inheritance), struct tags
- Struct tags --- `` `json:"name,omitempty"` `` for JSON/XML/DB field mapping; parsed via `reflect.StructTag`
- **Arrays** --- value type, fixed size (rarely used directly; slices preferred)
- Multidimensional slices

### Control Flow
- `switch` does not fall through by default; use `fallthrough` to explicitly transfer to next case body
- Labeled `break` / `continue` --- the Go substitute for Java's labeled loops
- `goto` --- exists but niche

### Interfaces
- Implicit interface satisfaction (no `implements` keyword)
- Interface composition
- `any` (`interface{}`) and type assertions (`x.(T)`)
- Type switches (`switch v := i.(type)`)
- Small interfaces: `io.Reader`, `io.Writer`, `fmt.Stringer`, `sort.Interface`
- "Accept interfaces, return structs" idiom
- Interface nil traps (typed nil vs untyped nil)

### Functions
- First-class functions and closures
- Variadic functions (`...T`)
- `defer` --- LIFO order, captures variables by reference
- `init()` --- package initialization, multiple allowed per file
- Function types as parameters (callbacks, middleware)
- `http.HandlerFunc` adapter --- function type implementing an interface; the canonical strategy pattern

### Pointers
- `&` (address-of) and `*` (dereference) --- no arithmetic
- When to use pointer vs value receivers
- Pointer receivers for mutation; value receivers for reads on small structs

---

## Error Handling
- `error` is just an interface (`Error() string`)
- Return `error` as the last return value
- `errors.New`, `fmt.Errorf` with `%w` for wrapping
- `errors.Is` and `errors.As` for unwrapping chains
- `errors.Join` (Go 1.20) --- combine multiple errors; `Is`/`As` unwrap through joined errors
- `fmt.Errorf` with multiple `%w` (Go 1.20) --- wrap more than one error in one call
- Sentinel errors (e.g., `io.EOF`)
- Custom error types
- `panic` / `recover` --- reserved for truly unrecoverable state, not normal control flow

---

## Goroutines and Concurrency

### Primitives
- `go` keyword to launch a goroutine
- Channels --- buffered vs unbuffered, directional types (`chan<-`, `<-chan`)
- Channel closing semantics --- only the sender closes; receiving from closed returns zero + false; sending to closed panics
- `select` statement --- fan-in, timeouts, non-blocking sends/receives

### sync Package
- `sync.Mutex` and `sync.RWMutex`
- `sync.WaitGroup`
- `sync.Once`
- `sync.Cond` --- condition variables for broadcast wakeup and state-change coordination
- `sync.Map` --- concurrent-safe map for many-readers / infrequent-writes patterns
- `sync.Pool` --- reusable object pool to reduce GC pressure on high-throughput allocations

### Atomic Operations
- `sync/atomic` --- typed atomics in Go 1.19+: `atomic.Int64`, `atomic.Pointer[T]` (prefer over function-based API)

### Context and Cancellation
- `context.Context` --- cancellation, deadlines, value propagation
- `context.WithValue` and unexported key types --- avoid string keys to prevent collisions

### Patterns and Pitfalls
- "Don't communicate by sharing memory; share memory by communicating"
- `golang.org/x/sync/errgroup` --- fan-out with automatic error collection and context cancellation
- Worker pool pattern --- bounded goroutine fan-out via a fixed channel or semaphore
- Rate limiting with `time.Ticker` --- token bucket pattern using a channel
- Goroutine leak detection --- goroutines that block forever; use `context` to bound lifetime; `goleak` in tests
- `GOMAXPROCS` --- number of OS threads running Go code; defaults to CPU count

### Memory Model
- Go memory model and happens-before --- visibility across goroutines requires synchronization
- Channels, mutexes, and `sync.Once` establish happens-before relationships
- Busy-wait loops without synchronization are undefined behavior

### Race Detector
- `go test -race` --- run with `-race` in CI; always

---

## Standard Library Essentials
- `fmt` --- `Println`, `Printf`, `Sprintf`, `Errorf`, `Fprintf`
- `strings` --- `Builder`, `Contains`, `Split`, `Join`, `TrimSpace`, `HasPrefix`
- `strconv` --- `Itoa`, `Atoi`, `ParseFloat`, `FormatFloat`
- `io` --- `Reader`, `Writer`, `ReadAll`, `Copy`, `MultiReader`, `MultiWriter`, `TeeReader`, `LimitReader`, `Pipe`
- `bufio` --- `Scanner`, `NewReader`, `NewWriter`
- `os` --- `Open`, `Create`, `ReadFile`, `WriteFile`, `Args`, `Stdin/Stdout/Stderr`
- `os/exec` --- spawning subprocesses: `exec.Command`, `Cmd.Output`, `Cmd.Run`
- `flag` --- standard command-line flag parsing
- `embed` --- `//go:embed` directive embeds static files into the binary at compile time
- `encoding/json` --- `Marshal`, `Unmarshal`, `Encoder`, `Decoder`, struct tags
- `encoding/xml` --- XML marshalling; appears in enterprise integrations
- `database/sql` --- `sql.DB` connection pool, `Query`/`QueryRow`/`Exec`, `Rows.Scan`, `sql.Tx`, context-aware cancellation, `sql.Null[T]` (Go 1.22)
- `net/http` --- `ListenAndServe`, `Handler`, `HandleFunc`, `Client`, `Request`; Go 1.22 `ServeMux` method routing and path wildcards
- `net/http` middleware chaining --- wrapping `http.Handler` to add logging, auth, metrics
- `net/http/pprof` --- import for side-effect to expose profiling endpoints on a live HTTP server
- `net` --- `net.Dial`, `net.Listen`, TCP/UDP below the HTTP layer
- `time` --- `Duration`, `Time`, `Now`, `Since`, `After`, `Ticker`, `Timer`
- `sort` --- `Slice`, `SliceStable`, `Search`, `Sort` interface; and `sort.Interface` (`Len`, `Less`, `Swap`)
- `slices` (Go 1.21) --- `Sort`, `SortFunc`, `Contains`, `Index`, `Compact`, `Collect`
- `maps` (Go 1.21) --- `Clone`, `Keys`, `Values`
- `cmp` (Go 1.21) --- `cmp.Compare`, `cmp.Ordered` constraint; used with `slices.SortFunc`
- `iter` (Go 1.23) --- `iter.Seq[V]`, `iter.Seq2[K,V]`; range-over-func for custom iterators with `yield` callbacks
- `unique` (Go 1.23) --- value interning via `unique.Make`; returns a `Handle[T]` comparable by pointer
- `math/rand/v2` (Go 1.22+) --- `N`, `Float64`
- `log` / `log/slog` (Go 1.21+) --- structured logging: `slog.Attr`, `slog.With`, `slog.Group`, custom `Handler`, `slog.SetDefault`
- `regexp` --- compiled patterns with `Compile`
- `path/filepath` --- cross-platform path manipulation
- `bytes` --- `Buffer`, `Contains`, `Split` (mirrors `strings` for `[]byte`)
- `crypto/tls`, `crypto/sha256`, `crypto/hmac` --- Go has a comprehensive crypto stdlib; prefer it over third-party

---

## Modules and Packages
- `go.mod` and `go.sum` --- module path, `require`, `replace` (local overrides, forks)
- Package naming --- short, lowercase, no underscores
- Internal packages (`internal/`) --- restricts visibility
- Standard project layout --- `cmd/` for executables, `internal/` for private packages, top-level for importable library
- `go get`, `go mod tidy`, `go mod vendor`
- Go workspaces (`go work`) --- `go.work` file for multi-module local development without `replace` directives
- Major version suffixes --- `module github.com/foo/bar/v2`; import path must include `/v2`
- Build tags / build constraints
- `//go:generate` directive
- `//go:embed` directive

---

## Idioms and Patterns
- **Table-driven tests** --- slice of structs with `t.Run`
- **Functional options** --- `func(cfg *Config)` variadic options pattern
- **Comma-ok idiom** --- maps, type assertions, channel receives
- **Defer for cleanup** --- file closes, mutex unlocks, span ends
- **Wrapping errors with context** --- `fmt.Errorf("parsing config: %w", err)`
- **Constructor functions** --- `NewFoo() *Foo`
- **Interface mocking in tests** --- small interfaces make mocks trivial
- **Embedding for code reuse** --- promoted methods, not inheritance
- **`io.Writer` as output sink** --- makes functions testable without real files
- **Context as first parameter** --- `func Foo(ctx context.Context, ...)`
- **`fmt.Stringer`** --- implement `String() string` for custom print output; Go's `toString()`
- **`io.Reader` / `io.Writer` composition** --- `MultiReader`, `TeeReader`, `LimitReader`, `Pipe`

### Go Proverbs (design philosophy)
- "Don't communicate by sharing memory; share memory by communicating"
- "A little copying is better than a little dependency"
- "Clear is better than clever"
- "The bigger the interface, the weaker the abstraction"
- "Errors are values"

---

## Tooling
- `gofmt` / `goimports` --- formatting is not optional
- `go vet` --- catches common bugs
- `golangci-lint` --- linter aggregator used in CI
- `go build`, `go run`, `go test ./...`
- `go doc` / `godoc`
- `gopls` --- official Go language server powering IDE support
- Delve (`dlv`) --- standard Go debugger; `dlv debug`, `dlv test`, goroutine inspection
- Fuzzing (`go test -fuzz`, Go 1.18+) --- `FuzzXxx(*testing.F)`, `f.Add(seed)`, coverage-guided; runs until failure
- Benchmarks (`func BenchmarkFoo(b *testing.B)`)
- `pprof` --- CPU and memory profiling; `go tool pprof -http` for flame graphs
- `net/http/pprof` --- always-on production profiling endpoint
- Block profile (`runtime.SetBlockProfileRate`) and mutex profile (`runtime.SetMutexProfileFraction`) --- off by default
- `go tool trace` --- goroutine and scheduler tracing
- Profile-guided optimization (PGO, Go 1.20+) --- `default.pgo` in main package; `go build -pgo=auto`; 2--14% speedup
- `GODEBUG` --- runtime knobs: `gctrace=1`, `schedtrace`, `asyncpreemptoff`

---

## Generics (Go 1.18+)
- Type parameters (`func Map[T, U any](...)`)
- `~T` tilde syntax --- `~int` means "any type whose underlying type is int"; needed for user-defined types in constraints
- `comparable` constraint vs `any` --- `comparable` admits only `==`-able types; map keys require it
- Constraints (`comparable`, custom constraint interfaces)
- `slices` and `maps` packages (Go 1.21+)
- `cmp.Ordered` constraint for ordered types
- Generic type aliases (Go 1.24) --- `type Alias[T any] = SomeGenericType[T]`
- When NOT to use generics (prefer concrete types for readability)

---

## GC and Runtime Tuning
- `GOGC` --- default 100 (trigger GC when heap doubles); raise to trade memory for CPU
- `GOMEMLIMIT` (Go 1.19) --- soft memory ceiling; essential for container deployments
- `runtime/debug.SetGCPercent` and `SetMemoryLimit` --- programmatic equivalents
- Escape analysis --- `go build -gcflags=-m` shows what escapes to the heap
- `GOMAXPROCS` --- OS thread count; defaults to CPU count

---

## Reflection (use sparingly)
- `reflect.TypeOf`, `reflect.ValueOf`
- `reflect.Value.Kind()` vs `Type()` distinction
- `reflect.Value.Elem()` for dereferencing pointers and unwrapping interfaces
- `reflect.Value.CanSet()` --- mutation requires a pointer
- Struct field iteration and `reflect.StructField.Tag` for custom tag parsing
- The three laws of reflection as a conceptual framework
- When reflection is warranted (serialization, DI frameworks)

---

## Unsafe and cgo (use sparingly)
- `unsafe.Pointer` --- only for FFI and performance-critical ops
- `cgo` --- C library integration; cross-compilation limitations; "cgo is not Go"
- `C.CString` / `C.GoString` and the mandatory `defer C.free(unsafe.Pointer(cs))`
