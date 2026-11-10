# Backup and Restore Exercise

Use a disposable target database and record timestamps, tool versions, database size, and validation results.

```bash
pg_dump --format=custom --file=nexacart.dump "$DATABASE_URL"
createdb nexacart_restore_test
pg_restore --dbname=nexacart_restore_test --clean --if-exists nexacart.dump
psql nexacart_restore_test -c "SELECT count(*) FROM orders;"
```

Do not commit the dump if it contains sensitive data. Capture the command output and checksums as evidence, then securely remove local test artefacts when no longer needed.
