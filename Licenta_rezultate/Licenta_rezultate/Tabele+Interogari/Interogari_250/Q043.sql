-- Q043: Vânzări per manager de magazin și trimestru
SELECT s.s_manager, s.s_state, d.d_year, d.d_qoy,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_manager, s.s_state, d.d_year, d.d_qoy
ORDER BY s.s_manager, d.d_year, d.d_qoy;
