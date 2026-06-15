-- Q091: Vânzări per schimb orar și program magazin
SELECT s.s_hours, t.t_shift, t.t_sub_shift,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_quantity)        AS cantitate_medie
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_hours, t.t_shift, t.t_sub_shift
ORDER BY total_vanzari DESC;
