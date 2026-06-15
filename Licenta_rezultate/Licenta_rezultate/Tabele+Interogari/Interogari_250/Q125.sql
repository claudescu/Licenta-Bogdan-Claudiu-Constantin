-- Q125: Adrese clienți grupate per tip locație și stat
SELECT ca_location_type, ca_state,
       COUNT(*) AS nr_adrese
FROM customer_address
GROUP BY ca_location_type, ca_state
ORDER BY nr_adrese DESC
LIMIT 100;
