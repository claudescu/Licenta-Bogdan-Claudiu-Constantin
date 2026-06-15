-- Q209: Vânzări web cu promoție per site și categorie
SELECT ws_site.web_name, p.p_promo_name, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_coupon_amt) AS total_cupoane
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, p.p_promo_name, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
