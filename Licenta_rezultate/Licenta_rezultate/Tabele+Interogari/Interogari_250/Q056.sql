-- Q056: Profil complet client cu band de venit, adresă, demografice și vânzări
SELECT c.c_customer_id, ca.ca_state, ca.ca_city,
       cd.cd_gender, cd.cd_education_status,
       ib.ib_lower_bound, ib.ib_upper_bound,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
       SUM(ss.ss_net_paid)                 AS total_cheltuit,
       AVG(ss.ss_sales_price)              AS pret_mediu
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
GROUP BY c.c_customer_id, ca.ca_state, ca.ca_city,
         cd.cd_gender, cd.cd_education_status,
         ib.ib_lower_bound, ib.ib_upper_bound
HAVING SUM(ss.ss_net_paid) > 100
ORDER BY total_cheltuit DESC
LIMIT 100;
