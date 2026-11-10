# Distributed and Cloud Design Decisions

## Availability and replication

Checkout requires strong consistency for inventory and order creation, so writes go to one PostgreSQL primary. A synchronous standby in another availability zone reduces recovery point loss for an infrastructure failure. Automatic failover must use a managed service or a consensus-aware controller to avoid two writable primaries.

Read replicas serve reports that tolerate replication lag. A cross-region asynchronous replica limits latency impact on checkout and supports disaster recovery, accepting a non-zero recovery point objective during a total regional loss.

## Consistency

Inventory reservation, order creation, and payment state use ACID transactions on the primary. Reporting reads may be eventually consistent. The catalogue can also be eventually consistent because a short delay in descriptive product updates is less harmful than stale inventory during checkout.

## Partitioning and sharding

PostgreSQL orders can be range-partitioned by `placed_at` after volume and retention needs justify the operational cost. Time-based partitions simplify archival and recent-order scans, but customer-history queries still require suitable indexes.

MongoDB may shard by hashed `productId` for balanced distribution. Category is not selected as the shard key because a few popular categories could form hotspots. Category queries would scatter across shards; a search service or derived category index may serve that workload at large scale.

## Failure handling

- Retry transient connection failures with bounded exponential backoff.
- Make payment callbacks idempotent using unique provider references.
- Use an outbox pattern when database changes must publish events.
- Monitor replication lag, lock waits, connection saturation, storage, backup age, and restore tests.
- Test failover and restore procedures; a backup that has never been restored is not proven.

## Security

Use private networking, TLS in transit, encryption at rest, least-privilege service roles, secret rotation, audit logs, and masked/non-production data in development. Never store raw payment-card details.

## Suggested objectives

- Transactional service availability target: 99.9% initially.
- Point-in-time recovery retention: 14 days.
- Target recovery point objective: under 5 minutes for regional loss.
- Target recovery time objective: under 60 minutes, validated by drills.

These are design targets, not measured claims, until recovery exercises provide evidence.
