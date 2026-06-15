-- Q078: Raport executiv per stat, brand, perioadă cu Window functions
WITH baza AS (
    SELECT s.s_state, s.s_market_manager, i.i_brand, i.i_category,
           cd.cd_gender, d.d_year, d.d_qoy,
           SUM(ss.ss_net_paid)                    AS total_vanzari,
           SUM(ss.ss_net_profit)                  AS profit_total,
           COUNT(DISTINCT ss.ss_customer_sk)       AS clienti_unici
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    GROUP BY s.s_state, s.s_market_manager, i.i_brand, i.i_category,
             cd.cd_gender, d.d_year, d.d_qoy
)
SELECT s_state, s_market_manager, i_brand, i_category,
       cd_gender, d_year, d_qoy,
       total_vanzari, profit_total, clienti_unici,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year) AS total_cat_stat_an,
       RANK() OVER (PARTITION BY s_state, d_year ORDER BY profit_total DESC) AS rank_profit
FROM baza
ORDER BY profit_total DESC
LIMIT 100;
