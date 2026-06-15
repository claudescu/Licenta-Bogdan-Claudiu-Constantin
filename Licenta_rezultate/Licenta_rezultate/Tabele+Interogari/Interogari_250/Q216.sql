-- Q216: Web retururi complet: stat, pagină, produs, demografice și venit
SELECT ca.ca_state, wp.wp_type, i.i_category,
       cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON wr.wr_returning_hdemo_sk = hd.hd_demo_sk
JOIN web_sales ws ON wr.wr_item_sk = ws.ws_item_sk AND wr.wr_order_number = ws.ws_order_number
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, wp.wp_type, i.i_category,
         cd.cd_gender, cd.cd_education_status,
         hd.hd_buy_potential, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;
