-- Q184: Produse cu mărime specifică și vânzările lor
SELECT i.i_size, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE i.i_size IS NOT NULL
GROUP BY i.i_size, i.i_category
ORDER BY total_vanzari DESC;
