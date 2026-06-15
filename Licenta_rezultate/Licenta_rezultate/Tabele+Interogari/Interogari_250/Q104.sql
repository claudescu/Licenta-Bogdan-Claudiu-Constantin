-- Q104: Raport complet per producător, magazin, client și perioadă — 6 join-uri
SELECT i.i_manufact, i.i_category, i.i_brand,
       s.s_store_name, s.s_division_name,
       ca.ca_state, d.d_year,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN item i              ON ss.ss_item_sk       = i.i_item_sk
JOIN store s             ON ss.ss_store_sk      = s.s_store_sk
JOIN customer c          ON ss.ss_customer_sk   = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d          ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY i.i_manufact, i.i_category, i.i_brand,
         s.s_store_name, s.s_division_name, ca.ca_state, d.d_year
ORDER BY profit_total DESC
LIMIT 100;
