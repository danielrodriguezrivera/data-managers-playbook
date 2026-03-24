-- Strategy 2: Partition Replacement
-- Best for: Large fact tables, time-series data, and Lakehouses

BEGIN;

-- 1. Isolate the blast radius: Delete ONLY the data for this run's timeframe
DELETE FROM analytics.fact_sales 
WHERE sale_date = '2026-03-23';

-- 2. Insert the fresh data for that specific partition
-- If the job retries 5 times, it simply deletes and inserts 5 times. Zero duplicates.
INSERT INTO analytics.fact_sales (
    sale_id,
    sale_date,
    amount,
    store_id
)
SELECT 
    sale_id,
    sale_date,
    amount,
    store_id
FROM staging.stg_sales
WHERE sale_date = '2026-03-23';

COMMIT;