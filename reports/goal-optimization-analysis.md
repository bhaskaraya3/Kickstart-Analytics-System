# Goal Optimization Analysis

---

## 1. Impact of Unrealistic Funding Goals
### How it is Defined?
- A goal is classified as **Unrealistic** if:
    - Goal > 3 × Median Goal of its Category

### SQL Query
```sql
WITH ranked_goals AS (
SELECT
category,
goal,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY goal) AS rn,
COUNT(*) OVER (PARTITION BY category) AS cnt
FROM kickstart
),
category_median AS (
SELECT
category,
AVG(goal) AS median_goal
FROM ranked_goals
WHERE rn IN (FLOOR((cnt + 1) / 2), FLOOR((cnt + 2) / 2))
GROUP BY category
),
goal_flagged AS (
SELECT 
k.state,
CASE 
WHEN k.goal > 3 * c.median_goal THEN 'Unrealistic'
ELSE 'Realistic'
END AS goal_type
FROM kickstart k
JOIN category_median c
ON k.category = c.category
)
SELECT 
goal_type,
ROUND(100 * AVG(CASE WHEN state = 'Successful' THEN 1 ELSE 0 END),2) AS success_rate
FROM goal_flagged
GROUP BY goal_type;
```

### Result

| goal_type   | success_rate |
|-------------|--------------|
| Realistic   | 39.73%      |
| Unrealistic | 19.89%       |

### Insights
- Success rate drops from 39.73% to 19.89%.
- This is a ~20 percentage point decline.
- Unrealistic campaigns are about 50% less likely to succeed.

## Conclusion
**Excessively ambitious funding targets significantly reduce campaign success probability.**

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
ROUND(100 * AVG(CASE WHEN state = 'Successful' THEN 1 ELSE 0 END),2) AS success_rate,
ROUND(AVG(pledged),2) AS avg_pledged
FROM goal_binned
GROUP BY goal_range
)
SELECT
goal_range,
success_rate,
avg_pledged,
ROUND((success_rate/100 * avg_pledged),2) AS expected_value
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

### Insights
- Expected returns increase initially with goal size.
- Peak occurs at $50K–$100K.
- Declines beyond $100K due to falling success rates.

## Conclusions
**1. $50K–$100K maximizes expected funding return.**

**2. $25K–$50K provides a strong balance of risk and feasibility.**

**3. Above $100K, declining success rates outweigh higher pledges.**


---

## 3. Does Setting a Lower Goal Increase Success Probability?

### SQL Query
```sql
WITH goal_bins AS (
SELECT 
CASE
	WHEN goal < 10000 THEN 'Low Goal'
	WHEN goal < 50000 THEN 'Medium Goal'
	WHEN goal < 200000 THEN 'High Goal'
ELSE 'Very High Goal'
END AS goal_groups,
state
FROM kickstart
)
SELECT 
goal_groups,
ROUND(100 * AVG(CASE WHEN state = 'Successful' THEN 1 ELSE 0 END),2) AS success_rate
FROM goal_bins
GROUP BY goal_groups
ORDER BY success_rate DESC;
```

### Result

| Goal Group | Success Rate |
|------------|--------------|
| Low goal   | **43.08%** |
| Medium goal| 28.05% |
| High goal  | 13.93% |
| Very High goal | **4.18%** |

### Insights
- Success probability decreases sharply as goal size increases.
- Low goals succeed 43%, while very high goals succeed only 4%.
- Strong inverse relationship between goal size and success rate.

## Conclusion
**Lower funding goals significantly increase the probability of campaign success.**

---

# Overall Conclusions
**1. Unrealistic funding goals significantly reduce success probability.**

**2. There exists an optimal funding range balancing risk and return.**

**3. Lower funding goals strongly improve campaign success rates.**