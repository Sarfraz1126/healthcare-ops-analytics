-- Part 1: readmission rate
-- Step A: one row per inpatient stay, with days since the previous discharge
WITH stays AS (
    SELECT patient, start,
           start::date - (LAG(stop) OVER (PARTITION BY patient ORDER BY start))::date
               AS days_since_last_discharge
    FROM encounters
    WHERE encounterclass = 'inpatient'
)
-- Step B: stamp each stay 1 (readmission) or 0, then calculate the rate
SELECT COUNT(*) AS total_stays,
       SUM(CASE WHEN days_since_last_discharge <= 30 THEN 1 ELSE 0 END) AS readmissions,
       ROUND(100.0 * SUM(CASE WHEN days_since_last_discharge <= 30 THEN 1 ELSE 0 END) / COUNT(*), 1) AS readmission_rate_pct
FROM stays;

-- Part 2: stay-level detail (gaps between each patient's stays)
SELECT patient, start, stop,
-- using lead for forward stays and lag for backward stays
       LEAD(start) OVER (PARTITION BY patient ORDER BY start) AS next_start,
	   lag(stop) over (partition by patient order by start) as previous_stop,
	   stop::date - start::date AS length_of_stay_days,
	   start::date - (lag(stop) over (partition by patient order by start))::date as days_since_last_discharge
FROM encounters
WHERE encounterclass = 'inpatient'
ORDER BY patient, start;
