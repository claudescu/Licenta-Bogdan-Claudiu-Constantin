-- Q044: Vânzări per nivel de educație al clientului și categorie produs
SELECT cd.cd_education_status, i.i_category,
       COUNT(DISTINCT ss.ss_customer_sk) AS nr_clienti,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_sales_price)            AS pret_mediu
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN item i                   ON ss.ss_item_sk  = i.i_item_sk
GROUP BY cd.cd_education_status, i.i_category
ORDER BY total_vanzari DESC;
