-- Q4: Customer Lifetime Value Estimation

WITH inflow_summary AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        u.date_joined,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) AS total_amount  -- Still in kobo
    FROM 
        users_customuser u
    LEFT JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE 
        s.confirmed_amount > 0
    GROUP BY 
        u.id, u.first_name, u.last_name, u.date_joined
    HAVING 
        tenure_months > 0
),

clv_calc AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        total_amount,
        (total_amount * 0.001) / total_transactions AS avg_profit_per_transaction,  -- 0.1% profit rate
        ROUND((total_transactions / tenure_months) * 12 * ((total_amount * 0.001) / total_transactions), 2) AS estimated_clv
    FROM 
        inflow_summary
)

SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM 
    clv_calc
ORDER BY 
    estimated_clv DESC;
