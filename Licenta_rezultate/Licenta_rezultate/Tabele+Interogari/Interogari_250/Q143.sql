-- Q143: Vânzări web per stat client
SELECT ca.ca_state, ca.ca_country,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
GROUP BY ca.ca_state, ca.ca_country
ORDER BY total_vanzari DESC
LIMIT 50;
