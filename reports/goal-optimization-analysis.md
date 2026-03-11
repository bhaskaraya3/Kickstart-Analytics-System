# Goal Optimization Analysis

---

## 1. Impact of Unrealistic Funding Goals
### How it is Defined?
- A goal is classified as **Unrealistic** if:
    - Goal > 3 × Median Goal of its Category

### SQL Query
```sql
WITH ranked_goals AS(
SELECT
category,
goal,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY goal) AS rn,
COUNT(*) OVER (PARTITION BY category) AS cnt
FROM kickstart
),
category_median AS(
SELECT
category,
AVG(goal) AS median_goal
FROM ranked_goals
WHERE rn IN (FLOOR((cnt + 1) / 2), FLOOR((cnt + 2) / 2))
GROUP BY category
),
goal_flagged AS(
SELECT 
k.state,
CASE WHEN k.goal > 3 * c.median_goal THEN 'Unrealistic'
ELSE 'Realistic'
END AS goal_type
FROM kickstart k
JOIN category_median c
ON k.category = c.category
)
SELECT 
goal_type,
COUNT(*) AS total_projects,
SUM(state = 'Successful') AS successful_projects,
AVG(state = 'Successful') AS success_rate
FROM goal_flagged
GROUP BY goal_type;
```

### Results

| goal_type    | total_projects | successful_projects | success_rate |
|-------------|----------------|--------------------|-------------|
| Realistic   | 298,903       | 118,746            | 39.73%      |
| Unrealistic | 75,950        | 15,105             | 19.89%      |

### Key Insight
- Success rate drops from **39.7% → 19.9%.**
- That is a **19.8** percentage point decline.
- Unrealistic campaigns are **~50%** less likely to succeed.

### Conclusion
**Excessively ambitious funding targets significantly undermine campaign viability.**

---

## 2. What Is the Optimal Goal Range?

### Observation
- Low goals → High success probability but low capital raised  
- High goals → High capital potential but low success probability  

To balance risk and reward, we define:
- **Expected Value = Success Rate × Average Pledged**

### SQL Query
```sql
WITH goal_binned AS (
SELECT
goal,
pledged,
state,
CASE
	WHEN goal < 1000 THEN '0-1K'
	WHEN goal < 5000 THEN '1K-5K'
	WHEN goal < 10000 THEN '5K-10K'
	WHEN goal < 25000 THEN '10K-25K'
	WHEN goal < 50000 THEN '25K-50K'
	WHEN goal < 100000 THEN '50K-100K'
	WHEN goal < 500000 THEN '100K-500K'
ELSE '500K+'
END AS goal_range
FROM kickstart
),
goal_summary AS (
SELECT
goal_range,
COUNT(*) AS total_projects,
ROUND(AVG(state = 'Successful'),2) AS success_rate,
ROUND(AVG(pledged),2) AS avg_pledged
FROM goal_binned
GROUP BY goal_range
)
SELECT
goal_range,
total_projects,
success_rate,
avg_pledged,
ROUND((success_rate * avg_pledged),2) AS expected_value
FROM goal_summary
ORDER BY expected_value DESC;
```

### Result
| goal_range   | success_rate | avg_pledged | expected_value |
|-------------|-------------|------------|---------------|
| 50K-100K    | 15%         | 30,158.74  | **4,523.81**  |
| 25K-50K     | 22%         | 18,919.20  | 4,162.22      |
| 100K-500K   | 9%          | 42,878.38  | 3,859.05      |
| 10K-25K     | 31%         | 10,909.77  | 3,382.03      |
| 500K+       | 3%          | 67,671.78  | 2,030.15      |
| 5K-10K      | 36%         | 4,682.06   | 1,685.54      |
| 1K-5K       | 44%         | 2,093.49   | 921.14        |
| 0-1K        | 50%         | 721.51     | 360.76        |

### Key Insight
- Rises steadily from low ranges.
- Peaks at **$50K–$100K.**
- Declines sharply beyond **$100K.**

### Conclusion
- **$50K–$100K** maximizes expected funding return.
- **$25K–$50K** offers a strong balance of probability (22%) and return.
- Above $100K, declining success probability outweighs higher pledges.

### Risk 
While $50K–$100K maximizes expected value:
- Success rate is only 15%.
- Volatility is higher.
- May require stronger brand validation.

---

## 3. Does Setting a Lower Goal Increase Success Probability?

### SQL Query
```sql
WITH goal_bins AS(
SELECT 
CASE
	WHEN goal < 10000 THEN 'Low goal'
    WHEN goal < 50000 THEN 'Medium goal'
    WHEN goal < 200000 THEN 'High goal'
    ELSE 'Very High goal'
END AS goal_groups,
state
FROM kickstart
)
SELECT 
goal_groups,
COUNT(*) AS total_campaigns,
SUM(CASE WHEN state='Successful' THEN 1 ELSE 0 END) AS successful_campaigns,
ROUND(100*AVG(state = 'Successful'),2) AS success_rate
FROM goal_bins
GROUP BY goal_groups
ORDER BY success_rate DESC;
```

### Results

| Goal Group | Total Campaigns | Successful Campaigns | Success Rate |
|------------|----------------|----------------------|--------------|
| Low goal | 229,679 | 98,950 | **43.08%** |
| Medium goal | 108,914 | 30,547 | 28.05% |
| High goal | 29,101 | 4,055 | 13.93% |
| Very High goal | 7,159 | 299 | **4.18%** |

### Key Insight
Success probability decreases sharply as funding goals increase:
- Low goal campaigns succeed **43% of the time**
- Medium goal campaigns succeed **28% of the time**
- High goal campaigns succeed **14% of the time**
- Very high goal campaigns succeed only **4% of the time**

**This indicates a strong inverse relationship between goal size and success probability.**

## Conclusion
**Setting a lower funding goal significantly increases the probability of campaign success**.

# Overall Conclusion

1. Unrealistic funding goals significantly reduce success probability.
Campaigns with goals greater than 3× the category median experience a success rate drop from 39.7% to 19.9%, making them roughly half as likely to succeed as realistically funded projects.

2. There is an optimal funding range that balances risk and reward.
When considering both success probability and average pledged funding, the $50K–$100K range maximizes expected funding value, while $25K–$50K offers a strong balance of feasibility and return.

3. Lower funding goals strongly increase campaign success probability.
Campaigns with lower goals succeed 43% of the time, while very high goals succeed only 4% of the time, demonstrating a clear inverse relationship between goal size and success rate.