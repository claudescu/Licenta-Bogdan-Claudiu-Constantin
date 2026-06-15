-- Q162: Catalog vânzări per stat, categorie, depozit, gen și band venit
SELECT ca.ca_state, i.i_category, w.w_warehouse_name,
       cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       COUNT(DISTINCT cs.cs_bill_customer_sk) AS clienti_unici
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, w.w_warehouse_name,
         cd.cd_gender, cd.cd_education_status,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
