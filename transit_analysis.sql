-- =====================================================
-- Winnipeg Transit Redesign Analysis
-- SQL validation & aggregation queries
-- =====================================================

-- Q1: How did overall transit activity change after the redesign?
-- Events per hour (normalised)

SELECT
    Hour,
    RedesignPeriod,
    SUM(NormWeight) AS events_per_hour
FROM events_cleaned
GROUP BY Hour, RedesignPeriod
ORDER BY Hour, RedesignPeriod;


-- Q2: Did evening / off-peak service improve?

SELECT
    IsEvening,
    RedesignPeriod,
    SUM(NormWeight) AS events
FROM events_cleaned
GROUP BY IsEvening, RedesignPeriod
ORDER BY IsEvening, RedesignPeriod;


-- Q3a: Did reliability improve? (Average headway)

SELECT
    RedesignPeriod,
    AVG(HeadwayMin) AS avg_headway_min
FROM headway
GROUP BY RedesignPeriod;


-- Q3b: Long headways (>20 minutes)

SELECT
    RedesignPeriod,
    COUNT(*) AS long_headway_count
FROM headway
WHERE HeadwayMin > 20
GROUP BY RedesignPeriod;


-- Q4: Where did service improve or worsen? (By stop)

SELECT
    stop_id,
    RedesignPeriod,
    SUM(NormWeight) AS events_per_stop
FROM events_cleaned
GROUP BY stop_id, RedesignPeriod
ORDER BY stop_id, events_per_stop DESC;
