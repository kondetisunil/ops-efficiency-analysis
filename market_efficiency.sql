PART 1: Identifying "Ground Handling" Bottlenecks
This helps the Strategy team identify which global hubs are failing to meet "Ready-for-Carriage" (RfC) timelines.

SQL
-- Identifying hubs where actual ground processing exceeds the SLA.
-- High latency here directly impacts flight departure punctuality.

SELECT 
    airport_code, 
    COUNT(awb_number) AS total_shipments, 
    AVG(actual_handling_time - scheduled_handling_time) AS avg_ground_delay_hours
FROM global_cargo_operations
WHERE shipment_status = 'Received'
GROUP BY airport_code
HAVING avg_ground_delay_hours > 2
ORDER BY avg_ground_delay_hours DESC;

PART 2: Digital Channel Utilization vs. Route Profitability
This aligns with your task of "responsibility for digital sales channels." It checks if your digital platforms are actually filling the planes.
    
-- Analyzing if digital bookings (Web/API) are driving higher load factors 
-- compared to traditional manual booking channels.

SELECT 
    booking_channel, -- e.g., 'Website', 'API', 'Manual'
    COUNT(awb_number) AS booking_count,
    AVG(revenue_per_kg) AS avg_yield,
    AVG(weight_kg) AS avg_shipment_size
FROM lufthansa_digital_sales
GROUP BY booking_channel
ORDER BY avg_yield DESC;
