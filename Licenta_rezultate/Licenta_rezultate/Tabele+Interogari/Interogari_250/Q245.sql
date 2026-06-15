-- Q245: Store vânzări per client, promoție și magazin
SELECT c.c_customer_id, p.p_promo_name, s.s_store_name, i.i_category,
       COUNT(*) AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY c.c_customer_id, p.p_promo_name, s.s_store_name, i.i_category
HAVING SUM(ss.ss_coupon_amt) > 10
ORDER BY total_cupoane DESC
LIMIT 100;
