-- 06 | Revenue Impact by Payment Status
-- Failed and abandoned order value is unrealized, not a confirmed loss.

SELECT
    COALESCE(payment_status, 'Unknown')                  AS payment_status,
    COUNT(*)                                             AS total_transactions,
    ROUND(SUM(order_total), 2)                           AS gross_order_value,
    ROUND(SUM(COALESCE(transaction_fee, 0)), 2)          AS total_transaction_fees,
    ROUND(SUM(COALESCE(net_revenue, 0)), 2)              AS recorded_net_revenue,
    ROUND(AVG(order_total), 2)                           AS average_order_value,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)   AS transaction_share_pct
FROM orders
GROUP BY COALESCE(payment_status, 'Unknown')
ORDER BY gross_order_value DESC;
