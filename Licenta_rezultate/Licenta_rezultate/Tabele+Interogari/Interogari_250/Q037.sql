-- Q037: Promoții eficiente: vânzări generate vs cupoane date (per an)
SELECT p.p_promo_name, p.p_purpose, d.d_year,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane,
       ROUND(SUM(ss.ss_coupon_amt) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS pct_cupon,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk    = p.p_promo_sk
JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_purpose, d.d_year
ORDER BY pct_cupon DESC
LIMIT 50;
