-- Q142: Retururi catalog per produs și motiv
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
