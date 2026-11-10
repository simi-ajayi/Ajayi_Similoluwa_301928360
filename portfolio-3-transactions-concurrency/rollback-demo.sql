\set ON_ERROR_STOP off

SELECT quantity_reserved AS before_reserved
FROM inventory
WHERE warehouse_id = 1
  AND variant_id = '30000000-0000-0000-0000-000000000002';

BEGIN;

UPDATE inventory
SET quantity_reserved = quantity_reserved + 1
WHERE warehouse_id = 1
  AND variant_id = '30000000-0000-0000-0000-000000000002';

-- Deliberately invalid negative price: the check constraint aborts the transaction.
INSERT INTO order_items (
  order_id, variant_id, sku_snapshot, product_name_snapshot, quantity, unit_price
) VALUES (
  '40000000-0000-0000-0000-000000000001',
  '30000000-0000-0000-0000-000000000002',
  'NS-HEAD-WHT', 'Wireless Headphones - White', 1, -1
);

ROLLBACK;

SELECT quantity_reserved AS after_rollback_reserved
FROM inventory
WHERE warehouse_id = 1
  AND variant_id = '30000000-0000-0000-0000-000000000002';
