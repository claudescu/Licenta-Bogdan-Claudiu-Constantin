-- Q240: Web vânzări per stat, categorie și lună cu cumulative
WITH web_stat_lunar AS (
    SELECT ca.ca_state, i.i_category, d.d_year, d.d_moy,
           SUM(ws.ws_net_paid) AS vanzari,
           SUM(ws.ws_net_profit) AS profit
    FROM web_sales ws
    JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    GROUP BY ca.ca_state, i.i_category, d.d_year, d.d_moy
)
SELECT ca_state, i_category, d_year, d_moy, vanzari, profit,
       SUM(vanzari) OVER (PARTITION BY ca_state, i_category, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS vanzari_cumulate
FROM web_stat_lunar
ORDER BY ca_state, i_category, d_year, d_moy
LIMIT 200;
