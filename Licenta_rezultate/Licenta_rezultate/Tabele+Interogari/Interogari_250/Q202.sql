-- Q202: Catalog vânzări per stat livrare, depozit și mod livrare
SELECT ca.ca_state, w.w_warehouse_name, sm.sm_type,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare,
       AVG(cs.cs_ext_ship_cost) AS cost_mediu_livrare
FROM catalog_sales cs
JOIN customer c ON cs.cs_ship_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
GROUP BY ca.ca_state, w.w_warehouse_name, sm.sm_type
ORDER BY total_vanzari DESC
LIMIT 100;
