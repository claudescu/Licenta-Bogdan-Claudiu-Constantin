-- Q072: Market share per brand și regiune cu percentilă
WITH brand_reg AS (
    SELECT i.i_brand, i.i_category, s.s_state, ca.ca_state AS client_stat, d.d_year,
           SUM(ss.ss_net_paid) AS total_vanzari
    FROM store_sales ss
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY i.i_brand, i.i_category, s.s_state, ca.ca_state, d.d_year
)
SELECT i_brand, i_category, s_state, d_year, total_vanzari,
       SUM(total_vanzari) OVER (PARTITION BY i_category, s_state, d_year) AS total_cat_reg_an,
       ROUND(total_vanzari / NULLIF(SUM(total_vanzari) OVER (PARTITION BY i_category, s_state, d_year), 0) * 100, 2) AS market_share_pct,
       RANK() OVER (PARTITION BY i_category, s_state, d_year ORDER BY total_vanzari DESC) AS rank_brand
FROM brand_reg
ORDER BY i_category, s_state, d_year, rank_brand
LIMIT 200;
