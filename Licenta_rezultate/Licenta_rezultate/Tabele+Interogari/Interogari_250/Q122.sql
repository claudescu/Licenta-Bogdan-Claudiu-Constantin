-- Q122: Depozite ordonate după suprafață
SELECT w_warehouse_name, w_city, w_state, w_country,
       w_warehouse_sq_ft
FROM warehouse
ORDER BY w_warehouse_sq_ft DESC;
