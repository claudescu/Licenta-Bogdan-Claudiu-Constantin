-- Q071: Vânzări per tip promoție, band venit, stat și an
SELECT p.p_purpose, p.p_channel_email, p.p_channel_tv,
       ib.ib_lower_bound, ib.ib_upper_bound,
       ca.ca_state, d.d_year,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN promotion p               ON ss.ss_promo_sk    = p.p_promo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk    = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN customer c                ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca       ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d                ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_purpose, p.p_channel_email, p.p_channel_tv,
         ib.ib_lower_bound, ib.ib_upper_bound, ca.ca_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
