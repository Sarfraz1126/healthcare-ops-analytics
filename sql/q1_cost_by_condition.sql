SELECT c.description,
       COUNT(*) AS visits,
       ROUND(SUM(e.total_claim_cost)::numeric, 0)  AS total_cost,
       ROUND(avg(e.total_claim_cost)::numeric, 0) AS avg_cost_per_visit
FROM (SELECT DISTINCT encounter, description FROM conditions) c
JOIN encounters e ON c.encounter = e.id
where c.description not like '%(finding)%'
and c.description not like '%(situation)%'
GROUP BY c.description
ORDER BY total_cost DESC
LIMIT 10;