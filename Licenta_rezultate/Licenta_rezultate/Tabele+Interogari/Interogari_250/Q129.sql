-- Q129: Vânzări catalog per producător
SELECT i.i_manufact, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY i.i_manufact, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
