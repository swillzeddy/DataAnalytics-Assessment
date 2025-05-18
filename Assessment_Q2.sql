-- Q2: Transaction Frequency Analysis

WITH monthly_txn AS (
    SELECT 
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS txn_count
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0
    GROUP BY 
        s.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m')
),

avg_txn_per_cust AS (
    SELECT 
        owner_id,
        AVG(txn_count) AS avg_transactions_per_month
    FROM 
        monthly_txn
    GROUP BY 
        owner_id
),

categorized AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM 
        avg_txn_per_cust
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    categorized
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');