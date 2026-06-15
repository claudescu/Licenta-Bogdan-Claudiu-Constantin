-- Q160: Catalog vânzări cu cupoane mari per brand
SELECT i.i_brand, i.i_category,
       SUM(cs.cs_coupon_amt) AS total_cupoane,
       SUM(cs.cs_net_paid) AS total_vanzari,
       ROUND(SUM(cs.cs_coupon_amt) / NULLIF(SUM(cs.cs_net_paid), 0) * 100, 2) AS pct_cupon,
       COUNT(*) AS nr_tranzactii
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
WHERE cs.cs_coupon_amt > 0
GROUP BY i.i_brand, i.i_category
ORDER BY total_cupoane DESC
LIMIT 100;
