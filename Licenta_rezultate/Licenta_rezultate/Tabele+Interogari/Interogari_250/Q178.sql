-- Q178: Vânzări catalog per gen client și categorie produs
SELECT cd.cd_gender, cd.cd_education_status, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, cd.cd_education_status, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
