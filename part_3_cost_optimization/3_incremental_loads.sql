-- Standard 3: Incremental Materialization (dbt example)
-- Stop rebuilding years of historical data every night.

{{
    config(
        materialized='incremental',
        unique_key='transaction_id',
        partition_by={
            "field": "transaction_date",
            "data_type": "date"
        }
    )
}}

SELECT
    transaction_id,
    user_id,
    amount,
    transaction_date,
    CURRENT_TIMESTAMP() AS _etl_loaded_at
FROM {{ ref('stg_transactions') }}

-- The Magic: This block only runs on subsequent executions, not the first run.
-- It filters the source data to only grab records newer than our target table.
{% if is_incremental() %}

  WHERE transaction_date >= (SELECT MAX(transaction_date) FROM {{ this }})

{% endif %}