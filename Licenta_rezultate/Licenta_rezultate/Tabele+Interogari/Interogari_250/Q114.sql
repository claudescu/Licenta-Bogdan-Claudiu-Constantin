-- Q114: Distribuția clienților per an de naștere
SELECT c_birth_year,
       COUNT(*) AS nr_clienti,
       COUNT(DISTINCT c_birth_country) AS tari_distincte
FROM customer
WHERE c_birth_year IS NOT NULL
GROUP BY c_birth_year
ORDER BY c_birth_year;
