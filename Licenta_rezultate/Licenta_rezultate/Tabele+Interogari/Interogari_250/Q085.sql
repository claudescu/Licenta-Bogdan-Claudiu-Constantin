-- Q085: Rolling 6 luni + LAG an trecut + percentilă — 8 join-uri
WITH lunar_complet AS (
    SELECT s.s_store_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           cd.cd_gender, ib.ib_lower_bound,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)   AS vanzari,
           SUM(ss.ss_net_profit) AS profit
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, cd.cd_gender, ib.ib_lower_bound,
             d.d_year, d.d_moy
)
SELECT s_store_name, s_state, i_category, i_brand, cd_gender,
       ib_lower_bound, d_year, d_moy, vanzari, profit,
       AVG(vanzari) OVER (
           PARTITION BY s_store_name, i_category, i_brand
           ORDER BY d_year, d_moy ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
       ) AS medie_6luni,
       SUM(vanzari) OVER (
           PARTITION BY s_store_name, i_category, d_year
           ORDER BY d_moy ROWS UNBOUNDED PRECEDING
       ) AS vanzari_cumulate_an,
       LAG(vanzari, 12) OVER (
           PARTITION BY s_store_name, i_category, i_brand
           ORDER BY d_year, d_moy
       ) AS vanzari_aceeasi_luna_an_trecut,
       PERCENT_RANK() OVER (
           PARTITION BY s_state, i_category, d_year ORDER BY vanzari
       ) AS percentila_in_stat
FROM lunar_complet
ORDER BY s_store_name, i_category, i_brand, d_year, d_moy
LIMIT 300;
