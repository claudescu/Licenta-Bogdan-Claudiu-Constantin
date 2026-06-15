-- Q039: Vânzare per band de venit și an
SELECT ib.ib_lower_bound, ib.ib_upper_bound, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk       = hd.hd_demo_sk
JOIN income_band ib             ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN date_dim d                 ON ss.ss_sold_date_sk   = d.d_date_sk
GROUP BY ib.ib_lower_bound, ib.ib_upper_bound, d.d_year
ORDER BY ib.ib_lower_bound
LIMIT 100;
