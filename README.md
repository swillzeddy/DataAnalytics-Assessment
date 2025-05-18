# Data Analytics SQL Assessment

This assessment evaluates SQL proficiency through four business-use-case queries involving customer transactions, product usage, account activity, and customer lifetime value estimation.

---

## Q1. High-Value Customers with Multiple Products

### Approach:
Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` to identify customers with:
- At least one funded savings plan (using `confirmed_amount > 0`)
- At least one investment plan (`is_a_fund = 1`)
Used `COUNT(DISTINCT ...)` to count unique products and `SUM` to total deposits (converted from kobo to naira). Full name was constructed using `CONCAT(first_name, ' ', last_name)`.

### Challenges:
Initially referenced a non-existent `is_regular_savings` column, which was corrected by focusing on confirmed transactions alone.

---

## Q2. Transaction Frequency Analysis

### Approach:
1. Grouped transactions by customer and month (`DATE_FORMAT`).
2. Averaged monthly transactions per customer.
3. Categorized frequency:
   - High (≥10)
   - Medium (3–9)
   - Low (≤2)
4. Aggregated customers into categories with average transactions per group.

### Challenges:
Required multiple CTEs to ensure monthly averaging per customer before classification. Used `FIELD()` in `ORDER BY` for logical sorting of frequency labels.

---

## Q3. Account Inactivity Alert

### Approach:
Identified savings and investment plans using `plans_plan`, joined with `savings_savingsaccount` (for inflows).
- Used `MAX(transaction_date)` per plan to get the last inflow.
- If no transactions or last inflow was >365 days ago, the account was flagged.
- Used `CASE` to label the account type.

### Challenges:
Initially assumed `plans_plan` contained a timestamp like `created_at`, but it didn't. Solution adjusted to infer plan activity via related `savings_savingsaccount` transactions.

---

## Q4. Customer Lifetime Value (CLV)

### Approach:
1. Joined `users_customuser` and `savings_savingsaccount` to get transaction data.
2. Tenure calculated using `TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE())`.
3. Average profit per transaction = 0.1% of value.
4. CLV calculated with:
   \[
   CLV = \left(\frac{\text{total transactions}}{\text{tenure}}\right) \times 12 \times \text{avg profit per transaction}
   \]

### Challenges:
Handled edge case where tenure = 0 to avoid divide-by-zero error. Also ensured accurate currency handling from kobo.

---