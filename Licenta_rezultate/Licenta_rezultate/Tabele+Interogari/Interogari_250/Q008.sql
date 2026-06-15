-- Q008: Magazine cu mai mult de 10 tranzacții profitabile
SELECT ss_store_sk,
       COUNT(*)         AS nr_vanzari,
       SUM(ss_net_paid) AS total_incasat
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0
GROUP BY ss_store_sk
HAVING COUNT(*) > 10;
