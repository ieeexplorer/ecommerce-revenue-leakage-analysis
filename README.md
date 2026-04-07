# E-commerce Revenue Leakage & Retention Analysis

## Overview
This is a portfolio-ready **Data Analyst project** designed to demonstrate:
- SQL skills: joins, aggregations, CTEs, window/cohort logic
- pandas skills: cleaning, merging, feature engineering, KPI calculation
- charting and dashboard thinking
- business storytelling through actionable recommendations

## Business Problem
An e-commerce company wants to understand:
- why revenue fluctuates
- which products and regions perform best
- where returns and delays hurt performance
- which customers are most valuable
- which customers are at risk of churn

## Dataset
The project uses six tables:
- `customers`
- `orders`
- `products`
- `payments`
- `returns`
- `shipping`

Sample CSVs are included under `data/raw/`.

## Tools
- SQL (PostgreSQL-style syntax)
- pandas
- matplotlib
- Jupyter Notebook

## Project Structure
```text
ecommerce-analyst-project/
├── data/
│   ├── raw/
│   └── cleaned/
├── sql/
├── notebooks/
├── dashboard/
├── reports/
├── README.md
└── requirements.txt
```

## Key Questions Answered
1. What is the monthly revenue trend?
2. Which categories generate the most revenue and gross margin?
3. Which customers have the highest lifetime value?
4. Which customers appear to be at churn risk?
5. Which regions have the highest delivery delay rate?
6. Which categories have the highest return rate?

## How to Run
1. Create a virtual environment.
2. Install requirements:
   ```bash
   pip install -r requirements.txt
   ```
3. Open Jupyter:
   ```bash
   jupyter notebook
   ```
4. Run notebooks in this order:
   - `notebooks/01_data_cleaning.ipynb`
   - `notebooks/02_analysis.ipynb`
   - `notebooks/03_visuals.ipynb`

## Key Insights You Can Present
- Revenue is concentrated in a few categories and regions.
- Return rates reveal possible quality or expectation issues.
- Delivery delays cluster in specific regions.
- Repeat customers contribute disproportionate value.
- Churn-risk customers can be targeted with retention offers.

## Recommendations
- Review return-heavy categories for product or listing issues.
- Improve shipping SLAs in high-delay regions.
- Build a retention campaign for high-value customers inactive for >45 days.
- Reduce discount dependency where margin erosion is significant.

## Portfolio Pitch
> I built an end-to-end e-commerce business analysis project using SQL, pandas, and charts to identify revenue leakage, retention patterns, and operational issues. The project includes a cleaned analyst-ready dataset, KPI SQL queries, customer and product analysis, and visual storytelling with business recommendations.