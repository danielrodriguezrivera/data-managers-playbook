-- Standard 2: Column Pruning
-- In columnar databases, you are billed by the volume of data read.

-- THE BAD WAY (The Tax):
-- Reads all 150 columns of the user table into memory, burning compute credits.
CREATE OR REPLACE VIEW analytics.active_users_bad AS
SELECT *
FROM staging.stg_users
WHERE status = 'active';

-- THE SENIOR WAY (Column Pruning):
-- Explicitly select only the 3 columns needed for downstream analytics.
CREATE OR REPLACE VIEW analytics.active_users_optimized AS
SELECT 
    user_id,
    signup_date,
    lifetime_value
FROM staging.stg_users
WHERE status = 'active';