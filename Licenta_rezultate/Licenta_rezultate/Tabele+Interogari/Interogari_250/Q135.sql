-- Q135: Stocuri per depozit și categorie produs
SELECT w.w_warehouse_name, w.w_state, i.i_category,
       SUM(inv.inv_quantity_on_hand) AS stoc_total,
       COUNT(DISTINCT inv.inv_item_sk) AS produse_distincte,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN item i ON inv.inv_item_sk = i.i_item_sk
GROUP BY w.w_warehouse_name, w.w_state, i.i_category
ORDER BY stoc_total DESC
LIMIT 100;
