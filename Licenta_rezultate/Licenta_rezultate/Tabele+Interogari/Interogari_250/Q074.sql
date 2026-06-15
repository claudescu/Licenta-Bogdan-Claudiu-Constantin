-- Q074: Profil complet vânzare: client + adresă + demografice + HD + IB + produs + magazin
SELECT s.s_store_name, s.s_state AS magazin_stat,
       ca.ca_state AS client_stat, ca.ca_city,
       cd.cd_gender, cd.cd_marital_status, cd.cd_education_status,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, i.i_brand,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN store s                ON ss.ss_store_sk      = s.s_store_sk
GROUP BY s.s_store_name, s.s_state, ca.ca_state, ca.ca_city,
         cd.cd_gender, cd.cd_marital_status, cd.cd_education_status,
         ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, i.i_brand
ORDER BY profit_total DESC
LIMIT 100;
