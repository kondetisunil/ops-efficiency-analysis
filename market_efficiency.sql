-- PART 1: Identifying "High-Friction" Delivery Zones
-- This helps the team decide where to increase courier incentives or investigate merchant delays.

SELECT 
    city_zone, 
    COUNT(order_id) AS total_orders, 
    AVG(actual_delivery_time - estimated_delivery_time) AS avg_delay_minutes
FROM orders_germany
WHERE order_status = 'delivered'
GROUP BY city_zone
HAVING avg_delay_minutes > 10
ORDER BY avg_delay_minutes DESC;


-- PART 2: Courier Payout vs. Demand Volume
-- This helps align the budget (payouts) with peak demand to ensure efficiency.

SELECT 
    DATE_PART('hour', order_timestamp) AS hour_of_day,
    COUNT(order_id) AS demand_volume,
    AVG(courier_payout_euro) AS avg_payout
FROM orders_germany
GROUP BY hour_of_day
ORDER BY demand_volume DESC;
