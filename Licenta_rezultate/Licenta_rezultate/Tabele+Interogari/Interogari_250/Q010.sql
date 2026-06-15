-- Q010: Distribuția cantităților vândute (histogramă)
SELECT ss_quantity,
       COUNT(*)         AS frecventa,
       SUM(ss_net_paid) AS total_pe_cantitate
FROM store_sales
GROUP BY ss_quantity
ORDER BY ss_quantity;
