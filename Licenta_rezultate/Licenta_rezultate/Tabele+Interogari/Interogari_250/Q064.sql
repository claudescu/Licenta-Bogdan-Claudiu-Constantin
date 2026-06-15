-- Q064: Rolling 3 luni per magazin și categorie (medie mobilă)
WITH lunar AS (
    SELECT s.s_store_name, i.i_category, d.d_year, d.d_moy,
           SUM(ss.ss_net_paid) AS total_lunar
    FROM store_sales ss
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, i.i_category, d.d_year, d.d_moy
)
SELECT s_store_name, i_category, d_year, d_moy, total_lunar,
       AVG(total_lunar) OVER (
           PARTITION BY s_store_name, i_category
           ORDER BY d_year, d_moy ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS medie_mobila_3luni,
       SUM(total_lunar) OVER (
           PARTITION BY s_store_name, i_category, d_year
           ORDER BY d_moy ROWS UNBOUNDED PRECEDING
       ) AS total_cumulat_an
FROM lunar
ORDER BY s_store_name, i_category, d_year, d_moy
LIMIT 200;
