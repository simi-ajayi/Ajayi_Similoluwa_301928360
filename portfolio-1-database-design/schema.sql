BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE order_status AS ENUM (
  'pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded'
);
CREATE TYPE payment_status AS ENUM ('pending', 'authorised', 'captured', 'failed', 'refunded');
CREATE TYPE shipment_status AS ENUM ('pending', 'packed', 'dispatched', 'in_transit', 'delivered', 'returned');

CREATE TABLE customers (
  customer_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  phone text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT customers_email_not_blank CHECK (btrim(email) <> ''),
  CONSTRAINT customers_email_unique UNIQUE (email)
);

CREATE TABLE addresses (
  address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
  label text NOT NULL DEFAULT 'Home',
  line_1 text NOT NULL,
  line_2 text,
  city text NOT NULL,
  county text,
  postcode text NOT NULL,
  country_code char(2) NOT NULL DEFAULT 'GB',
  is_default boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT addresses_country_code_upper CHECK (country_code = upper(country_code))
);

CREATE UNIQUE INDEX addresses_one_default_per_customer
  ON addresses (customer_id) WHERE is_default;

CREATE TABLE categories (
  category_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  parent_category_id bigint REFERENCES categories(category_id) ON DELETE SET NULL,
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  CONSTRAINT categories_name_not_blank CHECK (btrim(name) <> '')
);

CREATE TABLE products (
  product_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id bigint NOT NULL REFERENCES categories(category_id),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text NOT NULL DEFAULT '',
  brand text NOT NULL,
  attributes jsonb NOT NULL DEFAULT '{}'::jsonb,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT products_attributes_object CHECK (jsonb_typeof(attributes) = 'object')
);

CREATE TABLE product_variants (
  variant_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  sku text NOT NULL UNIQUE,
  variant_name text NOT NULL,
  unit_price numeric(12,2) NOT NULL CHECK (unit_price >= 0),
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE warehouses (
  warehouse_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL UNIQUE,
  city text NOT NULL,
  active boolean NOT NULL DEFAULT true
);

CREATE TABLE inventory (
  warehouse_id smallint NOT NULL REFERENCES warehouses(warehouse_id),
  variant_id uuid NOT NULL REFERENCES product_variants(variant_id) ON DELETE CASCADE,
  quantity_on_hand integer NOT NULL DEFAULT 0 CHECK (quantity_on_hand >= 0),
  quantity_reserved integer NOT NULL DEFAULT 0 CHECK (quantity_reserved >= 0),
  reorder_level integer NOT NULL DEFAULT 5 CHECK (reorder_level >= 0),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (warehouse_id, variant_id),
  CONSTRAINT inventory_reservation_within_stock CHECK (quantity_reserved <= quantity_on_hand)
);

CREATE TABLE orders (
  order_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES customers(customer_id),
  shipping_address_id uuid NOT NULL REFERENCES addresses(address_id),
  status order_status NOT NULL DEFAULT 'pending',
  currency char(3) NOT NULL DEFAULT 'GBP',
  subtotal numeric(12,2) NOT NULL CHECK (subtotal >= 0),
  shipping_fee numeric(12,2) NOT NULL DEFAULT 0 CHECK (shipping_fee >= 0),
  discount_total numeric(12,2) NOT NULL DEFAULT 0 CHECK (discount_total >= 0),
  grand_total numeric(12,2) GENERATED ALWAYS AS (subtotal + shipping_fee - discount_total) STORED,
  placed_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT orders_discount_not_excessive CHECK (discount_total <= subtotal + shipping_fee)
);

CREATE TABLE order_items (
  order_item_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id uuid NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  variant_id uuid NOT NULL REFERENCES product_variants(variant_id),
  sku_snapshot text NOT NULL,
  product_name_snapshot text NOT NULL,
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price numeric(12,2) NOT NULL CHECK (unit_price >= 0),
  line_total numeric(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  CONSTRAINT order_items_one_variant_per_order UNIQUE (order_id, variant_id)
);

CREATE TABLE payments (
  payment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(order_id),
  provider text NOT NULL,
  provider_reference text NOT NULL UNIQUE,
  status payment_status NOT NULL DEFAULT 'pending',
  amount numeric(12,2) NOT NULL CHECK (amount > 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE shipments (
  shipment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(order_id),
  warehouse_id smallint NOT NULL REFERENCES warehouses(warehouse_id),
  carrier text,
  tracking_number text UNIQUE,
  status shipment_status NOT NULL DEFAULT 'pending',
  dispatched_at timestamptz,
  delivered_at timestamptz,
  CONSTRAINT shipments_delivery_order CHECK (
    delivered_at IS NULL OR dispatched_at IS NULL OR delivered_at >= dispatched_at
  )
);

CREATE TABLE audit_events (
  event_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  entity_type text NOT NULL,
  entity_id text NOT NULL,
  action text NOT NULL,
  actor text NOT NULL,
  details jsonb NOT NULL DEFAULT '{}'::jsonb,
  occurred_at timestamptz NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER customers_set_updated_at
BEFORE UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER products_set_updated_at
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER inventory_set_updated_at
BEFORE UPDATE ON inventory
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER orders_set_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER payments_set_updated_at
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMIT;
