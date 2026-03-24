-- Bonus Standard: The Audit Trail
-- Appending metadata for observability and targeted surgical rollbacks

INSERT INTO analytics.fact_sales (
    sale_id,
    amount,
    store_id,
    etl_batch_id,        -- The orchestrator's unique run ID (e.g., Airflow run_id)
    etl_processed_at     -- The exact timestamp of insertion
)
SELECT 
    sale_id,
    amount,
    store_id,
    'run_20260323_v1' AS etl_batch_id, 
    CURRENT_TIMESTAMP AS etl_processed_at
FROM staging.stg_sales;

-- Example of a surgical rollback using this metadata:
-- DELETE FROM analytics.fact_sales WHERE etl_batch_id = 'run_20260323_v1';