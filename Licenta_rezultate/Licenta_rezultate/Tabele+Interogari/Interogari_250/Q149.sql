-- Q149: Vânzări web per mod de livrare
SELECT sm.sm_type, sm.sm_carrier,
       COUNT(*) AS nr_livrari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare_total,
       SUM(ws.ws_net_paid) AS total_vanzari
FROM web_sales ws
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
GROUP BY sm.sm_type, sm.sm_carrier
ORDER BY total_vanzari DESC;
