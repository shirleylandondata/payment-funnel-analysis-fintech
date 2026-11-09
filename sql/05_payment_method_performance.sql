-- 05 | Payment Method Performance
-- Compares methods by rate, not just count, to avoid volume bias.

SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN payment_status = 'Paid'      THEN 1 ELSE 0 END) AS paid_transactions,
    SUM(CASE WHEN payment_status = 'Failed'    THEN 1 ELSE 0 END) AS failed_transactions,
    SUM(CASE WHEN payment_status = 'Abandoned' THEN 1 ELSE 0 END) AS abandoned_transactions,
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Paid'   THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS paid_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS failure_rate_pct
FROM orders
GROUP BY payment_method
ORDER BY paid_rate_pct DESC;
