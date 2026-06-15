-- Q031: Vânzări per magazin și an — evoluție temporală
SELECT s.s_store_name, s.s_state, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_an,
       SUM(ss.ss_net_profit)      AS profit_an
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year
ORDER BY s.s_store_name, d.d_year;
