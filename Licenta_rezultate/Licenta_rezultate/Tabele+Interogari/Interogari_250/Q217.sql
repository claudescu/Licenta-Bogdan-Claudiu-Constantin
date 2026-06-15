-- Q217: Store vânzări per adresă client, magazin și trimestru
SELECT ca.ca_state, ca.ca_city, s.s_store_name, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, ca.ca_city, s.s_store_name, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;
