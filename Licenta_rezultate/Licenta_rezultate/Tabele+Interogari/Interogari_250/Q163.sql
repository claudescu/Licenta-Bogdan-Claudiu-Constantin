-- Q163: Produse cu preț curent mult sub prețul de listă
SELECT i.i_product_name, i.i_category, i.i_brand,
       i.i_current_price, i.i_wholesale_cost,
       COUNT(ss.ss_item_sk) AS nr_vanzari,
       SUM(ss.ss_net_paid) AS total_vanzari
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE i.i_current_price < i.i_wholesale_cost * 1.1
  AND i.i_wholesale_cost > 0
GROUP BY i.i_product_name, i.i_category, i.i_brand,
         i.i_current_price, i.i_wholesale_cost
ORDER BY nr_vanzari DESC
LIMIT 100;
