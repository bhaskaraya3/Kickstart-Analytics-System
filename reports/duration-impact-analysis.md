# Duration Impact Analysis

## Objective
*Analyze whether the duration of a Kickstarter campaign influences its probability of success.*

Campaign duration is calculated as the difference between the **launch date** and **deadline**.  
Campaigns are then grouped into different duration buckets to compare their success rates.

---

## SQL Query

```sql
-- Duration Impact Analysis
-- Does campaign duration affect success probability?

WITH campaign_duration AS (
SELECT
DATEDIFF(deadline, launched) AS duration_days,
state
FROM kickstart
),

duration_bins AS (
SELECT
CASE
    WHEN duration_days <= 30 THEN 'Short (0-30)'
    WHEN duration_days <= 60 THEN 'Medium (31-60)'
    WHEN duration_days <= 90 THEN 'Long (61-90)'
    ELSE 'Very Long (90+)'
END AS duration_bucket,
state
FROM campaign_duration
)

SELECT
duration_bucket,
COUNT(*) AS total_campaigns,
SUM(state='Successful') AS successful_campaigns,
ROUND(100 * AVG(state='Successful'),2) AS success_rate
FROM duration_bins
GROUP BY duration_bucket
ORDER BY success_rate DESC;

## Result

| Duration Bucket | Total Campaigns | Successful Campaigns | Success Rate (%) |
|----------------|----------------|---------------------|------------------|
| Short (0–30) | 236,172 | 86,380 | 36.58 |
| Long (61–90) | 4,978 | 1,726 | 34.67 |
| Medium (31–60) | 133,214 | 45,602 | 34.23 |
| Very Long (90+) | 489 | 143 | 29.24 |

---

## Key Insights

### Short Campaigns Perform Best
*Campaigns lasting **0–30 days** show the highest success rate (~36.6%).*  
Shorter campaigns may create *urgency and momentum*, encouraging faster backing decisions.

### Medium and Long Campaigns Show Similar Performance
Campaigns running **31–90 days** have a slightly lower success rate (~34%).  
This suggests that extending campaign duration does *not significantly increase the chances of success*.

### Very Long Campaigns Perform the Worst
Campaigns running **more than 90 days** have the *lowest success rate (~29%)*.  
Long durations may reduce urgency and signal *weaker campaign planning*.

---

## Conclusion

*Campaign duration has a measurable impact on Kickstarter success.*

The analysis indicates that **shorter campaigns (under 30 days)** tend to perform better, while **very long campaigns show declining success rates**.  
This suggests that maintaining **urgency and momentum** may be an important factor in crowdfunding success.