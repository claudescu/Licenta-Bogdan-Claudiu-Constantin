-- Q250: Catalog vânzări cu analiză timp de livrare per depozit
SELECT w.w_warehouse_name, w.w_state, sm.sm_type,
       d_sold.d_year AS an_vanzare, d_sold.d_moy AS luna_vanzare,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN date_dim d_sold ON cs.cs_sold_date_sk = d_sold.d_date_sk
JOIN date_dim d_ship ON cs.cs_ship_date_sk = d_ship.d_date_sk
GROUP BY w.w_warehouse_name, w.w_state, sm.sm_type, d_sold.d_year, d_sold.d_moy
ORDER BY total_vanzari DESC
LIMIT 100;
