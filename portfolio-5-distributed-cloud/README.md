# Portfolio 5 - Distributed and Cloud Database Exercise

## Proposed architecture

The production design uses a managed PostgreSQL primary in one UK region with synchronous multi-availability-zone standby, asynchronous cross-region disaster-recovery replica, read replicas for reporting, and point-in-time recovery. The MongoDB catalogue uses a three-member replica set initially and can be sharded by hashed `productId` when catalogue scale justifies it.

See `architecture.mmd` for the deployment view and `design-decisions.md` for replication, sharding, availability, consistency, and recovery analysis.

## Evidence to produce

1. Render the architecture diagram.
2. Show a local PostgreSQL backup and restore using the commands in `backup-restore.md`.
3. If a cloud sandbox is available, capture service configuration without exposing account IDs, endpoints, or credentials.
4. Explain which parts are implemented and which are a design proposal.

Do not imply that a cloud deployment was performed unless there is verifiable configuration and test evidence.
