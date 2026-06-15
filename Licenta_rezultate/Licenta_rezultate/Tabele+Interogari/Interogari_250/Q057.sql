-- Q057: Vânzări per magazin, categorie, gen și an
SELECT s.s_store_name, s.s_state, i.i_category,
       cd.cd_gender, d.d_year,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, i.i_category, cd.cd_gender, d.d_year
ORDER BY profit_total DESC
LIMIT 100;
