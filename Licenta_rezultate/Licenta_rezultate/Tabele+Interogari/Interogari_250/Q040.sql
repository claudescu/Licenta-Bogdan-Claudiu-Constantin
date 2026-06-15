-- Q040: Clienți care revin (activi în cel puțin 2 ani diferiți)
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(DISTINCT d.d_year) AS ani_activi,
       SUM(ss.ss_net_paid)      AS total_cheltuit,
       COUNT(*)                 AS nr_tranzactii_totale
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
HAVING COUNT(DISTINCT d.d_year) >= 2
ORDER BY total_cheltuit DESC
LIMIT 100;
