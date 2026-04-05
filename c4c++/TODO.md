# c4c++ TODO

## should fix

- [ ] ch04 line 179: "the pointer `0x7fff`" is an integer literal, not a pointer
- [ ] ch06 line 98: `argv` described as "a pointer to an array of string pointers" — should be "pointer to the first element of an array of string pointers" or similar
- [ ] ch07: term "forward declaration" never explicitly used despite being in the content outline
- [ ] ch08 line 117-118: "heap persists" should say the *allocation* persists
- [ ] ch08 lines 147-150: awkward phrasing about NULL checks / "CPU will do the check for you" means SIGSEGV — clarify
- [ ] ch08 line 232: comment assumes `sizeof(int) == 4` without qualification
- [ ] ch11: `write()` return values ignored in examples — will warn with `-Wall -Wextra`
- [ ] ch05: "Wind of Change" (Scorpions) is 1990/1991, not 80s — no CLAUDE.md exception like Nirvana has

## consider

- [ ] ch04: comma operator never explained (it is in the precedence table)
- [ ] ch06: pointer subtraction / `ptrdiff_t` not covered
- [ ] ch07: limited 80s reference variety (only "Iron Man")
- [ ] ch08: add `memset` non-zero trap callout (sets bytes, not ints)
- [ ] ch08: mention VLAs briefly (C99 feature not in C++)
- [ ] ch08: mention `static` at file scope / `extern` for globals across translation units
- [ ] ch09: numbers-to-strings conversion is thin (deferred to ch10 but outline says to cover it)
- [ ] ch09: `stdint.h` fixed-width types not mentioned
- [ ] ch09: signed vs unsigned overflow behavior not discussed
- [ ] ch10: no `fseek`/`ftell` (stdio-level seek)
- [ ] ch10: no `getchar`/`putchar`/`getc`/`putc`
- [ ] ch10: `fopen` return values unchecked in binary I/O and Try It examples (contradicts own key points)
- [ ] ch11: no partial read/write loop pattern
- [ ] ch11: no `errno`/`perror` forward reference to ch12
- [ ] ch12: `EXIT_SUCCESS`/`EXIT_FAILURE` not mentioned
- [ ] ch12: `errno` must be checked immediately after a failing call — worth a trap callout
