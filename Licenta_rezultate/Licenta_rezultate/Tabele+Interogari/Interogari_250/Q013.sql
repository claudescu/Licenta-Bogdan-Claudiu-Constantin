-- Q013: Profitul net total și mediu per produs (item)
SELECT ss_item_sk,
       COUNT(*)           AS nr_vanzari,
       SUM(ss_net_profit) AS profit_total,
       AVG(ss_net_profit) AS profit_mediu,
       MIN(ss_net_profit) AS profit_minim,
       MAX(ss_net_profit) AS profit_maxim
FROM store_sales
GROUP BY ss_item_sk
ORDER BY profit_total DESC
LIMIT 50;
