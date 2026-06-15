-- Q007: Vânzări profitabile grupate per magazin
SELECT ss_store_sk,
       COUNT(*)            AS nr_vanzari,
       SUM(ss_net_paid)    AS total_incasat,
       AVG(ss_sales_price) AS pret_mediu
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0
GROUP BY ss_store_sk;
