-- Q049: Impactul promoțiilor per brand și an
SELECT i.i_brand, p.p_promo_name, p.p_purpose, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_coupon_amt)      AS total_cupoane,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN item i      ON ss.ss_item_sk    = i.i_item_sk
JOIN promotion p ON ss.ss_promo_sk   = p.p_promo_sk
JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, p.p_promo_name, p.p_purpose, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
