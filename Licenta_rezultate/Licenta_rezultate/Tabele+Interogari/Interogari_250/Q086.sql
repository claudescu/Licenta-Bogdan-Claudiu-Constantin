-- Q086: Raport executiv complet cu toate dimensiunile și Window functions — 8 join-uri
WITH baza AS (
    SELECT s.s_division_name, s.s_company_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           cd.cd_gender, cd.cd_marital_status,
           ib.ib_lower_bound, ib.ib_upper_bound,
           d.d_year, d.d_qoy,
           COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
           SUM(ss.ss_net_paid)               AS total_vanzari,
           SUM(ss.ss_net_profit)             AS profit_total,
           AVG(ss.ss_sales_price)            AS pret_mediu
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_division_name, s.s_company_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, cd.cd_gender, cd.cd_marital_status,
             ib.ib_lower_bound, ib.ib_upper_bound, d.d_year, d.d_qoy
)
SELECT s_division_name, s_company_name, s_state, s_market_manager,
       i_category, i_brand, cd_gender, cd_marital_status,
       ib_lower_bound, ib_upper_bound, d_year, d_qoy,
       clienti_unici, total_vanzari, profit_total, pret_mediu,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year)                              AS total_cat_stat_an,
       RANK()         OVER (PARTITION BY s_state, d_year, d_qoy ORDER BY profit_total DESC)            AS rank_profit_trimestru,
       PERCENT_RANK() OVER (PARTITION BY i_category ORDER BY total_vanzari)                            AS percentila_vanzari_cat
FROM baza
ORDER BY profit_total DESC
LIMIT 100;
