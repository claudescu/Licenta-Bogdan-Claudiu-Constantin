-- Q234: Web vânzări per site, stat client și trimestru
SELECT ws_site.web_name, ca.ca_state, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, ca.ca_state, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;
