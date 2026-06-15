-- Q235: Catalog retururi complet: stat, produs, motiv, demografice și call center
SELECT ca.ca_state, i.i_category, r.r_reason_desc,
       cc.cc_name, cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON cr.cr_returning_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cr.cr_returning_hdemo_sk = hd.hd_demo_sk
JOIN item i ON cr.cr_item_sk = i.i_item_sk
JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, r.r_reason_desc,
         cc.cc_name, cd.cd_gender, cd.cd_education_status,
         hd.hd_buy_potential, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;
