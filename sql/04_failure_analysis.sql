-- 04 | Payment Failure Analysis

-- 4.1 Failure classification by root cause
-- AVS (address) mismatches are grouped with customer / payment method issues.
SELECT
    CASE
        WHEN fraud_flag = 1
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%fraud%'
            THEN 'Fraud / Risk Issue'
        WHEN LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%3ds%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%authentication%'
            THEN 'Authentication Issue'
        WHEN LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%expired%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%insufficient funds%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%invalid card%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%cvv%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%avs%'
            THEN 'Customer / Payment Method Issue'
        WHEN LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%processor%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%timeout%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%gateway%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%bank%'
            OR LOWER(TRIM(COALESCE(decline_reason, ''))) LIKE '%declined%'
            THEN 'Bank / Processing Issue'
        ELSE 'Other / Unclassified'
    END AS failure_category,
    COUNT(*) AS failed_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percent_of_failures
FROM orders
WHERE payment_status = 'Failed'
GROUP BY failure_category
ORDER BY failed_transactions DESC;

-- 4.2 Decline reasons
SELECT
    COALESCE(decline_reason, 'Not Specified') AS decline_reason,
    COUNT(*) AS failed_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percent_of_failures
FROM orders
WHERE payment_status = 'Failed'
GROUP BY COALESCE(decline_reason, 'Not Specified')
ORDER BY failed_transactions DESC;

-- 4.3 Decline reasons by payment method
SELECT
    payment_method,
    COALESCE(decline_reason, 'Unspecified') AS decline_reason,
    COUNT(*) AS failed_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY payment_method), 2) AS pct_of_method_failures
FROM orders
WHERE payment_status = 'Failed'
GROUP BY payment_method, COALESCE(decline_reason, 'Unspecified')
ORDER BY payment_method, failed_transactions DESC;
