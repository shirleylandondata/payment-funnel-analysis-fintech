-- 01 | Data Quality Checks
-- Confirms record counts, uniqueness, date coverage, completeness, and status distribution
-- before any metrics are calculated.

-- 1.1 Record validation: totals, duplicates, date range, gross order value
SELECT
    COUNT(*)                                  AS total_records,
    COUNT(DISTINCT order_id)                  AS unique_orders,
    COUNT(*) - COUNT(DISTINCT order_id)       AS duplicate_order_ids,
    COUNT(DISTINCT customer_id)               AS unique_customers,
    MIN(order_date)                           AS earliest_order_date,
    MAX(order_date)                           AS latest_order_date,
    ROUND(SUM(order_total), 2)                AS total_order_value
FROM orders;

-- 1.2 Missing values in critical fields
SELECT
    COUNT(*)                                          AS total_records,
    COUNT(*) FILTER (WHERE order_id IS NULL)          AS missing_order_ids,
    COUNT(*) FILTER (WHERE customer_id IS NULL)       AS missing_customer_ids,
    COUNT(*) FILTER (WHERE order_date IS NULL)        AS missing_order_dates,
    COUNT(*) FILTER (WHERE payment_method IS NULL)    AS missing_payment_methods,
    COUNT(*) FILTER (WHERE payment_status IS NULL)    AS missing_payment_statuses,
    COUNT(*) FILTER (WHERE order_total IS NULL)       AS missing_order_values
FROM orders;

-- 1.3 Payment status distribution
SELECT
    payment_status,
    COUNT(*)                                              AS total_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)    AS percentage_of_total,
    ROUND(SUM(order_total), 2)                            AS gross_order_value
FROM orders
GROUP BY payment_status
ORDER BY total_transactions DESC;
