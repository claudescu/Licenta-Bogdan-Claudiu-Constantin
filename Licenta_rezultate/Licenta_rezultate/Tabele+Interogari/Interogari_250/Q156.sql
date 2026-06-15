-- Q156: Catalog vânzări per call center
SELECT cc.cc_name, cc.cc_manager, cc.cc_state,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY cc.cc_name, cc.cc_manager, cc.cc_state
ORDER BY total_vanzari DESC;
