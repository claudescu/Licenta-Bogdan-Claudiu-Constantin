-- Q221: Analiza inventar scăzut per depozit și categorie
SELECT w.w_warehouse_name, w.w_state, i.i_category, i.i_brand, d.d_year,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu,
       MIN(inv.inv_quantity_on_hand) AS stoc_minim
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN item i ON inv.inv_item_sk = i.i_item_sk
JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, w.w_state, i.i_category, i.i_brand, d.d_year
HAVING AVG(inv.inv_quantity_on_hand) < 50
ORDER BY stoc_mediu ASC
LIMIT 100;
