-- Q188: Vânzări catalog per gen, educație și categorie produs per an
SELECT cd.cd_gender, cd.cd_education_status, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY cd.cd_gender, cd.cd_education_status, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
