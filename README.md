# MIT 8103 Advanced Database Systems Portfolio

This repository is a practical database portfolio for the **NexaCart Commerce Platform**, a simulated UK e-commerce business. The same case study is used consistently across relational design, query optimisation, transactions, NoSQL modelling, and distributed/cloud database work.

## Case study

NexaCart operates a multi-category online shop. Customers browse products, choose variants, place orders, make payments, and track deliveries. Operations staff manage catalogue data and stock; finance staff review payments and refunds; fulfilment staff process shipments; analysts examine sales and inventory trends.

The database stores customers, addresses, categories, products, variants, inventory, orders, order items, payments, shipments, and audit events. Its key operations are catalogue search, stock updates, checkout, payment recording, order fulfilment, refund processing, and reporting.

## Portfolio map

| Component | Evidence in this repository |
|---|---|
| 1. Database design and modelling | ER diagram, PostgreSQL schema, constraints, seed data, normalisation notes, schema checks |
| 2. Query processing and optimisation | Representative queries, indexes, `EXPLAIN (ANALYZE, BUFFERS)` workflow, results folder |
| 3. Transactions and concurrency | Checkout transaction, rollback example, row-locking concurrency demonstration |
| 4. NoSQL and advanced data models | MongoDB catalogue documents, indexes, validation, and queries |
| 5. Distributed and cloud databases | Architecture diagram and reasoned replication, sharding, consistency, and recovery plan |
| Final documentation | Summary outline, evidence checklist, reflection template, references, AI-use declaration |

## Quick start

Requirements: PostgreSQL 14+ and MongoDB 6+ locally, or Docker with Compose.

```bash
cp .env.example .env
docker compose up -d
psql postgresql://portfolio:portfolio@localhost:5432/nexacart -f portfolio-1-database-design/schema.sql
psql postgresql://portfolio:portfolio@localhost:5432/nexacart -f portfolio-1-database-design/seed.sql
psql postgresql://portfolio:portfolio@localhost:5432/nexacart -f portfolio-1-database-design/tests/schema_checks.sql
```

Load the MongoDB model:

```bash
mongosh mongodb://localhost:27017/nexacart_catalogue portfolio-4-nosql/mongo-init.js
mongosh mongodb://localhost:27017/nexacart_catalogue portfolio-4-nosql/queries.js
```

## Evidence policy

The `evidence/` and `portfolio-2-query-optimisation/results/` directories contain instructions, not fabricated outputs. Capture screenshots, execution plans, timings, logs, and test results only after running the scripts. Record the date, environment, dataset size, and command used for every result.

## Repository practice

- Commit each meaningful step separately.
- Explain changes in commit messages.
- Keep secrets in `.env`, never in Git.
- Verify every script before using its result in the final submission.
- Keep the remote repository private and grant the assessor access before submission.

## Academic integrity

This portfolio is a technical starting point. The student remains responsible for running, validating, explaining, and adapting every artefact. Sources and AI assistance must be declared in the final submission.
