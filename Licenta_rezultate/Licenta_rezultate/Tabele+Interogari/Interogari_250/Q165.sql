-- Q165: Promoții per an cu impact pe vânzări store
SELECT p.p_promo_name, p.p_channel_tv, p.p_channel_email, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_channel_tv, p.p_channel_email, d.d_year
ORDER BY d.d_year, total_vanzari DESC
LIMIT 100;
