-- Q076: Comparare clienți fideli vs ocazionali per stat și band venit
WITH client_tip AS (
    SELECT ss.ss_customer_sk,
           COUNT(DISTINCT d.d_year) AS ani_activi,
           SUM(ss.ss_net_paid)      AS total_cheltuit
    FROM store_sales ss
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY ss.ss_customer_sk
)
SELECT ca.ca_state, ib.ib_lower_bound, ib.ib_upper_bound,
       cd.cd_credit_rating, cd.cd_education_status,
       SUM(CASE WHEN ct.ani_activi >= 2 THEN ct.total_cheltuit ELSE 0 END) AS vanzari_clienti_fideli,
       SUM(CASE WHEN ct.ani_activi  < 2 THEN ct.total_cheltuit ELSE 0 END) AS vanzari_clienti_ocazionali,
       COUNT(DISTINCT CASE WHEN ct.ani_activi >= 2 THEN c.c_customer_sk END) AS nr_fideli,
       COUNT(DISTINCT CASE WHEN ct.ani_activi  < 2 THEN c.c_customer_sk END) AS nr_ocazionali
FROM client_tip ct
JOIN customer c             ON ct.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store_sales ss         ON c.c_customer_sk    = ss.ss_customer_sk
GROUP BY ca.ca_state, ib.ib_lower_bound, ib.ib_upper_bound,
         cd.cd_credit_rating, cd.cd_education_status
ORDER BY vanzari_clienti_fideli DESC
LIMIT 100;
