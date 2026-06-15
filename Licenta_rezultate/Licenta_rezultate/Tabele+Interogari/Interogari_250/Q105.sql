-- Q105: LTV clienți cu segmentare NTILE și profilare completă — 6 join-uri
WITH ltv AS (
    SELECT ss.ss_customer_sk,
           SUM(ss.ss_net_paid) AS total,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           NTILE(4) OVER (ORDER BY SUM(ss.ss_net_paid) DESC) AS quartila
    FROM store_sales ss
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    GROUP BY ss.ss_customer_sk
)
SELECT lt.quartila,
       CASE lt.quartila WHEN 1 THEN 'PREMIUM' WHEN 2 THEN 'HIGH'
                        WHEN 3 THEN 'MED' ELSE 'BASIC' END AS segment,
       ca.ca_state, cd.cd_gender, cd.cd_marital_status,
       ib.ib_lower_bound, ib.ib_upper_bound,
       COUNT(DISTINCT lt.ss_customer_sk) AS nr_clienti,
       AVG(lt.total)     AS ltv_mediu,
       AVG(lt.nr_comenzi) AS comenzi_medii
FROM ltv lt
JOIN customer c             ON lt.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
GROUP BY lt.quartila, ca.ca_state, cd.cd_gender, cd.cd_marital_status,
         ib.ib_lower_bound, ib.ib_upper_bound
ORDER BY lt.quartila, nr_clienti DESC
LIMIT 150;
