-- Duration Impact Analysis

-- Analyze whether the duration of a Kickstarter campaign influences its probability of success.
WITH duration_bucket AS(
SELECT
CASE 
	WHEN campaign_duration_days <=30 THEN 'Short(0-30)' 
    WHEN campaign_duration_days <=60 THEN 'Medium(30-60)' 
    WHEN campaign_duration_days <=90 THEN 'Long(60-90)' 
    ELSE 'Very Long Days'
END AS duration_bucket,
state
FROM kickstart
)
SELECT 
duration_bucket,
COUNT(*) AS total_campaigns,
SUM(state='Successful') AS successful_rate,
ROUND(100*AVG(state='Successful'),2) AS success_rate
FROM duration_bucket
GROUP BY duration_bucket
ORDER BY success_rate DESC;

-- Best Month to Launch a Kickstarter Campaign
WITH launch_month_data AS (
SELECT
MONTHNAME(launched) AS launch_month,
state,
backers,
pledged
FROM kickstart
)
SELECT
launch_month,
COUNT(*) AS total_campaigns,
SUM(state = 'Successful') AS successful_campaigns,
ROUND(100 * AVG(state = 'Successful'),2) AS success_rate,
ROUND(100 * AVG(backers),2) AS avg_backers,
ROUND(100 * AVG(pledged),2) AS avg_pledged
FROM launch_month_data
GROUP BY launch_month
ORDER BY success_rate DESC;