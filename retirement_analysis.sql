
-- Retirement Plan Analytics
-- Author: Divyarajsinh Chavda
-- Dataset: retirement_data.csv (12,000 participant records)
-- Plan types: Defined Benefit Pension, 401(k), Annuity


-- ============================
-- 1. EXPLORATORY DATA ANALYSIS


-- 1a. Overview: participants, assets, contribution, readiness
SELECT
    COUNT(participant_id)                          AS total_participants,
    ROUND(SUM(account_balance), 0)                 AS total_assets,
    ROUND(AVG(account_balance), 0)                 AS avg_balance,
    ROUND(AVG(contribution_rate) * 100, 1)         AS avg_contribution_pct,
    ROUND(AVG(plan_funded_ratio) * 100, 1)         AS avg_funded_ratio_pct,
    ROUND(AVG(CASE WHEN readiness = 'On Track' THEN 1.0 ELSE 0 END) * 100, 1) AS pct_on_track
FROM retirement_data;

-- 1b. Median balance by age band (accumulation curve)
SELECT
    CASE
        WHEN age <= 30 THEN '22-30'
        WHEN age <= 40 THEN '31-40'
        WHEN age <= 50 THEN '41-50'
        WHEN age <= 60 THEN '51-60'
        WHEN age <= 70 THEN '61-70'
        ELSE '71-80'
    END                                            AS age_band,
    COUNT(*)                                       AS participants,
    ROUND(AVG(account_balance), 0)                 AS avg_balance,
    ROUND(AVG(contribution_rate) * 100, 1)         AS avg_contribution_pct
FROM retirement_data
GROUP BY age_band
ORDER BY age_band;

-- =========================
-- 2. PLAN TYPE PERFORMANCE


-- 2a. Core metrics by plan type
SELECT
    plan_type,
    COUNT(*)                                       AS participants,
    ROUND(AVG(account_balance), 0)                 AS avg_balance,
    ROUND(AVG(contribution_rate) * 100, 1)         AS avg_contribution_pct,
    ROUND(AVG(plan_funded_ratio) * 100, 1)         AS avg_funded_ratio_pct,
    ROUND(AVG(CASE WHEN readiness = 'On Track' THEN 1.0 ELSE 0 END) * 100, 1) AS pct_on_track,
    ROUND(AVG(replacement_ratio) * 100, 1)         AS avg_replacement_pct
FROM retirement_data
GROUP BY plan_type
ORDER BY pct_on_track DESC;

-- 2b. Readiness tier breakdown by plan type (feeds the stacked bar chart)
SELECT
    plan_type,
    readiness,
    COUNT(*)                                       AS participants,
    ROUND(COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY plan_type), 1) AS pct_within_plan
FROM retirement_data
GROUP BY plan_type, readiness
ORDER BY plan_type, readiness;

-- =======================
-- 3. READINESS DEEP DIVE


-- 3a. What separates On Track from Off Track participants?
SELECT
    readiness,
    COUNT(*)                                       AS participants,
    ROUND(AVG(age), 0)                             AS avg_age,
    ROUND(AVG(tenure_years), 1)                    AS avg_tenure,
    ROUND(AVG(contribution_rate) * 100, 1)         AS avg_contribution_pct,
    ROUND(AVG(annual_salary), 0)                   AS avg_salary,
    ROUND(AVG(account_balance), 0)                 AS avg_balance
FROM retirement_data
GROUP BY readiness
ORDER BY avg_balance DESC;

-- 3b. Contribution-rate buckets vs readiness (is contribution the lever?)
SELECT
    CASE
        WHEN contribution_rate < 0.04 THEN 'Under 4%'
        WHEN contribution_rate < 0.07 THEN '4-7%'
        WHEN contribution_rate < 0.10 THEN '7-10%'
        ELSE '10%+'
    END                                            AS contribution_bucket,
    COUNT(*)                                       AS participants,
    ROUND(AVG(CASE WHEN readiness = 'On Track' THEN 1.0 ELSE 0 END) * 100, 1) AS pct_on_track,
    ROUND(AVG(account_balance), 0)                 AS avg_balance
FROM retirement_data
GROUP BY contribution_bucket
ORDER BY pct_on_track DESC;

-- ============================
-- 4. REGIONAL & INDUSTRY VIEW


-- 4a. Total assets and readiness by region (feeds the regional bar chart)
SELECT
    region,
    COUNT(*)                                       AS participants,
    ROUND(SUM(account_balance), 0)                 AS total_assets,
    ROUND(AVG(plan_funded_ratio) * 100, 1)         AS avg_funded_ratio_pct,
    ROUND(AVG(CASE WHEN readiness = 'On Track' THEN 1.0 ELSE 0 END) * 100, 1) AS pct_on_track
FROM retirement_data
GROUP BY region
ORDER BY total_assets DESC;

-- 4b. Industry contribution behavior
SELECT
    industry,
    COUNT(*)                                       AS participants,
    ROUND(AVG(contribution_rate) * 100, 1)         AS avg_contribution_pct,
    ROUND(AVG(account_balance), 0)                 AS avg_balance
FROM retirement_data
GROUP BY industry
ORDER BY avg_contribution_pct DESC;

-- ====================
-- 5. FUNDED STATUS RISK


-- 5a. Underfunded plan exposure (funded ratio below 80%)
SELECT
    plan_type,
    COUNT(*)                                       AS participants,
    SUM(CASE WHEN plan_funded_ratio < 0.80 THEN 1 ELSE 0 END) AS underfunded_count,
    ROUND(SUM(CASE WHEN plan_funded_ratio < 0.80 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_underfunded,
    ROUND(SUM(CASE WHEN plan_funded_ratio < 0.80 THEN account_balance ELSE 0 END), 0) AS assets_at_risk
FROM retirement_data
GROUP BY plan_type
ORDER BY pct_underfunded DESC;

-- ================================
-- 6. ADVANCED: PROJECTED SHORTFALL (Composite metric)

-- Estimates the gap between projected retirement income and a 70%
-- replacement target, by plan type. Negative = shortfall.

WITH stats AS (
    SELECT
        plan_type,
        AVG(replacement_ratio)        AS avg_repl,
        AVG(account_balance)          AS avg_bal,
        AVG(contribution_rate)        AS avg_contrib,
        COUNT(*)                      AS volume
    FROM retirement_data
    GROUP BY plan_type
)
SELECT
    plan_type,
    volume,
    ROUND(avg_repl * 100, 1)                       AS avg_replacement_pct,
    ROUND((avg_repl - 0.70) * 100, 1)              AS gap_to_target_pct,
    ROUND(avg_bal, 0)                              AS avg_balance,
    ROUND(avg_contrib * 100, 1)                    AS avg_contribution_pct,
    CASE
        WHEN avg_repl >= 0.70 THEN 'Meets target'
        WHEN avg_repl >= 0.55 THEN 'Moderate shortfall'
        ELSE 'Severe shortfall'
    END                                            AS status
FROM stats
ORDER BY gap_to_target_pct DESC;
