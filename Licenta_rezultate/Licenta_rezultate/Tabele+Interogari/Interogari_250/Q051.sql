-- Q051: Magazin + produs + an: evoluție profit cu ranking YoY
WITH vanzari_anuale AS (
    SELECT s.s_store_name, i.i_category, d.d_year,
           SUM(ss.ss_net_paid)   AS total_vanzari,
           SUM(ss.ss_net_profit) AS profit_total
    FROM store_sales ss
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, i.i_category, d.d_year
)
SELECT s_store_name, i_category, d_year, total_vanzari, profit_total,
       LAG(profit_total) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year) AS profit_an_trecut,
       ROUND((profit_total - LAG(profit_total) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year))
             / NULLIF(LAG(profit_total) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year), 0) * 100, 2) AS crestere_pct
FROM vanzari_anuale
ORDER BY s_store_name, i_category, d_year
LIMIT 200;
