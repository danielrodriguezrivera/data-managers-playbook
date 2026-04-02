-- Standard 1: Enabling the Source Database for CDC
-- Before Debezium or Kafka can read the logs, you must configure the source DB.
-- Example: Preparing PostgreSQL for Log-Based Change Data Capture

-- 1. In your postgresql.conf file, you must set the wal_level to 'logical'
-- ALTER SYSTEM SET wal_level = logical;

-- 2. Create a dedicated replication user with the correct privileges
CREATE ROLE cdc_replicator WITH REPLICATION LOGIN PASSWORD 'secure_password';

-- 3. Grant the replicator access to the specific schema
GRANT USAGE ON SCHEMA public TO cdc_replicator;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cdc_replicator;

-- 4. Create a Logical Replication Publication
-- This tells Postgres to broadcast all INSERT, UPDATE, and DELETE events 
-- for these specific tables to the Write-Ahead Log (WAL).
CREATE PUBLICATION enterprise_data_stream 
FOR TABLE users, orders, payments;