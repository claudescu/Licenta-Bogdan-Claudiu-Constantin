-- Q015: Magazine cu total vânzări peste 100.000 și profit pozitiv
SELECT ss_store_sk,
       SUM(ss_net_paid)   AS total_incasat,
       SUM(ss_net_profit) AS profit_total,
       COUNT(*)           AS nr_tranzactii,
       AVG(ss_quantity)   AS cantitate_medie
FROM store_sales
GROUP BY ss_store_sk
HAVING SUM(ss_net_paid) > 100000 AND SUM(ss_net_profit) > 0
ORDER BY total_incasat DESC;



