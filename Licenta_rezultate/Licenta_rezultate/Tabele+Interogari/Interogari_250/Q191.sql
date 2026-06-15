-- Q191: Catalog retururi per stat client, call center și an
SELECT ca.ca_state, cc.cc_name, d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, cc.cc_name, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;
