# Portfolio 2 - Query Processing and Optimisation

The scripts provide a repeatable before/after workflow. Run `queries.sql` before adding the optional indexes, save the plans, apply `indexes.sql`, run `ANALYZE`, and capture the plans again.

```bash
psql "$DATABASE_URL" -f queries.sql > results/before-indexes.txt
psql "$DATABASE_URL" -f indexes.sql
psql "$DATABASE_URL" -f queries.sql > results/after-indexes.txt
```

Do not claim an index improved performance merely because PostgreSQL used it. Compare execution time, planning time, row estimates, actual rows, loops, buffer hits/reads, dataset size, and selectivity. A sequential scan can be correct for a small table or a query returning a large share of rows.

Use `generate-volume.sql` only in a disposable development database. Record the row count and hardware/environment alongside results.
