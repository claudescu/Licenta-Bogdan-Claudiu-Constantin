-- Q244: Web retururi complet: site, stat, produs, demografice și motiv
SELECT ws_site.web_name, ca.ca_state, i.i_category,
       cd.cd_gender, cd.cd_marital_status,
       hd.hd_buy_potential, r.r_reason_desc,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN web_sales ws ON wr.wr_item_sk = ws.ws_item_sk AND wr.wr_order_number = ws.ws_order_number
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON wr.wr_returning_hdemo_sk = hd.hd_demo_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, ca.ca_state, i.i_category,
         cd.cd_gender, cd.cd_marital_status,
         hd.hd_buy_potential, r.r_reason_desc, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;
