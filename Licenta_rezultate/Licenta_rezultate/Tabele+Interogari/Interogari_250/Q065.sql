-- Q065: Segmentare clienți (NTILE 4) per stat, rating și potențial
SELECT cd.cd_credit_rating, ca.ca_state, hd.hd_buy_potential, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS nr_clienti,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_net_paid)               AS val_medie_tranzactie
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY cd.cd_credit_rating, ca.ca_state, hd.hd_buy_potential, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

-- ===========================================================
-- BLOC 6: 5 JOIN-URI (Q066–Q078)
-- ===========================================================
