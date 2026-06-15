-- Q185: Vânzări web per stat client, categorie și an
SELECT ca.ca_state, i.i_category, d.d_year,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
