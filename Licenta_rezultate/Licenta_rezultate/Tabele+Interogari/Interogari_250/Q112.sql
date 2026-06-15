-- Q112: Primele 100 de produse ordonate după preț curent
SELECT i_product_name, i_category, i_brand, i_current_price, i_wholesale_cost
FROM item
ORDER BY i_current_price DESC
LIMIT 100;
