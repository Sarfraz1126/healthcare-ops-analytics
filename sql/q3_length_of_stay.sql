-- Q3 Part 1: distribution of inpatient length of stay
-- one row per length-of-stay value (0 days, 1 day, 2 days...)

-- Step A: one row per inpatient stay, with its length in days
WITH stays AS (
    SELECT stop::date - start::date AS los_days
    FROM encounters
    WHERE encounterclass = 'inpatient'
)
-- Step B: one row per length of stay, count how many stays have it
SELECT los_days,
       COUNT(*) AS stays
FROM stays
GROUP BY los_days
ORDER BY los_days;

-- Part 2: average length of stay by diagnosis
-- (stays > 30 days excluded as outliers; diagnoses with >= 5 stays only)

-- Step A: one row per inpatient stay, with its id and length
WITH stays AS (
    SELECT id,
           stop::date - start::date AS los_days
    FROM encounters
    WHERE encounterclass = 'inpatient'
      AND stop::date - start::date <= 30
)
-- Step B: staple each diagnosis to its stay, one row per diagnosis
SELECT c.description,
       COUNT(*)                        AS stays,
       ROUND(AVG(s.los_days), 1)       AS avg_los_days
FROM (SELECT DISTINCT encounter, description FROM conditions) c
JOIN stays s ON c.encounter = s.id                  
WHERE c.description NOT LIKE '%(finding)%'
  AND c.description NOT LIKE '%(situation)%'
  AND c.description NOT LIKE 'History of%'
GROUP BY c.description
HAVING COUNT(*) >= 5                              
ORDER BY avg_los_days DESC                                  
LIMIT 10;