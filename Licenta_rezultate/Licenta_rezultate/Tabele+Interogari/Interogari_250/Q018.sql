-- Q018: Vânzări cu denumirea produsului și categoria
SELECT i.i_product_name, i.i_category, i.i_brand,
       COUNT(ss.ss_item_sk) AS nr_vanzari,
       SUM(ss.ss_net_paid)  AS total_incasat,
       AVG(ss.ss_sales_price) AS pret_mediu_vanzare
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_product_name, i.i_category, i.i_brand
ORDER BY total_incasat DESC
LIMIT 50;
