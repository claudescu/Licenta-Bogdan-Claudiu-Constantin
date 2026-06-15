-- Q097: Distribuție vânzări per număr de dependenți și categorie per trimestru
SELECT hd.hd_dep_count, hd.hd_vehicle_count, i.i_category, d.d_year, d.d_qoy,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_sales_price)            AS pret_mediu
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk     = hd.hd_demo_sk
JOIN item i                    ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d                ON ss.ss_sold_date_sk  = d.d_date_sk
JOIN store s                   ON ss.ss_store_sk      = s.s_store_sk
GROUP BY hd.hd_dep_count, hd.hd_vehicle_count, i.i_category, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;
