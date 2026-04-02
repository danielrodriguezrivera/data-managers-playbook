-- Standard 2: Native Data Warehouse CDC (Snowflake Streams)
-- If you don't want to manage Kafka, modern warehouses offer native CDC.

-- 1. Create a Stream on your raw staging table
-- This stream acts as a bookmark, recording exactly which rows have been 
-- inserted, updated, or deleted since the last time the stream was consumed.
CREATE OR REPLACE STREAM raw_orders_cdc_stream 
ON TABLE raw.orders;

-- 2. Consume the Stream using an Idempotent MERGE (Linking back to Part 1!)
-- When this runs, it automatically flushes the stream, moving the bookmark forward.
MERGE INTO analytics.fact_orders AS target
USING raw_orders_cdc_stream AS source
ON target.order_id = source.order_id

-- Handle Deletes from the source DB
WHEN MATCHED AND source.METADATA$ACTION = 'DELETE' THEN
  DELETE

-- Handle Updates
WHEN MATCHED AND source.METADATA$ACTION = 'INSERT' AND source.METADATA$ISUPDATE = 'TRUE' THEN
  UPDATE SET 
    target.status = source.status,
    target.updated_at = CURRENT_TIMESTAMP()

-- Handle brand new Inserts
WHEN NOT MATCHED AND source.METADATA$ACTION = 'INSERT' THEN
  INSERT (order_id, amount, status, created_at)
  VALUES (source.order_id, source.amount, source.status, CURRENT_TIMESTAMP());