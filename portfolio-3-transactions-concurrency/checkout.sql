\set ON_ERROR_STOP on
\set customer_id '00000000-0000-0000-0000-000000000002'
\set address_id '10000000-0000-0000-0000-000000000002'
\set variant_id '30000000-0000-0000-0000-000000000003'
\set warehouse_id 1
\set requested_qty 2

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- The conditional UPDATE takes a row lock and rechecks availability after any competing writer commits.
-- If stock is insufficient, reserved is empty and the dependent INSERTs create no partial order.
WITH reserved AS (
  UPDATE inventory
  SET quantity_reserved = quantity_reserved + :requested_qty
  WHERE warehouse_id = :warehouse_id
    AND variant_id = :'variant_id'
    AND quantity_on_hand - quantity_reserved >= :requested_qty
  RETURNING variant_id
), chosen AS (
  SELECT v.variant_id, v.sku, v.unit_price, p.name
  FROM product_variants AS v
  JOIN products AS p ON p.product_id = v.product_id
  JOIN reserved AS r ON r.variant_id = v.variant_id
  WHERE v.variant_id = :'variant_id'
), new_order AS (
  INSERT INTO orders (customer_id, shipping_address_id, subtotal, shipping_fee, discount_total)
  SELECT :'customer_id', :'address_id', unit_price * :requested_qty, 4.99, 0
  FROM chosen
  RETURNING order_id
)
INSERT INTO order_items (
  order_id, variant_id, sku_snapshot, product_name_snapshot, quantity, unit_price
)
SELECT o.order_id, c.variant_id, c.sku, c.name, :requested_qty, c.unit_price
FROM new_order AS o
CROSS JOIN chosen AS c
RETURNING order_id, order_item_id, line_total;

COMMIT;
