# Kickstart Campaigns Analysis

## Project Overview
This project analyzes Kickstarter campaign data to reveal unhidden trends and insights that can help creators optimize their campaigns for success. We explore various factors such as campaign duration, funding goals, category performance, and more to understand what contributes to a successful Kickstarter campaign.

## About Dataset
The dataset contains information about Kickstarter campaigns, including:
- Campaign name
- Category
- Funding goal
- Amount pledged
- Number of backers
- Campaign duration
- Launch date
- Campaign state (successful, failed, etc.)

This data allows us to perform a comprehensive analysis of the factors influencing campaign success.

## Core Business Questions
### *1. What is the success rate?*

#### Insights
> Nearly **60%** of campaigns fail.
> Kickstarter is highly competitive.
> More than half of creators do not meet their funding goals.

**This indicates the importance of goal sizing, duration optimization, and category positioning.**

### *2. Does funding goal impact success?*

#### Insights
- Campaigns exceeding 3× their category median goal:
    - Increase perceived execution risk
    - Slow early funding momentum
    - Require unrealistic average pledge per backer
    - Reduce probability of reaching funding threshold

**Excessively ambitious funding targets significantly undermine campaign viability.**

### 3. How do backers influence outcomes?

#### Insights
- Success probability increases dramatically as the number of backers grows:
    - Campaigns with no backers never succeed.
    - Campaigns with very few backers succeed only ~5% of the time.
    - Campaigns with 200+ backers achieve success rates above 75%.
    - Campaigns with 500+ backers succeed over 90% of the time.

**This shows a strong positive relationship between community size and campaign success.**

### 4. Does campaign duration matter? 

#### Insights

- **Short Campaigns Perform Best**
    - Campaigns lasting 0–30 days show the highest success rate (~36.6%).
    - Shorter campaigns may create urgency and momentum, encouraging faster backing decisions.

- **Medium and Long Campaigns Show Similar Performance**
    - Campaigns running 31–90 days have a slightly lower success rate (~34%).
    - This suggests that extending campaign duration does not significantly increase the chances of success.

- **Very Long Campaigns Perform the Worst**
    - Campaigns running more than 90 days have the lowest success rate (~29%).  
    - Long durations may reduce urgency and signal weaker campaign planning.

