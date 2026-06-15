-- Q059: Analiza completă vânzări per schimb, stat, gen și categorie
SELECT t.t_shift, s.s_state, cd.cd_gender, i.i_category,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
JOIN store s                ON ss.ss_store_sk     = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
JOIN item i                 ON ss.ss_item_sk      = i.i_item_sk
GROUP BY t.t_shift, s.s_state, cd.cd_gender, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
