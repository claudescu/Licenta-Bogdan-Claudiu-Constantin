-- Q204: Vânzări store per client cu adresă și magazin
SELECT c.c_customer_id, ca.ca_state, s.s_store_name,
       i.i_category,
       COUNT(*) AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY c.c_customer_id, ca.ca_state, s.s_store_name, i.i_category
HAVING SUM(ss.ss_net_paid) > 500
ORDER BY total_cheltuit DESC
LIMIT 100;
