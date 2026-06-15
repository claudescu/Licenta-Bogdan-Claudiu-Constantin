-- Q087: Raport executiv suprem cu Window + LAG + NTILE — 9 join-uri
WITH complet AS (
    SELECT s.s_store_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           ca.ca_state AS cl_state,
           cd.cd_gender, cd.cd_education_status,
           ib.ib_lower_bound, ib.ib_upper_bound,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)   AS vanzari,
           SUM(ss.ss_net_profit) AS profit,
           COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
           COUNT(*) AS nr_tranzactii
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    GROUP BY s.s_store_name, s.s_state, s.s_market_manager, i.i_category, i.i_brand,
             ca.ca_state, cd.cd_gender, cd.cd_education_status,
             ib.ib_lower_bound, ib.ib_upper_bound, d.d_year, d.d_moy
)
SELECT s_store_name, s_state, i_category, i_brand,
       cd_gender, ib_lower_bound, d_year, d_moy,
       vanzari, profit, clienti_unici, nr_tranzactii,
       SUM(vanzari) OVER (PARTITION BY s_store_name, i_category, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS vanzari_cumulate,
       AVG(vanzari) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year, d_moy ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS medie_6luni,
       LAG(vanzari, 12) OVER (PARTITION BY s_store_name, i_category, i_brand ORDER BY d_year, d_moy) AS vanzari_an_trecut,
       NTILE(10) OVER (PARTITION BY s_state, d_year ORDER BY vanzari DESC) AS decila_stat,
       PERCENT_RANK() OVER (PARTITION BY i_category, d_year ORDER BY profit)  AS percentila_profit
FROM complet
ORDER BY s_store_name, i_category, d_year, d_moy
LIMIT 300;
