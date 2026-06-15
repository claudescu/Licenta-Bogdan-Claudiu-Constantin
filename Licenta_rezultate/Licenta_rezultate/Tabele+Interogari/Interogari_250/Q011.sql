-- Q011: Statistici complete per magazin (toate metricile)
SELECT ss_store_sk,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss_net_paid)      AS total_incasat,
       SUM(ss_net_profit)    AS profit_total,
       AVG(ss_sales_price)   AS pret_mediu,
       MIN(ss_sales_price)   AS pret_minim,
       MAX(ss_sales_price)   AS pret_maxim,
       SUM(ss_ext_discount_amt) AS discount_total
FROM store_sales
GROUP BY ss_store_sk
ORDER BY profit_total DESC;
