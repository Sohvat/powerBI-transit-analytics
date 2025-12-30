-- =====================================================
-- Winnipeg Transit Redesign Analysis
-- SQL aggregation & validation queries
-- =====================================================
-- I used SQL to validate the results given by PowerBI reporting tools
-- =====================================================


-- =====================================================
-- Q1. Did overall transit activity change after the redesign?
-- High-level comparison of total activity (normalized)
-- =====================================================

SELECT
    RedesignPeriod,
    SUM(NormWeight) AS total_activity
FROM events_cleaned
GROUP BY RedesignPeriod;


-- =====================================================
-- Q2. Did evening and off-peak usage change after the redesign?
-- Evaluates City claims about improved evening service
-- =====================================================

SELECT
    IsEvening,
    RedesignPeriod,
    SUM(NormWeight) AS activity
FROM events_cleaned
GROUP BY IsEvening, RedesignPeriod
ORDER BY IsEvening, RedesignPeriod;


-- =====================================================
-- Q3. Did the redesign reduce extremely low-activity periods
--     ("dead zones")?
-- Dead zones are proxied using long headways (>20 minutes)
-- =====================================================

SELECT
    RedesignPeriod,
    COUNT(*) AS long_gap_count
FROM headway
WHERE HeadwayMin > 20
GROUP BY RedesignPeriod;


-- =====================================================
-- Q4. Did off-peak usage change more than peak usage?
-- Compares shifts in activity between peak and off-peak periods
-- =====================================================

SELECT
    TimePeriod,
    RedesignPeriod,
    SUM(NormWeight) AS activity
FROM events_cleaned
GROUP BY TimePeriod, RedesignPeriod
ORDER BY TimePeriod, RedesignPeriod;
