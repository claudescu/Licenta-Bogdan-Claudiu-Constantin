-- Q136: Vânzări web per pagină web
SELECT wp.wp_type, wp.wp_url,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
GROUP BY wp.wp_type, wp.wp_url
ORDER BY total_vanzari DESC
LIMIT 100;
