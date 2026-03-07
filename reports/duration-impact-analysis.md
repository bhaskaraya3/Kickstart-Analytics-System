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
```

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

# 2. Best Month to Launch a Kickstarter Campaign

## Objective
*Analyze whether the launch month influences the success of crowdfunding campaigns.*

This analysis examines campaign performance across different months to determine when campaigns are most likely to succeed. The evaluation is based on:

- Total number of campaigns launched
- Number of successful campaigns
- Campaign success rate
- Average number of backers
- Average pledged amount

---

## SQL Query

```sql
-- What is the best month to launch campaigns?

SELECT
MONTHNAME(launched) AS launch_month,
COUNT(*) AS total_campaigns,
SUM(state = 'Successful') AS successful_campaigns,
ROUND(100 * AVG(state = 'Successful'),2) AS success_rate,
ROUND(100 * AVG(backers),2) AS avg_backers,
ROUND(100 * AVG(pledged),2) AS avg_pledged
FROM kickstart
GROUP BY launch_month
ORDER BY success_rate DESC;
```

## Result

| Launch Month | Total Campaigns | Successful Campaigns | Success Rate (%) | Avg Backers | Avg Pledged |
|---|---|---|---|---|---|
| March | 33,511 | 12,812 | 38.23 | 10,984.63 | 953,287.56 |
| April | 31,845 | 12,034 | 37.79 | 11,017.67 | 927,586.92 |
| February | 29,340 | 11,003 | 37.50 | 10,729.74 | 914,498.13 |
| October | 33,175 | 12,350 | 37.23 | 11,761.44 | 992,124.11 |
| May | 32,654 | 12,055 | 36.92 | 11,875.37 | 1,033,992.35 |
| September | 30,767 | 11,231 | 36.50 | 11,772.55 | 1,042,990.94 |
| June | 32,414 | 11,773 | 36.32 | 10,525.38 | 922,922.70 |
| November | 32,556 | 11,770 | 36.15 | 10,967.87 | 1,012,140.16 |
| January | 27,491 | 9,480 | 34.48 | 10,445.84 | 763,989.81 |
| August | 31,999 | 10,820 | 33.81 | 9,884.28 | 780,712.63 |
| July | 36,097 | 11,681 | 32.36 | 9,849.21 | 894,949.54 |
| December | 23,004 | 6,842 | 29.74 | 7,309.85 | 594,071.86 |

---

## Key Insights

### March Shows the Highest Success Rate
*Campaigns launched in **March** achieved the highest success rate (~38.23%).*  
This suggests that early spring may provide favorable conditions for campaign visibility and backer engagement.

### Strong Performance in Early Spring
Months like **April** and **February** also show high success rates (~37–38%), indicating that campaigns launched during this period tend to perform well.

### Higher Funding Activity in Late Year Months
Although months like **September**, **October**, and **November** do not always have the highest success rates, they show **higher average pledged amounts**, indicating stronger funding activity among successful campaigns.

### Lower Performance During Year-End
Campaigns launched in **December** show the lowest success rate (~29.74%) along with the lowest average pledged amount and fewer average backers.  
Holiday distractions and reduced online engagement may contribute to this trend.

---

## Conclusion

*The timing of a campaign launch can significantly influence crowdfunding success.*

Campaigns launched during **late winter and early spring (February–April)** tend to achieve the highest success rates, while **December campaigns show the weakest performance**.  
Creators may increase their chances of success by strategically launching campaigns during months with historically stronger engagement and funding outcomes.