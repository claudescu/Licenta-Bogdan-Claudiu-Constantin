-- Q222: Catalog vânzări per stat client, mod livrare și an
SELECT ca.ca_state, sm.sm_carrier, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, sm.sm_carrier, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;
