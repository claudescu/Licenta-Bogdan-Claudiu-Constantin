-- Q232: Evoluție vânzări web per categorie cu rolling average
WITH web_cat_lunar AS (
    SELECT i.i_category, d.d_year, d.d_moy,
           SUM(ws.ws_net_paid) AS vanzari,
           SUM(ws.ws_net_profit) AS profit
    FROM web_sales ws
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    GROUP BY i.i_category, d.d_year, d.d_moy
)
SELECT i_category, d_year, d_moy, vanzari, profit,
       AVG(vanzari) OVER (PARTITION BY i_category ORDER BY d_year, d_moy ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS medie_3luni
FROM web_cat_lunar
ORDER BY i_category, d_year, d_moy
LIMIT 200;
