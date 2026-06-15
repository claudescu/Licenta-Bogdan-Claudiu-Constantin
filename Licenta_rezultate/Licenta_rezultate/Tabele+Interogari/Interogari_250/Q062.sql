-- Q062: Vânzare per divizie magazin, brand, rating credit și an
SELECT s.s_division_name, s.s_company_name,
       i.i_brand, cd.cd_credit_rating, d.d_year,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_division_name, s.s_company_name,
         i.i_brand, cd.cd_credit_rating, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;
