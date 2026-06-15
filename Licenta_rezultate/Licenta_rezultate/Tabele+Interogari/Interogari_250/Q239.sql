-- Q239: Store vânzări per piață marketing, producător și an
SELECT s.s_market_id, s.s_market_manager, i.i_manufact, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_market_id, s.s_market_manager, i.i_manufact, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
