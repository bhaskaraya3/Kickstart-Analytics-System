-- Success Rate Analysis

-- What percentage of Kickstarter campaigns succeed vs fail?
SELECT
state,
COUNT(*) AS total_projects,
ROUND(100 * COUNT(*)/SUM(COUNT(*)) OVER(),2) AS percentage
FROM kickstart
WHERE state IN ('Failed','Successful')
GROUP BY state;

-- Which Category Has the Highest Success Rate?
SELECT 
category,
ROUND(100* SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END)/COUNT(*),2) AS success_rate
FROM kickstart
GROUP BY category
ORDER BY success_rate DESC;

-- What are the major causes of failed campaigns?
-- A. Impact of High Funding Goals
SELECT 
goal,
pledged,
backers,
state
FROM kickstart
ORDER BY goal DESC;

-- B. Impact of Campaign Duration
SELECT
campaign_duration_days,
COUNT(*) AS total_campaingns,
SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END) AS successful_count,
SUM(CASE WHEN state='Failed' THEN 1 ELSE 0 END) AS failed_count,
ROUND(100*SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END)/COUNT(*),2) AS successful_rate,
ROUND(100*SUM(CASE WHEN state='Failed' THEN 1 ELSE 0 END)/COUNT(*),2) AS failed_rate
FROM kickstart
WHERE state IN ('Successful','Failed')
GROUP BY campaign_duration_days
ORDER BY campaign_duration_days DESC;

-- Bucket Duration
SELECT
CASE 
    WHEN campaign_duration_days <= 30 THEN 'Short (0-30)'
    WHEN campaign_duration_days <= 60 THEN 'Medium (31-60)'
    ELSE 'Long (61+)'
END AS duration_bucket,
COUNT(*) AS total_campaigns,
ROUND(SUM(CASE WHEN state = 'Successful' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS success_rate,
ROUND(SUM(CASE WHEN state = 'Failed' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS failed_rate
FROM kickstart
WHERE state IN ('Successful','Failed')
GROUP BY duration_bucket
ORDER BY success_rate DESC;




