-- Q024: Vânzări per oră din zi
SELECT t.t_hour, t.t_am_pm, t.t_shift,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
GROUP BY t.t_hour, t.t_am_pm, t.t_shift
ORDER BY t.t_hour;
