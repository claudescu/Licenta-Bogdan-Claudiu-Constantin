-- Q152: Vânzări catalog per stat de livrare
SELECT ca.ca_state,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare_total,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer c ON cs.cs_ship_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
GROUP BY ca.ca_state
ORDER BY total_vanzari DESC;
