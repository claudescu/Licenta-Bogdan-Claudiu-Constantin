-- Q223: Web vânzări per client cu adresă, site și categorie
SELECT c.c_customer_id, ca.ca_state, ws_site.web_name, i.i_category,
       COUNT(*) AS nr_achizitii,
       SUM(ws.ws_net_paid) AS total_cheltuit,
       SUM(ws.ws_net_profit) AS profit
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY c.c_customer_id, ca.ca_state, ws_site.web_name, i.i_category
HAVING SUM(ws.ws_net_paid) > 200
ORDER BY total_cheltuit DESC
LIMIT 100;
