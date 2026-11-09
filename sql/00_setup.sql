-- 00 | Setup
-- Run from the repository root with DuckDB.
-- In the Hex notebook, the same file is queried directly as "fintech_payment_funnel_orders.csv".
-- Note: the source file is tab-delimited.

CREATE OR REPLACE VIEW orders AS
SELECT *
FROM read_csv('data/fintech_payment_funnel_orders.csv', delim = '\t', header = true);
