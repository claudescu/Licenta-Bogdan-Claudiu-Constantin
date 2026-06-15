-- Q106: Vânzări + retururi complete per magazin, produs, client și timp — 7 join-uri
SELECT s.s_store_name, s.s_state, i.i_category, i.i_brand,
       ca.ca_state AS cl_state, cd.cd_gender, d.d_year,
       COUNT(DISTINCT ss.ss_ticket_number)  AS nr_vanzari,
       SUM(ss.ss_net_paid)                  AS total_vanzari,
       COUNT(DISTINCT sr.sr_ticket_number)  AS nr_retururi,
       COALESCE(SUM(sr.sr_return_amt), 0)   AS total_returnat,
       SUM(ss.ss_net_profit)                AS profit_total
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
LEFT JOIN store_returns sr  ON ss.ss_item_sk      = sr.sr_item_sk
                           AND ss.ss_ticket_number = sr.sr_ticket_number
GROUP BY s.s_store_name, s.s_state, i.i_category, i.i_brand,
         ca.ca_state, cd.cd_gender, d.d_year
ORDER BY profit_total DESC
LIMIT 100;
