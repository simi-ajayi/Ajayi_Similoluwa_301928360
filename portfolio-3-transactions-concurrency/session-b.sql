\set ON_ERROR_STOP on
BEGIN;

SELECT pg_backend_pid() AS session_b_pid;

-- This waits while Session A owns the row lock. After A commits, the WHERE clause is checked again.
UPDATE inventory
SET quantity_reserved = quantity_reserved + 10
WHERE warehouse_id = 1
  AND variant_id = '30000000-0000-0000-0000-000000000003'
  AND quantity_on_hand - quantity_reserved >= 10
RETURNING quantity_on_hand, quantity_reserved;

\if :ROW_COUNT = 0
  \echo 'No reservation made: stock was no longer sufficient after the lock was released.'
\endif

COMMIT;
