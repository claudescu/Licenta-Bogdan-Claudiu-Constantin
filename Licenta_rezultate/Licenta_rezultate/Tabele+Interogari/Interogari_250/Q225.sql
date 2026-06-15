-- Q225: Vânzări catalog cu analiza marjei per categorie și an
SELECT i.i_category, i.i_class, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_wholesale_cost) AS cost_angro,
       ROUND((SUM(cs.cs_net_paid) - SUM(cs.cs_ext_wholesale_cost))
             / NULLIF(SUM(cs.cs_net_paid), 0) * 100, 2) AS marja_pct
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY i.i_category, i.i_class, d.d_year
ORDER BY marja_pct DESC
LIMIT 100;
