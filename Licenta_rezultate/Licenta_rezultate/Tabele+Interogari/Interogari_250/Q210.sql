-- Q210: Vânzări store per stat client și magazin cu ranking
WITH vanzari_stat AS (
    SELECT ca.ca_state, s.s_store_name, i.i_category,
           SUM(ss.ss_net_paid) AS total_vanzari,
           SUM(ss.ss_net_profit) AS profit_total
    FROM store_sales ss
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN store s ON ss.ss_store_sk = s.s_store_sk
    JOIN item i ON ss.ss_item_sk = i.i_item_sk
    GROUP BY ca.ca_state, s.s_store_name, i.i_category
)
SELECT ca_state, s_store_name, i_category, total_vanzari, profit_total,
       RANK() OVER (PARTITION BY ca_state ORDER BY total_vanzari DESC) AS rank_in_stat
FROM vanzari_stat
ORDER BY ca_state, rank_in_stat
LIMIT 200;
