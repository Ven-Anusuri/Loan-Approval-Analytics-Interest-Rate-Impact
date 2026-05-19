SELECT 'loans' AS table_name, COUNT(*) AS row_count FROM loans
UNION ALL
SELECT 'boc_rates' AS table_name, COUNT(*) AS row_count FROM boc_rates;

select * 
from loans
LIMIT 5;

SELECT*
FROM boc_rates LIMIT 5;

SELECT
COUNT (*) AS total_loans,
SUM(LoanApproved) AS total_approved,
COUNT(*)-SUM(LoanApproved) AS total_rejected,
ROUND(AVG(LoanApproved)* 100,2) AS approval_rate_pct
FROM loans;
SELECT 
    CASE
        WHEN CreditScore >= 800 THEN 'Excellent (800-850)'
        WHEN CreditScore >= 740 THEN 'Very Good (740-799)'
        WHEN CreditScore >= 670 THEN 'Good (670-739)'
        WHEN CreditScore >= 580 THEN 'Fair (580-669)'
        ELSE 'Poor (300-579)'
    END AS credit_tier,
    COUNT(*) AS total_loans,
    SUM(LoanApproved) AS approved,
    ROUND(AVG(LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans
GROUP BY credit_tier
ORDER BY approval_rate_pct DESC;
SELECT 
    CASE
        WHEN CreditScore >= 670 THEN 'Good or Better'
        WHEN CreditScore >= 580 THEN 'Fair'
        ELSE 'Poor'
    END AS credit_group,
    EmploymentType,
    COUNT(*) AS total_loans,
    ROUND(AVG(LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans
GROUP BY credit_group, EmploymentType
ORDER BY credit_group, approval_rate_pct DESC;




SELECT 
    strftime('%Y-%m', date) AS rate_month,
    ROUND(AVG(overnight_rate), 2) AS avg_rate
FROM boc_rates
GROUP BY rate_month
ORDER BY rate_month;


SELECT 
    strftime('%Y-%m', l.LoanDate) AS loan_month,
    ROUND(AVG(r.overnight_rate), 2) AS avg_interest_rate,
    COUNT(*) AS total_loans,
    ROUND(AVG(l.LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans l
JOIN boc_rates r 
    ON strftime('%Y-%m', l.LoanDate) = strftime('%Y-%m', r.date)
GROUP BY loan_month
ORDER BY loan_month;

SELECT 
    strftime('%Y-%m', l.LoanDate) AS loan_month,
    monthly_rates.avg_rate AS avg_interest_rate,
    COUNT(*) AS total_loans,
    ROUND(AVG(l.LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans l
JOIN (
    SELECT 
        strftime('%Y-%m', date) AS rate_month,
        ROUND(AVG(overnight_rate), 2) AS avg_rate
    FROM boc_rates
    GROUP BY rate_month
) AS monthly_rates
    ON strftime('%Y-%m', l.LoanDate) = monthly_rates.rate_month
GROUP BY loan_month
ORDER BY loan_month;

SELECT 
    CASE
        WHEN monthly_rates.avg_rate <= 0.5 THEN 'Ultra Low (COVID)'
        WHEN monthly_rates.avg_rate <= 2.0 THEN 'Low'
        WHEN monthly_rates.avg_rate <= 3.5 THEN 'Moderate'
        ELSE 'High (Hike Cycle)'
    END AS rate_environment,
    ROUND(AVG(monthly_rates.avg_rate), 2) AS avg_rate,
    COUNT(*) AS total_loans,
    ROUND(AVG(l.LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans l
JOIN (
    SELECT 
        strftime('%Y-%m', date) AS rate_month,
        ROUND(AVG(overnight_rate), 2) AS avg_rate
    FROM boc_rates
    GROUP BY rate_month
) AS monthly_rates
    ON strftime('%Y-%m', l.LoanDate) = monthly_rates.rate_month
GROUP BY rate_environment
ORDER BY avg_rate;


SELECT 
    CASE
        WHEN CreditScore >= 670 THEN 'Good or Better'
        WHEN CreditScore >= 580 THEN 'Fair'
        ELSE 'Poor'
    END AS credit_group,
    EmploymentType,
    COUNT(*) AS total_loans,
    SUM(LoanApproved) AS approved,
    ROUND(AVG(LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans
GROUP BY credit_group, EmploymentType
ORDER BY credit_group, approval_rate_pct DESC;





SELECT 
    strftime('%Y-%m', l.LoanDate) AS loan_month,
    monthly_rates.avg_rate AS avg_interest_rate,
    COUNT(*) AS total_loans,
    ROUND(AVG(l.LoanApproved) * 100, 2) AS approval_rate_pct
FROM loans l
JOIN (
    SELECT strftime('%Y-%m', date) AS rate_month,
           ROUND(AVG(overnight_rate), 2) AS avg_rate
    FROM boc_rates
    GROUP BY rate_month
) AS monthly_rates
    ON strftime('%Y-%m', l.LoanDate) = monthly_rates.rate_month
GROUP BY loan_month
ORDER BY loan_month;