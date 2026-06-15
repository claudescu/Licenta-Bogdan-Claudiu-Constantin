-- Q137: Catalog retururi per call center
SELECT cc.cc_name, cc.cc_city, cc.cc_state,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
GROUP BY cc.cc_name, cc.cc_city, cc.cc_state
ORDER BY nr_retururi DESC;
