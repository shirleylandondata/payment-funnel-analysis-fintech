-- 03 | Payment Funnel Conversion and Drop-Off
-- Each order is mapped to the furthest stage it reached. An order counts toward every
-- stage up to and including that one. LAG() calculates stage-to-stage drop-off.

WITH orders_with_stage AS (
    SELECT
        order_id,
        CASE payment_stage
            WHEN 'checkout_started'       THEN 1
            WHEN 'payment_method_entered' THEN 2
            WHEN 'payment_attempted'      THEN 3
            WHEN 'payment_authorized'     THEN 4
            WHEN 'payment_captured'       THEN 5
        END AS max_stage
    FROM orders
),
stage_definitions AS (
    SELECT 1 AS status_id, 'Checkout Started' AS status_description
    UNION ALL SELECT 2, 'Payment Method Entered'
    UNION ALL SELECT 3, 'Payment Attempted'
    UNION ALL SELECT 4, 'Payment Authorized'
    UNION ALL SELECT 5, 'Payment Captured'
),
funnel AS (
    SELECT
        s.status_id,
        s.status_description,
        COUNT(DISTINCT o.order_id) AS orders_reached
    FROM stage_definitions s
    LEFT JOIN orders_with_stage o
        ON o.max_stage >= s.status_id
    GROUP BY s.status_id, s.status_description
),
dropoff AS (
    SELECT
        status_id,
        status_description,
        orders_reached,
        LAG(orders_reached) OVER (ORDER BY status_id) AS previous_stage_orders
    FROM funnel
)
SELECT
    status_id,
    status_description,
    orders_reached,
    ROUND(100.0 * orders_reached / FIRST_VALUE(orders_reached) OVER (ORDER BY status_id), 2) AS conversion_from_start_pct,
    previous_stage_orders,
    previous_stage_orders - orders_reached AS drop_off_count,
    ROUND(100.0 * (previous_stage_orders - orders_reached)
          / NULLIF(previous_stage_orders, 0), 2) AS drop_off_pct
FROM dropoff
ORDER BY status_id;
