-- Q212: Web vânzări per promoție, stat client și an
SELECT p.p_purpose, p.p_channel_email, ca.ca_state, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_coupon_amt) AS total_cupoane
FROM web_sales ws
JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY p.p_purpose, p.p_channel_email, ca.ca_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
