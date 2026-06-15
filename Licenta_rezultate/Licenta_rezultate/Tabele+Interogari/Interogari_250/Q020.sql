-- Q020: Vânzări totale per an și trimestru
SELECT d.d_year, d.d_qoy AS trimestru, d.d_quarter_name,
       COUNT(*)            AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_trimestru,
       SUM(ss.ss_net_profit) AS profit_trimestru
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy, d.d_quarter_name
ORDER BY d.d_year, d.d_qoy;
