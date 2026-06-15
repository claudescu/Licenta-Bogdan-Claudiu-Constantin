-- Q181: Catalog vânzări per call center și trimestru
SELECT cc.cc_name, cc.cc_state, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cc.cc_name, cc.cc_state, d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy, total_vanzari DESC;
