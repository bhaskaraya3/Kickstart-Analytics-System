-- Goal Optimization

-- Impact of Unrealistic Funding Goals
WITH ranked_goals AS(
SELECT
category,
goal,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY goal) AS rn,
COUNT(*) OVER (PARTITION BY category) AS cnt
FROM kickstart
),
category_median AS(
SELECT
category,
AVG(goal) AS median_goal
FROM ranked_goals
WHERE rn IN (FLOOR((cnt + 1) / 2), FLOOR((cnt + 2) / 2))
GROUP BY category
),
goal_flagged AS(
SELECT 
k.state,
CASE WHEN k.goal > 3 * c.median_goal THEN 'Unrealistic'
ELSE 'Realistic'
END AS goal_type
FROM kickstart k
JOIN category_median c
ON k.category = c.category
)
SELECT 
goal_type,
COUNT(*) AS total_projects,
SUM(state = 'Successful') AS successful_projects,
AVG(state = 'Successful') AS success_rate
FROM goal_flagged
GROUP BY goal_type;

-- What would be the optimal Goal range?
WITH goal_binned AS (
SELECT
goal,
pledged,
state,
CASE
	WHEN goal < 1000 THEN '0-1K'
	WHEN goal < 5000 THEN '1K-5K'
	WHEN goal < 10000 THEN '5K-10K'
	WHEN goal < 25000 THEN '10K-25K'
	WHEN goal < 50000 THEN '25K-50K'
	WHEN goal < 100000 THEN '50K-100K'
	WHEN goal < 500000 THEN '100K-500K'
ELSE '500K+'
END AS goal_range
FROM kickstart
),
goal_summary AS (
SELECT
goal_range,
COUNT(*) AS total_projects,
ROUND(100*AVG(state = 'Successful'),2) AS success_rate,
ROUND(AVG(pledged),2) AS avg_pledged
FROM goal_binned
GROUP BY goal_range
)
SELECT
goal_range,
total_projects,
success_rate,
avg_pledged,
ROUND((success_rate * avg_pledged),2) AS expected_value
FROM goal_summary
ORDER BY expected_value DESC;

-- Does Setting a Lower Goal Increase Success Probability?
WITH goal_bins AS(
SELECT 
CASE
	WHEN goal < 10000 THEN 'Low goal'
    WHEN goal < 50000 THEN 'Medium goal'
    WHEN goal < 200000 THEN 'High goal'
    ELSE 'Very High goal'
END AS goal_groups,
state
FROM kickstart
)
SELECT 
goal_groups,
COUNT(*) AS total_campaigns,
SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END) AS successful_campaigns,
ROUND(100*AVG(state = 'Successful'),2) AS success_rate
FROM goal_bins
GROUP BY goal_groups
ORDER BY success_rate DESC;