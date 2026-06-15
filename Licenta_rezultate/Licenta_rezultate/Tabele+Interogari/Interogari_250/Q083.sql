-- Q083: Raport complet sezonalitate + demografice + magazin + produs + timp (7 join-uri)
WITH baza AS (
    SELECT s.s_store_name, s.s_division_name, s.s_state,
           i.i_category, i.i_brand,
           t.t_shift, t.t_am_pm,
           cd.cd_gender, cd.cd_marital_status,
           d.d_year, d.d_moy, d.d_weekend,
           COUNT(*)               AS nr_tranzactii,
           SUM(ss.ss_net_paid)    AS total_vanzari,
           SUM(ss.ss_net_profit)  AS profit_total,
           AVG(ss.ss_sales_price) AS pret_mediu
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk     = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk      = i.i_item_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    GROUP BY s.s_store_name, s.s_division_name, s.s_state, i.i_category, i.i_brand,
             t.t_shift, t.t_am_pm, cd.cd_gender, cd.cd_marital_status,
             d.d_year, d.d_moy, d.d_weekend
)
SELECT s_store_name, s_division_name, s_state, i_category, i_brand,
       t_shift, t_am_pm, cd_gender, cd_marital_status,
       d_year, d_moy, d_weekend,
       nr_tranzactii, total_vanzari, profit_total, pret_mediu,
       SUM(total_vanzari) OVER (PARTITION BY s_store_name, i_category, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS total_cumulat_an
FROM baza
ORDER BY profit_total DESC
LIMIT 100;
