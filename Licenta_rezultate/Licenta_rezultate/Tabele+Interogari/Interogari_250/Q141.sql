-- Q141: Catalog vânzări per an cu evoluție
SELECT d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total,
       AVG(cs.cs_quantity) AS cantitate_medie
FROM catalog_sales cs
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY d.d_year
ORDER BY d.d_year;
