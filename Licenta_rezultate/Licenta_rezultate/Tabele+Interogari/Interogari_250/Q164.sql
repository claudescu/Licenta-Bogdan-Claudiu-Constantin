-- Q164: Web vânzări per an și categorie produs
SELECT i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total,
       AVG(ws.ws_quantity) AS cantitate_medie
FROM web_sales ws
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY i.i_category, d.d_year
ORDER BY i.i_category, d.d_year;
