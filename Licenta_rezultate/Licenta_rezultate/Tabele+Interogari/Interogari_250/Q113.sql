-- Q113: Număr de magazine per stat
SELECT s_state, s_country,
       COUNT(*) AS nr_magazine,
       AVG(s_number_employees) AS angajati_mediu,
       SUM(s_floor_space) AS suprafata_totala
FROM store
GROUP BY s_state, s_country
ORDER BY nr_magazine DESC;
