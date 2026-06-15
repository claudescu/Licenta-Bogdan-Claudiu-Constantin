-- Q058: Promoții cu ROI pozitiv — vânzări > cost promoție per brand și an
SELECT p.p_promo_name, p.p_purpose, i.i_brand, d.d_year,
       p.p_cost                             AS cost_promotie,
       SUM(ss.ss_net_paid)                  AS vanzari_generate,
       SUM(ss.ss_net_paid) - p.p_cost       AS roi_net,
       COUNT(DISTINCT ss.ss_customer_sk)    AS clienti_unici
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk    = p.p_promo_sk
JOIN item i      ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s     ON ss.ss_store_sk    = s.s_store_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_brand, d.d_year, p.p_cost
HAVING SUM(ss.ss_net_paid) > p.p_cost
ORDER BY roi_net DESC
LIMIT 50;
