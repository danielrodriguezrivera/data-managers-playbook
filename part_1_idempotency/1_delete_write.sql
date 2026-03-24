-- Strategy 1: Delete-Write (Truncate & Load)
-- Best for: Small dimension tables or full reference data refreshes

BEGIN;

-- 1. Wipe the target table clean
TRUNCATE TABLE analytics.dim_customers;

-- 2. Insert the fresh data from staging
INSERT INTO analytics.dim_customers (
    customer_id,
    full_name,
    signup_date,
    tier
)
SELECT 
    customer_id,
    full_name,
    signup_date,
    tier
FROM staging.stg_customers;

COMMIT;