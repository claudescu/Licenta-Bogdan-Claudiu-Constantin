-- Q120: Statistici retururi din catalog per warehouse
SELECT cr_warehouse_sk,
       COUNT(*) AS nr_retururi,
       SUM(cr_return_amount) AS total_returnat,
       SUM(cr_net_loss) AS pierdere_neta,
       AVG(cr_return_quantity) AS cantitate_medie_returnata
FROM catalog_returns
GROUP BY cr_warehouse_sk
ORDER BY total_returnat DESC;
