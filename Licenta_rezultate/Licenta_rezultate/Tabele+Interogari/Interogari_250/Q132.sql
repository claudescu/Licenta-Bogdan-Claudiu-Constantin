-- Q132: Top 100 clienți pe vânzări catalog
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(*) AS nr_comenzi,
       SUM(cs.cs_net_paid) AS total_cheltuit
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
ORDER BY total_cheltuit DESC
LIMIT 100;
