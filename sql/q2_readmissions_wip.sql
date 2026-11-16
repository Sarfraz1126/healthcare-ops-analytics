SELECT patient, start, stop,
-- using lead for forward stays and lag for backward stays
       LEAD(start) OVER (PARTITION BY patient ORDER BY start) AS next_start,
	   lag(stop) over (partition by patient order by start) as previous_stop,
	   stop::date - start::date AS length_of_stay_days,
	   start::date - (lag(stop) over (partition by patient order by start))::date as days_since_last_discharge
FROM encounters
WHERE encounterclass = 'inpatient'
ORDER BY patient, start;
