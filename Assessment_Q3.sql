-- Q3: Account Inactivity Alert

WITH last_txn AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Savings'
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM 
        plans_plan p
    LEFT JOIN 
        savings_savingsaccount s ON p.id = s.plan_id AND s.confirmed_amount > 0
    GROUP BY 
        p.id, p.owner_id, p.is_a_fund
)

SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE(), last_transaction_date) AS inactivity_days
FROM 
    last_txn
WHERE 
    last_transaction_date IS NULL OR DATEDIFF(CURRENT_DATE(), last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;