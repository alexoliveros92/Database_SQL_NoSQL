--use flightsDB
--go

--1. Delay general report by airline

--SQL SERVER (SQL)
SELECT f.flight_ID as [Fligth ID], f.date as [Date], f.Flight_number as [Flight Number], 
f.origin_airport as [Origin Airport], f.Departure_delay as [Departure delay], f.destination_airport as [Destination Airport], f.Arrival_delay as [Arrival delay],
f.delay, ROUND(((f.Departure_delay)+(f.Arrival_delay))/2,0) as [Average delay], al.Airline
FROM airport a
INNER JOIN flights f
ON a.airport_code = f.destination_airport
INNER JOIN airlines al
ON al.airline_code = f.airline_code
WHERE al.Airline_code='AA' 
ORDER BY [Average delay] DESC;

--NEO4J (CQL)
/*
MATCH (a:Airport)<-[:LANDS_AT]-(f:Flight)-[:OPERATED_BY]->(al:Airlines)
WHERE al.id = 'AA'
RETURN f.id as `Fligth ID`, f.date as `Date`, f.flight_number as `Flight Number`,
       f.origin_airport as `Origin Airport`, f.departure_delay as `Departure delay`,
       f.destination_airport as `Destination Airport`, f.arrival_delay as `Arrival delay`,
       f.delay, toInteger((f.departure_delay + f.arrival_delay) / 2) as `Average delay`,
       al.airline as `Airline`
ORDER BY `Average delay` DESC
*/


--2. Number of flights by airport

--SQL SERVER (SQL)
SELECT f.origin_airport as Airport, a.airport, COUNT(f.origin_airport) AS num_flights
FROM flights f
INNER JOIN airport a
ON f.origin_airport = a.airport_code
GROUP BY f.origin_airport, a.airport
ORDER BY num_flights DESC;

--NEO4J (CQL)
/*
MATCH (f:Flight)-[:TAKES_OFF_FROM]->(a:Airport)
RETURN f.origin_airport as Airport, a.airport as airport, count(f.origin_airport) as num_flights
ORDER BY num_flights DESC
*/


--3. What airlines are using the flight number 1495 and where?

--SQL SERVER (SQL)
SELECT DISTINCT flights.date, airlines.airline
FROM flights
JOIN airlines
ON flights.airline_code = airlines.airline_code
WHERE flights.flight_number = '1495';

--NEO4J (CQL)

/*
MATCH (f:Flight)-[:OPERATED_BY]->(a:Airlines)
WHERE f.flight_number = 1495
RETURN DISTINCT f.date as date, a.id as airline
*/


--4.TOP 5 ailines with more delayed flights

--SQL SERVER (SQL)
SELECT TOP 5 COUNT(*) AS num_delays, al.airline_code, al.airline
FROM flights
inner join airlines al
ON flights.airline_code = al.airline_code
WHERE flights.delay_minutes > 0
GROUP BY al.airline_code, al.airline
ORDER BY num_delays DESC;

--NEO4J (CQL)

/*
MATCH (f:Flight)-[:OPERATED_BY]->(a:Airlines)
WHERE f.delay_minutes > 0
WITH COUNT(*) AS num_delays, a.id AS airline_code, a.airline AS airline
ORDER BY num_delays DESC
RETURN airline_code, airline, num_delays
LIMIT 5
*/


--5. Which airline has the highest average delay time for flights departing from New York's JFK airport?

--SQL SERVER (SQL)
SELECT TOP 5 al.airline, AVG(f.departure_delay) AS avg_delay
FROM airlines al
INNER JOIN flights f
ON al.airline_code = f.airline_code
WHERE f.origin_airport = 'JFK' AND f.departure_delay IS NOT NULL
GROUP BY airline
ORDER BY avg_delay DESC

--NEO4J (CQL)

/*
MATCH (a:Airlines)<-[:OPERATED_BY]-(f:Flight {origin_airport: 'JFK'})
WHERE f.departure_delay IS NOT NULL
WITH a.airline AS airline, AVG(f.departure_delay) AS avg_delay
ORDER BY avg_delay DESC
RETURN airline, avg_delay
LIMIT 5
*/

--6. Average distance trip by airline

--SQL SERVER (SQL)
SELECT f.airline_code, a.airline, avg(f.distance) as Average_distance
FROM flights f
INNER JOIN airlines a
ON a.airline_code=f.airline_code
GROUP BY f.airline_code, a.airline
ORDER BY Average_distance DESC

--NEO4J (CQL)

/*
MATCH (a:Airlines)<-[:OPERATED_BY]-(f:Flight)
WITH a.id AS airline_code, a.airline AS airline, AVG(f.distance) AS average_distance
ORDER BY average_distance DESC
RETURN airline_code, airline, average_distance
*/

--7. Cancellation percentage per airline

--SQL SERVER (SQL)
SELECT f.airline_code, a.airline,
       (COUNT(CASE WHEN f.delay_id != 'N' THEN 1 END)) as Delayed,
	   COUNT(*) as Total_flights,
	   ROUND(CAST(COUNT(CASE WHEN f.delay_id != 'N' THEN 1 END) AS FLOAT) / COUNT(*),2) * 100 as [Delay percentage (%)]
FROM flights f
INNER JOIN airlines a
ON a.airline_code=f.airline_code
GROUP BY f.airline_code, a.airline
ORDER BY [Delay percentage (%)] DESC

/*
MATCH (f:Flight)-[:OPERATED_BY]->(a:Airlines)
WITH a.id AS airline_code, a.airline AS airline,
     COUNT(CASE WHEN f.delay_id <> 'N' THEN 1 END) AS delayed,
     COUNT(*) AS total_flights
RETURN airline_code, airline, delayed, total_flights, (toFloat(delayed) / total_flights) * 100 AS `Delay percentage (%)`
ORDER BY (`Delay percentage (%)`) desc
LIMIT 5
*/