-- Run only in a disposable development database.
INSERT INTO customers (email, first_name, last_name)
SELECT format('customer%05s@example.test', n), 'Customer', n::text
FROM generate_series(1, 10000) AS n
ON CONFLICT (email) DO NOTHING;

ANALYZE customers;
