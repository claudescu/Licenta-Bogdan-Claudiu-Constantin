-- Q028: Distribuție vânzări per gen și status marital (demografice)
SELECT cd.cd_gender, cd.cd_marital_status, cd.cd_education_status,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status
ORDER BY total_vanzari DESC;
