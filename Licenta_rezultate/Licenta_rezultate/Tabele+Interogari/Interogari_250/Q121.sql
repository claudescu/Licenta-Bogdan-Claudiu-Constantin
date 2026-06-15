-- Q121: Promoții active cu discount
SELECT p_promo_name, p_purpose, p_discount_active,
       p_channel_email, p_channel_tv, p_channel_radio, p_channel_press,
       p_cost
FROM promotion
WHERE p_discount_active = 'Y'
ORDER BY p_cost DESC
LIMIT 100;
