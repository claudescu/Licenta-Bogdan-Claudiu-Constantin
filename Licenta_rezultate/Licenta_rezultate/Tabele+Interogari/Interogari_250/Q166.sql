-- Q166: Web vânzări per pagină web și categorie produs
SELECT wp.wp_type, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY wp.wp_type, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
