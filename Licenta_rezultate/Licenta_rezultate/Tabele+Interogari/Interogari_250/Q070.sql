-- Q070: Detectare clienți cu risc fraudă: retururi mari vs cumpărături mici
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       ca.ca_state, cd.cd_credit_rating,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
       SUM(ss.ss_net_paid)                 AS total_cumparat,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       SUM(sr.sr_return_amt)               AS total_returnat,
       ROUND(CAST(COUNT(DISTINCT sr.sr_ticket_number) AS DECIMAL)
             / NULLIF(COUNT(DISTINCT ss.ss_ticket_number), 0) * 100, 2) AS rata_retur_pct
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
LEFT JOIN store_returns sr  ON c.c_customer_sk    = sr.sr_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name,
         ca.ca_state, cd.cd_credit_rating
HAVING COUNT(DISTINCT sr.sr_ticket_number) > 1
   AND SUM(ss.ss_net_paid) > 0
ORDER BY rata_retur_pct DESC
LIMIT 100;
