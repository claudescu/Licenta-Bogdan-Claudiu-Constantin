-- Q048: Vânzări per oră, zi a săptămânii și magazin
SELECT s.s_store_name, t.t_hour, t.t_am_pm, d.d_day_name,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, t.t_hour, t.t_am_pm, d.d_day_name
ORDER BY s.s_store_name, d.d_day_name, t.t_hour
LIMIT 200;
