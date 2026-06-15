-- Q168: Vânzări store per clasă produs și producător
SELECT i.i_class, i.i_manufact,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_class, i.i_manufact
ORDER BY total_vanzari DESC
LIMIT 100;
