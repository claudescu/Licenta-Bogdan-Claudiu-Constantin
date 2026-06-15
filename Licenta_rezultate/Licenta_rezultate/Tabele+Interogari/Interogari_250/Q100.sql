-- Q100: Clienți preferați vs nepreferați per band venit și categorie
SELECT c.c_preferred_cust_flag,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, d.d_year,
       COUNT(DISTINCT c.c_customer_sk)  AS nr_clienti,
       SUM(ss.ss_net_paid)              AS total_vanzari,
       AVG(ss.ss_net_paid)              AS val_medie_tranzactie,
       SUM(ss.ss_net_profit)            AS profit_total
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
WHERE c.c_preferred_cust_flag IS NOT NULL
GROUP BY c.c_preferred_cust_flag, ib.ib_lower_bound, ib.ib_upper_bound,
         i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
