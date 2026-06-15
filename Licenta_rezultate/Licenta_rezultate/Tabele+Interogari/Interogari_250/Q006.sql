-- Q006: Total încasat și număr tranzacții profitabile
SELECT COUNT(*) AS nr_vanzari,
       SUM(ss_net_paid) AS total_incasat
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0;
