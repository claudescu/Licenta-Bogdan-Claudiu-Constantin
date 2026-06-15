-- Q200: Stocuri per depozit, categorie produs și lună cu tendință
SELECT w.w_warehouse_name, i.i_category, d.d_year, d.d_moy,
       SUM(inv.inv_quantity_on_hand) AS stoc_total,
       COUNT(DISTINCT inv.inv_item_sk) AS produse_in_stoc,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN item i ON inv.inv_item_sk = i.i_item_sk
JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, i.i_category, d.d_year, d.d_moy
ORDER BY w.w_warehouse_name, i.i_category, d.d_year, d.d_moy
LIMIT 200;
