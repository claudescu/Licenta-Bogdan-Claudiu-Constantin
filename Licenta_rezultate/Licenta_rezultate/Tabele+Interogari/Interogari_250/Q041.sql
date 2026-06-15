-- Q041: Magazinele cu pierderi nete lunare (profit < 0 per lună)
SELECT s.s_store_name, s.s_state, d.d_year, d.d_moy,
       SUM(ss.ss_net_profit) AS profit_lunar,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year, d.d_moy
HAVING SUM(ss.ss_net_profit) < 0
ORDER BY profit_lunar ASC;
