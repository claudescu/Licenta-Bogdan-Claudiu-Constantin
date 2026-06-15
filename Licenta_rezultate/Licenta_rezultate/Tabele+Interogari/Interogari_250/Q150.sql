-- Q150: Catalog vânzări per depozit și categorie
SELECT w.w_warehouse_name, w.w_state, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY w.w_warehouse_name, w.w_state, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
