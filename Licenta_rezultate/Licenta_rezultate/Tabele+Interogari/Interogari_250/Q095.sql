-- Q095: Top produse per stat cu Window RANK și LAG an trecut — 4 join-uri
WITH prod_stat AS (
    SELECT s.s_state, i.i_product_name, i.i_category, d.d_year,
           SUM(ss.ss_net_paid) AS total_vanzari,
           COUNT(*) AS nr_tranzactii
    FROM store_sales ss
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_state, i.i_product_name, i.i_category, d.d_year
)
SELECT s_state, i_product_name, i_category, d_year, total_vanzari,
       RANK() OVER (PARTITION BY s_state, d_year ORDER BY total_vanzari DESC) AS rank_in_stat,
       LAG(total_vanzari) OVER (PARTITION BY s_state, i_product_name ORDER BY d_year) AS vanzari_an_trecut
FROM prod_stat
ORDER BY s_state, d_year, rank_in_stat
LIMIT 200;
