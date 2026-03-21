SELECT 
    p.category,
    -- The "Cash" Profit
    ROUND(SUM(oi.sale_price - p.cost), 2) AS total_profit,
    -- The "Efficiency" (Margin %)
    ROUND((SUM(oi.sale_price - p.cost) / SUM(oi.sale_price)) * 100, 2) AS margin_percentage
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE oi.status = 'Complete'
GROUP BY 1
ORDER BY 3 DESC;
