-- Q211: Catalog vânzări per gen, categorie, call center și an
SELECT cd.cd_gender, i.i_category, cc.cc_name, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, i.i_category, cc.cc_name, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
