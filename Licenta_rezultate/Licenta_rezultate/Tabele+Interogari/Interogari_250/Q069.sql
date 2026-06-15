-- Q069: Raport global vânzări store cu toate dimensiunile de bază
SELECT s.s_state, s.s_market_manager, i.i_category, i.i_brand,
       cd.cd_gender, d.d_year, d.d_qoy,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       SUM(ss.ss_net_profit)             AS profit_total,
       RANK() OVER (PARTITION BY s.s_state, d.d_year ORDER BY SUM(ss.ss_net_profit) DESC) AS rank_profit
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
GROUP BY s.s_state, s.s_market_manager, i.i_category, i.i_brand,
         cd.cd_gender, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;
