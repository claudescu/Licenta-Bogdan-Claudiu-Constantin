-- Q098: Performanța magazinelor per piață de marketing și producător
SELECT s.s_market_id, s.s_market_manager, i.i_manufact, d.d_year,
       COUNT(DISTINCT s.s_store_sk)     AS nr_magazine,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)              AS total_vanzari,
       SUM(ss.ss_net_profit)            AS profit_total
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_market_id, s.s_market_manager, i.i_manufact, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

-- ===========================================================
-- BLOC 13: INTEROGĂRI SUPLIMENTARE — 5 JOIN-URI (Q106–Q110)
-- ===========================================================
