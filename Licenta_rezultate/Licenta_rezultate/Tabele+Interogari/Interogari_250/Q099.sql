-- Q099: Analiza vânzărilor per culoare produs, tip container, stat și gen
SELECT i.i_color, i.i_container, i.i_units,
       s.s_state, cd.cd_gender, d.d_year,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_color, i.i_container, i.i_units, s.s_state, cd.cd_gender, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
