-- Q205: Catalog vânzări per pagină catalog, categorie și an
SELECT cp.cp_department, cp.cp_type, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cp.cp_department, cp.cp_type, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
