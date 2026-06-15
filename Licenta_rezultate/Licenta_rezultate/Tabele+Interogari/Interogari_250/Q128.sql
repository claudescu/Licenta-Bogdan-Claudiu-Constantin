-- Q128: Vânzări web per categorie produs
SELECT i.i_category, i.i_brand,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY i.i_category, i.i_brand
ORDER BY total_vanzari DESC
LIMIT 100;
