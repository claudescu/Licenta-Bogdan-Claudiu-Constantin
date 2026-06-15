-- Q089: Vânzări per clasă produs și stat magazin per an
SELECT i.i_class, s.s_state, d.d_year,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       SUM(ss.ss_net_profit)  AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_class, s.s_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
