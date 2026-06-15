-- Q237: Web vânzări per depozit, mod livrare și an
SELECT w.w_warehouse_name, sm.sm_type, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, sm.sm_type, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
