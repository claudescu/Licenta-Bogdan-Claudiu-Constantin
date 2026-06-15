-- Q233: Store vânzări per stat, brand și promoție cu metrici
SELECT s.s_state, i.i_brand, p.p_purpose, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane,
       ROUND(SUM(ss.ss_coupon_amt) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS pct_cupon
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_state, i.i_brand, p.p_purpose, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
