-- Q127: Inventar mediu per depozit
SELECT inv_warehouse_sk,
       COUNT(DISTINCT inv_item_sk) AS produse_distincte,
       AVG(inv_quantity_on_hand) AS stoc_mediu,
       SUM(inv_quantity_on_hand) AS stoc_total,
       MIN(inv_quantity_on_hand) AS stoc_minim,
       MAX(inv_quantity_on_hand) AS stoc_maxim
FROM inventory
GROUP BY inv_warehouse_sk
ORDER BY stoc_total DESC;
