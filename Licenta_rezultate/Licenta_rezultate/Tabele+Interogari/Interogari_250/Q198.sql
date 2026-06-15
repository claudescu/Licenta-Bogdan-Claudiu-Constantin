-- Q198: Vânzări catalog per band de venit și categorie
SELECT hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari
FROM catalog_sales cs
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
