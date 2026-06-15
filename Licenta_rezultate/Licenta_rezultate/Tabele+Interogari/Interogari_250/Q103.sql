-- Q103: Sezonalitate per categorie, band venit, stat și zi săptămână
SELECT i.i_category, ib.ib_lower_bound, ib.ib_upper_bound,
       ca.ca_state, d.d_day_name, d.d_weekend,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN customer c             ON ss.ss_customer_sk   = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY i.i_category, ib.ib_lower_bound, ib.ib_upper_bound,
         ca.ca_state, d.d_day_name, d.d_weekend
ORDER BY total_vanzari DESC
LIMIT 100;

-- ===========================================================
-- BLOC 14: INTEROGĂRI SUPLIMENTARE — 6–7 JOIN-URI (Q111–Q115)
-- ===========================================================
