-- Q012: Vânzările cu suma netă plătită între 10 și 100
SELECT ss_ticket_number, ss_item_sk, ss_store_sk,
       ss_net_paid, ss_net_profit, ss_quantity
FROM store_sales
WHERE ss_net_paid BETWEEN 10 AND 100
ORDER BY ss_net_paid DESC
LIMIT 200;
