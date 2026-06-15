-- Q023: Cei mai cheltuitori clienți (top 100)
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address,
       COUNT(*)            AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit,
       AVG(ss.ss_net_paid) AS valoare_medie_tranzactie
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address
ORDER BY total_cheltuit DESC
LIMIT 100;
