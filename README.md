# database
MATCH (f:Flight)-[:OPERATED_BY]->(a:Airlines)
WITH a.id AS airline_code, a.airline AS airline,
     COUNT(CASE WHEN f.delay_id <> 'N' THEN 1 END) AS delayed,
     COUNT(*) AS total_flights
RETURN airline_code, airline, delayed, total_flights, (toFloat(delayed) / total_flights) * 100 AS `Delay percentage (%)`
ORDER BY (`Delay percentage (%)`) desc
LIMIT 5
