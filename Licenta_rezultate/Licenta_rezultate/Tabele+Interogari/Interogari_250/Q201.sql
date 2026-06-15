-- Q201: Vânzări store per stat client, promoție și categorie
SELECT ca.ca_state, p.p_purpose, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY ca.ca_state, p.p_purpose, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
