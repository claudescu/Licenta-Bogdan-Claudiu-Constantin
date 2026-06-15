-- Q117: Retururi din magazin grupate per motiv
SELECT sr_reason_sk,
       COUNT(*) AS nr_retururi,
       SUM(sr_return_amt) AS valoare_totala_returnata,
       AVG(sr_return_amt) AS valoare_medie_retur,
       SUM(sr_net_loss) AS pierdere_neta_totala
FROM store_returns
GROUP BY sr_reason_sk
ORDER BY nr_retururi DESC;
