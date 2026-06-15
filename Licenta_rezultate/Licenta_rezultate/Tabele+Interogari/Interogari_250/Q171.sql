-- Q171: Catalog vânzări per depozit și lună
SELECT w.w_warehouse_name, d.d_year, d.d_moy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, d.d_year, d.d_moy
ORDER BY w.w_warehouse_name, d.d_year, d.d_moy;
