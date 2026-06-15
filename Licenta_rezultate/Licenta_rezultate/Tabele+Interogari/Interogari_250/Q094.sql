-- Q094: Comportament cumpărare per tip locuință, band venit, categorie și an
SELECT ca.ca_location_type, ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_quantity)               AS cantitate_medie
FROM store_sales ss
JOIN customer c          ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib       ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i               ON ss.ss_item_sk        = i.i_item_sk
JOIN date_dim d           ON ss.ss_sold_date_sk   = d.d_date_sk
GROUP BY ca.ca_location_type, ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
