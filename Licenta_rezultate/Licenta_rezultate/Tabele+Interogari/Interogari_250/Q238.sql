-- Q238: Catalog vânzări per gen, venit și categorie
SELECT cd.cd_gender, hd.hd_buy_potential, ib.ib_lower_bound, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, hd.hd_buy_potential, ib.ib_lower_bound, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
