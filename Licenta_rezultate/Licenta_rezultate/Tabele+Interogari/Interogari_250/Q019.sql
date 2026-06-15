-- Q019: Vânzări totale per dată calendaristică (zi cu zi)
SELECT d.d_date, d.d_year, d.d_moy, d.d_day_name,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_zi,
       SUM(ss.ss_net_profit)      AS profit_zi
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_date, d.d_year, d.d_moy, d.d_day_name
ORDER BY d.d_date;
