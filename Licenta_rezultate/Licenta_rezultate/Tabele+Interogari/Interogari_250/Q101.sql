-- Q101: Vânzări per orar magazin, categorie, stat client și trimestru
SELECT s.s_hours, i.i_category, ca.ca_state, d.d_year, d.d_qoy,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       COUNT(*)                          AS nr_tranzactii,
       SUM(ss.ss_net_paid)               AS total_vanzari
FROM store_sales ss
JOIN store s             ON ss.ss_store_sk    = s.s_store_sk
JOIN item i              ON ss.ss_item_sk     = i.i_item_sk
JOIN customer c          ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d          ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_hours, i.i_category, ca.ca_state, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;
