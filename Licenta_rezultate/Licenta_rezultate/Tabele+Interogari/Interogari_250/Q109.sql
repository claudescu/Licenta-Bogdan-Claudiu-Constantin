-- Q109: Raport final vânzări + retururi + promoții cu toate metricele — 9 join-uri
WITH baza AS (
    SELECT s.s_store_name, s.s_state, s.s_division_name,
           i.i_category, i.i_brand,
           ca.ca_state, ca.ca_location_type,
           cd.cd_gender, cd.cd_credit_rating,
           hd.hd_buy_potential, ib.ib_lower_bound,
           p.p_purpose,
           t.t_shift,
           d.d_year, d.d_qoy,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           COUNT(DISTINCT ss.ss_customer_sk)   AS clienti_unici,
           SUM(ss.ss_net_paid)                 AS total_vanzari,
           SUM(ss.ss_net_profit)               AS profit_total,
           SUM(ss.ss_coupon_amt)               AS cupoane_total,
           SUM(ss.ss_ext_discount_amt)         AS discount_total
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    LEFT JOIN promotion p       ON ss.ss_promo_sk    = p.p_promo_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_state, s.s_division_name, i.i_category, i.i_brand,
             ca.ca_state, ca.ca_location_type, cd.cd_gender, cd.cd_credit_rating,
             hd.hd_buy_potential, ib.ib_lower_bound, p.p_purpose, t.t_shift,
             d.d_year, d.d_qoy
)
SELECT s_store_name, s_state, s_division_name, i_category, i_brand,
       ca_state, ca_location_type, cd_gender, cd_credit_rating,
       hd_buy_potential, ib_lower_bound, p_purpose, t_shift, d_year, d_qoy,
       nr_comenzi, clienti_unici, total_vanzari, profit_total, cupoane_total, discount_total,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year) AS total_cat_stat_an,
       RANK() OVER (PARTITION BY s_state, d_year ORDER BY profit_total DESC)  AS rank_profit
FROM baza
ORDER BY profit_total DESC
LIMIT 100;
