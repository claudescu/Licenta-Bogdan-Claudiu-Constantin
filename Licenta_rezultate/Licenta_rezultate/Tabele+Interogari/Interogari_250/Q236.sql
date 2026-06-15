-- Q236: Store vânzări per demografice, magazin și lună
SELECT cd.cd_gender, cd.cd_marital_status, s.s_store_name,
       d.d_year, d.d_moy,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, cd.cd_marital_status, s.s_store_name, d.d_year, d.d_moy
ORDER BY total_vanzari DESC
LIMIT 200;
