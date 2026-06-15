-- Q096: Eficiența promoțiilor per canal și gen client
SELECT p.p_channel_email, p.p_channel_tv, p.p_channel_radio,
       cd.cd_gender, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_coupon_amt)      AS total_cupoane,
       ROUND(SUM(ss.ss_coupon_amt) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS pct_cupon
FROM store_sales ss
JOIN promotion p              ON ss.ss_promo_sk  = p.p_promo_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
JOIN date_dim d               ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s                  ON ss.ss_store_sk  = s.s_store_sk
GROUP BY p.p_channel_email, p.p_channel_tv, p.p_channel_radio,
         cd.cd_gender, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
