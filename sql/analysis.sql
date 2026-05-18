-- Average loyalty by category

SELECT
    category,
    ROUND(AVG(loyalty_score), 2) AS avg_loyalty
FROM customers
GROUP BY category
ORDER BY avg_loyalty DESC;


-- Promo dependency by customer tier

SELECT
    value_tier,
    COUNT(*) AS total_customers,
    ROUND(AVG(promo_dependency), 2) AS avg_promo_dependency
FROM customers
GROUP BY value_tier
ORDER BY avg_promo_dependency DESC;


-- Revenue by category

SELECT
    category,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customers
GROUP BY category
ORDER BY total_revenue DESC;


-- Average purchase amount by category

SELECT
    category,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase
FROM customers
GROUP BY category
ORDER BY avg_purchase DESC;