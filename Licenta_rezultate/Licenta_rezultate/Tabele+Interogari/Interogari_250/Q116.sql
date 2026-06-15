-- Q116: Produse grupate per categorie cu statistici de preț
SELECT i_category,
       COUNT(*) AS nr_produse,
       AVG(i_current_price) AS pret_mediu,
       MIN(i_current_price) AS pret_minim,
       MAX(i_current_price) AS pret_maxim,
       AVG(i_wholesale_cost) AS cost_mediu
FROM item
GROUP BY i_category
ORDER BY nr_produse DESC;
