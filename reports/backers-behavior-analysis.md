## Backer Behavior Analysis

---

### 1. Business Question
How does the number of backers influence campaign success?

### SQL Query
```sql
WITH backer_groups AS(
SELECT
CASE 
	WHEN backers = 0 THEN 'No Backers'
    WHEN backers <= 10 THEN 'Very Low'
    WHEN backers <= 50 THEN 'Low'
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
SUM(state='Successful') AS successful_campaigns,
ROUND(100 * AVG(state='Successful'),2) AS success_rate
FROM backer_groups
GROUP BY backer_bucket
ORDER BY success_rate DESC;
```

### Results

| Backer Bucket | Total Campaigns | Successful Campaigns | Success Rate |
|---------------|----------------|----------------------|--------------|
| Viral | 12,690 | 11,946 | **94.14%** |
| High | 18,950 | 16,565 | **87.41%** |
| Medium | 69,519 | 53,920 | **77.56%** |
| Low | 94,010 | 45,105 | 47.98% |
| Very Low | 127,880 | 6,315 | 4.94% |
| No Backers | 51,804 | 0 | **0%** |

### Key Insight
**Success probability increases dramatically as the number of backers grows:**
- Campaigns with no backers never succeed.
- Campaigns with very few backers succeed only ~5% of the time.
- Campaigns with 200+ backers achieve success rates above 75%.
- Campaigns with 500+ backers succeed over 90% of the time.

**This shows a strong positive relationship between community size and campaign success**.

### Conclusion
- **Backer engagement is one of the strongest predictors of crowdfunding success.**

- **Campaigns that attract a large community early are significantly more likely to reach their funding goals due to momentum, visibility, and social validation.**

---

## 2. Are Successful Campaigns Driven by Many Small Backers or Large Contributions?

### SQL Query
```sql
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
```

### Results

| Backer Type | Total Campaigns | Successful Campaigns | Success Rate |
|-------------|---------------|---------------------|-------------|
| Very Large Backers | 60,853 | 34,403 | **56.53%** |
| Large Backers | 91,983 | 50,735 | **55.16%** |
| Moderate Backers | 108,034 | 42,814 | 39.63% |
| Small Backers | 62,179 | 5,899 | **9.49%** |

### Key Insight
**Campaigns with higher average pledge per backer show higher success rates**:
- Small pledge campaigns succeed only **~9% of the time**
- Moderate pledge campaigns succeed **~40%**
- Large pledge campaigns exceed **55% success**

### Conclusion
- While larger average contributions correlate with higher success rates, crowdfunding success is typically driven by a combination of community size and pledge magnitude rather than large contributions alone.

---

# Overall Conclusion
1. Campaigns with more backers have dramatically higher success rates. Projects with 200+ backers exceed a 75% success rate, while campaigns with 500+ backers succeed over 90% of the time.

2. Campaigns with no backers never succeed, and those with very few backers (~0–10) succeed only about 5% of the time, highlighting the importance of early community engagement.

3. Campaigns with larger average pledges per backer achieve higher success rates, with large and very large contributors pushing success rates above 55%.

4. Campaigns driven primarily by small pledges show very low success rates (~9%), indicating that higher-value contributions significantly strengthen campaign outcomes.