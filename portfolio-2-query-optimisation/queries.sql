\timing on

-- Q1: customer order history, newest first.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT o.order_id, o.status, o.grand_total, o.placed_at
FROM orders AS o
WHERE o.customer_id = '00000000-0000-0000-0000-000000000001'
ORDER BY o.placed_at DESC
LIMIT 20;

-- Q2: active catalogue search by category and case-insensitive name.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT p.product_id, p.name, p.brand, min(v.unit_price) AS starting_price
FROM products AS p
JOIN categories AS c ON c.category_id = p.category_id
JOIN product_variants AS v ON v.product_id = p.product_id AND v.active
WHERE p.active
  AND c.slug = 'electronics'
  AND lower(p.name) LIKE '%head%'
GROUP BY p.product_id, p.name, p.brand
ORDER BY p.name;

-- Q3: low-stock variants requiring replenishment.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT w.name AS warehouse, v.sku, p.name,
       i.quantity_on_hand - i.quantity_reserved AS available,
       i.reorder_level
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN product_variants AS v ON v.variant_id = i.variant_id
JOIN products AS p ON p.product_id = v.product_id
WHERE i.quantity_on_hand - i.quantity_reserved <= i.reorder_level
ORDER BY available, v.sku;

-- Q4: monthly captured revenue and order volume.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT date_trunc('month', o.placed_at) AS month,
       count(DISTINCT o.order_id) AS orders,
       sum(p.amount) AS captured_revenue
FROM orders AS o
JOIN payments AS p ON p.order_id = o.order_id
WHERE p.status = 'captured'
  AND o.placed_at >= current_date - interval '12 months'
GROUP BY date_trunc('month', o.placed_at)
ORDER BY month;

-- Q5: JSONB attribute filter.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT product_id, name, attributes
FROM products
WHERE active AND attributes @> '{"wireless": true}'::jsonb;
