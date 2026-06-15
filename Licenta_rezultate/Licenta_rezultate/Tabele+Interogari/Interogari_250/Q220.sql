-- Q220: Store vânzări per gen, educație și magazin
SELECT cd.cd_gender, cd.cd_education_status, s.s_store_name, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_education_status, s.s_store_name, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
