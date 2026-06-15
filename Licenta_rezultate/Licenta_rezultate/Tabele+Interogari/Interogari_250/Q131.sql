-- Q131: Vânzări web per an și trimestru
SELECT d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy;
