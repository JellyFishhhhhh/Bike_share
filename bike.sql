CREATE TABLE `Cyclistic.wholetrip` AS 
select ride_id,rideable_type,started_at,ended_at,member_casual
from `Cyclistic.trip202311` 
union all
select ride_id,rideable_type,started_at,ended_at,member_casual
from `Cyclistic.trip202312` 
union all
select ride_id,rideable_type,started_at,ended_at,member_casual
from `Cyclistic.trip202401` 
union all
select ride_id,rideable_type,started_at,ended_at,member_casual
from `Cyclistic.trip202402` 
union all
select ride_id,rideable_type,started_at,ended_at,member_casual
from `Cyclistic.trip202403` 
union all
select ride_id,rideable_type,started_at,ended_at,member_casual
from `Cyclistic.trip202404`;

SELECT *
FROM `Cyclistic.wholetrip`
WHERE ride_id IS NULL
OR rideable_type IS NULL
OR started_at IS NULL
OR ended_at IS NULL
OR member_casual IS NULL;

SELECT ride_id,rideable_type,started_at,ended_at,member_casual, COUNT(*) AS c
FROM `Cyclistic.wholetrip`
GROUP BY ride_id,rideable_type,started_at,ended_at,member_casual
HAVING COUNT(*) > 1;
