-- Q079: Analiza completă cost de vânzare: magazin + produs + client + HD + timp + promoție
SELECT s.s_store_name, i.i_category, hd.hd_buy_potential,
       p.p_purpose, d.d_year,
       SUM(ss.ss_wholesale_cost * ss.ss_quantity) AS cost_cu_ridicata,
       SUM(ss.ss_list_price * ss.ss_quantity)     AS valoare_lista,
       SUM(ss.ss_net_paid)                        AS total_incasat,
       SUM(ss.ss_net_profit)                      AS profit_total,
       ROUND(SUM(ss.ss_net_profit) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS marja_neta_pct
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
LEFT JOIN promotion p       ON ss.ss_promo_sk   = p.p_promo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_store_name, i.i_category, hd.hd_buy_potential, p.p_purpose, d.d_year
ORDER BY profit_total DESC
LIMIT 100;
