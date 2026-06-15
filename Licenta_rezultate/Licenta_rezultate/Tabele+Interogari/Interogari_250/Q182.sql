-- Q182: Vânzări store per culoare produs
SELECT i.i_color, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_color, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
