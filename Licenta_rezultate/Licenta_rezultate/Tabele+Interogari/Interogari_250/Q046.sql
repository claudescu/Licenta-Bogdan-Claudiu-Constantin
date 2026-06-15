-- Q046: Profil complet client: demografic + adresă + vânzări
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       ca.ca_city, ca.ca_state, ca.ca_country,
       cd.cd_gender, cd.cd_credit_rating,
       COUNT(*)            AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name,
         ca.ca_city, ca.ca_state, ca.ca_country,
         cd.cd_gender, cd.cd_credit_rating
ORDER BY total_cheltuit DESC
LIMIT 100;
