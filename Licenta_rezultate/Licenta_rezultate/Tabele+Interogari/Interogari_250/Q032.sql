-- Q032: Vânzări per lună și magazin (tendință lunară)
SELECT s.s_store_name, d.d_year, d.d_moy,
       SUM(ss.ss_net_paid)                    AS total_luna,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, d.d_year, d.d_moy
ORDER BY s.s_store_name, d.d_year, d.d_moy;
