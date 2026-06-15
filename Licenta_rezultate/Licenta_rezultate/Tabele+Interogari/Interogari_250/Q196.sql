-- Q196: Web vânzări per site, mod livrare și categorie
SELECT ws_site.web_name, sm.sm_type, sm.sm_carrier, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, sm.sm_type, sm.sm_carrier, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
