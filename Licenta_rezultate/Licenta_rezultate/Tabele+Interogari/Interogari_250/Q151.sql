-- Q151: Clienți care au cumpărat atât din store cât și web
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(DISTINCT ss.ss_ticket_number) AS comenzi_store,
       SUM(ss.ss_net_paid) AS total_store
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE EXISTS (
    SELECT 1 FROM web_sales ws
    WHERE ws.ws_bill_customer_sk = c.c_customer_sk
)
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
ORDER BY total_store DESC
LIMIT 100;
