-- Q073: Top clienți per stat cu LTV complet (store + metrice demografice)
SELECT ca.ca_state, c.c_customer_id,
       c.c_first_name || ' ' || c.c_last_name AS nume,
       cd.cd_education_status, ib.ib_lower_bound, ib.ib_upper_bound,
       SUM(ss.ss_net_paid) AS ltv_total,
       ROW_NUMBER() OVER (PARTITION BY ca.ca_state ORDER BY SUM(ss.ss_net_paid) DESC) AS rank_in_stat
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
GROUP BY ca.ca_state, c.c_customer_id, c.c_first_name, c.c_last_name,
         cd.cd_education_status, ib.ib_lower_bound, ib.ib_upper_bound
ORDER BY ca.ca_state, rank_in_stat
LIMIT 200;

-- ===========================================================
-- BLOC 7: 6 JOIN-URI (Q074–Q085)
-- ===========================================================
