-- Q126: Vânzări store cu cupoane mari (top 200)
SELECT ss_ticket_number, ss_item_sk, ss_store_sk,
       ss_coupon_amt, ss_net_paid, ss_net_profit
FROM store_sales
WHERE ss_coupon_amt > 0
ORDER BY ss_coupon_amt DESC
LIMIT 200;
