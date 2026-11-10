# Case Study: NexaCart Commerce Platform

## Organisation and system

NexaCart is a simulated UK e-commerce platform selling consumer electronics, home products, and fitness equipment. The portfolio focuses on the data platform that supports catalogue management, checkout, payment tracking, inventory control, fulfilment, and operational reporting.

## Database users

- Customers browse products, maintain addresses, place orders, and track delivery.
- Catalogue administrators manage categories, products, variants, prices, and attributes.
- Warehouse staff receive stock and reserve or release inventory.
- Finance staff reconcile payments, refunds, and order totals.
- Fulfilment staff create shipments and update tracking status.
- Analysts run sales, customer, catalogue, and inventory reports.

## Major data

Customer profiles and addresses; hierarchical categories; product and variant catalogue data; warehouse stock; orders and order lines; payment attempts; shipment events; and audit records.

## Key operations

1. Search and filter the product catalogue.
2. Reserve inventory and create an order atomically.
3. Record payment success, failure, and refunds.
4. Update fulfilment and delivery status.
5. Prevent overselling under concurrent checkout.
6. Analyse revenue, product demand, customer activity, and low stock.
7. Scale read-heavy catalogue traffic separately from transactional checkout workloads.

## Scope and assumptions

- Prices are stored in GBP as exact `numeric` values.
- Each product can have several saleable variants.
- Inventory is tracked per variant and warehouse.
- Payment card details are never stored; only provider references are retained.
- A completed order keeps snapshots of product names, SKUs, and prices so later catalogue changes do not alter historical records.
