# Portfolio 4 - NoSQL and Advanced Data Models

The relational database remains the source of truth for checkout, payments, and inventory. MongoDB is used for the read-heavy catalogue, where products have category-specific attributes and nested media, variants, and reviews.

## Why a document model fits

- A product and its display data are normally read together.
- Attributes vary by product category.
- Embedded variants avoid joins for catalogue pages.
- A JSON Schema validator still enforces essential fields and types.
- Search and attribute indexes support common catalogue access patterns.

Reviews are embedded here only as a bounded summary/sample. At high volume, complete reviews should move to a separate collection partitioned by product ID to avoid unbounded document growth.

## Run

```bash
mongosh mongodb://localhost:27017/nexacart_catalogue mongo-init.js
mongosh mongodb://localhost:27017/nexacart_catalogue queries.js
```

Capture collection validation, index output, query results, and `explain("executionStats")` evidence.
