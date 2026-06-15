-- Q134: Vânzări catalog per mod de livrare
SELECT sm.sm_type, sm.sm_carrier,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare_total,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_ext_ship_cost) AS cost_mediu_livrare
FROM catalog_sales cs
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
GROUP BY sm.sm_type, sm.sm_carrier
ORDER BY total_vanzari DESC;
