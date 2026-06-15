-- Q175: Vânzări store lunare per stat magazin
SELECT s.s_state, d.d_year, d.d_moy,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_store_sk) AS magazine_active
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_state, d.d_year, d.d_moy
ORDER BY s.s_state, d.d_year, d.d_moy;
