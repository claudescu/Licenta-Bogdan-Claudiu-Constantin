-- Q060: Distribuție lunară vânzări per manager, categorie și gen
SELECT s.s_manager, i.i_category, cd.cd_gender, d.d_year, d.d_moy,
       SUM(ss.ss_net_paid)   AS total_lunar,
       SUM(ss.ss_net_profit) AS profit_lunar,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_manager, i.i_category, cd.cd_gender, d.d_year, d.d_moy
ORDER BY s.s_manager, d.d_year, d.d_moy
LIMIT 200;
