-- Q197: Analiza vânzări vs retururi per magazin și categorie
SELECT s.s_store_name, s.s_state, i.i_category, d.d_year,
       SUM(ss.ss_net_paid) AS vanzari_totale,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_store_name, s.s_state, i.i_category, d.d_year
HAVING SUM(ss.ss_net_profit) < 0
ORDER BY profit_total ASC
LIMIT 100;
