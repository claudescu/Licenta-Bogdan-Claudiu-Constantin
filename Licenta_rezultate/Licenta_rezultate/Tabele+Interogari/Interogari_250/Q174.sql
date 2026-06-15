-- Q174: Retururi catalog per produs cu pierdere mare
SELECT i.i_product_name, i.i_category,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta,
       AVG(cr.cr_return_quantity) AS cantitate_medie
FROM catalog_returns cr
JOIN item i ON cr.cr_item_sk = i.i_item_sk
GROUP BY i.i_product_name, i.i_category
HAVING SUM(cr.cr_net_loss) > 100
ORDER BY pierdere_neta DESC
LIMIT 100;
