-- Q249: Store retururi complet cu toate dimensiunile demografice
WITH retur_complet AS (
    SELECT ca.ca_state, s.s_store_name, i.i_category,
           cd.cd_gender, cd.cd_education_status,
           hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
           d.d_year,
           COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
           SUM(sr.sr_return_amt) AS total_returnat,
           SUM(sr.sr_net_loss) AS pierdere_neta,
           COUNT(DISTINCT sr.sr_customer_sk) AS clienti_cu_retururi
    FROM store_returns sr
    JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN item i ON sr.sr_item_sk = i.i_item_sk
    JOIN store s ON sr.sr_store_sk = s.s_store_sk
    JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
    GROUP BY ca.ca_state, s.s_store_name, i.i_category,
             cd.cd_gender, cd.cd_education_status,
             hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound, d.d_year
)
SELECT ca_state, s_store_name, i_category,
       cd_gender, cd_education_status, hd_buy_potential,
       ib_lower_bound, ib_upper_bound, d_year,
       nr_retururi, total_returnat, pierdere_neta, clienti_cu_retururi,
       RANK() OVER (PARTITION BY ca_state, d_year ORDER BY pierdere_neta DESC) AS rank_pierdere
FROM retur_complet
ORDER BY ca_state, d_year, rank_pierdere
LIMIT 200;
