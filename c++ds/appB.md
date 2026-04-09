\newpage

# Appendix B: Complexity Cheat Sheet

\index{complexity!cheat sheet}

This appendix summarizes the time and space complexity of every data structure covered in the book.
Use it as a quick reference when selecting a data structure for a problem.

## Big-O Quick Reference

\index{Big-O notation}

| Notation | Name | Grows faster than... | Typical operation |
|----------|------|---------------------|-------------------|
| O(1) | Constant | Nothing | Array index access |
| O(log n) | Logarithmic | O(1) | Binary search, heap operations |
| O(n) | Linear | O(log n) | Linear scan, list traversal |
| O(n log n) | Linearithmic | O(n) | Merge sort, heap sort |
| O(n²) | Quadratic | O(n log n) | Bubble sort, insertion sort |
| O(2ⁿ) | Exponential | O(n²) | Naïve recursive enumeration |

Constants and lower-order terms are dropped.
`3n + 7` → O(n).
`n² + 100n` → O(n²).

## Data Structure Complexity Reference

### Arrays

\index{array!complexity}

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| Access by index | O(1) | `arr[i]` |
| Search (unsorted) | O(n) | Linear scan |
| Search (sorted) | O(log n) | Binary search |
| Insert at end | O(1) amortized | Growable array doubles capacity |
| Insert at front or middle | O(n) | Elements must shift |
| Delete at end | O(1) | Decrement size |
| Delete at front or middle | O(n) | Elements must shift |
| Space | O(n) | Plus capacity slack |

### Singly Linked Lists

\index{linked list!singly!complexity}

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| Access by index | O(n) | Must traverse from head |
| Search | O(n) | Linear scan |
| Insert at front (prepend) | O(1) | Update head |
| Insert at back (append) | O(1) | With tail pointer |
| Insert at arbitrary index | O(n) | O(n) to find position |
| Delete at front | O(1) | Update head |
| Delete at back | O(n) | Must find second-to-last node |
| Delete given a node's predecessor | O(1) | Pointer update only |
| Space | O(n) | Plus one pointer per node |

### Doubly Linked Lists

\index{linked list!doubly!complexity}

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| Access by index | O(n) | Must traverse |
| Search | O(n) | Linear scan |
| Insert at front | O(1) | |
| Insert at back | O(1) | |
| Insert given a node pointer | O(1) | Pointer updates only |
| Delete at front | O(1) | |
| Delete at back | O(1) | Use prev pointer |
| Delete given a node pointer | O(1) | Pointer updates only |
| Space | O(n) | Plus two pointers per node |

### Stacks

\index{stack!complexity}

| Operation | Complexity |
|-----------|-----------|
| `push` | O(1) |
| `pop` | O(1) |
| `top` | O(1) |
| `empty` | O(1) |
| `size` | O(1) |
| Space | O(n) |

### Queues

\index{queue!complexity}

| Operation | Complexity |
|-----------|-----------|
| `enqueue` | O(1) |
| `dequeue` | O(1) |
| `front` | O(1) |
| `empty` | O(1) |
| `size` | O(1) |
| Space | O(n) |

Note: a naïve array queue (shifting on dequeue) has O(n) dequeue.
Always use a circular array or linked list.

### Heaps (Binary)

\index{heap!complexity}

| Operation | Complexity |
|-----------|-----------|
| `insert` | O(log n) |
| `remove_max` / `remove_min` | O(log n) |
| `max` / `min` | O(1) |
| `empty` | O(1) |
| `size` | O(1) |
| Build from array (bottom-up) | O(n) |
| Build from n insertions | O(n log n) |
| Space | O(n) |

### Hash Tables

\index{hash table!complexity}

| Operation | Average | Worst case |
|-----------|---------|-----------|
| `insert` | O(1) | O(n) |
| `lookup` | O(1) | O(n) |
| `remove` | O(1) | O(n) |
| `contains` | O(1) | O(n) |
| Space | O(n) | O(n + capacity) |

Worst case occurs with a degenerate hash function or adversarial input.

### `std::map` (Balanced BST)

\index{std::map!complexity}

| Operation | Complexity |
|-----------|-----------|
| `insert` | O(log n) |
| `find` | O(log n) |
| `erase` | O(log n) |
| Iteration (sorted) | O(n) |
| Space | O(n) |

Use when you need sorted iteration or range queries.

## Choosing a Data Structure: Quick Reference

| Need | Best choice |
|------|------------|
| Access by integer index | `std::vector` |
| Fast front insert/delete | `std::deque` or `std::list` |
| LIFO (last-in first-out) | `std::stack` |
| FIFO (first-in first-out) | `std::queue` |
| Always need min or max | `std::priority_queue` |
| Key-value lookup (fast) | `std::unordered_map` |
| Key-value lookup (sorted) | `std::map` |
| Sorted unique values | `std::set` |
| Generic sequence | `std::vector` (default choice) |

## Space Complexity Reference

| Structure | Space | Extra per element |
|-----------|-------|------------------|
| Array (fixed) | O(capacity) | 0 |
| Growable array | O(capacity) ≤ 2n | 0 |
| Singly linked list | O(n) | 1 pointer (8 bytes) |
| Doubly linked list | O(n) | 2 pointers (16 bytes) |
| Heap (array) | O(n) | 0 |
| Hash table (chained) | O(n + capacity) | 1 pointer per bucket |
| Hash table (open addr.) | O(capacity) | 0 |
| Balanced BST | O(n) | 2-3 pointers per node |

\printindex
