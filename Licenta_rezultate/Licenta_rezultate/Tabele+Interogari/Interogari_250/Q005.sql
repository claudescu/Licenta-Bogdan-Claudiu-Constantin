-- Q005: Câte vânzări profitabile există?
SELECT COUNT(*) AS nr_vanzari
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0;
