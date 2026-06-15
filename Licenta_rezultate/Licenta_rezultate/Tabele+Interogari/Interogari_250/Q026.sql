-- Q026: Produse cu marjă de profit sub 20% și vânzări frecvente
SELECT i.i_product_name, i.i_category, i.i_current_price, i.i_wholesale_cost,
       ROUND((i.i_current_price - i.i_wholesale_cost)
             / NULLIF(i.i_current_price, 0) * 100, 2) AS marja_pct,
       COUNT(ss.ss_item_sk) AS nr_vanzari,
       SUM(ss.ss_net_paid)  AS total_vanzari
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE i.i_current_price > 0
GROUP BY i.i_product_name, i.i_category, i.i_current_price, i.i_wholesale_cost
HAVING ROUND((i.i_current_price - i.i_wholesale_cost)
             / NULLIF(i.i_current_price, 0) * 100, 2) < 20
ORDER BY ROUND((i.i_current_price - i.i_wholesale_cost)
               / NULLIF(i.i_current_price, 0) * 100, 2) ASC
LIMIT 100;
