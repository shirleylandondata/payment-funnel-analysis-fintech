-- 07 | Funnel Outcome Reconciliation
-- Cross-checks each order's furthest funnel stage against its final payment status,
-- so every one of the 5,000 orders is accounted for.

SELECT
    CASE payment_stage
        WHEN 'checkout_started'       THEN 1
        WHEN 'payment_method_entered' THEN 2
        WHEN 'payment_attempted'      THEN 3
        WHEN 'payment_authorized'     THEN 4
        WHEN 'payment_captured'       THEN 5
    END AS max_status,
    payment_stage || ' / ' || payment_status AS payment_funnel_stage,
    COUNT(*) AS total_orders
FROM orders
GROUP BY 1, 2
ORDER BY max_status, total_orders DESC;
