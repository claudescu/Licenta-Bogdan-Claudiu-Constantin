-- Q226: Web vânzări per gen, venit și categorie cu ranking
WITH web_dem AS (
    SELECT cd.cd_gender, hd.hd_buy_potential, i.i_category,
           SUM(ws.ws_net_paid) AS total_vanzari,
           COUNT(*) AS nr_tranzactii
    FROM web_sales ws
    JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    GROUP BY cd.cd_gender, hd.hd_buy_potential, i.i_category
)
SELECT cd_gender, hd_buy_potential, i_category, total_vanzari,
       RANK() OVER (PARTITION BY cd_gender ORDER BY total_vanzari DESC) AS rank_per_gen
FROM web_dem
ORDER BY cd_gender, rank_per_gen
LIMIT 100;
