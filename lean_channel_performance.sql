/*******************************************************************************
  AGILE Strategy and Operations: LEAN PERFORMANCE AUDITS
  Purpose: Real-time identification of supply chain bottlenecks and 
           channel profitability, stripped of unnecessary reporting bloat.
*******************************************************************************/

-- PART 1: OPERATIONAL THROUGHPUT (Ready-for-Shipment SLA)
-- Focus: Identifying which hubs are slowing down the fulfillment flow.

SELECT 
    dc.name AS distribution_hub,
    COUNT(oi.order_id) AS total_shipped,
    ROUND(AVG(TIMESTAMP_DIFF(oi.shipped_at, oi.created_at, HOUR)), 2) AS avg_delay_hours
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
INNER JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
INNER JOIN `bigquery-public-data.thelook_ecommerce.distribution_centers` AS dc ON p.distribution_center_id = dc.id
WHERE oi.status = 'Shipped' 
  AND oi.shipped_at IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC;


-- PART 2: COMMERCIAL CHANNEL YIELD
-- Focus: Identifying the highest-revenue acquisition channels without the return-rate noise.

SELECT 
    u.traffic_source AS channel,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(AVG(oi.sale_price), 2) AS avg_yield,
    ROUND(SUM(oi.sale_price), 2) AS gross_rev
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.users` AS u ON oi.user_id = u.id
WHERE oi.status = 'Complete'
GROUP BY 1 
ORDER BY 4 DESC;
