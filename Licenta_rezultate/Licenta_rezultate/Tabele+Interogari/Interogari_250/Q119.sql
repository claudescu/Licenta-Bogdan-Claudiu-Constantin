-- Q119: Vânzări web cu cantitate mare și profit negativ
SELECT ws_item_sk, ws_bill_customer_sk,
       ws_quantity, ws_sales_price, ws_net_paid, ws_net_profit
FROM web_sales
WHERE ws_quantity > 5 AND ws_net_profit < 0
ORDER BY ws_net_profit ASC
LIMIT 200;
