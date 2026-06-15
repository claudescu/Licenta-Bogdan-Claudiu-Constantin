-- Q042: Top 5 produse per magazin cu ranking Window
SELECT s.s_store_name, i.i_product_name, i.i_category,
       SUM(ss.ss_net_paid) AS total_vanzari,
       COUNT(*)            AS nr_tranzactii,
       RANK() OVER (PARTITION BY ss.ss_store_sk ORDER BY SUM(ss.ss_net_paid) DESC) AS rank_produs
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i  ON ss.ss_item_sk  = i.i_item_sk
GROUP BY s.s_store_name, ss.ss_store_sk, i.i_product_name, i.i_category
ORDER BY s.s_store_name, rank_produs
LIMIT 200;
