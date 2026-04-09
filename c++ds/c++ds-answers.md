---
title: "Data Structures in C++ -- Answer Key"
toc: true
toc-depth: 2
colorlinks: true
header-includes:
  - \usepackage[most]{tcolorbox}
---

\newpage

# Chapter 1: Abstract Data Types

**1.** An array-based list is better when the workload primarily accesses elements by index and rarely inserts or deletes in the middle (e.g., a lookup table of records accessed by ID).
A linked list is better when elements are frequently inserted or removed at the front or middle, and index access is rare (e.g., a queue of tasks where tasks are added to the back and removed from the front).

**2.** Output: `0`

`ModCounter` with mod 3 starts at 0.
After three increments: `(0+1)%3 = 1`, `(1+1)%3 = 2`, `(2+1)%3 = 0`.
`c->value()` returns 0.

**3.** The bug is calling `s.pop()` on an empty stack.
`top_` starts at -1, so `pop()` returns `data_[-1]` (undefined behavior) and decrements `top_` to -2.
The fix is to check `empty()` before calling `pop()`, or to have `pop()` throw when empty.

**4.** The separation is useful because it lets different team members work independently.
The interface author defines the contract; the implementor fulfills it; the caller only needs the contract.
The caller's code does not need to change when the implementation changes, and the caller does not need to wait for the implementation to be written --- they can program against the interface immediately.

**5.** When 1024 items have been pushed, the last push triggered a resize that copied all 1023 existing items.
That single resize caused 1023 copy operations.
"Amortized O(1)" means the total cost of all n pushes is O(n) --- even though one push is O(n), the cost is spread over all pushes, making the average O(1) per push.

**6.** Output: `Square: 16`

`s` is a `Shape*` pointing to a `Square{4.0}`.
`name()` is virtual and returns `"Square"`; `area()` is virtual and returns `4.0 * 4.0 = 16`.

**7.** The destructor `~Queue()` is not virtual.
If a `Queue*` points to a derived class object and `delete` is called on it, only `~Queue()` runs and the derived class's resources are leaked.
Fix: `virtual ~Queue() = default;`

**8.** The load factor is `α = 8 / 10 = 0.8`.
With a uniform hash function, the expected chain length equals the load factor: 0.8 items per bucket on average.

**9.** After pushing 5 items and popping 2, size is 3.
Pushing 4 more: size becomes 7.
Does not overflow (capacity is 8; 7 <= 8).

**10.** (Program exercise --- no single correct answer.
The program should define `Deque` with `push_front`, `push_back`, `pop_front`, `pop_back`, `front`, `back`, `empty`, `size` as an abstract class, implement it with a fixed-size array using two indices, and test all operations including edge cases on empty and single-element deques.)

---

# Chapter 2: Foundations for Building Data Structures in C++

**1.** The Rule of Five says "define or explicitly delete" because sometimes you want to *prevent* copying.
For example, a class that manages a mutex or a unique hardware resource should not be copyable --- you would `= delete` the copy constructor and copy assignment to make copying a compile error, rather than letting the compiler silently generate a wrong copy.

**2.** Output:
```
7
Brave New World
```

`p.max()` returns `first > second ? first : second`.
For ints, `7 > 3` → 7.
For strings, `"Brave New World" > "1984"` → `"Brave New World"` (lexicographic comparison; 'B' > '1').

**3.** The bug is the missing copy constructor.
`process(arr)` takes `a` by value, which invokes the compiler-generated copy constructor.
The generated copy copies the *pointer* `data_`, not the data.
Both `arr` and the local copy `a` point to the same array.
When `process` returns, `a`'s destructor calls `delete[] data_`.
Then when `arr` goes out of scope, its destructor calls `delete[]` on the same pointer --- double-free, which is undefined behavior (and typically a crash).

**4.** With raw `new`/`delete`, if an exception is thrown between `new` and `delete`, execution jumps to the catch block, skipping the `delete`.
The memory is never freed.
RAII solves this because the destructor runs automatically when the object goes out of scope, whether the scope exits normally or via an exception.

**5.** Starting with capacity 1 and doubling: capacities after each resize are 1, 2, 4, 8, 16, 32.
To store 32 items requires 5 resize operations (1→2, 2→4, 4→8, 8→16, 16→32).
Copy counts: 1 + 2 + 4 + 8 + 16 = 31 total copies across all resizes.

**6.** Output:
```
3
0
100
```

`clamp(3, 1, 10)` → 3 (within range).
`clamp(-5, 0, 100)` → 0 (below lo).
`clamp(200, 0, 100)` → 100 (above hi).

**7.** The bug is infinite loop → stack overflow.
The loop pushes 1 forever until the fixed-size array `data_[10]` overflows (writing past the array boundary, which is undefined behavior).
`push` does not check for overflow.

**8.** O(n²) means time scales quadratically.
For n=100: 4 ms.
For n=1000: the time is (1000/100)² × 4 ms = 100 × 4 = 400 ms.

**9.** If the vector grew by a fixed amount (say 10) instead of doubling, each group of 10 appends would trigger a resize that copies all existing elements.
For n total appends, the total copy work is approximately 10 + 20 + 30 + ... + n = O(n²/10) = O(n²).
Amortized per insert would be O(n), not O(1).
Doubling ensures the total copy work is O(n) because the geometric series 1 + 2 + 4 + ... + n/2 sums to O(n).

**10.** (Program exercise --- no single correct answer.
The `MinMax<T>` class should have a `bool has_value_` flag, a `T min_` and `T max_` member, and throw `std::runtime_error` when `min()` or `max()` is called with no items added.
`add()` updates `min_` and `max_` using `<` and `>`.)

---

# Chapter 3: Linear Data Structures Overview

**1.** An array is better for text editor lines if random access is the dominant operation (e.g., "go to line 5000" in a text editor).
A linked list is better if insertions and deletions of lines are the dominant operation and random access is rare (e.g., a stream editor like `sed` that processes lines sequentially).
In practice, most text editors use a "piece table" or "rope" --- more sophisticated structures that handle both cases well.

**2.** Output:
```
Hamlet
Macbeth
```

Element at index 1 (`"Othello"`) is deleted by shifting left.
The remaining elements are `"Hamlet"` and `"Macbeth"`.

**3.** Inserting at index 0 shifts all 1000 elements one position right.
That is 1000 copies.
At 10 ns each: 10,000 ns = 10 microseconds.

**4.** The bug is a memory leak.
`to_delete` is deleted from the chain by updating `prev->next`, but `delete to_delete` is never called.
The node's memory is leaked.

**5.** In a singly linked list, prepending is O(1) because you only update two pointers: `new_node->next = head` and `head = new_node`.
In an array, inserting at index 0 is O(n) because every existing element must shift one position to the right to make room.
The diagram: list = just pointer updates; array = moving every element.

**6.** Output:
```
Hamlet
Othello
Macbeth
```

The nodes are stack-allocated and linked via raw pointers.
The loop traverses from `a` through `b` to `c`.

**7.** Extra memory = 8 bytes × 1000 = 8,000 bytes (≈ 8 KB).
Each linked list node uses 40 bytes (32 for string + 8 for pointer) vs. 32 bytes for the array element.

**8.** The bug is calling `.get()` on an rvalue `std::move(n1)`.
`std::move(n1)` produces an rvalue; calling `.get()` on it returns the raw pointer, but the `unique_ptr` ownership has already been "moved" (in this case, just cast to an rvalue; the actual transfer happens when assigned to another `unique_ptr`).
More critically, passing the raw pointer to `print()` while the `unique_ptr` is being destroyed at the end of the full expression is dangerously close to a use-after-free.
Fix: `print(n1.get())` without the `std::move`.

**9.** A `std::deque` is implemented as a sequence of fixed-size chunks (blocks) of elements, with a map of pointers to those chunks.
This gives O(1) push/pop at both ends (like a linked list), O(1) random access (like an array), and good cache locality within each chunk.
It combines some benefits of both: better cache behavior than a linked list, and O(1) front operations unlike a vector.

**10.** (Program exercise --- no single correct answer.
`Sequence<T>` should use a `T data_[16]` array and an `int size_` counter.
`append` adds at the end, `insert_at` shifts right, `remove_at` shifts left, `at` returns by const reference with bounds checking.)

---

# Chapter 4: The List ADT

**1.** If the fixed amount added is k, after n appends the total number of copies is approximately k + 2k + 3k + ... = k × (n/k)(n/k+1)/2 = O(n²/k) = O(n²).
The amortized cost per append would be O(n), not O(1).
Doubling is necessary to keep the amortized cost O(1).

**2.** Output: `1 2 3 `

`prepend(0)` is called last, making 0 the head.
After the three appends and one prepend, the list is `0 → 1 → 2 → 3`.
The range-for prints all four values.
Wait, re-reading: `append(1)`, `append(2)`, `append(3)` then `prepend(0)` gives `0 1 2 3`.

Output: `0 1 2 3 `

**3.** The bug is the missing copy constructor.
`SimpleList<std::string> b = a` invokes the compiler-generated copy constructor, which copies the `head_` pointer.
Both `a` and `b` share the same linked list nodes.
When `b`'s destructor runs, it deletes all the nodes.
When `a`'s destructor then runs, it tries to delete the same nodes again --- double-free, undefined behavior.

**4.** Both `prev` and `next` cannot be `unique_ptr` because a doubly linked list has cycles in ownership: each node is "owned" by its predecessor (via `next`), but the predecessor is also reachable from the node (via `prev`).
If both were `unique_ptr`, ownership would be circular and neither could be freed.
`prev` is a raw non-owning pointer because each node is owned by exactly one predecessor (or by `head_`); the backward link is just an observation, not ownership.

**5.** To remove the node at index 500, you must traverse from `head_` through 499 `next` pointers to reach the node *before* the target (index 499), then update one pointer.
The traversal touches 500 nodes.
The complexity is O(n).

**6.** Output: `0 1 2 3 `

`append(1)`, `append(2)`, `append(3)` gives list `1 2 3`.
`prepend(0)` makes it `0 1 2 3`.
Range-for prints them in order.

**7.** The bug is not updating `tail_` when the list becomes empty.
After removing the only element (or any time `head_` becomes null), `tail_` still points to the deleted node.
Fix: `if (!head_) tail_ = nullptr;` after `head_ = std::move(head_->next);`.

**8.** Starting capacity 4, doubling each time: 4 → 8 → 16 → 32.
After 17 appends, capacity is 32.
Resize operations: 4→8 copies 4 elements, 8→16 copies 8, 16→32 copies 16.
Total copies: 4 + 8 + 16 = 28.

**9.** `std::list` is rarely faster than `std::vector` in practice for middle insertions because *finding* the insertion position still requires O(n) traversal of the linked list --- and that traversal generates many cache misses.
The O(1) insertion cost of `std::list` only applies given a pointer to the insertion position; obtaining that pointer is O(n) and cache-unfriendly.
`std::vector`'s O(n) shift is cache-friendly because all elements are contiguous in memory.

**10.** (Program exercise --- no single correct answer.
The `DoublyLinkedList<T>` should use `unique_ptr<Node>` for `next` and a raw `Node*` for `prev`.
All operations must correctly handle empty and single-element lists.
Forward traversal: head to tail via `next`.
Reverse traversal: tail to head via `prev`.)

---

# Chapter 5: Stacks

**1.** The call stack is a fixed-size array-based stack managed by the OS and runtime.
Recursion pushes a new frame on every call; if the recursion is deep enough, the array fills up --- stack overflow.
Iteration uses only a fixed number of stack frames (the loop body does not push anything new), so it cannot overflow the call stack regardless of the number of iterations.

**2.** Output:
```
3
4
3
```

Push 1, 2, 3 → size 3.
`pop()` returns 3, size is now 2.
`push(4)` → stack is [1, 2, 4], size 3.
`top()` returns 4.
`size()` returns 3.

**3.** The bug is the order of pop.
`a` is popped first, so `a = 10` (the top).
Then `b = 3`.
The computation is `a - b = 10 - 3 = 7`.
Wait --- the expression is `"10 3 -"`.
`10` is pushed, then `3` is pushed.
For `"-"`: `a = stack.pop()` gets 3, `b = stack.pop()` gets 10.
`a - b = 3 - 10 = -7`.
But expected is `10 - 3 = 7`.
The fix: pop the *right* operand first (`b`), then the *left* operand (`a`), and compute `a - b`:
```cpp
double b = stack.pop();
double a = stack.pop();
stack.push(a - b);
```

**4.** To cap undo history at 100 operations, you could use a fixed-size circular buffer (deque) that discards the oldest entry when it is full.
A queue is better suited than a stack for this: you need to add to one end and potentially discard from the other (oldest) end.
A `std::deque` with size capped at 100 is the standard approach.

**5.** With 7 numbers and 6 binary operators in a valid postfix expression, the maximum stack depth is 7 (after all numbers are pushed before any operator is applied).
In practice, numbers and operators interleave, but the maximum is still bounded by the number of numbers: 7 items.

**6.** Output: `5 4 3 2 1 `

Values 1 through 5 are pushed; then popped in reverse order (LIFO).

**7.** The bug is calling `st.top()` without checking `st.empty()` first.
If the input starts with a closing bracket (e.g., `")"`) or has more closing than opening brackets, `st.empty()` is true when `top()` is called, which is undefined behavior.
Fix: check `if (st.empty()) return false;` before `st.top()`.

**8.** Push 6: size = 6.
Pop 3: size = 3.
Push 8 more: size = 3 + 8 = 11.
Capacity is 10.
After pushing 7 more (size reaches 10), the next push (making size 11) overflows.
So yes, it overflows.

**9.** Yes, a queue can be implemented with two stacks.
`enqueue(x)`: push to stack 1.
`dequeue()`: if stack 2 is empty, pop all items from stack 1 and push them onto stack 2 (this reverses the order); then pop from stack 2.
Complexity: `enqueue` is O(1); `dequeue` is amortized O(1) (each element is moved at most once from stack 1 to stack 2).

**10.** (Program exercise --- no single correct answer.
Push each character onto a `std::stack<char>`, then pop all characters and concatenate to form the reversed string.
For example, "hello" → "olleh".)

---

# Chapter 6: Queues

**1.** In a naïve array queue, `dequeue` removes the front element and shifts all remaining n-1 elements one position left to fill the gap --- O(n).
The circular array avoids this by moving the `front_` index forward instead of moving the elements, leaving them in place.
No shifting means O(1) dequeue.

**2.** Output:
```
1
2
3
```

Push 1, 2, 3.
`front()` is 1.
`pop()` removes 1.
`push(4)` adds 4 to the back.
`front()` is now 2.
`size()` is 3 (elements 2, 3, 4).

**3.** The bug is that `front_` and `back_` advance indefinitely without wrapping.
After 5 enqueue/dequeue cycles, `front_ = back_ = 5`.
The next `enqueue` sets `data_[5]` --- still valid in this 8-element array.
But after enough cycles, the indices go out of bounds.
For example, after 8 full cycles, `back_ = 8`, which is past the end of `data_[8]`.
Fix: wrap with `% 8` (circular buffer).

**4.** With a fixed capacity, if the producer is faster than the consumer the queue fills up.
The producer must then wait (block) or items are dropped --- common choices are backpressure or overflow error.
With a linked-list queue, the queue grows indefinitely until the system runs out of memory --- a different kind of problem.
In practice, you want a bounded queue (fixed capacity) with backpressure so producers slow down when the queue is full.

**5.** `front_` is at index 4, `size_` is 3.
Back element physical index = `(front_ + size_ - 1) % capacity` = `(4 + 3 - 1) % 7 = 6 % 7 = 6`.
Enqueuing one more: new back index = `(front_ + size_) % capacity` = `(4 + 3) % 7 = 0`.
It wraps around to index 0.

**6.** Output: `3 4 5 6 `

Enqueue 1, 2, 3, 4.
Dequeue 1 and 2 (leaving 3, 4).
Enqueue 5 and 6 (queue: 3, 4, 5, 6).
Dequeue all four: `3 4 5 6`.

**7.** The bug is the order of operations.
`tail_ = node.get()` updates `tail_` *before* linking the node to the list.
Then `tail_->next = std::move(node)` moves `node` into `tail_->next`, but `tail_` already points to the new node, not the previous tail.
The previous tail's `next` is never updated.
Fix: `tail_->next = std::move(node); tail_ = tail_->next.get();`

**8.** A linked list queue allocates a new node on the heap for each of the 1000 enqueues --- 1000 allocations.
It deallocates a node for each of the 1000 dequeues --- 1000 deallocations.
Total: 1000 allocations + 1000 deallocations.
The circular array queue allocates once (the array) and deallocates once --- far fewer allocations.

**9.** If you copy `data_` directly with the original `front_` value, you have a circular buffer where the logical start is at some offset `front_`.
But after copying, `size_` is correct, `front_` is correct, and elements are at their original physical positions.
This is actually fine for the copy.
The problem would be if `front_` pointed to index 5 and the array had logically wrapped around (elements at 5, 6, 7, 0, 1, 2) --- the copy would be correct as long as you preserve `front_`.
The chapter's grow/copy copies elements in *logical* order (0 to size-1 mapped to physical) so that after growth, `front_` resets to 0 and the layout is clean.
Copying raw with old `front_` is also correct but leaves `front_` non-zero unnecessarily.

**10.** (Program exercise --- no single correct answer.
Define a `std::queue<std::string>` for the spooler.
Add 5 jobs, dequeue and "print" 2, add 3 more, dequeue and print all remaining.
Output should show jobs in FIFO order.)

---

# Chapter 7: Heaps

**1.** A heap only guarantees that the root is the maximum.
The second maximum could be in either child of the root.
Identifying it requires comparing the two children --- O(1) if the tree has only one level below the root.
But finding the *k*-th maximum in general requires O(k log n) time, because each extraction re-heapifies the tree.

**2.** Output:
```
8
5
```

Pushing 5, 1, 8, 3 into a max-priority queue.
`top()` is 8 (the maximum).
After `pop()`, 8 is removed and the new maximum is 5.

**3.** The bug is that `i` is never updated.
After swapping `heap[i]` with `heap[parent]`, `i` should be set to `parent` to continue sifting up.
Without that update, the loop either terminates immediately (since `parent` is re-computed from the original `i`) or runs infinitely.
Fix: `i = parent;` at the end of the loop body.

**4.** In `build_heap`, we call `sift_down` on each internal node starting from the last.
Nodes near the leaves have very few descendants, so their sift-down is short.
Specifically: half the nodes are leaves (0 swaps), a quarter are one level up (at most 1 swap), an eighth are two levels up (at most 2 swaps), etc.
Total work = n/2 × 0 + n/4 × 1 + n/8 × 2 + ... = O(n).
This converges to O(n) because the series Σ k/2^k converges.

**5.** A heap of 15 elements is a complete binary tree.
Height = ⌊log₂ 15⌋ = 3.
`sift_down` from the root performs at most `height = 3` swaps in the worst case.

**6.** The array `{1, 2, 3, 4, 5}` will have `build_heap` called on it.
The result is a max-heap; `arr[0]` holds the maximum value.
Maximum of `{1, 2, 3, 4, 5}` is 5.
Output: `5`

**7.** The bug is calling `sift_down(0)` when the heap might be empty after `pop_back()`.
If there was only one element, `pop_back()` empties `data_`, and `sift_down(0)` on an empty vector accesses `data_[0]` --- undefined behavior.
Fix: `if (!data_.empty()) sift_down(0);`

**8.** Insertions of 10, 20, 5, 15, 30 into an empty max-heap:
- Insert 10: `[10]`
- Insert 20: `[10, 20]` → sift up 20 (20 > 10): `[20, 10]`
- Insert 5: `[20, 10, 5]` → 5 < 20, no sift: `[20, 10, 5]`
- Insert 15: `[20, 10, 5, 15]` → 15 > parent(10): `[20, 15, 5, 10]`
- Insert 30: `[20, 15, 5, 10, 30]` → 30 > parent(15) → `[20, 30, 5, 10, 15]` → 30 > parent(20) → `[30, 20, 5, 10, 15]`

Final array: `[30, 20, 5, 10, 15]`

**9.** We swap the root with the *last* element rather than with the largest child because this preserves the *complete binary tree* structural property.
The last element occupies the last position in the array (last leaf), so after swapping and removing the last position, the tree is still complete.
If we moved the largest child to the root and left a gap, the tree would no longer be a valid complete binary tree.

**10.** (Program exercise --- no single correct answer.
Implement `MinHeap<T>` by changing the comparison in `sift_up` and `sift_down` from `>` to `<` (child is "better than" parent when it is smaller).
Insert all elements and call `remove_min()` repeatedly to get them in ascending order.)

---

# Chapter 8: Hash Tables

**1.** If every key hashes to 0, all entries go into bucket 0.
The chain at bucket 0 becomes a list of all n entries.
Lookup degrades to O(n) --- a linear scan of the chain.
This shows that the hash function is the critical factor in hash table performance.
A bad hash function turns O(1) average into O(n) in every case.

**2.** Output:
```
1847
1
3
```

`m["Typee"] = 1847` overwrites the previous value 1846.
`m.count("Billy Budd")` returns 1 (key exists).
`m.size()` returns 3 (three entries: "Moby Dick", "Typee", "Billy Budd").

**3.** The bug is clearing a slot with `slots_[idx].reset()` without leaving a tombstone.
If another key was inserted after `key` and landed in a slot beyond `idx` during linear probing, a later lookup for that other key starts at its hash position, scans forward, and stops when it hits the now-empty slot at `idx` --- before reaching the actual entry.
The fix is to mark the slot with a tombstone (`deleted` sentinel) so probing continues past it.

**4.** `std::unordered_map` does not support range queries because the keys are not stored in sorted order --- they are distributed across buckets by hash.
To find all keys between 'A' and 'M', you would need to scan all buckets --- O(n + capacity).
For range queries, use `std::map` (a balanced BST), which stores keys in sorted order and supports `lower_bound` and `upper_bound` for O(log n) range boundary finding.

**5.** Load factor = 8 / 10 = 0.8.
With uniform distribution, expected chain length ≈ α = 0.8.

**6.** Output: `not found`

`m.find(3)` returns `m.end()` because key 3 is not in the map.
The `if (it == m.end())` branch prints `"not found"`.

**7.** The bug is that `bad_hash` only uses the string's length.
Any two strings of the same length will always hash to the same slot, regardless of `table_size`.
For example: `"Moby Dick"` (9 chars) and `"Billy Bud"` (9 chars) both hash to `9 % table_size` for any `table_size`.

**8.** The table had 6 items.
At load 0.75, rehash is triggered.
All 6 existing entries are reinserted into the new capacity-16 table.
6 entries are reinserted.

**9.** If an adversary knows the hash function (or can predict it), they can craft inputs that all hash to the same bucket, degrading O(1) average to O(n) worst case for every operation.
This is a **hash flooding DoS attack**.
The defense is **hash randomization**: use a per-process random seed (salt) in the hash function so the adversary cannot predict collisions.
C++ `std::hash` implementations typically do this for string types in security-conscious builds.

**10.** (Program exercise --- no single correct answer.
The phone book should use `ChainedHashTable<std::string, std::string>` (or `std::unordered_map<std::string, std::string>`) with `insert(name, number)`, `lookup(name)`, `remove(name)`, and a `search_by_name` function that iterates the buckets to find entries by partial name match.)

---

# Chapter 9: Comparing Data Structures

**1.** A good combination: `std::unordered_map<std::string, int>` for O(1) score lookup and update; a sorted `std::vector<pair<int,string>>` (or `std::multiset`) rebuilt on demand for top-10 extraction; and a separate `std::map<std::string, int>` (sorted by player name with rank computed as offset) for rank lookup.
In practice, a `std::map<int, std::string, std::greater<int>>` keyed by score handles both sorted ranking and O(log n) rank lookup simultaneously.

**2.** Output: `1 2 3 4 5 `

The vector `{5, 3, 1, 4, 2}` is used to initialize a min-priority queue (using `std::greater<int>`).
The smallest element comes out first.
Popping all elements gives 1, 2, 3, 4, 5.

**3.** `std::list<int>` traversal with 1 cache miss every 8 elements:
- 1,000,000 elements ÷ 8 = 125,000 cache misses per traversal.
- 125,000 × 100 ns = 12.5 ms per traversal.
- 1000 traversals × 12.5 ms = 12.5 seconds.

`std::vector<int>` with 1 cache miss every 16 elements:
- 1,000,000 ÷ 16 = 62,500 cache misses per traversal.
- 62,500 × 100 ns = 6.25 ms per traversal.
- 1000 traversals × 6.25 ms = 6.25 seconds.
(These are rough estimates; real cache behavior is more complex.)

**4.** Use `std::unordered_set<std::string>` for O(1) average lookup.
For suggesting closest matches (spell correction), you would additionally need either a BK-tree (for edit-distance search), a trie (for prefix search), or a precomputed list of similar words.
A hash set alone cannot suggest the closest match --- you need an ordered or metric-space structure for that.

**5.** The problem is O(n) `erase(begin())`: removing from the front of a `std::vector` shifts all remaining elements.
For 1000 tasks arriving per second, each removal costs O(n) where n grows over time.
Use `std::queue<Task>` (backed by `std::deque`), which provides O(1) front removal.

**6.** Output:
```
Hobbit: 1937
Silmarillion: 1977
Unfinished Tales: 1980
```

`std::map` stores keys in sorted (lexicographic) order.
"Hobbit" < "Silmarillion" < "Unfinished Tales" alphabetically.

**7.** Average access: node at index 5,000 → 5,000 node visits.
At 50 ns per node: 5,000 × 50 ns = 250 µs per access.
500 accesses/second × 250 µs = 125 ms/second spent on access.
`std::vector`: index access is O(1), essentially 1 ns.
500 accesses × 1 ns = negligible.
Yes, `std::vector` is dramatically faster for index access.

**8.** `std::deque` exists for workloads that need fast insertion and removal at *both* ends.
`std::vector` has O(n) front insertion; `std::deque` has O(1).
Example: a sliding-window algorithm that adds to the back and removes from the front is a perfect fit for `std::deque`.

**9.** In a real-time system where latency spikes are unacceptable, `std::map` (O(log n) guaranteed) is preferable to `std::unordered_map`.
A hash table can degrade to O(n) during a rehash or with adversarial input --- exactly the scenario that causes a latency spike.
BST operations are bounded by O(log n) in all cases (for a balanced tree), so worst-case latency is predictable.

**10.** (Program exercise --- no single correct answer.
Use `std::chrono::high_resolution_clock::now()` before and after traversal.
Fill a `std::list<int>` and `std::vector<int>` with 100,000 elements.
Traverse each with a range-for loop and accumulate the sum.
Print both times.
`std::vector` will typically be 5-10× faster due to cache locality.)

---

# Chapter 10: Design and Implementation Best Practices

**1.** An invariant can be *temporarily* violated *during* a method's execution.
For example, when appending to a doubly linked list, you first update `tail_->next`, which momentarily breaks the invariant "`tail_` points to the last node" (because `tail_` still points to the old last node while the new node is being linked).
The invariant is restored before the method returns.
The key is that the invariant holds *between* method calls (at the boundaries), not necessarily within them.

**2.** Output:
```
2
3
```

`begin()` returns an iterator to the first node (value 1).
`++it` advances to the second node (value 2), `*it` prints 2.
`++it` advances to the third node (value 3), `*it` prints 3.

**3.** The bug is the self-assignment case.
If `other` is `*this` (i.e., `a = a`), then `delete[] data_` frees the memory that `other.data_` also points to.
`other.data_` is now dangling.
The subsequent `std::copy` reads from a freed pointer --- undefined behavior.
Fix: check `if (this == &other) return *this;` at the start, or use the copy-and-swap idiom.

**4.** `std::vector` uses the move constructor when growing (reallocating).
If the element's move constructor is not `noexcept`, `std::vector` falls back to using the copy constructor instead (to maintain the strong exception guarantee: if a copy throws midway, it can abandon the reallocation).
If move constructors are `noexcept`, `std::vector` can use moves, which are much faster for types like `std::string` or `std::vector` (O(1) vs. O(n) for copies).

**5.** Copy-and-swap takes `other` by value.
If the source has n elements, the copy constructor copies all n elements.
Then the swap exchanges the internals in O(1).
Total: n copies.
This is the same cost as a direct copy --- no more, no less.
The advantage is not efficiency but exception safety: if the copy constructor throws, the original is unmodified.

**6.** After `v.push_back(6)`, if `v` was reallocated, all iterators (including `it = v.begin() + 2`) are invalidated.
`*it` is undefined behavior --- it reads from the old (freed) memory.
The output might accidentally look correct (0, 1, 2, ...) because the old memory often still contains the previous values before being overwritten, but the behavior is undefined.

**7.** The bug is that `operator==` is defined but `operator!=` is not.
Range-for requires `operator!=` to check for the end condition (`begin() != end()`).
Fix: add `bool operator!=(const Iterator& other) const { return node != other.node; }`.

**8.** `const_iterator` is needed so that `const` containers can be iterated.
If you only provide `iterator`, then `const LinkedList<T>& list` cannot call `begin()` and `end()` on a const reference (because non-const member functions cannot be called on const objects).
`cbegin()` and `cend()` return `const_iterator`, allowing read-only traversal of const containers.

**9.** With a shared raw pointer (pointer aliasing without deep copy): `a = b` copies the pointer, so both `a` and `b` point to the same underlying data.
When `b.clear()` removes the data, `a`'s data disappears too.
Specific example: if both `a.data_` and `b.data_` point to the same `int[10]` array, `b.clear()` (which calls `delete[] b.data_`) frees the array.
Now `a.data_` is a dangling pointer, and using `a` is undefined behavior.

**10.** (Program exercise --- no single correct answer.
`const_iterator` should have `const T& operator*() const` and `const T*` for `node`.
`cbegin()` and `cend()` should be `const` member functions returning `const_iterator`.
A `const LinkedList<std::string>` should be iterable with `for (const auto& v : list)`.)

---

# Chapter 11: Reusability Through Templates

**1.** Standard library containers are templates rather than virtual-function hierarchies because templates have zero runtime overhead: operations are resolved at compile time.
A virtual-function `Container` base class would require every `push_back`, `operator[]`, and `size()` call to go through a vtable, adding indirection and preventing inlining.
Templates also allow the exact type to be known at the call site, enabling compiler optimizations like loop unrolling and SIMD.
What would be lost is the ability to store different container types in the same variable --- you cannot have `Container* c = new vector<int>()` and then replace it with `new list<int>()`.

**2.** Output:
```
2
3
20
1
```

`s.size()` after two pushes is 2.
`s.capacity()` is 3 (template parameter).
`s.pop()` returns the top (20).
`s.size()` after pop is 1.

**3.** The bug is missing wrap-around.
`back_` advances from 0 to 3 without modulo.
After 4 enqueue + 4 dequeue cycles, `front_ = back_ = 4`.
`enqueue(99)` sets `data_[4]` --- out of bounds for a size-4 array.
Fix: use `back_ = (back_ + 1) % N` and `front_ = (front_ + 1) % N`.

**4.** `std::priority_queue` uses `comp(parent, child)` to check if the parent should swap with the child.
With `std::less<T>`, `comp(parent, child)` = `parent < child`.
The heap "sifts up" when `comp(parent, child)` is true --- i.e., when the parent is *less than* the child.
This means larger children bubble up, putting the largest value at the root.
Hence `std::less` → max-heap.

**5.** `sizeof(double)` is 8 bytes.
`FixedStack<double, 1024>` contains `double data_[1024]` and `int top_` (4 bytes).
Total ≈ 8 × 1024 + 4 = 8,196 bytes ≈ 8 KB.
As a local variable, 8 KB is pushed onto the call stack.
Most systems have a default stack size of 1–8 MB, so this is usually fine.
But `FixedStack<double, 100000>` (800 KB) or larger risks stack overflow.

**6.** Output:
```
10 5
Paradiso Inferno
```

`swap_vals(x, y)` swaps 5 and 10: `x = 10, y = 5`.
`swap_vals(a, b)` swaps "Inferno" and "Paradiso": `a = "Paradiso", b = "Inferno"`.

**7.** `Opaque` does not have `operator<<` defined, so `std::cout << t` fails to compile.
The concept `Printable` requires `std::cout << t` to be valid.
The compiler will emit an error at `print(Opaque{42})` stating that the constraint is not satisfied.
This is the intended behavior --- it is a much clearer error than the nested template instantiation error you would get without the concept.

**8.** `FixedStack<T, N>` is clearly better when the maximum size is known at compile time and stack-allocated storage is preferred (no heap allocation, no runtime overhead).
`Stack<T>` (dynamic, linked list) is better when the maximum size is unknown or highly variable, especially if it could be large (beyond safe stack size).

**9.** Push 5, 3, 8, 1, 7 into `PriorityQueue<int, std::greater<int>>` (min-heap).
After all inserts, `top()` is 1 (the minimum).
After one `pop()`, 1 is removed.
The new minimum is 3, so `top()` is 3.

**10.** (Program exercise --- no single correct answer.
`Stack<T, N>` uses `T data_[N]` and `int top_`.
`generic_reverse<Container, Iter>(Container& stack, Iter begin, Iter end)` pushes all elements from the range, then pops them into a `std::vector<T>` to get them in reversed order.
The stack must have room for all elements in the range.)

---

# Chapter 12: Testing and Debugging Data Structures

**1.** 100% line coverage means every line was executed at least once.
But line coverage cannot catch bugs related to *combinations* of operations or *invariant violations* that only manifest after multiple steps.
Example: a linked list with a corrupted `tail_` pointer that is set correctly after the first `append` but left pointing to the wrong node after a `remove_front`.
Every line of `append` and `remove_front` may execute, but the bug only manifests on the *second* `append` after a `remove_front` --- a scenario not covered by single-operation tests.

**2.** If deep copy: `a.size()` = 2, `b.size()` = 3.
If shallow copy: `b.append(3)` would append to the *same* linked list that `a` points to.
Both `a.size()` and `b.size()` would return 3, and `a.front()` might now include the element appended via `b`.

**3.** This test can pass with a shallow copy because `a.top() == 2` does not check whether `a`'s data is still independent.
Even after a shallow copy, `a` and `b` point to the same nodes.
After `b.push(3)`, `b.size()` is 3 and `a.size()` is also 3 (they share the same list).
The assertions `a.size() == 2` would actually *fail* with a shallow copy --- so this test *would* catch a shallow copy bug.
Wait, re-reading: yes, `a.size() == 2` would fail if `b.push(3)` also incremented `a`'s size.
The assertion catches the bug.
But if size is stored separately in each object (not in the nodes), then `a.size_` might still be 2 even though the shared node chain has 3 nodes.
To guarantee the test catches the bug, also verify `a.top() == 2` before accessing it --- checking the actual data, not just the counter.

**4.** A fuzz test can catch many bugs but misses bugs that require a specific sequence of operations never generated randomly, bugs that only appear with specific values (not random values), and bugs in features not covered by the fuzz operations (e.g., copy and move are not fuzzed).
It also cannot verify correctness without a reference implementation to compare against.

**5.** Each of the 10 appends calls `check_invariants()` at start and end: 2 × 10 = 20 checks.
Each of the 5 remove_fronts: 2 × 5 = 10 checks.
Each of the 3 more appends: 2 × 3 = 6 checks.
Each of the 8 remove_backs: 2 × 8 = 16 checks.
Total: 20 + 10 + 6 + 16 = 52 invariant checks.

**6.** Output:
```
3
2
```

`std::stack` supports copy.
`s` has `{1, 2, 3}` and `t = s` is a copy.
`t.pop()` removes 3 from `t` only.
`s.top()` is still 3.
`t.top()` is 2.

**7.** The bug is `assert(q.dequeue() == "Jazz")`.
FIFO order means `dequeue()` should return `"Sula"` (the second item enqueued), not `"Jazz"` (the third).
The correct assertion is `assert(q.dequeue() == "Sula")`.

**8.** ASan has 2-5× overhead, which is too much for production traffic.
You would enable it for a production service only in a controlled way: in a canary deployment (a small percentage of traffic), or in a staging environment, or during a brief diagnostic window when investigating a specific memory bug.
The standard practice is to run ASan in testing, CI, and staging --- not in production.

**9.** The ballot problem: for a random walk of n steps where each step is +1 (push) or -1 (pop) with equal probability 0.5, and starting at 0, the probability of ending at exactly 0 after 1000 steps is C(1000, 500) × (0.5)^1000 ≈ 1/√(500π) ≈ 0.025 (about 2.5% chance, using Stirling's approximation).

**10.** (Program exercise --- no single correct answer.
Test `MaxHeap<int>`: insert 10 elements, verify `max()` returns the largest.
Call `remove_max()` repeatedly and verify elements come out in *decreasing* order.
Check that `size()` decrements correctly.
After all removes, verify `empty()` is true.
Test copy: copy a heap, remove from the copy, verify the original is unchanged.
Also verify the heap property after every insert and remove by checking that `data_[i] >= data_[2i+1]` and `data_[2i+2]` for all valid indices.)

---

# Chapter 13: Documentation and Interface Design

**1.** Example 1: `std::vector::size()` --- if you write `v.size() == 0` but ignore the result (e.g., `myVec.size();` as a statement), there is no bug.
But `std::remove` and `std::remove_if` return an iterator to the new "end" --- if you ignore the return value and do not call `erase`, the "removed" elements are still in the vector.
Example 2: `std::unique` similarly returns an iterator; ignoring it leaves duplicates in the vector.
`[[nodiscard]]` on these functions would catch silent "remove then forget to erase" bugs at compile time.

**2.** Output: `8`

`Queue{8}` constructs a Queue with cap 8.
The `explicit` means `show(8)` would fail to compile --- there is no implicit conversion from `int` to `Queue`.
`show(Queue{8})` compiles and prints 8.
`// show(8);` --- this would fail to compile with `explicit`.

**3.** Two problems:
(1) Returning `""` (empty string) on underflow is a silent error.
The caller cannot distinguish between "the queue is empty" and "the front element is an empty string."
The contract should be clear: call `dequeue()` on an empty queue → throw.
(2) The `@return` Doxygen comment says "The front element" but does not document the empty-queue behavior.
The precondition and exception behavior must be documented.

**4.** If a class adds a new non-pure virtual method with a default implementation in version 2.0, existing derived classes compiled against version 1.0 will silently use the default --- which may be wrong for their specific subtype.
If the method is pure virtual (`= 0`), existing derived classes will fail to compile against version 2.0 (they do not implement the new pure virtual function), which is a *compile-time* breaking change --- surfacing the problem immediately rather than silently using a wrong default.

**5.** Changing `void push(T value)` (pass by value) to `void push(const T& value)` (pass by const reference) is a source-compatible change for callers: all existing call sites work unchanged.
However, it is a *breaking change for overriders*: a class that overrides `virtual void push(T value)` (by value) will no longer override the new `virtual void push(const T& value)` (by const reference) --- they have different signatures.
Without `override`, the overrider silently becomes a new non-overriding function; with `override`, it becomes a compile error.

**6.** Output: `42`

`w.value()` on the first line is silently discarded, generating a compiler warning (`[[nodiscard]]`).
`int v = w.value()` captures the value; `v` is 42.
`std::cout << v` prints 42.

**7.** The bug is `empty()` without a lock.
`bool empty() const { return stack_.empty(); }` reads `stack_` without acquiring `mutex_`.
If another thread is simultaneously pushing or popping (which holds the lock), `stack_.empty()` reads an object being modified by another thread --- a data race.
Fix: acquire the lock in `empty()`:
```cpp
bool empty() const {
    std::lock_guard<std::mutex> lock{mutex_};
    return stack_.empty();
}
```

**8.** When many `.cpp` files include the same template header, each translation unit instantiates the template independently.
The linker merges duplicate instantiations, but each compilation unit still pays the compilation cost.
For large templates in widely included headers, this can significantly increase compile times.
The solution is **explicit instantiation**: declare `extern template class Stack<int>;` in the header to suppress implicit instantiation in other translation units, and provide one `template class Stack<int>;` explicit instantiation in a single `.cpp` file.
This trades link-time deduplication for a single compile-time instantiation.

**9.** Semantic breaking change example: `size()` returns the number of elements.
Suppose version 2.0 changes it to return the capacity instead.
The signature is unchanged (`int size() const`), so it compiles.
But any caller that used `size()` to check the number of elements now silently gets the wrong answer, leading to logic bugs.

**10.** (Program exercise --- no single correct answer.
`CircularBuffer<T, N>` should have:
- `explicit CircularBuffer()` (no capacity argument needed, N is a template param)
- `[[nodiscard]] bool empty()`, `[[nodiscard]] bool full()`, `[[nodiscard]] T pop()`, `[[nodiscard]] int size()`
- `void push(const T& v)`
- Doxygen `/** @brief ... @pre ... @post ... @throws ... */` on every public method
- `#ifdef NDEBUG ... check_invariants() ... #endif` in mutating methods
- A `[[deprecated("use pop() instead")]] T dequeue()` alias
- The code should compile cleanly with `-Wall -Wextra -pedantic`.)
