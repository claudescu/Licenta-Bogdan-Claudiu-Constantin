-- Q183: Clienți per lună naștere, stat, categorie și an
SELECT c.c_birth_month, ca.ca_state, i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_net_paid) AS valoare_medie
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE c.c_birth_month IS NOT NULL
GROUP BY c.c_birth_month, ca.ca_state, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
