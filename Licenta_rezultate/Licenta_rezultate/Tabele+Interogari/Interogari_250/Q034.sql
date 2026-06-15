-- Q034: Clienți cu cheltuieli peste media globală
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       c.c_preferred_cust_flag,
       COUNT(*)            AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, c.c_preferred_cust_flag
HAVING SUM(ss.ss_net_paid) > (
    SELECT AVG(sub_total)
    FROM (
        SELECT ss2.ss_customer_sk, SUM(ss2.ss_net_paid) AS sub_total
        FROM store_sales ss2 GROUP BY ss2.ss_customer_sk
    ) t
)
ORDER BY total_cheltuit DESC
LIMIT 100;
