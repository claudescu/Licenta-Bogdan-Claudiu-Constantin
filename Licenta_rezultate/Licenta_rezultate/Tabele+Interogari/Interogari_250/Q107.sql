-- Q107: Corelație promoții + timp + demografice + produs + magazin — 7 join-uri
SELECT p.p_promo_name, p.p_purpose, i.i_category, i.i_brand,
       s.s_state, cd.cd_gender, ib.ib_lower_bound,
       d.d_year, d.d_qoy,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       SUM(ss.ss_coupon_amt)  AS cupoane_total,
       SUM(ss.ss_net_profit)  AS profit_total
FROM store_sales ss
JOIN promotion p               ON ss.ss_promo_sk   = p.p_promo_sk
JOIN item i                    ON ss.ss_item_sk     = i.i_item_sk
JOIN store s                   ON ss.ss_store_sk    = s.s_store_sk
JOIN customer_demographics cd  ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk   = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN date_dim d                ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_category, i.i_brand,
         s.s_state, cd.cd_gender, ib.ib_lower_bound, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;
