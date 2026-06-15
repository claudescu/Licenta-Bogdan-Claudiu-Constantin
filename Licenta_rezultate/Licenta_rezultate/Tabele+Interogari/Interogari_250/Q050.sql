-- Q050: Clienți cu cheltuieli mari, grupați pe rating credit și stat
SELECT cd.cd_credit_rating, ca.ca_state,
       COUNT(DISTINCT c.c_customer_sk) AS nr_clienti,
       SUM(ss.ss_net_paid)             AS total_vanzari,
       AVG(ss.ss_sales_price)          AS pret_mediu
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
WHERE ss.ss_sales_price > 50
GROUP BY cd.cd_credit_rating, ca.ca_state
ORDER BY total_vanzari DESC
LIMIT 100;
