-- 02 | Executive KPI Summary

SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN payment_status = 'Paid' THEN 1 ELSE 0 END) AS paid_transactions,
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Paid' THEN 1 ELSE 0 END) / COUNT(*), 2)      AS paid_transaction_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Abandoned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS abandonment_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) / COUNT(*), 2)    AS failure_rate_pct,
    ROUND(SUM(CASE WHEN payment_status = 'Paid' THEN order_total ELSE 0 END), 2)  AS gross_paid_value,
    ROUND(SUM(CASE WHEN payment_status = 'Paid' THEN net_revenue ELSE 0 END), 2)  AS paid_net_revenue
FROM orders;
