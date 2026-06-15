-- Q206: Web vânzări per pagină, stat client și an
SELECT wp.wp_type, ca.ca_state, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici
FROM web_sales ws
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY wp.wp_type, ca.ca_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
