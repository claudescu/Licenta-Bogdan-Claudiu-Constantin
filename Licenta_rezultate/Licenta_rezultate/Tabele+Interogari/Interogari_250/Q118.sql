-- Q118: Distribuția demografică a clienților per gen și status marital
SELECT cd_gender, cd_marital_status,
       COUNT(*) AS nr_persoane,
       AVG(cd_purchase_estimate) AS estimare_medie_achizitii,
       AVG(cd_dep_count) AS nr_mediu_dependenti
FROM customer_demographics
GROUP BY cd_gender, cd_marital_status
ORDER BY nr_persoane DESC;
