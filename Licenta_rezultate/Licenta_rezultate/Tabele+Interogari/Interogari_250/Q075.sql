-- Q075: Sezonalitate completă: magazin + produs + timp + demografice + date + promoție
SELECT s.s_store_name, i.i_category, t.t_shift,
       cd.cd_gender, d.d_year, d.d_moy, d.d_weekend,
       p.p_promo_name,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS cupoane_utilizate
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
LEFT JOIN promotion p       ON ss.ss_promo_sk   = p.p_promo_sk
GROUP BY s.s_store_name, i.i_category, t.t_shift,
         cd.cd_gender, d.d_year, d.d_moy, d.d_weekend, p.p_promo_name
ORDER BY total_vanzari DESC
LIMIT 100;
