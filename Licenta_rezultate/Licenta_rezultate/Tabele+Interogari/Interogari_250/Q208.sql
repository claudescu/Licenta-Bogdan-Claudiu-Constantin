-- Q208: Catalog retururi per depozit, mod livrare și motiv
SELECT w.w_warehouse_name, sm.sm_type, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk
JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk
JOIN item i ON cr.cr_item_sk = i.i_item_sk
GROUP BY w.w_warehouse_name, sm.sm_type, r.r_reason_desc
ORDER BY pierdere_neta DESC
LIMIT 100;
