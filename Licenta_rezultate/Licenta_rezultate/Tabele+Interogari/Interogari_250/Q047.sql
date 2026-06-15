-- Q047: Vânzare per stat client, categorie produs și an
SELECT ca.ca_state, i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       SUM(ss.ss_net_profit)             AS profit_total
FROM store_sales ss
JOIN customer c          ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i              ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d          ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
