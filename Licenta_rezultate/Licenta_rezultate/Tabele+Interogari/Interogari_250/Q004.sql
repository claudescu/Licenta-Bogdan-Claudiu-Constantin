-- Q004: Vânzări profitabile (preț > 50, cantitate > 2, profit pozitiv)
SELECT * FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0;
