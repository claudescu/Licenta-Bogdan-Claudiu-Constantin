-- Q193: Vânzări store per oră, magazin, categorie și an
SELECT t.t_hour, t.t_shift, s.s_store_name, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY t.t_hour, t.t_shift, s.s_store_name, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 200;
