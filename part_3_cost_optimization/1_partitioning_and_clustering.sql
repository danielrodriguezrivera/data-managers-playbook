-- Standard 1: Partitioning and Clustering
-- Stop scanning terabytes when you only need gigabytes.

-- THE BAD WAY (Full Table Scan):
-- Creating a flat table means any query for a specific date scans the whole table.
CREATE TABLE analytics.fact_pageviews_bad (
    view_id STRING,
    user_id STRING,
    url STRING,
    view_timestamp TIMESTAMP
);

-- THE SENIOR WAY (Partitioned & Clustered):
-- BigQuery Example: Partition by Day, Cluster by frequently filtered IDs.
-- Queries filtering by date will now cost a fraction of the price.
CREATE TABLE analytics.fact_pageviews_optimized (
    view_id STRING,
    user_id STRING,
    url STRING,
    view_timestamp TIMESTAMP
)
PARTITION BY DATE(view_timestamp)
CLUSTER BY user_id;