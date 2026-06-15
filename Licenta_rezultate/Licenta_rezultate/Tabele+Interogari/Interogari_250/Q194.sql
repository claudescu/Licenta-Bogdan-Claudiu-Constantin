-- Q194: Catalog vânzări per depozit, mod livrare și an
SELECT w.w_warehouse_name, w.w_state, sm.sm_type, sm.sm_carrier, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare_total
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, w.w_state, sm.sm_type, sm.sm_carrier, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
