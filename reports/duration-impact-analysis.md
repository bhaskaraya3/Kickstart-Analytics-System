# Duration Impact Analysis

---

## 1. Does Campaign Duration Influence Success?

## SQL Query
```sql
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
ROUND(100*AVG(state='Successful'),2) AS success_rate
FROM duration_bucket
GROUP BY duration_bucket
ORDER BY success_rate DESC;
```

## Result

| Duration Bucket | Total Campaigns | Success Rate (%) |
|----------------|----------------|---------------------|
| Short (0–30) | 236172 | 36.58 |
| Long (61–90) | 4978 | 34.67 |
| Medium (31–60) | 133214 | 34.23 |
| Very Long (90+) | 489 | 29.24 |

### Insights
- Short campaigns (0–30 days) have the highest success rate (~36.6%).
- Medium and long campaigns (31–90 days) show similar but slightly lower performance (~34%).
- Very long campaigns (>90 days) perform the worst (~29%).
- Increasing duration does not improve success probability.

## Conclusion
**Shorter campaigns are more effective, while very long campaigns reduce the likelihood of success.**

---

# 2. Best Month to Launch a Kickstarter Campaign

## SQL Query
```sql
WITH launch_month_data AS (
SELECT
state,
MONTHNAME(launched) AS launch_month
FROM kickstart
)
SELECT
launch_month,
COUNT(*) AS total_campaigns,
ROUND(100 * AVG(state = 'Successful'),2) AS success_rate
FROM launch_month_data
GROUP BY launch_month
ORDER BY success_rate DESC
LIMIT 3;
```

## Result
| Launch Month | Total Campaigns | Success Rate (%) |
|--------------|----------------|------------------|
| March        | 33511          | 38.23            |
| April        | 31845          | 37.79            |
| February     | 29340          | 37.50            |

### Insights
- March has the highest success rate (~38.23%).
- February and April also show strong performance (~37–38%).
- Mid-year months show stable but slightly lower performance.
- December has the lowest success rate (~29.74%).

## Conclusion
**Campaigns launched between February and April perform best, while December shows the weakest performance.**

---

# Overall Conclusions
**1. Campaigns lasting 0–30 days achieve the highest success rates, making shorter durations more effective.**

**2. Very long campaigns (>90 days) have the lowest success rates and are least effective.**

**3. Campaigns launched between February and April show the strongest performance.**

**4. December campaigns perform the worst, likely due to reduced engagement.**