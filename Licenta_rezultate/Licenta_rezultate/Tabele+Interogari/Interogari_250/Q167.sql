-- Q167: Catalog vânzări per mod livrare și an
SELECT sm.sm_type, sm.sm_carrier, d.d_year,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare
FROM catalog_sales cs
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY sm.sm_type, sm.sm_carrier, d.d_year
ORDER BY d.d_year, total_vanzari DESC;
