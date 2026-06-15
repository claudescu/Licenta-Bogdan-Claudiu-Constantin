-- Q102: Analiza marjei de profit per brand, rating și tip promoție
SELECT i.i_brand, cd.cd_credit_rating, p.p_purpose, d.d_year,
       COUNT(*)                                       AS nr_tranzactii,
       SUM(ss.ss_net_paid)                            AS total_vanzari,
       SUM(ss.ss_net_profit)                          AS profit_total,
       ROUND(SUM(ss.ss_net_profit)/NULLIF(SUM(ss.ss_net_paid),0)*100, 2) AS marja_pct
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk    = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
LEFT JOIN promotion p       ON ss.ss_promo_sk   = p.p_promo_sk
JOIN store s                ON ss.ss_store_sk   = s.s_store_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, cd.cd_credit_rating, p.p_purpose, d.d_year
ORDER BY marja_pct DESC
LIMIT 100;
