-- Q067: Analiza completă vânzări store: timp + magazin + produs + demografice + date
SELECT s.s_store_name, t.t_shift, i.i_category, i.i_brand,
       cd.cd_education_status, d.d_year, d.d_qoy,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, t.t_shift, i.i_category, i.i_brand,
         cd.cd_education_status, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;
