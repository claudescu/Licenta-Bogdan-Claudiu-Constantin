-- Q241: Analiza discount per magazin, categorie și trimestru
SELECT s.s_store_name, s.s_state, i.i_category, d.d_year, d.d_qoy,
       SUM(ss.ss_ext_discount_amt) AS discount_total,
       SUM(ss.ss_net_paid) AS total_vanzari,
       ROUND(SUM(ss.ss_ext_discount_amt) / NULLIF(SUM(ss.ss_ext_list_price), 0) * 100, 2) AS pct_discount
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE ss.ss_ext_discount_amt > 0
GROUP BY s.s_store_name, s.s_state, i.i_category, d.d_year, d.d_qoy
ORDER BY discount_total DESC
LIMIT 100;
