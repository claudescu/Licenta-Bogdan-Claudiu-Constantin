-- Q061: Clienți cu risc de pierdere: mulți returnați, puțin cheltuit
SELECT c.c_customer_id, ca.ca_state,
       cd.cd_credit_rating, hd.hd_buy_potential,
       COUNT(DISTINCT ss.ss_ticket_number) AS comenzi_store,
       SUM(ss.ss_net_paid)                 AS total_store,
       COUNT(DISTINCT sr.sr_ticket_number) AS retururi
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
LEFT JOIN store_returns sr  ON c.c_customer_sk    = sr.sr_customer_sk
GROUP BY c.c_customer_id, ca.ca_state, cd.cd_credit_rating, hd.hd_buy_potential
HAVING COUNT(DISTINCT sr.sr_ticket_number) > 1
ORDER BY total_store ASC
LIMIT 100;
