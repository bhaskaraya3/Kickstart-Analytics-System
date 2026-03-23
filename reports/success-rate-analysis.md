# Success Rate Analysis

---

## 1. What percentage of Kickstarter campaigns succeed vs fail?

### SQL Query
```sql
SELECT
state,
COUNT(*) AS total_projects,
ROUND(100 * COUNT(*)/SUM(COUNT(*)) OVER(),2) AS percentage
FROM kickstart
WHERE state IN ('Failed','Successful')
GROUP BY state;
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

## Conclusion
**1. Kickstarter campaigns are high-risk, with failure being more common than success.**

**2. Proper goal setting, duration, and category selection are critical for success.**

---

## 2. Which Category Has the Highest Success Rate?

### SQL Query
```sql
SELECT 
category,
ROUND(100* SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END)/COUNT(*),2) AS success_rate
FROM kickstart
GROUP BY category
ORDER BY success_rate DESC
LIMIT 1;
```

### Result

#### Top Performing Categories
| Category       | Success Rate |
|---------------|--------------|
| Dance         | 62.07%       |
| Theater       | 59.88%       |
| Comics        | 54.00%       |
| Music         | 48.67%       |

#### Worst Performing Categories

| Category | Success Rate |
|----------|--------------|
| Food     | 24.74% |
| Fashion  | 24.52% |
| Crafts   | 24.01% |
| Journalism | 21.29% |
| Technology | 19.76% |

### Insights
- Performing arts categories have the highest success rates.
- Technology and high-cost categories have the lowest success rates.
- Competitive categories require stronger marketing and positioning.

## Conclusion
**1. Community-driven categories perform better than high-capital categories.**

**2. Choosing the right category significantly impacts success probability.**

---

## 3. What are the major causes of failed campaigns?

### A. Impact of High Funding Goals

#### SQL Query
```sql
SELECT
CASE 
	WHEN goal<=10000 THEN 'Low'
	WHEN goal<=50000 THEN 'Mid'
	WHEN goal<=100000 THEN 'High'
	ELSE 'Extremely High'
END AS funding_bucket,
COUNT(*) AS campaigns,
ROUND(SUM(CASE WHEN state='Failed' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS failing_rate
FROM kickstart
GROUP BY funding_bucket
ORDER BY failing_rate DESC;
```

### Result
| Funding Bucket   | Campaigns | Failure Rate (%) |
|------------------|----------|------------------|
| Extremely High   | 12679    | 71.13            |
| High             | 16353    | 66.73            |
| Mid              | 95353    | 59.00            |
| Low              | 250468   | 48.48            |

### Insights
- Extremely high funding goals show the highest failure rates.
- High-goal campaigns attract fewer backers and lower engagement.
- Many fail due to lack of early traction.

## Conclusion
**1. Unrealistic funding goals significantly reduce success chances.**
**2. Setting achievable goals is critical for campaign success.**

### B. Impact of Campaign Duration

#### SQL Query
```sql
SELECT
CASE 
    WHEN campaign_duration_days <= 30 THEN 'Short (0-30)'
    WHEN campaign_duration_days <= 60 THEN 'Medium (31-60)'
    ELSE 'Long (61+)'
END AS duration_bucket,
COUNT(*) AS total_campaigns,
ROUND(SUM(CASE WHEN state = 'Failed' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS failing_rate
FROM kickstart
WHERE state IN ('Successful','Failed')
GROUP BY duration_bucket
ORDER BY failing_rate DESC;

```

### Result
| Duration Bucket | Total Campaigns | Failure Rate (%) |
|-----------------|----------------|------------------|
| Long (61+)      | 4824           | 61.26            |
| Medium (31-60)  | 115357         | 60.47            |
| Short (0-30)    | 211281         | 59.12            |

### Insights
- Failure rate increases as campaign duration increases.
- Short campaigns perform better with lower failure rates.
- Longer campaigns tend to lose momentum over time.

## Conclusion
**1. Short campaigns (≤30 days) are more effective and less risky.**
**2. Longer duration does not improve success probability.**

---

## Recommendations for Kickstarter Businesses

**1. Set Realistic Funding Goals**
  - Smaller, achievable goals increase trust and attract more backers.
  - High funding targets often lead to lower participation and higher failure rates.

**2. Keep Campaign Duration Short (≤ 30 Days)**
  - Short campaigns create urgency and faster decision-making.
  - Longer campaigns lose momentum and have higher failure rates.

**3. Choose the Right Category**
  - Community-driven categories perform better than high-cost ones.
  - Selecting a category with strong demand improves success chances.