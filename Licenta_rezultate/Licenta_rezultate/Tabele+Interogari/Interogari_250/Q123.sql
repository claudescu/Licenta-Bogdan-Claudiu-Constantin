-- Q123: Număr de tranzacții per schimb orar
SELECT t_shift, t_sub_shift, t_meal_time,
       COUNT(*) AS nr_intervale
FROM time_dim
GROUP BY t_shift, t_sub_shift, t_meal_time
ORDER BY t_shift;
