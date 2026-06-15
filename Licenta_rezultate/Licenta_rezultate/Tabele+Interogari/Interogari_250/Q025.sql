-- Q025: Vânzări per promoție (impact promoții)
SELECT p.p_promo_name, p.p_purpose, p.p_channel_email, p.p_channel_tv,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_coupon_amt)      AS total_cupoane
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
GROUP BY p.p_promo_name, p.p_purpose, p.p_channel_email, p.p_channel_tv
ORDER BY total_vanzari DESC
LIMIT 50;
