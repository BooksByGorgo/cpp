# Chapter 11 Study Guide: Low-Level I/O

## Where these functions sit

- How do `read`, `write`, `open`, and `close` relate to the `<stdio.h>` functions you learned earlier?
- When you understand both layers, what does that let you see about how `printf` actually reaches the screen?

## File descriptors

- What is a file descriptor, and what datatype represents one?
- Which three file descriptors are already open when your program starts?
- What are the POSIX names for those three descriptors, and where are they defined?

## `read` and `write`

- What does `read` do, and what can its return value mean?
- What does `write` do, and what does a short return value tell you?
- How are `read` and `write` different from `fread`/`fwrite` and `printf`/`scanf` in terms of formatting and buffering?

### Experiment: echo with read and write

- Using only `read` and `write` on file descriptors 0 and 1, write a program that reads up to 256 bytes from stdin and echoes them to stdout.
- Run it interactively and with input redirected from a file.

## `open` and `close`

- What does `open` return on success, and on failure?
- What do `O_RDONLY`, `O_WRONLY`, and `O_RDWR` mean?
- How do you combine `O_CREAT`, `O_TRUNC`, and `O_APPEND` with OR, and when would you pick each?
- Why does `O_CREAT` require a permissions argument?
- What does the permissions value `0644` mean in practical terms?

## `creat`

- What does `creat` do, and to which call to `open` is it equivalent?
- Why did Ken Thompson say he would spell it `create` if he were doing it again?

## `lseek`

- What does `lseek` do to an open file descriptor?
- For each of `SEEK_SET`, `SEEK_CUR`, and `SEEK_END`, describe what the offset is relative to.
- How do you use `lseek` to get the current position without moving?
- What is `lseek`'s `<stdio.h>` counterpart?

### Experiment: seek around a file

- Create a file containing the alphabet (`A`-`Z`) using `open` + `write`.
- Use `lseek` to jump to byte 10 and read 5 bytes; print them.
- Use `lseek(fd, 0, SEEK_END)` to find the size of the file and print it.

## `pread` and `pwrite`

- How are `pread` and `pwrite` different from `read` and `write`?
- Why are they safer in multi-threaded programs that share a file descriptor?

### Experiment: file copy with low-level I/O

- Write a program `cp.c` that takes two filenames from `argv[1]` and `argv[2]`.
- Use `open`, `read`, `write`, and `close` to copy the contents of the first file to the second.
- Create the destination with `O_CREAT | O_WRONLY | O_TRUNC` and permissions `0644`.
- Check every system call for `-1` and write a helpful error to `stderr` with the low-level `write`.

### Experiment: see the relationship to stdio

- Write the same one-line message to `stdout` in three ways: with `printf`, with `fprintf(stdout, ...)`, and with `write(STDOUT_FILENO, ...)`.
- Run the program and confirm all three paths produce the same output.
- Redirect `stdout` to a file and check that all three still arrive in the file.
