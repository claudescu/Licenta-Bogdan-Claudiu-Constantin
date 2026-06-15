-- Q053: Vânzări per program orar magazin, schimb și categorie
SELECT s.s_hours, t.t_shift, i.i_category,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
GROUP BY s.s_hours, t.t_shift, i.i_category
ORDER BY total_vanzari DESC;
