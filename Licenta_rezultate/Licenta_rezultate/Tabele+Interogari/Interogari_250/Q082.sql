-- Q082: Segmentare NTILE clienti cu toate dimensiunile — 7 join-uri
WITH segmente AS (
    SELECT c.c_customer_sk, c.c_customer_id,
           SUM(ss.ss_net_paid) AS ltv,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           COUNT(DISTINCT d.d_year)            AS ani_activi,
           NTILE(5) OVER (ORDER BY SUM(ss.ss_net_paid) DESC) AS quintila
    FROM store_sales ss
    JOIN customer c  ON ss.ss_customer_sk = c.c_customer_sk
    JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY c.c_customer_sk, c.c_customer_id
)
SELECT sg.quintila,
       CASE sg.quintila
           WHEN 1 THEN 'PREMIUM' WHEN 2 THEN 'HIGH VALUE'
           WHEN 3 THEN 'MID VALUE' WHEN 4 THEN 'LOW VALUE'
           ELSE 'BUDGET'
       END AS segment,
       ca.ca_state, cd.cd_gender, cd.cd_education_status,
       cd.cd_credit_rating, hd.hd_buy_potential,
       ib.ib_lower_bound, ib.ib_upper_bound,
       COUNT(DISTINCT sg.c_customer_sk) AS nr_clienti,
       AVG(sg.ltv)         AS ltv_mediu,
       AVG(sg.nr_comenzi)  AS comenzi_medii,
       AVG(sg.ani_activi)  AS ani_activi_medii
FROM segmente sg
JOIN customer c             ON sg.c_customer_sk   = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store_sales ss         ON c.c_customer_sk    = ss.ss_customer_sk
GROUP BY sg.quintila, ca.ca_state, cd.cd_gender, cd.cd_education_status,
         cd.cd_credit_rating, hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound
ORDER BY sg.quintila, nr_clienti DESC
LIMIT 150;
