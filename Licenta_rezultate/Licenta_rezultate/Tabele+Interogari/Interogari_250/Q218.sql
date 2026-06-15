-- Q218: Catalog vânzări per promoție, brand și an
SELECT p.p_promo_name, p.p_purpose, i.i_brand, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_coupon_amt) AS total_cupoane,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_brand, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
