-- Q229: Web vânzări complet: stat, promoție, categorie, demografice și venit
SELECT ca.ca_state, p.p_promo_name, i.i_category,
       cd.cd_gender, hd.hd_buy_potential,
       ib.ib_lower_bound, ib.ib_upper_bound,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_coupon_amt) AS total_cupoane
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, p.p_promo_name, i.i_category,
         cd.cd_gender, hd.hd_buy_potential,
         ib.ib_lower_bound, ib.ib_upper_bound, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
