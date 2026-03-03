/* =========================================================
   DATABASE SETUP
   ========================================================= */

-- Create a dedicated database for healthcare claims analysis
CREATE DATABASE healthcare;

-- View the full claims table
SELECT *
FROM claims;

/* =========================================================
   DATA QUALITY CHECKS
   ========================================================= */

-- Check if any claim_id appears more than once
-- This helps verify claim-level uniqueness
SELECT COUNT(claim_id), claim_id
FROM claims
GROUP BY claim_id
HAVING COUNT(claim_id) = 1;

-- Identify duplicate claim_ids using a window function
-- row_number() assigns an order to each claim_id
-- Any row_num > 1 indicates a duplicate
SELECT row_num
FROM (
    SELECT claim_id,
           ROW_NUMBER() OVER (PARTITION BY claim_id ORDER BY claim_id) AS row_num
    FROM claims
) t
WHERE row_num > 1;

/* =========================================================
   CLAIM TYPE COST BREAKDOWN
   ========================================================= */

-- Aggregate costs by claim type
-- Calculates:
-- 1. Total paid amount
-- 2. Total billed amount
-- 3. Paid ratio (% of billed amount reimbursed)
-- 4. Average paid amount per claim
-- 5. Rank of claim types by total paid amount
SELECT claim_type,
       SUM(paid_amount) AS total_paid,
       SUM(billed_amount) AS total_billed,
       SUM(paid_amount) / SUM(billed_amount) * 100 AS paid_ratio,
       ROUND(SUM(paid_amount) / COUNT(*), 2) AS average_paid_per_claim,
       RANK() OVER (ORDER BY SUM(paid_amount) DESC) AS ranks
FROM claims
GROUP BY claim_type;

/* =========================================================
   TOP CPT & ICD COST DRIVERS (TOTAL SPEND)
   ========================================================= */

-- Top 10 CPT codes by total paid amount
-- Identifies procedures that contribute most to overall spending
SELECT cpt_code,
       SUM(paid_amount) AS total_paid
FROM claims
GROUP BY cpt_code
ORDER BY total_paid DESC
LIMIT 10;

-- Top 10 ICD codes by total paid amount
-- Identifies diagnoses that drive the highest total costs
SELECT icd_code,
       SUM(paid_amount) AS total_paid
FROM claims
GROUP BY icd_code
ORDER BY total_paid DESC
LIMIT 10;

/* =========================================================
   CPT & ICD COST INTENSITY ANALYSIS
   ========================================================= */

-- CPT codes with highest average paid amount per claim
-- Applies a threshold of >= 5 claims to avoid rare one-time cases
-- Focuses on procedures that are expensive each time they occur
SELECT cpt_code,
       COUNT(claim_id) AS claim_count,
       ROUND(SUM(paid_amount) / COUNT(claim_id), 2) AS avg_paid_per_claim
FROM claims
GROUP BY cpt_code
HAVING COUNT(claim_id) >= 5
ORDER BY avg_paid_per_claim DESC;

-- ICD codes ranked by average paid amount per claim
-- No threshold applied here since ICDs represent diagnoses
SELECT icd_code,
       COUNT(claim_id) AS claim_count,
       ROUND(SUM(paid_amount) / COUNT(claim_id), 2) AS avg_paid_per_claim
FROM claims
GROUP BY icd_code
ORDER BY avg_paid_per_claim DESC;

/* =========================================================
   MEMBER-LEVEL COST ANALYSIS
   ========================================================= */

-- Identify top 10 highest-cost members by total paid amount
-- Highlights members responsible for the largest share of spending
SELECT member_id,
       SUM(paid_amount) AS total_paid
FROM claims
WHERE paid_amount IS NOT NULL
GROUP BY member_id
ORDER BY total_paid DESC
LIMIT 10;

/* =========================================================
   COST DRIVERS FOR HIGH-COST MEMBERS
   ========================================================= */

-- Common Table Expression (CTE) to isolate top 10 highest-cost members
WITH highest_paid_member AS (
    SELECT member_id,
           SUM(paid_amount) AS total_paid
    FROM claims
    WHERE paid_amount IS NOT NULL
    GROUP BY member_id
    ORDER BY total_paid DESC
    LIMIT 10
)

-- Break down spending for high-cost members by claim type
-- Calculates the percentage contribution of each claim type
-- Helps identify whether inpatient, ER, or outpatient drives cost
SELECT c.member_id,
       c.claim_type,
       SUM(c.paid_amount) AS total_paid_per_type,
       SUM(c.paid_amount) /
       SUM(SUM(c.paid_amount)) OVER (PARTITION BY c.member_id) * 100
       AS pct_per_member_claim
FROM claims c
JOIN highest_paid_member hp
  ON c.member_id = hp.member_id
GROUP BY c.member_id, c.claim_type
ORDER BY c.member_id ASC, total_paid_per_type DESC;

/* =========================================================
   BILLED VS PAID COMPARISON
   ========================================================= */

-- Paid ratio by claim type
-- Shows reimbursement efficiency across service categories
SELECT claim_type,
       SUM(paid_amount) / SUM(billed_amount) * 100 AS paid_ratio
FROM claims
GROUP BY claim_type;

-- Paid ratio by provider (minimum 5 claims threshold)
-- Helps identify provider-level reimbursement efficiency
SELECT provider_id,
       COUNT(claim_id) AS claim_count,
       SUM(paid_amount) / SUM(billed_amount) * 100 AS paid_ratio
FROM claims
GROUP BY provider_id
HAVING COUNT(claim_id) >= 5
ORDER BY paid_ratio DESC;

-- Paid ratio by CPT code (minimum 5 claims threshold)
-- Used in CPT paid ratio scatter plot
SELECT cpt_code,
       SUM(paid_amount) / SUM(billed_amount) * 100 AS paid_ratio
FROM claims
GROUP BY cpt_code
HAVING COUNT(claim_id) >= 5
ORDER BY paid_ratio DESC;

