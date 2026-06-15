-- Q231: Catalog vânzări per pagină catalog, depozit și mod livrare
SELECT cp.cp_department, w.w_warehouse_name, sm.sm_carrier,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY cp.cp_department, w.w_warehouse_name, sm.sm_carrier
ORDER BY total_vanzari DESC
LIMIT 100;
