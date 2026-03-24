-- Strategy 3: The MERGE / UPSERT
-- Best for: Mutable data, Slowly Changing Dimensions, CDC streams

MERGE INTO analytics.fact_orders AS target
USING staging.stg_orders AS source
ON target.order_id = source.order_id

-- If the order exists, update its changing attributes
WHEN MATCHED AND target.status != source.status THEN
  UPDATE SET 
    target.status = source.status,
    target.updated_at = CURRENT_TIMESTAMP()

-- If the order is completely new, insert it
WHEN NOT MATCHED THEN
  INSERT (order_id, customer_id, amount, status, created_at)
  VALUES (
    source.order_id, 
    source.customer_id, 
    source.amount, 
    source.status, 
    CURRENT_TIMESTAMP()
  );