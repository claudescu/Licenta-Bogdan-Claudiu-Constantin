-- Q036: Vânzări per oră și categorie produs
SELECT t.t_hour, t.t_am_pm, i.i_category,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN item i     ON ss.ss_item_sk      = i.i_item_sk
GROUP BY t.t_hour, t.t_am_pm, i.i_category
ORDER BY t.t_hour, total_vanzari DESC;
