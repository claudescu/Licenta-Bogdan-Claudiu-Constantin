-- Q124: Vânzări catalog grupate per warehouse
SELECT cs_warehouse_sk,
       COUNT(*) AS nr_tranzactii,
       SUM(cs_net_paid) AS total_incasat,
       SUM(cs_net_profit) AS profit_total,
       AVG(cs_quantity) AS cantitate_medie
FROM catalog_sales
GROUP BY cs_warehouse_sk
ORDER BY total_incasat DESC;
