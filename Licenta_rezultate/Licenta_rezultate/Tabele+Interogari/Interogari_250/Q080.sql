-- Q080: Cumulativ vânzări lunare per brand și stat cu LAG an trecut
WITH lunar_brand AS (
    SELECT i.i_brand, i.i_category, s.s_state, ca.ca_state AS cl_state,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)   AS vanzari,
           SUM(ss.ss_net_profit) AS profit
    FROM store_sales ss
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY i.i_brand, i.i_category, s.s_state, ca.ca_state, d.d_year, d.d_moy
)
SELECT i_brand, i_category, s_state, d_year, d_moy, vanzari, profit,
       SUM(vanzari) OVER (PARTITION BY i_brand, i_category, s_state, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS vanzari_cumulate_an,
       LAG(vanzari, 12) OVER (PARTITION BY i_brand, i_category, s_state ORDER BY d_year, d_moy) AS vanzari_aceeasi_luna_an_trecut
FROM lunar_brand
ORDER BY i_brand, i_category, s_state, d_year, d_moy
LIMIT 200;


