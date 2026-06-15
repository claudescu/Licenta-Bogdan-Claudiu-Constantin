-- Q248: Web vânzări complet: gen, stat, pagină, venit, produs și timp
SELECT cd.cd_gender, ca.ca_state, wp.wp_type,
       hd.hd_buy_potential, ib.ib_lower_bound,
       i.i_category, t.t_shift,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, ca.ca_state, wp.wp_type,
         hd.hd_buy_potential, ib.ib_lower_bound,
         i.i_category, t.t_shift, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
