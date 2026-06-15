-- Q092: Produse vândute în perioade de promoție vs fără promoție
SELECT i.i_category, i.i_brand,
       CASE WHEN ss.ss_promo_sk IS NOT NULL THEN 'CU PROMOTIE' ELSE 'FARA PROMOTIE' END AS tip_vanzare,
       d.d_year,
       COUNT(*)            AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
GROUP BY i.i_category, i.i_brand,
         CASE WHEN ss.ss_promo_sk IS NOT NULL THEN 'CU PROMOTIE' ELSE 'FARA PROMOTIE' END,
         d.d_year
ORDER BY i.i_category, tip_vanzare, d.d_year
LIMIT 200;
