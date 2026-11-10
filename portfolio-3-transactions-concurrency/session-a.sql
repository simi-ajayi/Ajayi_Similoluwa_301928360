\set ON_ERROR_STOP on
BEGIN;

SELECT pg_backend_pid() AS session_a_pid;

SELECT quantity_on_hand, quantity_reserved
FROM inventory
WHERE warehouse_id = 1
  AND variant_id = '30000000-0000-0000-0000-000000000003'
FOR UPDATE;

UPDATE inventory
SET quantity_reserved = quantity_reserved + 10
WHERE warehouse_id = 1
  AND variant_id = '30000000-0000-0000-0000-000000000003';

\echo 'Keep this transaction open, run session-b.sql, then press Enter.'
\prompt continue
COMMIT;
