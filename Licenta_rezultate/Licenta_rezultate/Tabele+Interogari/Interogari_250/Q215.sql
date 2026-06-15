-- Q215: Store vânzări cu Window per magazin, produs și an
WITH prod_mag AS (
    SELECT s.s_store_name, i.i_category, i.i_brand, d.d_year,
           SUM(ss.ss_net_paid) AS total_vanzari,
           SUM(ss.ss_net_profit) AS profit_total
    FROM store_sales ss
    JOIN store s ON ss.ss_store_sk = s.s_store_sk
    JOIN item i ON ss.ss_item_sk = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    GROUP BY s.s_store_name, i.i_category, i.i_brand, d.d_year
)
SELECT s_store_name, i_category, i_brand, d_year, total_vanzari, profit_total,
       RANK() OVER (PARTITION BY s_store_name, d_year ORDER BY total_vanzari DESC) AS rank_in_magazin,
       LAG(total_vanzari) OVER (PARTITION BY s_store_name, i_brand ORDER BY d_year) AS vanzari_an_trecut
FROM prod_mag
ORDER BY s_store_name, d_year, rank_in_magazin
LIMIT 200;
