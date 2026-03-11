# Success Rate Analysis

---

## 1. What percentage of Kickstarter campaigns succeed vs fail?

### SQL Query
```sql
SELECT
state,
COUNT(*) AS total_campaigns,
ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS percentage
FROM kickstart
WHERE state IN ('Failed','Successful')
GROUP BY state
ORDER BY percentage DESC;
```

### Result
| State      | Total Campaigns | Percentage |
|------------|---------------|------------|
| Failed     | 197611        | 59.62%     |
| Successful | 133851        | 40.38%     |

### Insights
- Nearly **60% of campaigns fail**.
- Kickstarter campaigns are highly competitive.
- More than half of creators do not meet their funding goals.

**This indicates the importance of goal sizing, duration optimization, and category positioning.**

---

## 2. Which Category Has the Highest Success Rate?

### SQL Query
```sql
SELECT
category,
ROUND(SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS success_rate
FROM kickstart
GROUP BY category
ORDER BY success_rate DESC;
```

### Insights

#### Top Performing Categories
| Category       | Success Rate |
|---------------|--------------|
| Dance         | 62.07%       |
| Theater       | 59.88%       |
| Comics        | 54.00%       |
| Music         | 48.67%       |

##### Key Observations
- Performing arts categories dominate in success rate.
- **These campaigns likely:**
  - Have lower funding goals
  - May have strong community or local support
  - Target loyal niche audiences
- Emotion-driven and community-backed projects outperform capital-intensive ones.

#### Mid-Tier Categories
| Category       | Success Rate |
|---------------|--------------|
| Art           | 40.89%       |
| Film & Video  | 37.66%       |
| Games         | 35.54%       |
| Design        | 35.09%       |

##### Key Observations
- Competitive but still viable.
- Likely require strong marketing and realistic funding goals.
- These categories may have moderately higher funding requirements, increasing risk exposure.

#### Worst Performing Categories

| Category | Success Rate |
|----------|--------------|
| Food     | 24.74% |
| Fashion  | 24.52% |
| Crafts   | 24.01% |
| Journalism | 21.29% |
| Technology | 19.76% |

##### Insight
- Technology is the lowest-performing category (**19.76%**).

##### Possible Reasons
- Extremely high funding goals.
- Overpromising hardware or product innovation.
- Production and logistics complexity.
- High competition and execution risk.

##### Food, Fashion, and Crafts
- Likely oversaturated markets.
- Difficult product differentiation.
- Thin margins and high operational challenges.

### Conclusion
- **Community-driven and performance-based projects have significantly higher probability of success.**
- **High-capital and hardware-driven categories face structural risk.**
- **Realistic goal-setting and niche targeting appear to be critical drivers of campaign success.**

---

## 3. What are the major causes of failed campaigns?

### A. Impact of High Funding Goals

#### SQL Query
```sql
SELECT 
goal,
pledged,
backers,
state
FROM kickstart
ORDER BY goal DESC;
```

### Result
#### Campaigns with extremely high funding goals show:

1. Very low pledged amounts.
2. Minimal backers.
3. Mostly Failed, Suspended, or Canceled states.

### Insights
- Unrealistically high goals significantly reduce success probability.
- Many high-goal campaigns fail to build early traction.
- Backer participation drops sharply for large capital requirements.

### Conclusion
- **Setting aggressive funding goals without proven demand increases failure risk.**
- **Goal optimization is critical for campaign viability.**

### B. Impact of Campaign Duration

#### SQL Query
```sql
SELECT
campaign_duration_days,
COUNT(*) AS total_campaigns,
ROUND(SUM(CASE WHEN state = 'Successful' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS success_rate,
ROUND(SUM(CASE WHEN state = 'Failed' THEN 1 ELSE 0 END) * 100/COUNT(*),2) AS failed_rate
FROM kickstart
WHERE state IN ('Successful','Failed')
GROUP BY campaign_duration_days
ORDER BY campaign_duration_days DESC;
```

### Result
| Duration        | Success Rate | Failure Rate |
|-----------------|-------------|--------------|
| 90+ Days        | ~32%        | ~68% |
| 91 Days         | 31.01%      | 68.99% |
| 92 Days         | 22.73%      | 77.27% |

### Insights
- Longer campaigns show noticeably lower success rates.

### SQL Query *(Bucketed Duration)*
```sql
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
```

### Result
| Duration Bucket | Total Campaigns | Success Rate (%) | Failure Rate (%) |
|-----------------|----------------|------------------|------------------|
| Short (0-30)    | 211281         | 40.88            | 59.12            |
| Medium (31-60)  | 115357         | 39.53            | 60.47            |
| Long (61+)      | 4824           | 38.74            | 61.26            |

### Insights
1. Short campaigns (≤30 days) have the highest success rate.
2. Success probability declines as duration increases.
3. Extending campaign duration does not significantly improve outcomes.

### Conclusion
- **Momentum and urgency drive performance more than longer exposure.**
- **Optimal campaign duration appears to be 30 days or less**.

---

## Overall Strategic Insights

1. **Realistic funding goals are critical for success.**
2. **Community engagement (number of backers) strongly predicts campaign outcomes.**
3. **Shorter campaigns generate stronger funding momentum.**
4. **Creative and performance-based categories outperform hardware-focused projects.**
