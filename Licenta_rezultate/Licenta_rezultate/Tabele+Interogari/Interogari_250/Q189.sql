-- Q189: Web vânzări per demografice client și site web
SELECT cd.cd_gender, cd.cd_marital_status,
       ws_site.web_name, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_marital_status, ws_site.web_name, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
