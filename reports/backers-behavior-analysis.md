## Backer Behavior Analysis

---

### 1. How does the number of backers influence campaign success?

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
ROUND(100 * AVG(state='Successful'),2) AS success_rate
FROM backer_groups
GROUP BY backer_bucket
ORDER BY success_rate DESC;
```

### Results

| Backer Bucket | Total Campaigns | Success Rate |
|---------------|----------------|---------------|
| Viral | 12,690 | **94.14%** |
| High | 18,950 | **87.41%** |
| Medium | 69,519 | **77.56%** |
| Low | 94,010 | **47.98%** |
| Very Low | 127,880 | **4.94%** |
| No Backers | 51,804 | **0%** |

### Insights
- Success rate increases sharply with the number of backers.
- Campaigns with no backers never succeed.
- Campaigns with 200+ backers exceed 75% success rates.
- Campaigns with 500+ backers achieve over 90% success rates.

## Conclusions
**1. Backer engagement is one of the strongest drivers of campaign success.**

**2. Larger communities create momentum, visibility, and trust.**

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
ROUND(100 * AVG(state='Successful'),2) AS success_rate
FROM pledged_backer_bucket
GROUP BY pledged_per_backer_bucket
ORDER BY success_rate DESC;
```

### Results

| Backer Type | Total Campaigns | Success Rate |
|-------------|---------------|-------------|
| Very Large Backers | 60,853 | **56.53%** |
| Large Backers | 91,983 | **55.16%** |
| Moderate Backers | 108,034 | **39.63%** |
| Small Backers | 62,179 | **9.49%** |

### Insights
- Higher average pledge per backer leads to higher success rates.
- Small pledge campaigns have very low success (~9%).
- Large and very large backers push success rates above 55%.

## Conclusion
**1. Success is influenced by both number of backers and contribution size.**

**2. Strong campaigns combine large communities with meaningful contributions.**

---

# Overall Conclusion
**1. Campaigns with more backers have significantly higher success rates, with 500+ backers achieving over 90% success.**

**2. Campaigns with no or very few backers rarely succeed, highlighting the importance of early traction.**

**3.Higher average pledge per backer improves success rates, with large contributors increasing campaign performance.**

**4. The most successful campaigns balance both strong community size and higher-value contributions.**