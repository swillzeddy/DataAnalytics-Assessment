-- Q1: High-Value Customers with Multiple Products

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.confirmed_amount) / 100 AS total_deposits  -- Convert from kobo to Naira
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON u.id = p.owner_id AND p.is_a_fund = 1  -- Filter investment plans here
WHERE 
    s.confirmed_amount > 0  -- Ensure only funded savings accounts are counted
GROUP BY 
    u.id
HAVING 
    COUNT(DISTINCT s.id) >= 1 AND 
    COUNT(DISTINCT p.id) >= 1
ORDER BY 
    total_deposits DESC;