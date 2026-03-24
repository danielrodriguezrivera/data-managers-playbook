# 🛡️ Part 1: Pipeline Idempotency & Auditability

This module contains SQL templates demonstrating core strategies for building **idempotent data pipelines** with built-in audit trails. 

In Data Engineering, an idempotent pipeline guarantees that running a job once yields the exact same state in the target database as running it 100 times. This prevents data duplication when orchestrators (like Airflow, Dagster, or Prefect) auto-retry failed tasks.

## 📌 The Standards

### 1. Delete-Write 
* **File:** `1_delete_write.sql`
* **Use Case:** Small dimension tables, reference data, or full-refresh lookup tables.
* **Mechanism:** Truncates the table then loads fresh data.

### 2. Partition Replacement
* **File:** `2_partition_replacement.sql`
* **Use Case:** Large fact tables, time-series data, and modern Lakehouse architectures.
* **Mechanism:** Programmatically deletes only the data within the specific timeframe (partition) of the current pipeline run, then inserts the new data. Wrapped in a transaction.

### 3. The MERGE / UPSERT
* **File:** `3_merge_upsert.sql`
* **Use Case:** Mutable data, Slowly Changing Dimensions (SCDs), or Change Data Capture (CDC) streams.
* **Mechanism:** Matches records on a Primary Key. Updates existing records if their attributes have changed, and inserts completely new records. 

### 🌟 Bonus: The Audit Trail (Metadata Injection)
* **File:** `4_audit_metadata.sql`
* **Use Case:** Debugging, data lineage, and targeted rollbacks.
* **Mechanism:** Appends system metadata (`etl_batch_id` and `etl_processed_at`) to every row. If a specific pipeline run introduces bad data, you can isolate or delete those exact rows instantly without affecting the rest of the table.