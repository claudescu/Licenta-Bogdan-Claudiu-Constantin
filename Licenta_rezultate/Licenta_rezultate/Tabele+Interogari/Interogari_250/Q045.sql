-- Q045: Eficiența magazinelor: vânzări per angajat și per mp
SELECT s.s_store_name, s.s_state,
       s.s_number_employees, s.s_floor_space,
       SUM(ss.ss_net_paid) AS total_vanzari,
       ROUND(SUM(ss.ss_net_paid) / NULLIF(s.s_number_employees, 0), 2) AS vanzari_per_angajat,
       ROUND(SUM(ss.ss_net_paid) / NULLIF(s.s_floor_space, 0), 2)      AS vanzari_per_sqft
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE s.s_number_employees > 0 AND s.s_floor_space > 0
GROUP BY s.s_store_name, s.s_state, s.s_number_employees, s.s_floor_space
ORDER BY vanzari_per_angajat DESC
LIMIT 50;

-- ===========================================================
-- BLOC 4: 3 JOIN-URI (Q046–Q060)
-- ===========================================================
