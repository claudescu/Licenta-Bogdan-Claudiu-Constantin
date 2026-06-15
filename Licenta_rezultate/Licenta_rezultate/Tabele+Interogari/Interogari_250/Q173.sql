-- Q173: Vânzări web per oră din zi
SELECT t.t_hour, t.t_shift, t.t_am_pm,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk
GROUP BY t.t_hour, t.t_shift, t.t_am_pm
ORDER BY t.t_hour;
