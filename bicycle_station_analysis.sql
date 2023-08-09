WITH
  rental_counts AS
    (
      SELECT
        CAST(DATE_TRUNC(start_date, month) AS DATE) AS rental_month,
        start_station_name,
        COUNT(DISTINCT rental_id)                   AS rental_count
      FROM
        `bigquery-public-data.london_bicycles.cycle_hire`
      WHERE CAST (start_date AS DATE) >= '2022-01-01'
      GROUP BY
        1, 2
  )
  ,
  rental_station_rank AS
    (
      SELECT
        rental_month,
        start_station_name,
        rental_count,
        RANK() OVER (PARTITION BY rental_month ORDER BY rental_count DESC) AS station_rank
      FROM
        rental_counts
  )
SELECT
  FORMAT_DATE('%b %Y', rental_month) AS bicycle_rental_date,
  EXTRACT(YEAR FROM rental_month)    AS bicycle_rental_year,
  EXTRACT(MONTH FROM rental_month)   AS bicycle_rental_month,
  start_station_name                 AS bicycle_rental_station,
  rental_count                       AS bicycle_rental_count,
  station_rank                       AS bicycle_rental_staion_rank
FROM
  rental_station_rank
WHERE station_rank <= 5
ORDER BY
  rental_month DESC,
  station_rank ASC
;
