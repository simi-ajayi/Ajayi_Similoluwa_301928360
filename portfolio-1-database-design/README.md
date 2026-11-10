# Portfolio 1 - Database Design and Modelling

## Evidence included

- `er-diagram.mmd`: Mermaid ER model that can be rendered in GitHub.
- `schema.sql`: PostgreSQL tables, keys, constraints, types, indexes, and timestamp triggers.
- `seed.sql`: deterministic demonstration data using reserved example domains and fictitious values.
- `normalisation.md`: progression to third normal form and deliberate denormalisation decisions.
- `tests/schema_checks.sql`: executable checks for constraints and derived totals.

## Run

```bash
psql postgresql://portfolio:portfolio@localhost:5432/nexacart -f schema.sql
psql postgresql://portfolio:portfolio@localhost:5432/nexacart -f seed.sql
psql postgresql://portfolio:portfolio@localhost:5432/nexacart -f tests/schema_checks.sql
```

Capture the successful test output and the rendered ER diagram in `../evidence/`.
