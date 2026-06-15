-- Q055: Corelație vânzări vs potențial de cumpărare pe an și categorie
SELECT hd.hd_buy_potential, i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_quantity)               AS cantitate_medie
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk     = hd.hd_demo_sk
JOIN item i                    ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d                ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY hd.hd_buy_potential, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

-- ===========================================================
-- BLOC 5: 4 JOIN-URI (Q056–Q070)
-- ===========================================================
