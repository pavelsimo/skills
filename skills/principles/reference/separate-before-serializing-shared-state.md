# separate-before-serializing-shared-state

**Phase:** concurrency / ops

## rule

When concurrent work fights over shared state, first try to stop sharing it: partition it, give each worker its own copy, or make the data immutable. Reach for locks, queues, or serialization only when the state really has to be shared.

## when it applies

- race conditions, deadlocks, and lock contention
- a global counter, cache, or file several workers write to
- about to add a mutex or a single-worker queue

## example

Workers updating one shared `stats` row cause lock contention. Each worker writes its own row, and a read sums them. No lock is needed.

## usual violation

Wrapping everything in one big lock, which fixes the race and quietly turns a parallel system into a serial one.
