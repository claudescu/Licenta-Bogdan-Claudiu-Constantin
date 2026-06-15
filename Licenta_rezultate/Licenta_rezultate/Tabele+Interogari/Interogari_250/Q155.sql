-- Q155: Vânzări per zi a săptămânii — comparare store vs web
SELECT d.d_day_name, d.d_dow,
       COUNT(*) AS nr_tranzactii_store,
       SUM(ss.ss_net_paid) AS total_store
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_day_name, d.d_dow
ORDER BY d.d_dow;
