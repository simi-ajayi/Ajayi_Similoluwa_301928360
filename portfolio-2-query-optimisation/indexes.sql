CREATE INDEX IF NOT EXISTS orders_customer_placed_idx
  ON orders (customer_id, placed_at DESC)
  INCLUDE (status, grand_total);

CREATE INDEX IF NOT EXISTS products_category_active_idx
  ON products (category_id, name) WHERE active;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS products_lower_name_trgm_idx
  ON products USING gin (lower(name) gin_trgm_ops) WHERE active;

CREATE INDEX IF NOT EXISTS inventory_available_idx
  ON inventory ((quantity_on_hand - quantity_reserved));

CREATE INDEX IF NOT EXISTS payments_captured_order_idx
  ON payments (order_id) INCLUDE (amount) WHERE status = 'captured';

CREATE INDEX IF NOT EXISTS orders_placed_at_idx
  ON orders (placed_at);

CREATE INDEX IF NOT EXISTS products_attributes_gin_idx
  ON products USING gin (attributes jsonb_path_ops);

ANALYZE customers;
ANALYZE products;
ANALYZE product_variants;
ANALYZE inventory;
ANALYZE orders;
ANALYZE payments;
