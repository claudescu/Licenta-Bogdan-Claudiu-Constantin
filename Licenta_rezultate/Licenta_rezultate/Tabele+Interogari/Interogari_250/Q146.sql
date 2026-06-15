-- Q146: Evoluție lunară vânzări web
SELECT d.d_year, d.d_moy,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_moy
ORDER BY d.d_year, d.d_moy;
