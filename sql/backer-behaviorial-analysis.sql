-- Backer Behavior Analysis

-- How does the number of backers influence campaign success?
WITH backer_groups AS(
SELECT
CASE 
	WHEN backers = 0 THEN 'No backers'
    WHEN backers <= 10 THEN 'Very Low'
    WHEN backers <=50 THEN 'Low'
    WHEN backers <= 200 THEN 'Medium'
    WHEN backers <= 500 THEN 'High'
    ELSE 'Viral'
END AS backer_bucket,
state
FROM kickstart
)
SELECT
backer_bucket,
COUNT(*) AS total_campaigns,
SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END) AS successful_campaigns,
ROUND(100*AVG(state='Successful'),2) AS success_rate
FROM backer_groups
GROUP BY backer_bucket
ORDER BY success_rate DESC;

-- Are Successful Campaigns Driven by Many Small Backers or Large Contributions?
WITH pledged_per_backer AS(
SELECT
ROUND(pledged / NULLIF(backers,0),0) AS avg_pledged_per_backer,
backers,
state
FROM kickstart
),
pledged_backer_bucket AS(
SELECT
CASE 
	WHEN avg_pledged_per_backer <= 20 THEN 'Small Backers'
	WHEN avg_pledged_per_backer <= 50 THEN 'Moderate Backers'
    WHEN avg_pledged_per_backer <= 100 THEN 'Large Backers'
    ELSE 'Very Large Backers'
END AS pledged_per_backer_bucket,
state
FROM pledged_per_backer
WHERE backers > 0
)
SELECT
pledged_per_backer_bucket,
COUNT(*) AS total_campaigns,
SUM(state='Successful') AS successful_campaigns,
ROUND(100 * AVG(state='Successful'),2) AS success_rate
FROM pledged_backer_bucket
GROUP BY pledged_per_backer_bucket
ORDER BY success_rate DESC;