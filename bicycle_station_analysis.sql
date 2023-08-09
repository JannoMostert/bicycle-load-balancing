SELECT
  CAST(DATE_TRUNC(start_date, month) AS DATE) AS rental_month,
  start_station_name,
  COUNT(DISTINCT rental_id)     AS rental_count
FROM
  `bigquery-public-data.london_bicycles.cycle_hire` 
WHERE CAST(start_date AS DATE) >= CAST('2022-01-01' AS DATE)
GROUP BY
  1, 2
ORDER BY rental_month DESC
;
