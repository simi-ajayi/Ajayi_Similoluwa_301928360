# Portfolio 3 - Transactions and Concurrency

## Demonstrations

- `checkout.sql` reserves stock and creates an order atomically.
- `rollback-demo.sql` proves a failed transaction leaves no partial order or inventory reservation.
- `session-a.sql` and `session-b.sql` demonstrate row-level locking under concurrent checkout.

## Concurrency exercise

Open two `psql` terminals. Run `session-a.sql` in the first. Before committing Session A, run `session-b.sql` in the second. Session B should wait on the same inventory row. After Session A commits, Session B re-evaluates the row and fails the stock condition rather than overselling.

Capture both terminal sessions and query `pg_stat_activity`/`pg_locks` while Session B is waiting. Explain how `SELECT ... FOR UPDATE`, the inventory check constraint, and transaction boundaries work together.
