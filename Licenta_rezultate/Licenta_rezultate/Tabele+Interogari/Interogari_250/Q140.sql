-- Q140: Vânzări web per gen client
SELECT cd.cd_gender, cd.cd_marital_status,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_gender, cd.cd_marital_status
ORDER BY total_vanzari DESC;
