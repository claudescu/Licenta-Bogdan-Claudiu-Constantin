-- Q157: Produse cu cele mai mari discounturi în store
SELECT i.i_product_name, i.i_category,
       SUM(ss.ss_ext_discount_amt) AS discount_total,
       SUM(ss.ss_net_paid) AS total_vanzari,
       ROUND(SUM(ss.ss_ext_discount_amt) / NULLIF(SUM(ss.ss_ext_list_price), 0) * 100, 2) AS pct_discount
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE ss.ss_ext_discount_amt > 0
GROUP BY i.i_product_name, i.i_category
ORDER BY discount_total DESC
LIMIT 100;
