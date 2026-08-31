# Customer Retention Strategy Analysis

A SQL-driven customer intelligence project for a direct-to-consumer (D2C) fashion brand — built to answer
one question: **are customers genuinely loyal, or is the business just buying repeat visits with
discounts?**

---

## Business Problem

The brand sells clothing, accessories, footwear, and outerwear directly to consumers across the US, runs
an active promotional discount program, and has behavioral data on ~3,900 customers — but no structured
way to read it. It cannot currently answer who its most valuable customers are, how much of its revenue
depends on discounts, or which customers would keep buying if promotions were pulled back.

**Objectives**
- Identify high-value customers
- Measure promotion dependency
- Build a data-backed loyalty metric
- Analyze customer behavior across category, geography, and season
- Turn the findings into a retention recommendation

The dataset has **no loyalty score, no churn label, and no timestamps** — every metric used in this
analysis (loyalty, value tier, promo dependency) is engineered from raw transactional and behavioral
fields, not assumed.

## Repository Structure

```
.
├── data/
│   ├── Dataset.csv              # Raw customer transactional & behavioral data (~3,900 rows)
│   └── customer_features.csv    # Cleaned data + engineered features (output of notebook 1)
├── notebooks/
│   ├── customer_retention_strategy_analysis.ipynb   # Python: cleaning, EDA, feature engineering
├── Playbook/
|   └── Retention Playbook.docx
├── Powerbi/
|   └── customer_dashboard.pbix
├── sql/
|   ├── customer.db
|   └── sqlQuaries.ipynb
├── Executive summary.docx
└── README.md
```

## Notebooks

### 1. `customer_retention_strategy_analysis.ipynb`
Python (pandas, scikit-learn) notebook covering:

- **Data loading & quality checks** — shape, dtypes, missing values, duplicates
- **Exploratory data analysis** — revenue by category, discount usage, average spend by category
- **Feature engineering**
  - `annual_frequency` — converts the ordinal `Frequency of Purchases` label (Weekly, Monthly, etc.) into
    an estimated number of purchases per year
  - `promo_dependency` — how reliant a customer is on `Discount Applied` / `Promo Code Used` to transact
- **Loyalty model** — `loyalty_score` built as a weighted, min-max-scaled composite:

  ```
  loyalty_score = 0.4 × previous_purchases_scaled
                + 0.3 × frequency_scaled
                + 0.2 × purchase_amount_scaled
                + 0.1 × review_rating_scaled
  ```

- **Customer segmentation** — `value_tier` (High / Medium / Low Value) from `loyalty_score` thresholds
- **Loyalty vs. promo-dependency breakdown by tier**, and **loyalty by category**
- Exports the enriched dataset to `data/customer_features.csv` for the SQL layer

### 2. `sqlQuaries.ipynb`
Loads `customer_features.csv` into an in-memory SQLite database and answers the case's core business
questions with SQL (`GROUP BY`, aggregate functions, `HAVING`):

| Question | What the query surfaces |
|---|---|
| **Q1.** What separates high-value from low-value customers, and which profiles repeat-purchase the most? | Spend, previous purchases, loyalty score, and discount dependency by `value_tier`; strongest repeat-purchase profiles by gender × category × location × frequency |
| **Q2.** Which seasons/categories skew toward lower-tenure vs. high-previous-purchase customers? | Season × category breakdown of purchase history and customer stage |
| **Q3.** Which geographies signal organic demand vs. discount-driven volume? | Location-level revenue, average spend, and discount reliance |

Each query is paired with a short written answer interpreting the result for a non-technical reader.

## Key Findings

- **High-value customers** are separated by higher spending, more previous purchases, a stronger loyalty
  score, and lower discount dependency — and they show the strongest repeat-purchase behavior.
- **Clothing** generated the highest revenue and the highest average loyalty score of any category.
- **Footwear** customers showed high spending behavior relative to other categories.
- Customer segmentation surfaced clearly different retention opportunities across tiers.
- The `promo_dependency` score isolates the customers whose repeat behavior is most at risk if
  discounting is scaled back.

## Recommended Actions

- Reduce blanket, brand-wide promotions in favor of targeted offers
- Protect high-loyalty customers with experience-based benefits instead of discounts
- Target low-value / high-promo-dependency customers with personalized retention campaigns rather than
  further blanket discounting

## How to Run

1. Clone the repo and install dependencies:
   ```bash
   pip install pandas numpy matplotlib scikit-learn
   ```
2. Run `notebooks/customer_retention_strategy_analysis.ipynb` first — it cleans `data/Dataset.csv`,
   engineers the loyalty and promo-dependency metrics, and writes `data/customer_features.csv`.
3. Run `sql/sqlQuaries.ipynb` next — it loads `data/customer_features.csv` into SQLite and runs the
   segmentation queries.

## Tech Stack

- **Python** — pandas, NumPy, scikit-learn (`MinMaxScaler`), Matplotlib
- **SQL** — SQLite (via `sqlite3`), queried through pandas
