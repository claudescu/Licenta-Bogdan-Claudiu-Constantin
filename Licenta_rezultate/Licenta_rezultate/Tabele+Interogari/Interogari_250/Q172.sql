-- Q172: Store vânzări per client cu credit rating
SELECT cd.cd_credit_rating,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_net_paid) AS valoare_medie
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_credit_rating
ORDER BY total_vanzari DESC;
