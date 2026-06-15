-- Q180: Vânzări web weekend vs weekday per categorie
SELECT d.d_weekend, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY d.d_weekend, i.i_category
ORDER BY i.i_category, d.d_weekend;
