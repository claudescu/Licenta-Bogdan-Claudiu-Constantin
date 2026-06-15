-- Q219: Analiza cost livrare web per stat, mod livrare și categorie
SELECT ca.ca_state, sm.sm_type, sm.sm_carrier, i.i_category,
       COUNT(*) AS nr_livrari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare_total,
       AVG(ws.ws_ext_ship_cost) AS cost_mediu_livrare,
       SUM(ws.ws_net_paid) AS total_vanzari
FROM web_sales ws
JOIN customer c ON ws.ws_ship_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY ca.ca_state, sm.sm_type, sm.sm_carrier, i.i_category
ORDER BY cost_livrare_total DESC
LIMIT 100;
