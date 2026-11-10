\set ON_ERROR_STOP on

SELECT 'seeded customers' AS check_name, count(*) = 2 AS passed FROM customers;
SELECT 'seeded variants' AS check_name, count(*) = 3 AS passed FROM product_variants;

SELECT
  'generated order total' AS check_name,
  grand_total = 94.98 AS passed
FROM orders
WHERE order_id = '40000000-0000-0000-0000-000000000001';

SELECT
  'generated line total' AS check_name,
  line_total = 89.99 AS passed
FROM order_items
WHERE order_id = '40000000-0000-0000-0000-000000000001';

DO $$
BEGIN
  BEGIN
    UPDATE inventory
    SET quantity_reserved = quantity_on_hand + 1
    WHERE warehouse_id = 1
      AND variant_id = '30000000-0000-0000-0000-000000000001';
    RAISE EXCEPTION 'inventory constraint did not reject excessive reservation';
  EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'PASS: excessive reservation rejected';
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO customers (email, first_name, last_name)
    VALUES ('amina@example.test', 'Duplicate', 'Email');
    RAISE EXCEPTION 'unique email constraint did not reject duplicate';
  EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'PASS: duplicate customer email rejected';
  END;
END;
$$;
