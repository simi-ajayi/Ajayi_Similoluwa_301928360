# Normalisation Analysis

## Starting business record

A single checkout record could contain customer details, a delivery address, repeated product lines, current product descriptions, stock quantities, payment information, and shipment tracking. This creates repeating groups and update anomalies.

## First normal form

Repeating order lines are moved into `order_items`. Each field contains one value, and every table has a primary key. Product attributes that vary by category are intentionally stored in a JSON object; the document itself is atomic from the relational model's perspective and is queried through PostgreSQL JSON operators when needed.

## Second normal form

The only composite-key table is `inventory`. Its quantities describe the complete `(warehouse_id, variant_id)` key, not either key alone. Descriptive warehouse and variant fields remain in their own tables.

## Third normal form

- Customer addresses are separated from customers because a customer can maintain several addresses.
- Product variants are separated from products because SKU, variant name, and price depend on the saleable variant.
- Categories are separated and referenced by key.
- Payment and shipment state are separated from order state because each has its own lifecycle and may have several attempts or consignments.
- Warehouse details are separated from stock balances.

Non-key attributes therefore depend on the key, the whole key, and nothing but the key.

## Controlled denormalisation

`order_items` stores SKU, product name, and unit-price snapshots. This deliberate historical snapshot prevents later catalogue changes from rewriting the meaning or value of an existing order. `orders.grand_total` and `order_items.line_total` are generated columns, avoiding inconsistent manually maintained totals.

`products.attributes` is JSONB because attributes differ substantially between electronics, fitness products, and future categories. Stable entities and relationships remain relational; flexible descriptive attributes use a document-shaped value.
