-- Q228: Catalog retururi per stat client, produs și call center
SELECT ca.ca_state, i.i_category, cc.cc_name,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta,
       AVG(cr.cr_return_quantity) AS cantitate_medie
FROM catalog_returns cr
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON cr.cr_item_sk = i.i_item_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
GROUP BY ca.ca_state, i.i_category, cc.cc_name
ORDER BY pierdere_neta DESC
LIMIT 100;
