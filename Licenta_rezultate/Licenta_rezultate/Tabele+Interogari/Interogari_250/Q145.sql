-- Q145: Clienți cu retururi web frecvente
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_totala
FROM web_returns wr
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
HAVING COUNT(*) > 3
ORDER BY nr_retururi DESC
LIMIT 100;
