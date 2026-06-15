-- Q177: Retururi store complet: stat, magazin, motiv, demografice și venit
SELECT ca.ca_state, s.s_store_name, r.r_reason_desc,
       cd.cd_gender, cd.cd_marital_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year,
       COUNT(DISTINCT sr.sr_customer_sk) AS clienti_cu_retururi,
       COUNT(*) AS total_retururi,
       SUM(sr.sr_return_amt) AS valoare_returnata
FROM store_returns sr
JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, s.s_store_name, r.r_reason_desc,
         cd.cd_gender, cd.cd_marital_status,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year
ORDER BY total_retururi DESC
LIMIT 100;
