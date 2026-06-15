-- Q179: Top magazine per profit pe trimestru
SELECT s.s_store_name, s.s_state, d.d_year, d.d_qoy,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;
