-- Q022: Vânzări din zilele de sărbătoare vs normale
SELECT d.d_holiday,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu,
       SUM(ss.ss_net_profit)  AS profit_total
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_holiday;
