WITH feature_usage_summary AS (
    SELECT
        user_id,
        feature_name,
        MIN(usage_time) AS first_used,
        MAX(usage_time) AS last_used,
        COUNT(*) AS usage_count
    FROM feature_usage
    GROUP BY user_id, feature_name
)

SELECT
    feature_name,
    COUNT(*) AS total_users,
    COUNT(
        CASE 
            WHEN usage_count = 1 THEN user_id 
        END
    ) AS dropped_users,
    ROUND(
        COUNT(CASE WHEN usage_count = 1 THEN user_id END) * 100.0
        / COUNT(*),
        2
    ) AS dropoff_percentage,
    RANK() OVER (
        ORDER BY 
        COUNT(CASE WHEN usage_count = 1 THEN user_id END) DESC
    ) AS dropoff_rank
FROM feature_usage_summary
GROUP BY feature_name;
