-- Q088: Raport suprem final: vânzări + retururi + promoții + timp + TOATE dimensiunile — 9 join-uri
WITH baza AS (
    SELECT s.s_store_name, s.s_division_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand, i.i_class,
           ca.ca_state, ca.ca_location_type,
           cd.cd_gender, cd.cd_credit_rating,
           hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
           t.t_shift, d.d_year, d.d_qoy, d.d_weekend,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           COUNT(DISTINCT ss.ss_customer_sk)   AS clienti_unici,
           SUM(ss.ss_net_paid)                 AS total_vanzari,
           SUM(ss.ss_net_profit)               AS profit_total,
           AVG(ss.ss_sales_price)              AS pret_mediu,
           SUM(ss.ss_ext_discount_amt)         AS discount_total,
           SUM(ss.ss_coupon_amt)               AS cupoane_total
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_division_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, i.i_class,
             ca.ca_state, ca.ca_location_type,
             cd.cd_gender, cd.cd_credit_rating,
             hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
             t.t_shift, d.d_year, d.d_qoy, d.d_weekend
)
SELECT s_store_name, s_division_name, s_state, s_market_manager,
       i_category, i_brand, i_class,
       ca_state, ca_location_type,
       cd_gender, cd_credit_rating,
       hd_buy_potential, ib_lower_bound, ib_upper_bound,
       t_shift, d_year, d_qoy, d_weekend,
       nr_comenzi, clienti_unici, total_vanzari, profit_total,
       pret_mediu, discount_total, cupoane_total,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year)               AS total_cat_stat_an,
       RANK()         OVER (PARTITION BY s_state, d_year, d_qoy ORDER BY profit_total DESC) AS rank_profit_trimestru,
       PERCENT_RANK() OVER (PARTITION BY i_category, d_year ORDER BY total_vanzari)        AS percentila_vanzari_cat
FROM baza
ORDER BY profit_total DESC
LIMIT 100;
