## Backer Behavior Analysis

### 1. Business Question
How does the number of backers influence campaign success?

Crowdfunding platforms rely heavily on **community participation**.  
A larger number of backers may increase the probability of success through social proof and funding momentum.

To analyze this, campaigns were grouped into backer ranges and their success rates were compared.

---

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
---

### Results

| Backer Bucket | Total Campaigns | Successful Campaigns | Success Rate |
|---------------|----------------|----------------------|--------------|
| Viral | 12,690 | 11,946 | **94.14%** |
| High | 18,950 | 16,565 | **87.41%** |
| Medium | 69,519 | 53,920 | **77.56%** |
| Low | 94,010 | 45,105 | 47.98% |
| Very Low | 127,880 | 6,315 | 4.94% |
| No Backers | 51,804 | 0 | **0%** |

---

### Key Insight
Success probability increases dramatically as the number of backers grows:
- Campaigns with **no backers never succeed**.
- Campaigns with **very few backers succeed only ~5% of the time**.
- Campaigns with **200+ backers achieve success rates above 75%**.
- Campaigns with **500+ backers succeed over 90% of the time**.

This shows a **strong positive relationship between community size and campaign success**.

---

### Business Interpretation

Backer count acts as a form of **social proof** in crowdfunding:
- Higher participation signals trust and demand.
- Early funding momentum attracts additional supporters.
- Campaign visibility increases as engagement grows.

This creates a **network effect**, where each additional backer increases the likelihood of future backers joining.

---

### Conclusion

Backer engagement is one of the **strongest predictors of crowdfunding success**.

Campaigns that attract a large community early are significantly more likely to reach their funding goals due to momentum, visibility, and social validation.

## 2. Are Successful Campaigns Driven by Many Small Backers or Large Contributions?

### Business Question
Do successful crowdfunding campaigns rely on many small contributors or fewer large contributors?

Understanding pledge composition helps reveal whether crowdfunding success is primarily **community-driven** or **large-donor driven**.

To analyze this, the **average pledge per backer** was calculated and campaigns were grouped into pledge size categories.

---

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
---

### Results

| Backer Type | Total Campaigns | Successful Campaigns | Success Rate |
|-------------|---------------|---------------------|-------------|
| Very Large Backers | 60,853 | 34,403 | **56.53%** |
| Large Backers | 91,983 | 50,735 | **55.16%** |
| Moderate Backers | 108,034 | 42,814 | 39.63% |
| Small Backers | 62,179 | 5,899 | **9.49%** |

---

### Key Insight

Campaigns with **higher average pledge per backer show higher success rates**:

- Small pledge campaigns succeed only **~9% of the time**
- Moderate pledge campaigns succeed **~40%**
- Large pledge campaigns exceed **55% success**

This suggests that campaigns receiving **larger average contributions per supporter** tend to have stronger funding outcomes.

---

### Business Interpretation

Higher pledge sizes may indicate:
- Stronger supporter commitment
- Higher perceived product value
- Support from more financially capable backers

Campaigns that rely solely on very small contributions may struggle to reach their funding targets due to slower capital accumulation.

---

### Analytical Consideration

Average pledge per backer can be influenced by total funds raised.  
Since successful campaigns often raise more money overall, this metric may partially reflect **campaign success rather than purely backer behavior**.

Therefore, pledge composition should be interpreted alongside **backer count and total funding momentum**.

---

### Conclusion

While larger average contributions correlate with higher success rates, crowdfunding success is typically driven by a **combination of community size and pledge magnitude** rather than large contributions alone.