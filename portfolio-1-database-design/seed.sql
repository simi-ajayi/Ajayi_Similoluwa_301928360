BEGIN;

INSERT INTO customers (customer_id, email, first_name, last_name, phone) VALUES
  ('00000000-0000-0000-0000-000000000001', 'amina@example.test', 'Amina', 'Bello', '+44 7700 900001'),
  ('00000000-0000-0000-0000-000000000002', 'daniel@example.test', 'Daniel', 'Reed', '+44 7700 900002');

INSERT INTO addresses (address_id, customer_id, label, line_1, city, county, postcode, is_default) VALUES
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Home', '10 Sample Street', 'Leicester', 'Leicestershire', 'LE1 1AA', true),
  ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'Home', '20 Example Road', 'Nottingham', 'Nottinghamshire', 'NG1 1AA', true);

INSERT INTO categories (parent_category_id, name, slug) VALUES
  (NULL, 'Electronics', 'electronics'),
  (NULL, 'Fitness', 'fitness');

INSERT INTO products (product_id, category_id, name, slug, description, brand, attributes) VALUES
  ('20000000-0000-0000-0000-000000000001', 1, 'Wireless Headphones', 'wireless-headphones', 'Noise-cancelling over-ear headphones', 'Northstar', '{"wireless": true, "battery_hours": 30}'),
  ('20000000-0000-0000-0000-000000000002', 2, 'Smart Fitness Watch', 'smart-fitness-watch', 'Activity and heart-rate tracker', 'Pace', '{"water_resistant": true, "gps": true}');

INSERT INTO product_variants (variant_id, product_id, sku, variant_name, unit_price) VALUES
  ('30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'NS-HEAD-BLK', 'Black', 89.99),
  ('30000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', 'NS-HEAD-WHT', 'White', 89.99),
  ('30000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000002', 'PACE-WATCH-40', '40 mm', 129.50);

INSERT INTO warehouses (name, city) VALUES ('Midlands Fulfilment Centre', 'Leicester');

INSERT INTO inventory (warehouse_id, variant_id, quantity_on_hand, quantity_reserved, reorder_level) VALUES
  (1, '30000000-0000-0000-0000-000000000001', 50, 2, 10),
  (1, '30000000-0000-0000-0000-000000000002', 25, 0, 8),
  (1, '30000000-0000-0000-0000-000000000003', 15, 1, 5);

INSERT INTO orders (order_id, customer_id, shipping_address_id, status, subtotal, shipping_fee, discount_total, placed_at) VALUES
  ('40000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'paid', 89.99, 4.99, 0, now() - interval '2 days');

INSERT INTO order_items (order_id, variant_id, sku_snapshot, product_name_snapshot, quantity, unit_price) VALUES
  ('40000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'NS-HEAD-BLK', 'Wireless Headphones - Black', 1, 89.99);

INSERT INTO payments (order_id, provider, provider_reference, status, amount) VALUES
  ('40000000-0000-0000-0000-000000000001', 'sandbox-pay', 'pay_demo_001', 'captured', 94.98);

COMMIT;
