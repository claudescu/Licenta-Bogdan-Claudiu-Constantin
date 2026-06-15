-- Q115: Statistici complete tabel web_sales
SELECT COUNT(*) AS total_tranzactii,
       SUM(ws_net_paid) AS total_incasat,
       AVG(ws_net_paid) AS medie_tranzactie,
       SUM(ws_net_profit) AS profit_total,
       MIN(ws_sales_price) AS pret_minim,
       MAX(ws_sales_price) AS pret_maxim
FROM web_sales;
