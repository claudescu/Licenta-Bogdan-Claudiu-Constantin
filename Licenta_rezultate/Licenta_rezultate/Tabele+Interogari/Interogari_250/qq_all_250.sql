---- Q001
SELECT * FROM store_sales LIMIT 100;

---- Q002
SELECT * FROM store_sales
WHERE ss_sales_price > 50;

---- Q003
SELECT * FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2;

---- Q004
SELECT * FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0;

---- Q005
SELECT COUNT(*) AS nr_vanzari
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0;

---- Q006
SELECT COUNT(*) AS nr_vanzari,
       SUM(ss_net_paid) AS total_incasat
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0;

---- Q007
SELECT ss_store_sk,
       COUNT(*)            AS nr_vanzari,
       SUM(ss_net_paid)    AS total_incasat,
       AVG(ss_sales_price) AS pret_mediu
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0
GROUP BY ss_store_sk;

---- Q008
SELECT ss_store_sk,
       COUNT(*)         AS nr_vanzari,
       SUM(ss_net_paid) AS total_incasat
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0
GROUP BY ss_store_sk
HAVING COUNT(*) > 10;

---- Q009
SELECT ss_store_sk,
       COUNT(*)         AS nr_vanzari,
       SUM(ss_net_paid) AS total_incasat,
       AVG(ss_sales_price) AS pret_mediu
FROM store_sales
WHERE ss_sales_price > 50 AND ss_quantity > 2 AND ss_net_profit > 0
GROUP BY ss_store_sk
HAVING COUNT(*) > 10
ORDER BY total_incasat DESC;

---- Q010
SELECT ss_quantity,
       COUNT(*)         AS frecventa,
       SUM(ss_net_paid) AS total_pe_cantitate
FROM store_sales
GROUP BY ss_quantity
ORDER BY ss_quantity;

---- Q011
SELECT ss_store_sk,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss_net_paid)      AS total_incasat,
       SUM(ss_net_profit)    AS profit_total,
       AVG(ss_sales_price)   AS pret_mediu,
       MIN(ss_sales_price)   AS pret_minim,
       MAX(ss_sales_price)   AS pret_maxim,
       SUM(ss_ext_discount_amt) AS discount_total
FROM store_sales
GROUP BY ss_store_sk
ORDER BY profit_total DESC;

---- Q012
SELECT ss_ticket_number, ss_item_sk, ss_store_sk,
       ss_net_paid, ss_net_profit, ss_quantity
FROM store_sales
WHERE ss_net_paid BETWEEN 10 AND 100
ORDER BY ss_net_paid DESC
LIMIT 200;

---- Q013
SELECT ss_item_sk,
       COUNT(*)           AS nr_vanzari,
       SUM(ss_net_profit) AS profit_total,
       AVG(ss_net_profit) AS profit_mediu,
       MIN(ss_net_profit) AS profit_minim,
       MAX(ss_net_profit) AS profit_maxim
FROM store_sales
GROUP BY ss_item_sk
ORDER BY profit_total DESC
LIMIT 50;

---- Q014
SELECT ss_store_sk,
       SUM(ss_ext_tax)         AS taxa_totala,
       SUM(ss_ext_sales_price) AS vanzari_brute,
       ROUND(
           SUM(ss_ext_tax) / NULLIF(SUM(ss_ext_sales_price), 0) * 100, 2
       ) AS procent_taxa
FROM store_sales
GROUP BY ss_store_sk
ORDER BY procent_taxa DESC;

---- Q015
SELECT ss_store_sk,
       SUM(ss_net_paid)   AS total_incasat,
       SUM(ss_net_profit) AS profit_total,
       COUNT(*)           AS nr_tranzactii,
       AVG(ss_quantity)   AS cantitate_medie
FROM store_sales
GROUP BY ss_store_sk
HAVING SUM(ss_net_paid) > 100000 AND SUM(ss_net_profit) > 0
ORDER BY total_incasat DESC;

---- Q016
SELECT s.s_store_name, s.s_city, s.s_state,
       COUNT(*)            AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_incasat
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
GROUP BY s.s_store_name, s.s_city, s.s_state
ORDER BY total_incasat DESC;

---- Q017
SELECT s.s_store_name, s.s_state, s.s_tax_percentage,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
WHERE ss.ss_sales_price > 50 AND s.s_tax_percentage > 0
GROUP BY s.s_store_name, s.s_state, s.s_tax_percentage
ORDER BY profit_total DESC;

---- Q018
SELECT i.i_product_name, i.i_category, i.i_brand,
       COUNT(ss.ss_item_sk) AS nr_vanzari,
       SUM(ss.ss_net_paid)  AS total_incasat,
       AVG(ss.ss_sales_price) AS pret_mediu_vanzare
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_product_name, i.i_category, i.i_brand
ORDER BY total_incasat DESC
LIMIT 50;

---- Q019
SELECT d.d_date, d.d_year, d.d_moy, d.d_day_name,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_zi,
       SUM(ss.ss_net_profit)      AS profit_zi
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_date, d.d_year, d.d_moy, d.d_day_name
ORDER BY d.d_date;

---- Q020
SELECT d.d_year, d.d_qoy AS trimestru, d.d_quarter_name,
       COUNT(*)            AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_trimestru,
       SUM(ss.ss_net_profit) AS profit_trimestru
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy, d.d_quarter_name
ORDER BY d.d_year, d.d_qoy;

---- Q021
SELECT d.d_weekend,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu,
       SUM(ss.ss_net_profit)  AS profit_total
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_weekend;

---- Q022
SELECT d.d_holiday,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu,
       SUM(ss.ss_net_profit)  AS profit_total
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_holiday;

---- Q023
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address,
       COUNT(*)            AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit,
       AVG(ss.ss_net_paid) AS valoare_medie_tranzactie
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q024
SELECT t.t_hour, t.t_am_pm, t.t_shift,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
GROUP BY t.t_hour, t.t_am_pm, t.t_shift
ORDER BY t.t_hour;

---- Q025
SELECT p.p_promo_name, p.p_purpose, p.p_channel_email, p.p_channel_tv,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_coupon_amt)      AS total_cupoane
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
GROUP BY p.p_promo_name, p.p_purpose, p.p_channel_email, p.p_channel_tv
ORDER BY total_vanzari DESC
LIMIT 50;

---- Q026
SELECT i.i_product_name, i.i_category, i.i_current_price, i.i_wholesale_cost,
       ROUND((i.i_current_price - i.i_wholesale_cost)
             / NULLIF(i.i_current_price, 0) * 100, 2) AS marja_pct,
       COUNT(ss.ss_item_sk) AS nr_vanzari,
       SUM(ss.ss_net_paid)  AS total_vanzari
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE i.i_current_price > 0
GROUP BY i.i_product_name, i.i_category, i.i_current_price, i.i_wholesale_cost
HAVING ROUND((i.i_current_price - i.i_wholesale_cost)
             / NULLIF(i.i_current_price, 0) * 100, 2) < 20
ORDER BY ROUND((i.i_current_price - i.i_wholesale_cost)
               / NULLIF(i.i_current_price, 0) * 100, 2) ASC
LIMIT 100;

---- Q027
SELECT hd.hd_buy_potential, hd.hd_dep_count, hd.hd_vehicle_count,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
GROUP BY hd.hd_buy_potential, hd.hd_dep_count, hd.hd_vehicle_count
ORDER BY total_vanzari DESC;

---- Q028
SELECT cd.cd_gender, cd.cd_marital_status, cd.cd_education_status,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status
ORDER BY total_vanzari DESC;

---- Q029
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(ss.ss_ticket_number) AS nr_achizitii_store,
       SUM(ss.ss_net_paid)        AS total_cheltuit
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE NOT EXISTS (
    SELECT 1 FROM web_sales ws
    WHERE ws.ws_bill_customer_sk = c.c_customer_sk
)
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q030
SELECT i.i_category,
       i.i_product_name,
       i.i_brand,
       SUM(ss.ss_net_profit) AS profit_total,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       COUNT(*)              AS nr_vanzari,
       RANK() OVER (PARTITION BY i.i_category ORDER BY SUM(ss.ss_net_profit) DESC) AS rank_in_categorie
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_category, i.i_product_name, i.i_brand
ORDER BY i.i_category, rank_in_categorie
LIMIT 100;

---- Q031
SELECT s.s_store_name, s.s_state, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_an,
       SUM(ss.ss_net_profit)      AS profit_an
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year
ORDER BY s.s_store_name, d.d_year;

---- Q032
SELECT s.s_store_name, d.d_year, d.d_moy,
       SUM(ss.ss_net_paid)                    AS total_luna,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, d.d_year, d.d_moy
ORDER BY s.s_store_name, d.d_year, d.d_moy;

---- Q033
SELECT i.i_category, d.d_year,
       COUNT(*)              AS nr_vanzari,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_category, d.d_year
ORDER BY i.i_category, d.d_year;

---- Q034
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       c.c_preferred_cust_flag,
       COUNT(*)            AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, c.c_preferred_cust_flag
HAVING SUM(ss.ss_net_paid) > (
    SELECT AVG(sub_total)
    FROM (
        SELECT ss2.ss_customer_sk, SUM(ss2.ss_net_paid) AS sub_total
        FROM store_sales ss2 GROUP BY ss2.ss_customer_sk
    ) t
)
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q035
SELECT i.i_brand, d.d_day_name, d.d_dow,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, d.d_day_name, d.d_dow
ORDER BY d.d_dow, total_vanzari DESC;

---- Q036
SELECT t.t_hour, t.t_am_pm, i.i_category,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN item i     ON ss.ss_item_sk      = i.i_item_sk
GROUP BY t.t_hour, t.t_am_pm, i.i_category
ORDER BY t.t_hour, total_vanzari DESC;

---- Q037
SELECT p.p_promo_name, p.p_purpose, d.d_year,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane,
       ROUND(SUM(ss.ss_coupon_amt) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS pct_cupon,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk    = p.p_promo_sk
JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_purpose, d.d_year
ORDER BY pct_cupon DESC
LIMIT 50;

---- Q038
SELECT s.s_store_name, s.s_state,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_vanzari,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       ROUND(
           CAST(COUNT(DISTINCT sr.sr_ticket_number) AS DECIMAL)
           / NULLIF(COUNT(DISTINCT ss.ss_ticket_number), 0) * 100, 2
       ) AS rata_returnare_pct
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
LEFT JOIN store_returns sr ON ss.ss_store_sk    = sr.sr_store_sk
                          AND ss.ss_ticket_number = sr.sr_ticket_number
GROUP BY s.s_store_name, s.s_state
ORDER BY rata_returnare_pct DESC;

---- Q039
SELECT ib.ib_lower_bound, ib.ib_upper_bound, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk       = hd.hd_demo_sk
JOIN income_band ib             ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN date_dim d                 ON ss.ss_sold_date_sk   = d.d_date_sk
GROUP BY ib.ib_lower_bound, ib.ib_upper_bound, d.d_year
ORDER BY ib.ib_lower_bound
LIMIT 100;

---- Q040
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(DISTINCT d.d_year) AS ani_activi,
       SUM(ss.ss_net_paid)      AS total_cheltuit,
       COUNT(*)                 AS nr_tranzactii_totale
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
HAVING COUNT(DISTINCT d.d_year) >= 2
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q041
SELECT s.s_store_name, s.s_state, d.d_year, d.d_moy,
       SUM(ss.ss_net_profit) AS profit_lunar,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year, d.d_moy
HAVING SUM(ss.ss_net_profit) < 0
ORDER BY profit_lunar ASC;

---- Q042
SELECT s.s_store_name, i.i_product_name, i.i_category,
       SUM(ss.ss_net_paid) AS total_vanzari,
       COUNT(*)            AS nr_tranzactii,
       RANK() OVER (PARTITION BY ss.ss_store_sk ORDER BY SUM(ss.ss_net_paid) DESC) AS rank_produs
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i  ON ss.ss_item_sk  = i.i_item_sk
GROUP BY s.s_store_name, ss.ss_store_sk, i.i_product_name, i.i_category
ORDER BY s.s_store_name, rank_produs
LIMIT 200;

---- Q043
SELECT s.s_manager, s.s_state, d.d_year, d.d_qoy,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_manager, s.s_state, d.d_year, d.d_qoy
ORDER BY s.s_manager, d.d_year, d.d_qoy;

---- Q044
SELECT cd.cd_education_status, i.i_category,
       COUNT(DISTINCT ss.ss_customer_sk) AS nr_clienti,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_sales_price)            AS pret_mediu
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN item i                   ON ss.ss_item_sk  = i.i_item_sk
GROUP BY cd.cd_education_status, i.i_category
ORDER BY total_vanzari DESC;

---- Q045
SELECT s.s_store_name, s.s_state,
       s.s_number_employees, s.s_floor_space,
       SUM(ss.ss_net_paid) AS total_vanzari,
       ROUND(SUM(ss.ss_net_paid) / NULLIF(s.s_number_employees, 0), 2) AS vanzari_per_angajat,
       ROUND(SUM(ss.ss_net_paid) / NULLIF(s.s_floor_space, 0), 2)      AS vanzari_per_sqft
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE s.s_number_employees > 0 AND s.s_floor_space > 0
GROUP BY s.s_store_name, s.s_state, s.s_number_employees, s.s_floor_space
ORDER BY vanzari_per_angajat DESC
LIMIT 50;

---- Q046
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       ca.ca_city, ca.ca_state, ca.ca_country,
       cd.cd_gender, cd.cd_credit_rating,
       COUNT(*)            AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name,
         ca.ca_city, ca.ca_state, ca.ca_country,
         cd.cd_gender, cd.cd_credit_rating
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q047
SELECT ca.ca_state, i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       SUM(ss.ss_net_profit)             AS profit_total
FROM store_sales ss
JOIN customer c          ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i              ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d          ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q048
SELECT s.s_store_name, t.t_hour, t.t_am_pm, d.d_day_name,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, t.t_hour, t.t_am_pm, d.d_day_name
ORDER BY s.s_store_name, d.d_day_name, t.t_hour
LIMIT 200;

---- Q049
SELECT i.i_brand, p.p_promo_name, p.p_purpose, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_coupon_amt)      AS total_cupoane,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN item i      ON ss.ss_item_sk    = i.i_item_sk
JOIN promotion p ON ss.ss_promo_sk   = p.p_promo_sk
JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, p.p_promo_name, p.p_purpose, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q050
SELECT cd.cd_credit_rating, ca.ca_state,
       COUNT(DISTINCT c.c_customer_sk) AS nr_clienti,
       SUM(ss.ss_net_paid)             AS total_vanzari,
       AVG(ss.ss_sales_price)          AS pret_mediu
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
WHERE ss.ss_sales_price > 50
GROUP BY cd.cd_credit_rating, ca.ca_state
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q051
WITH vanzari_anuale AS (
    SELECT s.s_store_name, i.i_category, d.d_year,
           SUM(ss.ss_net_paid)   AS total_vanzari,
           SUM(ss.ss_net_profit) AS profit_total
    FROM store_sales ss
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, i.i_category, d.d_year
)
SELECT s_store_name, i_category, d_year, total_vanzari, profit_total,
       LAG(profit_total) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year) AS profit_an_trecut,
       ROUND((profit_total - LAG(profit_total) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year))
             / NULLIF(LAG(profit_total) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year), 0) * 100, 2) AS crestere_pct
FROM vanzari_anuale
ORDER BY s_store_name, i_category, d_year
LIMIT 200;

---- Q052
SELECT i.i_category, s.s_state, cd.cd_gender,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_vanzari,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       ROUND(CAST(COUNT(DISTINCT sr.sr_ticket_number) AS DECIMAL)
             / NULLIF(COUNT(DISTINCT ss.ss_ticket_number), 0) * 100, 2) AS rata_retur_pct
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk    = i.i_item_sk
JOIN store s                ON ss.ss_store_sk   = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
LEFT JOIN store_returns sr  ON ss.ss_item_sk      = sr.sr_item_sk
                           AND ss.ss_ticket_number = sr.sr_ticket_number
GROUP BY i.i_category, s.s_state, cd.cd_gender
ORDER BY rata_retur_pct DESC
LIMIT 100;

---- Q053
SELECT s.s_hours, t.t_shift, i.i_category,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
GROUP BY s.s_hours, t.t_shift, i.i_category
ORDER BY total_vanzari DESC;

---- Q054
SELECT i.i_category, i.i_brand,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk      = i.i_item_sk
JOIN store s    ON ss.ss_store_sk     = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE i.i_current_price > i.i_wholesale_cost * 1.5
  AND d.d_year = 2001
GROUP BY i.i_category, i.i_brand
ORDER BY profit_total DESC
LIMIT 100;

---- Q055
SELECT hd.hd_buy_potential, i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_quantity)               AS cantitate_medie
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk     = hd.hd_demo_sk
JOIN item i                    ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d                ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY hd.hd_buy_potential, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q056
SELECT c.c_customer_id, ca.ca_state, ca.ca_city,
       cd.cd_gender, cd.cd_education_status,
       ib.ib_lower_bound, ib.ib_upper_bound,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
       SUM(ss.ss_net_paid)                 AS total_cheltuit,
       AVG(ss.ss_sales_price)              AS pret_mediu
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
GROUP BY c.c_customer_id, ca.ca_state, ca.ca_city,
         cd.cd_gender, cd.cd_education_status,
         ib.ib_lower_bound, ib.ib_upper_bound
HAVING SUM(ss.ss_net_paid) > 100
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q057
SELECT s.s_store_name, s.s_state, i.i_category,
       cd.cd_gender, d.d_year,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, i.i_category, cd.cd_gender, d.d_year
ORDER BY profit_total DESC
LIMIT 100;

---- Q058
SELECT p.p_promo_name, p.p_purpose, i.i_brand, d.d_year,
       p.p_cost                             AS cost_promotie,
       SUM(ss.ss_net_paid)                  AS vanzari_generate,
       SUM(ss.ss_net_paid) - p.p_cost       AS roi_net,
       COUNT(DISTINCT ss.ss_customer_sk)    AS clienti_unici
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk    = p.p_promo_sk
JOIN item i      ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s     ON ss.ss_store_sk    = s.s_store_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_brand, d.d_year, p.p_cost
HAVING SUM(ss.ss_net_paid) > p.p_cost
ORDER BY roi_net DESC
LIMIT 50;

---- Q059
SELECT t.t_shift, s.s_state, cd.cd_gender, i.i_category,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
JOIN store s                ON ss.ss_store_sk     = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
JOIN item i                 ON ss.ss_item_sk      = i.i_item_sk
GROUP BY t.t_shift, s.s_state, cd.cd_gender, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q060
SELECT s.s_manager, i.i_category, cd.cd_gender, d.d_year, d.d_moy,
       SUM(ss.ss_net_paid)   AS total_lunar,
       SUM(ss.ss_net_profit) AS profit_lunar,
       COUNT(*)              AS nr_tranzactii
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_manager, i.i_category, cd.cd_gender, d.d_year, d.d_moy
ORDER BY s.s_manager, d.d_year, d.d_moy
LIMIT 200;

---- Q061
SELECT c.c_customer_id, ca.ca_state,
       cd.cd_credit_rating, hd.hd_buy_potential,
       COUNT(DISTINCT ss.ss_ticket_number) AS comenzi_store,
       SUM(ss.ss_net_paid)                 AS total_store,
       COUNT(DISTINCT sr.sr_ticket_number) AS retururi
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
LEFT JOIN store_returns sr  ON c.c_customer_sk    = sr.sr_customer_sk
GROUP BY c.c_customer_id, ca.ca_state, cd.cd_credit_rating, hd.hd_buy_potential
HAVING COUNT(DISTINCT sr.sr_ticket_number) > 1
ORDER BY total_store ASC
LIMIT 100;

---- Q062
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

---- Q063
SELECT s.s_store_name, i.i_brand, d.d_weekend, d.d_holiday, t.t_hour,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
GROUP BY s.s_store_name, i.i_brand, d.d_weekend, d.d_holiday, t.t_hour
ORDER BY total_vanzari DESC
LIMIT 200;

---- Q064
WITH lunar AS (
    SELECT s.s_store_name, i.i_category, d.d_year, d.d_moy,
           SUM(ss.ss_net_paid) AS total_lunar
    FROM store_sales ss
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, i.i_category, d.d_year, d.d_moy
)
SELECT s_store_name, i_category, d_year, d_moy, total_lunar,
       AVG(total_lunar) OVER (
           PARTITION BY s_store_name, i_category
           ORDER BY d_year, d_moy ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS medie_mobila_3luni,
       SUM(total_lunar) OVER (
           PARTITION BY s_store_name, i_category, d_year
           ORDER BY d_moy ROWS UNBOUNDED PRECEDING
       ) AS total_cumulat_an
FROM lunar
ORDER BY s_store_name, i_category, d_year, d_moy
LIMIT 200;

---- Q065
SELECT cd.cd_credit_rating, ca.ca_state, hd.hd_buy_potential, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS nr_clienti,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_net_paid)               AS val_medie_tranzactie
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY cd.cd_credit_rating, ca.ca_state, hd.hd_buy_potential, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q066
SELECT ca.ca_state, cd.cd_gender, cd.cd_marital_status,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, s.s_store_name,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       SUM(ss.ss_net_profit)             AS profit_total
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN store s                ON ss.ss_store_sk      = s.s_store_sk
GROUP BY ca.ca_state, cd.cd_gender, cd.cd_marital_status,
         ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, s.s_store_name
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q067
SELECT s.s_store_name, t.t_shift, i.i_category, i.i_brand,
       cd.cd_education_status, d.d_year, d.d_qoy,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, t.t_shift, i.i_category, i.i_brand,
         cd.cd_education_status, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;

---- Q068
SELECT s.s_store_name, i.i_category, r.r_reason_desc, cd.cd_gender, d.d_year,
       COUNT(sr.sr_item_sk)  AS nr_retururi,
       SUM(sr.sr_return_amt) AS suma_returnata,
       SUM(sr.sr_net_loss)   AS pierdere_totala
FROM store_returns sr
JOIN store s                ON sr.sr_store_sk  = s.s_store_sk
JOIN item i                 ON sr.sr_item_sk   = i.i_item_sk
JOIN reason r               ON sr.sr_reason_sk = r.r_reason_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, i.i_category, r.r_reason_desc, cd.cd_gender, d.d_year
ORDER BY pierdere_totala DESC
LIMIT 100;

---- Q069
SELECT s.s_state, s.s_market_manager, i.i_category, i.i_brand,
       cd.cd_gender, d.d_year, d.d_qoy,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       SUM(ss.ss_net_profit)             AS profit_total,
       RANK() OVER (PARTITION BY s.s_state, d.d_year ORDER BY SUM(ss.ss_net_profit) DESC) AS rank_profit
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
GROUP BY s.s_state, s.s_market_manager, i.i_category, i.i_brand,
         cd.cd_gender, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;

---- Q070
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       ca.ca_state, cd.cd_credit_rating,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
       SUM(ss.ss_net_paid)                 AS total_cumparat,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       SUM(sr.sr_return_amt)               AS total_returnat,
       ROUND(CAST(COUNT(DISTINCT sr.sr_ticket_number) AS DECIMAL)
             / NULLIF(COUNT(DISTINCT ss.ss_ticket_number), 0) * 100, 2) AS rata_retur_pct
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
LEFT JOIN store_returns sr  ON c.c_customer_sk    = sr.sr_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name,
         ca.ca_state, cd.cd_credit_rating
HAVING COUNT(DISTINCT sr.sr_ticket_number) > 1
   AND SUM(ss.ss_net_paid) > 0
ORDER BY rata_retur_pct DESC
LIMIT 100;

---- Q071
SELECT p.p_purpose, p.p_channel_email, p.p_channel_tv,
       ib.ib_lower_bound, ib.ib_upper_bound,
       ca.ca_state, d.d_year,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN promotion p               ON ss.ss_promo_sk    = p.p_promo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk    = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN customer c                ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca       ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d                ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_purpose, p.p_channel_email, p.p_channel_tv,
         ib.ib_lower_bound, ib.ib_upper_bound, ca.ca_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q072
WITH brand_reg AS (
    SELECT i.i_brand, i.i_category, s.s_state, ca.ca_state AS client_stat, d.d_year,
           SUM(ss.ss_net_paid) AS total_vanzari
    FROM store_sales ss
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY i.i_brand, i.i_category, s.s_state, ca.ca_state, d.d_year
)
SELECT i_brand, i_category, s_state, d_year, total_vanzari,
       SUM(total_vanzari) OVER (PARTITION BY i_category, s_state, d_year) AS total_cat_reg_an,
       ROUND(total_vanzari / NULLIF(SUM(total_vanzari) OVER (PARTITION BY i_category, s_state, d_year), 0) * 100, 2) AS market_share_pct,
       RANK() OVER (PARTITION BY i_category, s_state, d_year ORDER BY total_vanzari DESC) AS rank_brand
FROM brand_reg
ORDER BY i_category, s_state, d_year, rank_brand
LIMIT 200;

---- Q073
SELECT ca.ca_state, c.c_customer_id,
       c.c_first_name || ' ' || c.c_last_name AS nume,
       cd.cd_education_status, ib.ib_lower_bound, ib.ib_upper_bound,
       SUM(ss.ss_net_paid) AS ltv_total,
       ROW_NUMBER() OVER (PARTITION BY ca.ca_state ORDER BY SUM(ss.ss_net_paid) DESC) AS rank_in_stat
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
GROUP BY ca.ca_state, c.c_customer_id, c.c_first_name, c.c_last_name,
         cd.cd_education_status, ib.ib_lower_bound, ib.ib_upper_bound
ORDER BY ca.ca_state, rank_in_stat
LIMIT 200;

---- Q074
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

---- Q075
SELECT s.s_store_name, i.i_category, t.t_shift,
       cd.cd_gender, d.d_year, d.d_moy, d.d_weekend,
       p.p_promo_name,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS cupoane_utilizate
FROM store_sales ss
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
LEFT JOIN promotion p       ON ss.ss_promo_sk   = p.p_promo_sk
GROUP BY s.s_store_name, i.i_category, t.t_shift,
         cd.cd_gender, d.d_year, d.d_moy, d.d_weekend, p.p_promo_name
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q076
WITH client_tip AS (
    SELECT ss.ss_customer_sk,
           COUNT(DISTINCT d.d_year) AS ani_activi,
           SUM(ss.ss_net_paid)      AS total_cheltuit
    FROM store_sales ss
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY ss.ss_customer_sk
)
SELECT ca.ca_state, ib.ib_lower_bound, ib.ib_upper_bound,
       cd.cd_credit_rating, cd.cd_education_status,
       SUM(CASE WHEN ct.ani_activi >= 2 THEN ct.total_cheltuit ELSE 0 END) AS vanzari_clienti_fideli,
       SUM(CASE WHEN ct.ani_activi  < 2 THEN ct.total_cheltuit ELSE 0 END) AS vanzari_clienti_ocazionali,
       COUNT(DISTINCT CASE WHEN ct.ani_activi >= 2 THEN c.c_customer_sk END) AS nr_fideli,
       COUNT(DISTINCT CASE WHEN ct.ani_activi  < 2 THEN c.c_customer_sk END) AS nr_ocazionali
FROM client_tip ct
JOIN customer c             ON ct.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store_sales ss         ON c.c_customer_sk    = ss.ss_customer_sk
GROUP BY ca.ca_state, ib.ib_lower_bound, ib.ib_upper_bound,
         cd.cd_credit_rating, cd.cd_education_status
ORDER BY vanzari_clienti_fideli DESC
LIMIT 100;

---- Q077
SELECT r.r_reason_desc, i.i_category, i.i_brand,
       ca.ca_state, cd.cd_gender, cd.cd_credit_rating,
       d.d_year, d.d_qoy,
       COUNT(sr.sr_item_sk)  AS nr_retururi,
       SUM(sr.sr_return_amt) AS suma_returnata,
       SUM(sr.sr_net_loss)   AS pierdere_totala
FROM store_returns sr
JOIN customer c             ON sr.sr_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk   = cd.cd_demo_sk
JOIN item i                 ON sr.sr_item_sk       = i.i_item_sk
JOIN reason r               ON sr.sr_reason_sk     = r.r_reason_sk
JOIN date_dim d             ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY r.r_reason_desc, i.i_category, i.i_brand,
         ca.ca_state, cd.cd_gender, cd.cd_credit_rating, d.d_year, d.d_qoy
ORDER BY pierdere_totala DESC
LIMIT 100;

---- Q078
WITH baza AS (
    SELECT s.s_state, s.s_market_manager, i.i_brand, i.i_category,
           cd.cd_gender, d.d_year, d.d_qoy,
           SUM(ss.ss_net_paid)                    AS total_vanzari,
           SUM(ss.ss_net_profit)                  AS profit_total,
           COUNT(DISTINCT ss.ss_customer_sk)       AS clienti_unici
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    GROUP BY s.s_state, s.s_market_manager, i.i_brand, i.i_category,
             cd.cd_gender, d.d_year, d.d_qoy
)
SELECT s_state, s_market_manager, i_brand, i_category,
       cd_gender, d_year, d_qoy,
       total_vanzari, profit_total, clienti_unici,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year) AS total_cat_stat_an,
       RANK() OVER (PARTITION BY s_state, d_year ORDER BY profit_total DESC) AS rank_profit
FROM baza
ORDER BY profit_total DESC
LIMIT 100;

---- Q079
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

---- Q080
WITH lunar_brand AS (
    SELECT i.i_brand, i.i_category, s.s_state, ca.ca_state AS cl_state,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)   AS vanzari,
           SUM(ss.ss_net_profit) AS profit
    FROM store_sales ss
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY i.i_brand, i.i_category, s.s_state, ca.ca_state, d.d_year, d.d_moy
)
SELECT i_brand, i_category, s_state, d_year, d_moy, vanzari, profit,
       SUM(vanzari) OVER (PARTITION BY i_brand, i_category, s_state, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS vanzari_cumulate_an,
       LAG(vanzari, 12) OVER (PARTITION BY i_brand, i_category, s_state ORDER BY d_year, d_moy) AS vanzari_aceeasi_luna_an_trecut
FROM lunar_brand
ORDER BY i_brand, i_category, s_state, d_year, d_moy
LIMIT 200;

---- Q081
SELECT s.s_store_name, s.s_state AS mag_stat,
       ca.ca_state AS cl_stat, ca.ca_city,
       cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, i.i_brand,
       d.d_year,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN store s                ON ss.ss_store_sk      = s.s_store_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, ca.ca_state, ca.ca_city,
         cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating,
         ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, i.i_brand, d.d_year
ORDER BY profit_total DESC
LIMIT 100;

---- Q082
WITH segmente AS (
    SELECT c.c_customer_sk, c.c_customer_id,
           SUM(ss.ss_net_paid) AS ltv,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           COUNT(DISTINCT d.d_year)            AS ani_activi,
           NTILE(5) OVER (ORDER BY SUM(ss.ss_net_paid) DESC) AS quintila
    FROM store_sales ss
    JOIN customer c  ON ss.ss_customer_sk = c.c_customer_sk
    JOIN date_dim d  ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY c.c_customer_sk, c.c_customer_id
)
SELECT sg.quintila,
       CASE sg.quintila
           WHEN 1 THEN 'PREMIUM' WHEN 2 THEN 'HIGH VALUE'
           WHEN 3 THEN 'MID VALUE' WHEN 4 THEN 'LOW VALUE'
           ELSE 'BUDGET'
       END AS segment,
       ca.ca_state, cd.cd_gender, cd.cd_education_status,
       cd.cd_credit_rating, hd.hd_buy_potential,
       ib.ib_lower_bound, ib.ib_upper_bound,
       COUNT(DISTINCT sg.c_customer_sk) AS nr_clienti,
       AVG(sg.ltv)         AS ltv_mediu,
       AVG(sg.nr_comenzi)  AS comenzi_medii,
       AVG(sg.ani_activi)  AS ani_activi_medii
FROM segmente sg
JOIN customer c             ON sg.c_customer_sk   = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store_sales ss         ON c.c_customer_sk    = ss.ss_customer_sk
GROUP BY sg.quintila, ca.ca_state, cd.cd_gender, cd.cd_education_status,
         cd.cd_credit_rating, hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound
ORDER BY sg.quintila, nr_clienti DESC
LIMIT 150;

---- Q083
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

---- Q084
SELECT s.s_store_name, s.s_state,
       r.r_reason_desc,
       i.i_category, i.i_brand,
       ca.ca_state, cd.cd_gender, cd.cd_credit_rating,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year, d.d_qoy,
       COUNT(sr.sr_item_sk)  AS nr_retururi,
       SUM(sr.sr_return_amt) AS suma_returnata,
       SUM(sr.sr_net_loss)   AS pierdere_totala,
       RANK() OVER (PARTITION BY s.s_state, d.d_year ORDER BY SUM(sr.sr_net_loss) DESC) AS rank_pierdere_stat
FROM store_returns sr
JOIN store s                ON sr.sr_store_sk     = s.s_store_sk
JOIN item i                 ON sr.sr_item_sk      = i.i_item_sk
JOIN reason r               ON sr.sr_reason_sk    = r.r_reason_sk
JOIN customer c             ON sr.sr_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk  = cd.cd_demo_sk
JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN date_dim d             ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, r.r_reason_desc, i.i_category, i.i_brand,
         ca.ca_state, cd.cd_gender, cd.cd_credit_rating,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year, d.d_qoy
ORDER BY pierdere_totala DESC
LIMIT 100;

---- Q085
WITH lunar_complet AS (
    SELECT s.s_store_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           cd.cd_gender, ib.ib_lower_bound,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)   AS vanzari,
           SUM(ss.ss_net_profit) AS profit
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, cd.cd_gender, ib.ib_lower_bound,
             d.d_year, d.d_moy
)
SELECT s_store_name, s_state, i_category, i_brand, cd_gender,
       ib_lower_bound, d_year, d_moy, vanzari, profit,
       AVG(vanzari) OVER (
           PARTITION BY s_store_name, i_category, i_brand
           ORDER BY d_year, d_moy ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
       ) AS medie_6luni,
       SUM(vanzari) OVER (
           PARTITION BY s_store_name, i_category, d_year
           ORDER BY d_moy ROWS UNBOUNDED PRECEDING
       ) AS vanzari_cumulate_an,
       LAG(vanzari, 12) OVER (
           PARTITION BY s_store_name, i_category, i_brand
           ORDER BY d_year, d_moy
       ) AS vanzari_aceeasi_luna_an_trecut,
       PERCENT_RANK() OVER (
           PARTITION BY s_state, i_category, d_year ORDER BY vanzari
       ) AS percentila_in_stat
FROM lunar_complet
ORDER BY s_store_name, i_category, i_brand, d_year, d_moy
LIMIT 300;

---- Q086
WITH baza AS (
    SELECT s.s_division_name, s.s_company_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           cd.cd_gender, cd.cd_marital_status,
           ib.ib_lower_bound, ib.ib_upper_bound,
           d.d_year, d.d_qoy,
           COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
           SUM(ss.ss_net_paid)               AS total_vanzari,
           SUM(ss.ss_net_profit)             AS profit_total,
           AVG(ss.ss_sales_price)            AS pret_mediu
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_division_name, s.s_company_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, cd.cd_gender, cd.cd_marital_status,
             ib.ib_lower_bound, ib.ib_upper_bound, d.d_year, d.d_qoy
)
SELECT s_division_name, s_company_name, s_state, s_market_manager,
       i_category, i_brand, cd_gender, cd_marital_status,
       ib_lower_bound, ib_upper_bound, d_year, d_qoy,
       clienti_unici, total_vanzari, profit_total, pret_mediu,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year)                              AS total_cat_stat_an,
       RANK()         OVER (PARTITION BY s_state, d_year, d_qoy ORDER BY profit_total DESC)            AS rank_profit_trimestru,
       PERCENT_RANK() OVER (PARTITION BY i_category ORDER BY total_vanzari)                            AS percentila_vanzari_cat
FROM baza
ORDER BY profit_total DESC
LIMIT 100;

---- Q087
WITH complet AS (
    SELECT s.s_store_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           ca.ca_state AS cl_state,
           cd.cd_gender, cd.cd_education_status,
           ib.ib_lower_bound, ib.ib_upper_bound,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)   AS vanzari,
           SUM(ss.ss_net_profit) AS profit,
           COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
           COUNT(*) AS nr_tranzactii
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    GROUP BY s.s_store_name, s.s_state, s.s_market_manager, i.i_category, i.i_brand,
             ca.ca_state, cd.cd_gender, cd.cd_education_status,
             ib.ib_lower_bound, ib.ib_upper_bound, d.d_year, d.d_moy
)
SELECT s_store_name, s_state, i_category, i_brand,
       cd_gender, ib_lower_bound, d_year, d_moy,
       vanzari, profit, clienti_unici, nr_tranzactii,
       SUM(vanzari) OVER (PARTITION BY s_store_name, i_category, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS vanzari_cumulate,
       AVG(vanzari) OVER (PARTITION BY s_store_name, i_category ORDER BY d_year, d_moy ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS medie_6luni,
       LAG(vanzari, 12) OVER (PARTITION BY s_store_name, i_category, i_brand ORDER BY d_year, d_moy) AS vanzari_an_trecut,
       NTILE(10) OVER (PARTITION BY s_state, d_year ORDER BY vanzari DESC) AS decila_stat,
       PERCENT_RANK() OVER (PARTITION BY i_category, d_year ORDER BY profit)  AS percentila_profit
FROM complet
ORDER BY s_store_name, i_category, d_year, d_moy
LIMIT 300;

---- Q088
WITH baza AS (
    SELECT s.s_store_name, s.s_division_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand, i.i_class,
           ca.ca_state, ca.ca_location_type,
           cd.cd_gender, cd.cd_credit_rating,
           hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
           t.t_shift, d.d_year, d.d_qoy, d.d_weekend,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           COUNT(DISTINCT ss.ss_customer_sk)   AS clienti_unici,
           SUM(ss.ss_net_paid)                 AS total_vanzari,
           SUM(ss.ss_net_profit)               AS profit_total,
           AVG(ss.ss_sales_price)              AS pret_mediu,
           SUM(ss.ss_ext_discount_amt)         AS discount_total,
           SUM(ss.ss_coupon_amt)               AS cupoane_total
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_division_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, i.i_class,
             ca.ca_state, ca.ca_location_type,
             cd.cd_gender, cd.cd_credit_rating,
             hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
             t.t_shift, d.d_year, d.d_qoy, d.d_weekend
)
SELECT s_store_name, s_division_name, s_state, s_market_manager,
       i_category, i_brand, i_class,
       ca_state, ca_location_type,
       cd_gender, cd_credit_rating,
       hd_buy_potential, ib_lower_bound, ib_upper_bound,
       t_shift, d_year, d_qoy, d_weekend,
       nr_comenzi, clienti_unici, total_vanzari, profit_total,
       pret_mediu, discount_total, cupoane_total,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year)               AS total_cat_stat_an,
       RANK()         OVER (PARTITION BY s_state, d_year, d_qoy ORDER BY profit_total DESC) AS rank_profit_trimestru,
       PERCENT_RANK() OVER (PARTITION BY i_category, d_year ORDER BY total_vanzari)        AS percentila_vanzari_cat
FROM baza
ORDER BY profit_total DESC
LIMIT 100;

---- Q089
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

---- Q090
SELECT i.i_category, d.d_weekend,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       COUNT(*)                          AS nr_tranzactii,
       SUM(ss.ss_net_paid)               AS total_vanzari
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk  = c.c_customer_sk
GROUP BY i.i_category, d.d_weekend
ORDER BY total_vanzari DESC;

---- Q091
SELECT s.s_hours, t.t_shift, t.t_sub_shift,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_quantity)        AS cantitate_medie
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_hours, t.t_shift, t.t_sub_shift
ORDER BY total_vanzari DESC;

---- Q092
SELECT i.i_category, i.i_brand,
       CASE WHEN ss.ss_promo_sk IS NOT NULL THEN 'CU PROMOTIE' ELSE 'FARA PROMOTIE' END AS tip_vanzare,
       d.d_year,
       COUNT(*)            AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
GROUP BY i.i_category, i.i_brand,
         CASE WHEN ss.ss_promo_sk IS NOT NULL THEN 'CU PROMOTIE' ELSE 'FARA PROMOTIE' END,
         d.d_year
ORDER BY i.i_category, tip_vanzare, d.d_year
LIMIT 200;

---- Q093
SELECT i.i_brand, d.d_day_name, s.s_store_name,
       COUNT(*)                       AS nr_tranzactii_cu_discount,
       SUM(ss.ss_ext_discount_amt)    AS discount_total,
       AVG(ss.ss_ext_discount_amt)    AS discount_mediu,
       SUM(ss.ss_net_paid)            AS total_vanzari_nete
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
WHERE ss.ss_ext_discount_amt > 0
GROUP BY i.i_brand, d.d_day_name, s.s_store_name
ORDER BY discount_total DESC
LIMIT 100;

---- Q094
SELECT ca.ca_location_type, ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_quantity)               AS cantitate_medie
FROM store_sales ss
JOIN customer c          ON ss.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib       ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i               ON ss.ss_item_sk        = i.i_item_sk
JOIN date_dim d           ON ss.ss_sold_date_sk   = d.d_date_sk
GROUP BY ca.ca_location_type, ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q095
WITH prod_stat AS (
    SELECT s.s_state, i.i_product_name, i.i_category, d.d_year,
           SUM(ss.ss_net_paid) AS total_vanzari,
           COUNT(*) AS nr_tranzactii
    FROM store_sales ss
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_state, i.i_product_name, i.i_category, d.d_year
)
SELECT s_state, i_product_name, i_category, d_year, total_vanzari,
       RANK() OVER (PARTITION BY s_state, d_year ORDER BY total_vanzari DESC) AS rank_in_stat,
       LAG(total_vanzari) OVER (PARTITION BY s_state, i_product_name ORDER BY d_year) AS vanzari_an_trecut
FROM prod_stat
ORDER BY s_state, d_year, rank_in_stat
LIMIT 200;

---- Q096
SELECT p.p_channel_email, p.p_channel_tv, p.p_channel_radio,
       cd.cd_gender, d.d_year,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_coupon_amt)      AS total_cupoane,
       ROUND(SUM(ss.ss_coupon_amt) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS pct_cupon
FROM store_sales ss
JOIN promotion p              ON ss.ss_promo_sk  = p.p_promo_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk  = cd.cd_demo_sk
JOIN date_dim d               ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s                  ON ss.ss_store_sk  = s.s_store_sk
GROUP BY p.p_channel_email, p.p_channel_tv, p.p_channel_radio,
         cd.cd_gender, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q097
SELECT hd.hd_dep_count, hd.hd_vehicle_count, i.i_category, d.d_year, d.d_qoy,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)               AS total_vanzari,
       AVG(ss.ss_sales_price)            AS pret_mediu
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk     = hd.hd_demo_sk
JOIN item i                    ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d                ON ss.ss_sold_date_sk  = d.d_date_sk
JOIN store s                   ON ss.ss_store_sk      = s.s_store_sk
GROUP BY hd.hd_dep_count, hd.hd_vehicle_count, i.i_category, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q098
SELECT s.s_market_id, s.s_market_manager, i.i_manufact, d.d_year,
       COUNT(DISTINCT s.s_store_sk)     AS nr_magazine,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid)              AS total_vanzari,
       SUM(ss.ss_net_profit)            AS profit_total
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_market_id, s.s_market_manager, i.i_manufact, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q099
SELECT i.i_color, i.i_container, i.i_units,
       s.s_state, cd.cd_gender, d.d_year,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_color, i.i_container, i.i_units, s.s_state, cd.cd_gender, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q100
SELECT c.c_preferred_cust_flag,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, d.d_year,
       COUNT(DISTINCT c.c_customer_sk)  AS nr_clienti,
       SUM(ss.ss_net_paid)              AS total_vanzari,
       AVG(ss.ss_net_paid)              AS val_medie_tranzactie,
       SUM(ss.ss_net_profit)            AS profit_total
FROM store_sales ss
JOIN customer c             ON ss.ss_customer_sk  = c.c_customer_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
WHERE c.c_preferred_cust_flag IS NOT NULL
GROUP BY c.c_preferred_cust_flag, ib.ib_lower_bound, ib.ib_upper_bound,
         i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q101
SELECT s.s_hours, i.i_category, ca.ca_state, d.d_year, d.d_qoy,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       COUNT(*)                          AS nr_tranzactii,
       SUM(ss.ss_net_paid)               AS total_vanzari
FROM store_sales ss
JOIN store s             ON ss.ss_store_sk    = s.s_store_sk
JOIN item i              ON ss.ss_item_sk     = i.i_item_sk
JOIN customer c          ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d          ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_hours, i.i_category, ca.ca_state, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q102
SELECT i.i_brand, cd.cd_credit_rating, p.p_purpose, d.d_year,
       COUNT(*)                                       AS nr_tranzactii,
       SUM(ss.ss_net_paid)                            AS total_vanzari,
       SUM(ss.ss_net_profit)                          AS profit_total,
       ROUND(SUM(ss.ss_net_profit)/NULLIF(SUM(ss.ss_net_paid),0)*100, 2) AS marja_pct
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk    = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
LEFT JOIN promotion p       ON ss.ss_promo_sk   = p.p_promo_sk
JOIN store s                ON ss.ss_store_sk   = s.s_store_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, cd.cd_credit_rating, p.p_purpose, d.d_year
ORDER BY marja_pct DESC
LIMIT 100;

---- Q103
SELECT i.i_category, ib.ib_lower_bound, ib.ib_upper_bound,
       ca.ca_state, d.d_day_name, d.d_weekend,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk       = i.i_item_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk  = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN customer c             ON ss.ss_customer_sk   = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d             ON ss.ss_sold_date_sk  = d.d_date_sk
GROUP BY i.i_category, ib.ib_lower_bound, ib.ib_upper_bound,
         ca.ca_state, d.d_day_name, d.d_weekend
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q104
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

---- Q105
WITH ltv AS (
    SELECT ss.ss_customer_sk,
           SUM(ss.ss_net_paid) AS total,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           NTILE(4) OVER (ORDER BY SUM(ss.ss_net_paid) DESC) AS quartila
    FROM store_sales ss
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    GROUP BY ss.ss_customer_sk
)
SELECT lt.quartila,
       CASE lt.quartila WHEN 1 THEN 'PREMIUM' WHEN 2 THEN 'HIGH'
                        WHEN 3 THEN 'MED' ELSE 'BASIC' END AS segment,
       ca.ca_state, cd.cd_gender, cd.cd_marital_status,
       ib.ib_lower_bound, ib.ib_upper_bound,
       COUNT(DISTINCT lt.ss_customer_sk) AS nr_clienti,
       AVG(lt.total)     AS ltv_mediu,
       AVG(lt.nr_comenzi) AS comenzi_medii
FROM ltv lt
JOIN customer c             ON lt.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
GROUP BY lt.quartila, ca.ca_state, cd.cd_gender, cd.cd_marital_status,
         ib.ib_lower_bound, ib.ib_upper_bound
ORDER BY lt.quartila, nr_clienti DESC
LIMIT 150;

---- Q106
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

---- Q107
SELECT p.p_promo_name, p.p_purpose, i.i_category, i.i_brand,
       s.s_state, cd.cd_gender, ib.ib_lower_bound,
       d.d_year, d.d_qoy,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       SUM(ss.ss_coupon_amt)  AS cupoane_total,
       SUM(ss.ss_net_profit)  AS profit_total
FROM store_sales ss
JOIN promotion p               ON ss.ss_promo_sk   = p.p_promo_sk
JOIN item i                    ON ss.ss_item_sk     = i.i_item_sk
JOIN store s                   ON ss.ss_store_sk    = s.s_store_sk
JOIN customer_demographics cd  ON ss.ss_cdemo_sk   = cd.cd_demo_sk
JOIN household_demographics hd ON ss.ss_hdemo_sk   = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN date_dim d                ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_category, i.i_brand,
         s.s_state, cd.cd_gender, ib.ib_lower_bound, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;

---- Q108
WITH scor AS (
    SELECT c.c_customer_sk,
           SUM(ss.ss_net_paid)                    AS total_cumparat,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           SUM(ss.ss_coupon_amt)               AS cupoane_folosite,
           COUNT(DISTINCT d.d_year)            AS ani_activi
    FROM store_sales ss
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    GROUP BY c.c_customer_sk
)
SELECT c.c_customer_id, ca.ca_state, ca.ca_city,
       cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       sc.total_cumparat, sc.nr_comenzi, sc.cupoane_folosite, sc.ani_activi,
       ROUND(sc.total_cumparat / NULLIF(sc.nr_comenzi, 0), 2) AS val_medie_comanda,
       NTILE(5) OVER (ORDER BY sc.total_cumparat DESC) AS quintila_ltv,
       RANK()   OVER (PARTITION BY ca.ca_state ORDER BY sc.total_cumparat DESC) AS rank_stat
FROM scor sc
JOIN customer c             ON sc.c_customer_sk   = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
ORDER BY sc.total_cumparat DESC
LIMIT 200;

---- Q109
WITH baza AS (
    SELECT s.s_store_name, s.s_state, s.s_division_name,
           i.i_category, i.i_brand,
           ca.ca_state, ca.ca_location_type,
           cd.cd_gender, cd.cd_credit_rating,
           hd.hd_buy_potential, ib.ib_lower_bound,
           p.p_purpose,
           t.t_shift,
           d.d_year, d.d_qoy,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           COUNT(DISTINCT ss.ss_customer_sk)   AS clienti_unici,
           SUM(ss.ss_net_paid)                 AS total_vanzari,
           SUM(ss.ss_net_profit)               AS profit_total,
           SUM(ss.ss_coupon_amt)               AS cupoane_total,
           SUM(ss.ss_ext_discount_amt)         AS discount_total
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    LEFT JOIN promotion p       ON ss.ss_promo_sk    = p.p_promo_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_state, s.s_division_name, i.i_category, i.i_brand,
             ca.ca_state, ca.ca_location_type, cd.cd_gender, cd.cd_credit_rating,
             hd.hd_buy_potential, ib.ib_lower_bound, p.p_purpose, t.t_shift,
             d.d_year, d.d_qoy
)
SELECT s_store_name, s_state, s_division_name, i_category, i_brand,
       ca_state, ca_location_type, cd_gender, cd_credit_rating,
       hd_buy_potential, ib_lower_bound, p_purpose, t_shift, d_year, d_qoy,
       nr_comenzi, clienti_unici, total_vanzari, profit_total, cupoane_total, discount_total,
       SUM(total_vanzari) OVER (PARTITION BY s_state, i_category, d_year) AS total_cat_stat_an,
       RANK() OVER (PARTITION BY s_state, d_year ORDER BY profit_total DESC)  AS rank_profit
FROM baza
ORDER BY profit_total DESC
LIMIT 100;

---- Q110
WITH ltv_store AS (
    SELECT ss.ss_customer_sk,
           SUM(ss.ss_net_paid)                    AS total_store,
           COUNT(DISTINCT ss.ss_ticket_number) AS comenzi_store,
           COUNT(DISTINCT ss.ss_store_sk)      AS magazine_vizitate,
           COUNT(DISTINCT ss.ss_item_sk)       AS produse_distincte
    FROM store_sales ss GROUP BY ss.ss_customer_sk
),
retururi AS (
    SELECT sr.sr_customer_sk,
           SUM(sr.sr_return_amt)               AS val_retururi,
           COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi
    FROM store_returns sr GROUP BY sr.sr_customer_sk
)
SELECT c.c_customer_id, c.c_first_name || ' ' || c.c_last_name AS nume,
       ca.ca_state, ca.ca_city, ca.ca_location_type,
       cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating,
       hd.hd_buy_potential, hd.hd_dep_count,
       ib.ib_lower_bound, ib.ib_upper_bound,
       ls.total_store, ls.comenzi_store, ls.magazine_vizitate, ls.produse_distincte,
       COALESCE(r.val_retururi, 0)  AS val_retururi,
       COALESCE(r.nr_retururi, 0)   AS nr_retururi,
       ROUND(COALESCE(r.val_retururi, 0) / NULLIF(ls.total_store, 0) * 100, 2) AS pct_returnat,
       ROUND(ls.total_store / NULLIF(ls.comenzi_store, 0), 2) AS val_medie_comanda,
       NTILE(5)     OVER (ORDER BY ls.total_store DESC) AS quintila,
       ROW_NUMBER() OVER (PARTITION BY ca.ca_state ORDER BY ls.total_store DESC) AS rank_in_stat,
       PERCENT_RANK() OVER (PARTITION BY cd.cd_education_status ORDER BY ls.total_store) AS percentila_edu
FROM ltv_store ls
JOIN customer c             ON ls.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store_sales ss         ON c.c_customer_sk    = ss.ss_customer_sk
JOIN store s                ON ss.ss_store_sk     = s.s_store_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
LEFT JOIN retururi r        ON ls.ss_customer_sk  = r.sr_customer_sk
WHERE ls.total_store > 0
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name,
         ca.ca_state, ca.ca_city, ca.ca_location_type,
         cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating,
         hd.hd_buy_potential, hd.hd_dep_count, ib.ib_lower_bound, ib.ib_upper_bound,
         ls.total_store, ls.comenzi_store, ls.magazine_vizitate, ls.produse_distincte,
         r.val_retururi, r.nr_retururi
ORDER BY ls.total_store DESC
LIMIT 200;

---- Q111
WITH lunar AS (
    SELECT s.s_store_name, s.s_state, s.s_market_manager,
           i.i_category, i.i_brand,
           ca.ca_state AS cl_state,
           cd.cd_gender, cd.cd_credit_rating,
           hd.hd_buy_potential, ib.ib_lower_bound,
           d.d_year, d.d_moy,
           SUM(ss.ss_net_paid)                    AS vanzari,
           SUM(ss.ss_net_profit)                  AS profit,
           COUNT(DISTINCT ss.ss_customer_sk)      AS clienti_unici,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           SUM(ss.ss_ext_discount_amt)            AS discount_total
    FROM store_sales ss
    JOIN store s                ON ss.ss_store_sk    = s.s_store_sk
    JOIN item i                 ON ss.ss_item_sk     = i.i_item_sk
    JOIN customer c             ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
    JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
    JOIN time_dim t             ON ss.ss_sold_time_sk = t.t_time_sk
    JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
    GROUP BY s.s_store_name, s.s_state, s.s_market_manager,
             i.i_category, i.i_brand, ca.ca_state,
             cd.cd_gender, cd.cd_credit_rating,
             hd.hd_buy_potential, ib.ib_lower_bound,
             d.d_year, d.d_moy
)
SELECT s_store_name, s_state, i_category, i_brand,
       cl_state, cd_gender, ib_lower_bound,
       d_year, d_moy,
       vanzari, profit, clienti_unici, nr_comenzi, discount_total,
       SUM(vanzari) OVER (
           PARTITION BY s_store_name, i_category, d_year
           ORDER BY d_moy ROWS UNBOUNDED PRECEDING
       ) AS vanzari_cumulate_an,
       AVG(vanzari) OVER (
           PARTITION BY s_store_name, i_category
           ORDER BY d_year, d_moy ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
       ) AS medie_mobila_6luni,
       LAG(vanzari, 12) OVER (
           PARTITION BY s_store_name, i_category, i_brand
           ORDER BY d_year, d_moy
       ) AS vanzari_aceeasi_luna_an_trecut,
       ROUND((vanzari - LAG(vanzari, 12) OVER (
           PARTITION BY s_store_name, i_category, i_brand ORDER BY d_year, d_moy
       )) / NULLIF(LAG(vanzari, 12) OVER (
           PARTITION BY s_store_name, i_category, i_brand ORDER BY d_year, d_moy
       ), 0) * 100, 2) AS crestere_yoy_pct,
       NTILE(10) OVER (PARTITION BY s_state, d_year ORDER BY vanzari DESC) AS decila_stat,
       RANK()    OVER (PARTITION BY s_state, i_category, d_year ORDER BY profit DESC) AS rank_profit,
       PERCENT_RANK() OVER (PARTITION BY i_category, d_year ORDER BY vanzari) AS percentila_cat
FROM lunar
ORDER BY s_store_name, i_category, d_year, d_moy
LIMIT 300;

---- Q112
SELECT i_product_name, i_category, i_brand, i_current_price, i_wholesale_cost
FROM item
ORDER BY i_current_price DESC
LIMIT 100;

---- Q113
SELECT s_state, s_country,
       COUNT(*) AS nr_magazine,
       AVG(s_number_employees) AS angajati_mediu,
       SUM(s_floor_space) AS suprafata_totala
FROM store
GROUP BY s_state, s_country
ORDER BY nr_magazine DESC;

---- Q114
SELECT c_birth_year,
       COUNT(*) AS nr_clienti,
       COUNT(DISTINCT c_birth_country) AS tari_distincte
FROM customer
WHERE c_birth_year IS NOT NULL
GROUP BY c_birth_year
ORDER BY c_birth_year;

---- Q115
SELECT COUNT(*) AS total_tranzactii,
       SUM(ws_net_paid) AS total_incasat,
       AVG(ws_net_paid) AS medie_tranzactie,
       SUM(ws_net_profit) AS profit_total,
       MIN(ws_sales_price) AS pret_minim,
       MAX(ws_sales_price) AS pret_maxim
FROM web_sales;

---- Q116
SELECT i_category,
       COUNT(*) AS nr_produse,
       AVG(i_current_price) AS pret_mediu,
       MIN(i_current_price) AS pret_minim,
       MAX(i_current_price) AS pret_maxim,
       AVG(i_wholesale_cost) AS cost_mediu
FROM item
GROUP BY i_category
ORDER BY nr_produse DESC;

---- Q117
SELECT sr_reason_sk,
       COUNT(*) AS nr_retururi,
       SUM(sr_return_amt) AS valoare_totala_returnata,
       AVG(sr_return_amt) AS valoare_medie_retur,
       SUM(sr_net_loss) AS pierdere_neta_totala
FROM store_returns
GROUP BY sr_reason_sk
ORDER BY nr_retururi DESC;

---- Q118
SELECT cd_gender, cd_marital_status,
       COUNT(*) AS nr_persoane,
       AVG(cd_purchase_estimate) AS estimare_medie_achizitii,
       AVG(cd_dep_count) AS nr_mediu_dependenti
FROM customer_demographics
GROUP BY cd_gender, cd_marital_status
ORDER BY nr_persoane DESC;

---- Q119
SELECT ws_item_sk, ws_bill_customer_sk,
       ws_quantity, ws_sales_price, ws_net_paid, ws_net_profit
FROM web_sales
WHERE ws_quantity > 5 AND ws_net_profit < 0
ORDER BY ws_net_profit ASC
LIMIT 200;

---- Q120
SELECT cr_warehouse_sk,
       COUNT(*) AS nr_retururi,
       SUM(cr_return_amount) AS total_returnat,
       SUM(cr_net_loss) AS pierdere_neta,
       AVG(cr_return_quantity) AS cantitate_medie_returnata
FROM catalog_returns
GROUP BY cr_warehouse_sk
ORDER BY total_returnat DESC;

---- Q121
SELECT p_promo_name, p_purpose, p_discount_active,
       p_channel_email, p_channel_tv, p_channel_radio, p_channel_press,
       p_cost
FROM promotion
WHERE p_discount_active = 'Y'
ORDER BY p_cost DESC
LIMIT 100;

---- Q122
SELECT w_warehouse_name, w_city, w_state, w_country,
       w_warehouse_sq_ft
FROM warehouse
ORDER BY w_warehouse_sq_ft DESC;

---- Q123
SELECT t_shift, t_sub_shift, t_meal_time,
       COUNT(*) AS nr_intervale
FROM time_dim
GROUP BY t_shift, t_sub_shift, t_meal_time
ORDER BY t_shift;

---- Q124
SELECT cs_warehouse_sk,
       COUNT(*) AS nr_tranzactii,
       SUM(cs_net_paid) AS total_incasat,
       SUM(cs_net_profit) AS profit_total,
       AVG(cs_quantity) AS cantitate_medie
FROM catalog_sales
GROUP BY cs_warehouse_sk
ORDER BY total_incasat DESC;

---- Q125
SELECT ca_location_type, ca_state,
       COUNT(*) AS nr_adrese
FROM customer_address
GROUP BY ca_location_type, ca_state
ORDER BY nr_adrese DESC
LIMIT 100;

---- Q126
SELECT ss_ticket_number, ss_item_sk, ss_store_sk,
       ss_coupon_amt, ss_net_paid, ss_net_profit
FROM store_sales
WHERE ss_coupon_amt > 0
ORDER BY ss_coupon_amt DESC
LIMIT 200;

---- Q127
SELECT inv_warehouse_sk,
       COUNT(DISTINCT inv_item_sk) AS produse_distincte,
       AVG(inv_quantity_on_hand) AS stoc_mediu,
       SUM(inv_quantity_on_hand) AS stoc_total,
       MIN(inv_quantity_on_hand) AS stoc_minim,
       MAX(inv_quantity_on_hand) AS stoc_maxim
FROM inventory
GROUP BY inv_warehouse_sk
ORDER BY stoc_total DESC;

---- Q128
SELECT i.i_category, i.i_brand,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY i.i_category, i.i_brand
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q129
SELECT i.i_manufact, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY i.i_manufact, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q130
SELECT r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
GROUP BY r.r_reason_desc
ORDER BY nr_retururi DESC;

---- Q131
SELECT d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy;

---- Q132
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(*) AS nr_comenzi,
       SUM(cs.cs_net_paid) AS total_cheltuit
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q133
SELECT r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       AVG(sr.sr_return_amt) AS retur_mediu,
       SUM(sr.sr_net_loss) AS pierdere_totala
FROM store_returns sr
JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk
GROUP BY r.r_reason_desc
ORDER BY nr_retururi DESC;

---- Q134
SELECT sm.sm_type, sm.sm_carrier,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare_total,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_ext_ship_cost) AS cost_mediu_livrare
FROM catalog_sales cs
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
GROUP BY sm.sm_type, sm.sm_carrier
ORDER BY total_vanzari DESC;

---- Q135
SELECT w.w_warehouse_name, w.w_state, i.i_category,
       SUM(inv.inv_quantity_on_hand) AS stoc_total,
       COUNT(DISTINCT inv.inv_item_sk) AS produse_distincte,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN item i ON inv.inv_item_sk = i.i_item_sk
GROUP BY w.w_warehouse_name, w.w_state, i.i_category
ORDER BY stoc_total DESC
LIMIT 100;

---- Q136
SELECT wp.wp_type, wp.wp_url,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
GROUP BY wp.wp_type, wp.wp_url
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q137
SELECT cc.cc_name, cc.cc_city, cc.cc_state,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
GROUP BY cc.cc_name, cc.cc_city, cc.cc_state
ORDER BY nr_retururi DESC;

---- Q138
SELECT ws_site.web_name, ws_site.web_class, ws_site.web_manager,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
GROUP BY ws_site.web_name, ws_site.web_class, ws_site.web_manager
ORDER BY total_vanzari DESC;

---- Q139
SELECT cp.cp_department, cp.cp_type,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
GROUP BY cp.cp_department, cp.cp_type
ORDER BY total_vanzari DESC;

---- Q140
SELECT cd.cd_gender, cd.cd_marital_status,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_gender, cd.cd_marital_status
ORDER BY total_vanzari DESC;

---- Q141
SELECT d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total,
       AVG(cs.cs_quantity) AS cantitate_medie
FROM catalog_sales cs
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY d.d_year
ORDER BY d.d_year;

---- Q142
SELECT i.i_category, i.i_brand, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN item i ON cr.cr_item_sk = i.i_item_sk
JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk
GROUP BY i.i_category, i.i_brand, r.r_reason_desc
ORDER BY nr_retururi DESC
LIMIT 100;

---- Q143
SELECT ca.ca_state, ca.ca_country,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
GROUP BY ca.ca_state, ca.ca_country
ORDER BY total_vanzari DESC
LIMIT 50;

---- Q144
SELECT i.i_brand, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy, total_vanzari DESC
LIMIT 200;

---- Q145
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_totala
FROM web_returns wr
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
HAVING COUNT(*) > 3
ORDER BY nr_retururi DESC
LIMIT 100;

---- Q146
SELECT d.d_year, d.d_moy,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_moy
ORDER BY d.d_year, d.d_moy;

---- Q147
SELECT s.s_store_name, s.s_state, d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year
ORDER BY pierdere_neta DESC;

---- Q148
SELECT w.w_warehouse_name, d.d_year, d.d_moy,
       SUM(inv.inv_quantity_on_hand) AS stoc_total,
       COUNT(DISTINCT inv.inv_item_sk) AS produse_in_stoc,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, d.d_year, d.d_moy
ORDER BY w.w_warehouse_name, d.d_year, d.d_moy;

---- Q149
SELECT sm.sm_type, sm.sm_carrier,
       COUNT(*) AS nr_livrari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare_total,
       SUM(ws.ws_net_paid) AS total_vanzari
FROM web_sales ws
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
GROUP BY sm.sm_type, sm.sm_carrier
ORDER BY total_vanzari DESC;

---- Q150
SELECT w.w_warehouse_name, w.w_state, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY w.w_warehouse_name, w.w_state, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q151
SELECT c.c_customer_id, c.c_first_name, c.c_last_name,
       COUNT(DISTINCT ss.ss_ticket_number) AS comenzi_store,
       SUM(ss.ss_net_paid) AS total_store
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE EXISTS (
    SELECT 1 FROM web_sales ws
    WHERE ws.ws_bill_customer_sk = c.c_customer_sk
)
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name
ORDER BY total_store DESC
LIMIT 100;

---- Q152
SELECT ca.ca_state,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare_total,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer c ON cs.cs_ship_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
GROUP BY ca.ca_state
ORDER BY total_vanzari DESC;

---- Q153
SELECT d.d_year, d.d_qoy,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta,
       AVG(wr.wr_return_quantity) AS cantitate_medie
FROM web_returns wr
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy;

---- Q154
SELECT i.i_product_name, i.i_category, i.i_brand,
       COUNT(*) AS nr_vanzari_web,
       SUM(ws.ws_net_paid) AS total_web
FROM web_sales ws
JOIN item i ON ws.ws_item_sk = i.i_item_sk
WHERE NOT EXISTS (
    SELECT 1 FROM store_sales ss
    WHERE ss.ss_item_sk = i.i_item_sk
)
GROUP BY i.i_product_name, i.i_category, i.i_brand
ORDER BY total_web DESC
LIMIT 100;

---- Q155
SELECT d.d_day_name, d.d_dow,
       COUNT(*) AS nr_tranzactii_store,
       SUM(ss.ss_net_paid) AS total_store
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_day_name, d.d_dow
ORDER BY d.d_dow;

---- Q156
SELECT cc.cc_name, cc.cc_manager, cc.cc_state,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY cc.cc_name, cc.cc_manager, cc.cc_state
ORDER BY total_vanzari DESC;

---- Q157
SELECT i.i_product_name, i.i_category,
       SUM(ss.ss_ext_discount_amt) AS discount_total,
       SUM(ss.ss_net_paid) AS total_vanzari,
       ROUND(SUM(ss.ss_ext_discount_amt) / NULLIF(SUM(ss.ss_ext_list_price), 0) * 100, 2) AS pct_discount
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE ss.ss_ext_discount_amt > 0
GROUP BY i.i_product_name, i.i_category
ORDER BY discount_total DESC
LIMIT 100;

---- Q158
SELECT d.d_year, d.d_qoy, d.d_weekend,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy, d.d_weekend
ORDER BY d.d_year, d.d_qoy, d.d_weekend;

---- Q159
SELECT hd.hd_buy_potential, hd.hd_dep_count,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
GROUP BY hd.hd_buy_potential, hd.hd_dep_count
ORDER BY total_vanzari DESC;

---- Q160
SELECT i.i_brand, i.i_category,
       SUM(cs.cs_coupon_amt) AS total_cupoane,
       SUM(cs.cs_net_paid) AS total_vanzari,
       ROUND(SUM(cs.cs_coupon_amt) / NULLIF(SUM(cs.cs_net_paid), 0) * 100, 2) AS pct_cupon,
       COUNT(*) AS nr_tranzactii
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
WHERE cs.cs_coupon_amt > 0
GROUP BY i.i_brand, i.i_category
ORDER BY total_cupoane DESC
LIMIT 100;

---- Q161
SELECT i.i_product_name, i.i_category,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN item i ON sr.sr_item_sk = i.i_item_sk
GROUP BY i.i_product_name, i.i_category
ORDER BY nr_retururi DESC
LIMIT 100;

---- Q162
SELECT ca.ca_state, i.i_category, w.w_warehouse_name,
       cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       COUNT(DISTINCT cs.cs_bill_customer_sk) AS clienti_unici
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, w.w_warehouse_name,
         cd.cd_gender, cd.cd_education_status,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q163
SELECT i.i_product_name, i.i_category, i.i_brand,
       i.i_current_price, i.i_wholesale_cost,
       COUNT(ss.ss_item_sk) AS nr_vanzari,
       SUM(ss.ss_net_paid) AS total_vanzari
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE i.i_current_price < i.i_wholesale_cost * 1.1
  AND i.i_wholesale_cost > 0
GROUP BY i.i_product_name, i.i_category, i.i_brand,
         i.i_current_price, i.i_wholesale_cost
ORDER BY nr_vanzari DESC
LIMIT 100;

---- Q164
SELECT i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total,
       AVG(ws.ws_quantity) AS cantitate_medie
FROM web_sales ws
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY i.i_category, d.d_year
ORDER BY i.i_category, d.d_year;

---- Q165
SELECT p.p_promo_name, p.p_channel_tv, p.p_channel_email, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_channel_tv, p.p_channel_email, d.d_year
ORDER BY d.d_year, total_vanzari DESC
LIMIT 100;

---- Q166
SELECT wp.wp_type, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY wp.wp_type, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q167
SELECT sm.sm_type, sm.sm_carrier, d.d_year,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare
FROM catalog_sales cs
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY sm.sm_type, sm.sm_carrier, d.d_year
ORDER BY d.d_year, total_vanzari DESC;

---- Q168
SELECT i.i_class, i.i_manufact,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_class, i.i_manufact
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q169
SELECT i.i_category, i.i_brand, d.d_year, d.d_moy,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY i.i_category, i.i_brand, d.d_year, d.d_moy
ORDER BY pierdere_neta DESC
LIMIT 200;

---- Q170
SELECT s.s_store_name, s.s_state,
       AVG(ss.ss_sales_price) AS pret_mediu_vanzare,
       AVG(ss.ss_list_price) AS pret_mediu_lista,
       ROUND(AVG(ss.ss_sales_price) / NULLIF(AVG(ss.ss_list_price), 0) * 100, 2) AS pct_din_lista,
       COUNT(*) AS nr_tranzactii
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
GROUP BY s.s_store_name, s.s_state
ORDER BY pct_din_lista ASC;

---- Q171
SELECT w.w_warehouse_name, d.d_year, d.d_moy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, d.d_year, d.d_moy
ORDER BY w.w_warehouse_name, d.d_year, d.d_moy;

---- Q172
SELECT cd.cd_credit_rating,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_net_paid) AS valoare_medie
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_credit_rating
ORDER BY total_vanzari DESC;

---- Q173
SELECT t.t_hour, t.t_shift, t.t_am_pm,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk
GROUP BY t.t_hour, t.t_shift, t.t_am_pm
ORDER BY t.t_hour;

---- Q174
SELECT i.i_product_name, i.i_category,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta,
       AVG(cr.cr_return_quantity) AS cantitate_medie
FROM catalog_returns cr
JOIN item i ON cr.cr_item_sk = i.i_item_sk
GROUP BY i.i_product_name, i.i_category
HAVING SUM(cr.cr_net_loss) > 100
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q175
SELECT s.s_state, d.d_year, d.d_moy,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_store_sk) AS magazine_active
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_state, d.d_year, d.d_moy
ORDER BY s.s_state, d.d_year, d.d_moy;

---- Q176
SELECT ws_site.web_name, ws_site.web_market_manager, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, ws_site.web_market_manager, d.d_year
ORDER BY d.d_year, total_vanzari DESC;

---- Q177
SELECT ca.ca_state, s.s_store_name, r.r_reason_desc,
       cd.cd_gender, cd.cd_marital_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year,
       COUNT(DISTINCT sr.sr_customer_sk) AS clienti_cu_retururi,
       COUNT(*) AS total_retururi,
       SUM(sr.sr_return_amt) AS valoare_returnata
FROM store_returns sr
JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, s.s_store_name, r.r_reason_desc,
         cd.cd_gender, cd.cd_marital_status,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year
ORDER BY total_retururi DESC
LIMIT 100;

---- Q178
SELECT cd.cd_gender, cd.cd_education_status, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, cd.cd_education_status, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q179
SELECT s.s_store_name, s.s_state, d.d_year, d.d_qoy,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;

---- Q180
SELECT d.d_weekend, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY d.d_weekend, i.i_category
ORDER BY i.i_category, d.d_weekend;

---- Q181
SELECT cc.cc_name, cc.cc_state, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cc.cc_name, cc.cc_state, d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy, total_vanzari DESC;

---- Q182
SELECT i.i_color, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_color, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q183
SELECT c.c_birth_month, ca.ca_state, i.i_category, d.d_year,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_net_paid) AS valoare_medie
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE c.c_birth_month IS NOT NULL
GROUP BY c.c_birth_month, ca.ca_state, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q184
SELECT i.i_size, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE i.i_size IS NOT NULL
GROUP BY i.i_size, i.i_category
ORDER BY total_vanzari DESC;

---- Q185
SELECT ca.ca_state, i.i_category, d.d_year,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q186
SELECT ca.ca_state, i.i_brand, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_brand, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 200;

---- Q187
SELECT s.s_store_name, i.i_category, r.r_reason_desc, d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN item i ON sr.sr_item_sk = i.i_item_sk
JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, i.i_category, r.r_reason_desc, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q188
SELECT cd.cd_gender, cd.cd_education_status, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY cd.cd_gender, cd.cd_education_status, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q189
SELECT cd.cd_gender, cd.cd_marital_status,
       ws_site.web_name, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_marital_status, ws_site.web_name, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q190
SELECT s.s_manager, s.s_state, i.i_category, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_manager, s.s_state, i.i_category, d.d_year, d.d_qoy
ORDER BY profit_total DESC
LIMIT 100;

---- Q191
SELECT ca.ca_state, cc.cc_name, d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, cc.cc_name, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q192
SELECT ca.ca_state, i.i_category, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
GROUP BY ca.ca_state, i.i_category, r.r_reason_desc
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q193
SELECT t.t_hour, t.t_shift, s.s_store_name, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY t.t_hour, t.t_shift, s.s_store_name, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 200;

---- Q194
SELECT w.w_warehouse_name, w.w_state, sm.sm_type, sm.sm_carrier, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare_total
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, w.w_state, sm.sm_type, sm.sm_carrier, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q195
SELECT p.p_promo_name, p.p_purpose, i.i_category, s.s_store_name, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_category, s.s_store_name, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q196
SELECT ws_site.web_name, sm.sm_type, sm.sm_carrier, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, sm.sm_type, sm.sm_carrier, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q197
SELECT s.s_store_name, s.s_state, i.i_category, d.d_year,
       SUM(ss.ss_net_paid) AS vanzari_totale,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_store_name, s.s_state, i.i_category, d.d_year
HAVING SUM(ss.ss_net_profit) < 0
ORDER BY profit_total ASC
LIMIT 100;

---- Q198
SELECT hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari
FROM catalog_sales cs
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q199
SELECT cd.cd_gender, hd.hd_buy_potential,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q200
SELECT w.w_warehouse_name, i.i_category, d.d_year, d.d_moy,
       SUM(inv.inv_quantity_on_hand) AS stoc_total,
       COUNT(DISTINCT inv.inv_item_sk) AS produse_in_stoc,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN item i ON inv.inv_item_sk = i.i_item_sk
JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, i.i_category, d.d_year, d.d_moy
ORDER BY w.w_warehouse_name, i.i_category, d.d_year, d.d_moy
LIMIT 200;

---- Q201
SELECT ca.ca_state, p.p_purpose, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY ca.ca_state, p.p_purpose, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q202
SELECT ca.ca_state, w.w_warehouse_name, sm.sm_type,
       COUNT(*) AS nr_livrari,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare,
       AVG(cs.cs_ext_ship_cost) AS cost_mediu_livrare
FROM catalog_sales cs
JOIN customer c ON cs.cs_ship_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
GROUP BY ca.ca_state, w.w_warehouse_name, sm.sm_type
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q203
SELECT ws_site.web_name, i.i_category, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN web_sales ws ON wr.wr_item_sk = ws.ws_item_sk AND wr.wr_order_number = ws.ws_order_number
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
GROUP BY ws_site.web_name, i.i_category, r.r_reason_desc
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q204
SELECT c.c_customer_id, ca.ca_state, s.s_store_name,
       i.i_category,
       COUNT(*) AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY c.c_customer_id, ca.ca_state, s.s_store_name, i.i_category
HAVING SUM(ss.ss_net_paid) > 500
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q205
SELECT cp.cp_department, cp.cp_type, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cp.cp_department, cp.cp_type, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q206
SELECT wp.wp_type, ca.ca_state, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici
FROM web_sales ws
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY wp.wp_type, ca.ca_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q207
SELECT cd.cd_gender, cd.cd_education_status,
       i.i_category, s.s_store_name,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN item i ON sr.sr_item_sk = i.i_item_sk
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_education_status, i.i_category, s.s_store_name
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q208
SELECT w.w_warehouse_name, sm.sm_type, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk
JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk
JOIN item i ON cr.cr_item_sk = i.i_item_sk
GROUP BY w.w_warehouse_name, sm.sm_type, r.r_reason_desc
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q209
SELECT ws_site.web_name, p.p_promo_name, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_coupon_amt) AS total_cupoane
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, p.p_promo_name, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q210
WITH vanzari_stat AS (
    SELECT ca.ca_state, s.s_store_name, i.i_category,
           SUM(ss.ss_net_paid) AS total_vanzari,
           SUM(ss.ss_net_profit) AS profit_total
    FROM store_sales ss
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN store s ON ss.ss_store_sk = s.s_store_sk
    JOIN item i ON ss.ss_item_sk = i.i_item_sk
    GROUP BY ca.ca_state, s.s_store_name, i.i_category
)
SELECT ca_state, s_store_name, i_category, total_vanzari, profit_total,
       RANK() OVER (PARTITION BY ca_state ORDER BY total_vanzari DESC) AS rank_in_stat
FROM vanzari_stat
ORDER BY ca_state, rank_in_stat
LIMIT 200;

---- Q211
SELECT cd.cd_gender, i.i_category, cc.cc_name, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, i.i_category, cc.cc_name, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q212
SELECT p.p_purpose, p.p_channel_email, ca.ca_state, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_coupon_amt) AS total_cupoane
FROM web_sales ws
JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY p.p_purpose, p.p_channel_email, ca.ca_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q213
WITH web_lunar AS (
    SELECT i.i_category, d.d_year, d.d_moy,
           SUM(ws.ws_net_paid) AS vanzari,
           COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici,
           COUNT(*) AS nr_tranzactii
    FROM web_sales ws
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    JOIN web_site wst ON ws.ws_web_site_sk = wst.web_site_sk
    JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
    GROUP BY i.i_category, d.d_year, d.d_moy
)
SELECT i_category, d_year, d_moy, vanzari, clienti_unici, nr_tranzactii,
       LAG(vanzari) OVER (PARTITION BY i_category, d_year ORDER BY d_moy) AS vanzari_luna_prec
FROM web_lunar
ORDER BY i_category, d_year, d_moy;

---- Q214
SELECT ca.ca_state, i.i_category, w.w_warehouse_name,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total,
       AVG(cs.cs_quantity) AS cantitate_medie
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
GROUP BY ca.ca_state, i.i_category, w.w_warehouse_name
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q215
WITH prod_mag AS (
    SELECT s.s_store_name, i.i_category, i.i_brand, d.d_year,
           SUM(ss.ss_net_paid) AS total_vanzari,
           SUM(ss.ss_net_profit) AS profit_total
    FROM store_sales ss
    JOIN store s ON ss.ss_store_sk = s.s_store_sk
    JOIN item i ON ss.ss_item_sk = i.i_item_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    GROUP BY s.s_store_name, i.i_category, i.i_brand, d.d_year
)
SELECT s_store_name, i_category, i_brand, d_year, total_vanzari, profit_total,
       RANK() OVER (PARTITION BY s_store_name, d_year ORDER BY total_vanzari DESC) AS rank_in_magazin,
       LAG(total_vanzari) OVER (PARTITION BY s_store_name, i_brand ORDER BY d_year) AS vanzari_an_trecut
FROM prod_mag
ORDER BY s_store_name, d_year, rank_in_magazin
LIMIT 200;

---- Q216
SELECT ca.ca_state, wp.wp_type, i.i_category,
       cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON wr.wr_returning_hdemo_sk = hd.hd_demo_sk
JOIN web_sales ws ON wr.wr_item_sk = ws.ws_item_sk AND wr.wr_order_number = ws.ws_order_number
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, wp.wp_type, i.i_category,
         cd.cd_gender, cd.cd_education_status,
         hd.hd_buy_potential, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q217
SELECT ca.ca_state, ca.ca_city, s.s_store_name, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, ca.ca_city, s.s_store_name, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q218
SELECT p.p_promo_name, p.p_purpose, i.i_brand, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_coupon_amt) AS total_cupoane,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY p.p_promo_name, p.p_purpose, i.i_brand, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q219
SELECT ca.ca_state, sm.sm_type, sm.sm_carrier, i.i_category,
       COUNT(*) AS nr_livrari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare_total,
       AVG(ws.ws_ext_ship_cost) AS cost_mediu_livrare,
       SUM(ws.ws_net_paid) AS total_vanzari
FROM web_sales ws
JOIN customer c ON ws.ws_ship_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY ca.ca_state, sm.sm_type, sm.sm_carrier, i.i_category
ORDER BY cost_livrare_total DESC
LIMIT 100;

---- Q220
SELECT cd.cd_gender, cd.cd_education_status, s.s_store_name, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_education_status, s.s_store_name, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q221
SELECT w.w_warehouse_name, w.w_state, i.i_category, i.i_brand, d.d_year,
       AVG(inv.inv_quantity_on_hand) AS stoc_mediu,
       MIN(inv.inv_quantity_on_hand) AS stoc_minim
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN item i ON inv.inv_item_sk = i.i_item_sk
JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, w.w_state, i.i_category, i.i_brand, d.d_year
HAVING AVG(inv.inv_quantity_on_hand) < 50
ORDER BY stoc_mediu ASC
LIMIT 100;

---- Q222
SELECT ca.ca_state, sm.sm_carrier, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, sm.sm_carrier, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q223
SELECT c.c_customer_id, ca.ca_state, ws_site.web_name, i.i_category,
       COUNT(*) AS nr_achizitii,
       SUM(ws.ws_net_paid) AS total_cheltuit,
       SUM(ws.ws_net_profit) AS profit
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY c.c_customer_id, ca.ca_state, ws_site.web_name, i.i_category
HAVING SUM(ws.ws_net_paid) > 200
ORDER BY total_cheltuit DESC
LIMIT 100;

---- Q224
SELECT ca.ca_state, s.s_store_name, i.i_category,
       cd.cd_gender, cd.cd_marital_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN item i ON sr.sr_item_sk = i.i_item_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, s.s_store_name, i.i_category,
         cd.cd_gender, cd.cd_marital_status,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q225
SELECT i.i_category, i.i_class, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_wholesale_cost) AS cost_angro,
       ROUND((SUM(cs.cs_net_paid) - SUM(cs.cs_ext_wholesale_cost))
             / NULLIF(SUM(cs.cs_net_paid), 0) * 100, 2) AS marja_pct
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY i.i_category, i.i_class, d.d_year
ORDER BY marja_pct DESC
LIMIT 100;

---- Q226
WITH web_dem AS (
    SELECT cd.cd_gender, hd.hd_buy_potential, i.i_category,
           SUM(ws.ws_net_paid) AS total_vanzari,
           COUNT(*) AS nr_tranzactii
    FROM web_sales ws
    JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
    JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    GROUP BY cd.cd_gender, hd.hd_buy_potential, i.i_category
)
SELECT cd_gender, hd_buy_potential, i_category, total_vanzari,
       RANK() OVER (PARTITION BY cd_gender ORDER BY total_vanzari DESC) AS rank_per_gen
FROM web_dem
ORDER BY cd_gender, rank_per_gen
LIMIT 100;

---- Q227
SELECT t.t_shift, t.t_sub_shift, s.s_store_name, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY t.t_shift, t.t_sub_shift, s.s_store_name, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q228
SELECT ca.ca_state, i.i_category, cc.cc_name,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta,
       AVG(cr.cr_return_quantity) AS cantitate_medie
FROM catalog_returns cr
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON cr.cr_item_sk = i.i_item_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
GROUP BY ca.ca_state, i.i_category, cc.cc_name
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q229
SELECT ca.ca_state, p.p_promo_name, i.i_category,
       cd.cd_gender, hd.hd_buy_potential,
       ib.ib_lower_bound, ib.ib_upper_bound,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_coupon_amt) AS total_cupoane
FROM web_sales ws
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, p.p_promo_name, i.i_category,
         cd.cd_gender, hd.hd_buy_potential,
         ib.ib_lower_bound, ib.ib_upper_bound, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q230
SELECT s.s_city, s.s_state, i.i_brand, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_city, s.s_state, i.i_brand, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q231
SELECT cp.cp_department, w.w_warehouse_name, sm.sm_carrier,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY cp.cp_department, w.w_warehouse_name, sm.sm_carrier
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q232
WITH web_cat_lunar AS (
    SELECT i.i_category, d.d_year, d.d_moy,
           SUM(ws.ws_net_paid) AS vanzari,
           SUM(ws.ws_net_profit) AS profit
    FROM web_sales ws
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    GROUP BY i.i_category, d.d_year, d.d_moy
)
SELECT i_category, d_year, d_moy, vanzari, profit,
       AVG(vanzari) OVER (PARTITION BY i_category ORDER BY d_year, d_moy ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS medie_3luni
FROM web_cat_lunar
ORDER BY i_category, d_year, d_moy
LIMIT 200;

---- Q233
SELECT s.s_state, i.i_brand, p.p_purpose, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_coupon_amt) AS total_cupoane,
       ROUND(SUM(ss.ss_coupon_amt) / NULLIF(SUM(ss.ss_net_paid), 0) * 100, 2) AS pct_cupon
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY s.s_state, i.i_brand, p.p_purpose, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q234
SELECT ws_site.web_name, ca.ca_state, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total,
       COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, ca.ca_state, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q235
SELECT ca.ca_state, i.i_category, r.r_reason_desc,
       cc.cc_name, cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(cr.cr_return_amount) AS total_returnat,
       SUM(cr.cr_net_loss) AS pierdere_neta
FROM catalog_returns cr
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON cr.cr_returning_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cr.cr_returning_hdemo_sk = hd.hd_demo_sk
JOIN item i ON cr.cr_item_sk = i.i_item_sk
JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_category, r.r_reason_desc,
         cc.cc_name, cd.cd_gender, cd.cd_education_status,
         hd.hd_buy_potential, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q236
SELECT cd.cd_gender, cd.cd_marital_status, s.s_store_name,
       d.d_year, d.d_moy,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, cd.cd_marital_status, s.s_store_name, d.d_year, d.d_moy
ORDER BY total_vanzari DESC
LIMIT 200;

---- Q237
SELECT w.w_warehouse_name, sm.sm_type, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_ext_ship_cost) AS cost_livrare,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY w.w_warehouse_name, sm.sm_type, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q238
SELECT cd.cd_gender, hd.hd_buy_potential, ib.ib_lower_bound, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       AVG(cs.cs_sales_price) AS pret_mediu
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, hd.hd_buy_potential, ib.ib_lower_bound, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q239
SELECT s.s_market_id, s.s_market_manager, i.i_manufact, i.i_category, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
GROUP BY s.s_market_id, s.s_market_manager, i.i_manufact, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q240
WITH web_stat_lunar AS (
    SELECT ca.ca_state, i.i_category, d.d_year, d.d_moy,
           SUM(ws.ws_net_paid) AS vanzari,
           SUM(ws.ws_net_profit) AS profit
    FROM web_sales ws
    JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
    JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    GROUP BY ca.ca_state, i.i_category, d.d_year, d.d_moy
)
SELECT ca_state, i_category, d_year, d_moy, vanzari, profit,
       SUM(vanzari) OVER (PARTITION BY ca_state, i_category, d_year ORDER BY d_moy ROWS UNBOUNDED PRECEDING) AS vanzari_cumulate
FROM web_stat_lunar
ORDER BY ca_state, i_category, d_year, d_moy
LIMIT 200;

---- Q241
SELECT s.s_store_name, s.s_state, i.i_category, d.d_year, d.d_qoy,
       SUM(ss.ss_ext_discount_amt) AS discount_total,
       SUM(ss.ss_net_paid) AS total_vanzari,
       ROUND(SUM(ss.ss_ext_discount_amt) / NULLIF(SUM(ss.ss_ext_list_price), 0) * 100, 2) AS pct_discount
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE ss.ss_ext_discount_amt > 0
GROUP BY s.s_store_name, s.s_state, i.i_category, d.d_year, d.d_qoy
ORDER BY discount_total DESC
LIMIT 100;

---- Q242
SELECT ca.ca_state, w.w_warehouse_name, sm.sm_carrier,
       cd.cd_gender, hd.hd_buy_potential,
       ib.ib_lower_bound, i.i_category,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, w.w_warehouse_name, sm.sm_carrier,
         cd.cd_gender, hd.hd_buy_potential,
         ib.ib_lower_bound, i.i_category, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q243
SELECT hd.hd_buy_potential, hd.hd_dep_count, s.s_store_name, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_quantity) AS cantitate_medie
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY hd.hd_buy_potential, hd.hd_dep_count, s.s_store_name, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q244
SELECT ws_site.web_name, ca.ca_state, i.i_category,
       cd.cd_gender, cd.cd_marital_status,
       hd.hd_buy_potential, r.r_reason_desc,
       d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN web_sales ws ON wr.wr_item_sk = ws.ws_item_sk AND wr.wr_order_number = ws.ws_order_number
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON wr.wr_returning_hdemo_sk = hd.hd_demo_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, ca.ca_state, i.i_category,
         cd.cd_gender, cd.cd_marital_status,
         hd.hd_buy_potential, r.r_reason_desc, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;

---- Q245
SELECT c.c_customer_id, p.p_promo_name, s.s_store_name, i.i_category,
       COUNT(*) AS nr_achizitii,
       SUM(ss.ss_net_paid) AS total_cheltuit,
       SUM(ss.ss_coupon_amt) AS total_cupoane
FROM store_sales ss
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY c.c_customer_id, p.p_promo_name, s.s_store_name, i.i_category
HAVING SUM(ss.ss_coupon_amt) > 10
ORDER BY total_cupoane DESC
LIMIT 100;

---- Q246
SELECT cd.cd_gender, cd.cd_education_status, cc.cc_name, cc.cc_state, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total,
       COUNT(DISTINCT cs.cs_bill_customer_sk) AS clienti_unici
FROM catalog_sales cs
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_education_status, cc.cc_name, cc.cc_state, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q247
SELECT s.s_store_name, s.s_state, s.s_number_employees,
       i.i_category, d.d_year,
       SUM(ss.ss_net_paid) AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       ROUND(SUM(ss.ss_net_profit) / NULLIF(s.s_number_employees, 0), 2) AS profit_per_angajat
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
WHERE s.s_number_employees > 0
GROUP BY s.s_store_name, s.s_state, s.s_number_employees, i.i_category, d.d_year
ORDER BY profit_per_angajat DESC
LIMIT 100;

---- Q248
SELECT cd.cd_gender, ca.ca_state, wp.wp_type,
       hd.hd_buy_potential, ib.ib_lower_bound,
       i.i_category, t.t_shift,
       d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, ca.ca_state, wp.wp_type,
         hd.hd_buy_potential, ib.ib_lower_bound,
         i.i_category, t.t_shift, d.d_year
ORDER BY total_vanzari DESC
LIMIT 100;

---- Q249
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

---- Q250
SELECT w.w_warehouse_name, w.w_state, sm.sm_type,
       d_sold.d_year AS an_vanzare, d_sold.d_moy AS luna_vanzare,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_ext_ship_cost) AS cost_livrare
FROM catalog_sales cs
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN date_dim d_sold ON cs.cs_sold_date_sk = d_sold.d_date_sk
JOIN date_dim d_ship ON cs.cs_ship_date_sk = d_ship.d_date_sk
GROUP BY w.w_warehouse_name, w.w_state, sm.sm_type, d_sold.d_year, d_sold.d_moy
ORDER BY total_vanzari DESC
LIMIT 100;