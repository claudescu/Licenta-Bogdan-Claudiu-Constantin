-- Q247: Comparare performanță magazin: profit per angajat per an
SELECT s.s_store_name, s.s_state, s.s_number_employees,
       i.i_category, d.d_year,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       ROUND(SUM(ss.ss_net_profit) / NULLIF(s.s_number_employees, 0), 2) AS profit_per_angajat
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE s.s_number_employees > 0
GROUP BY s.s_store_name, s.s_state, s.s_number_employees, i.i_category, d.d_year
ORDER BY profit_per_angajat DESC
LIMIT 100;
