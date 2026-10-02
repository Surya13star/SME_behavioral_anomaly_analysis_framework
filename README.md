# SME Behavioral Anomaly Detection

### Statistical Detection of Unusual Transaction Behavior in SME Relationships

A statistical anomaly detection framework designed to identify **unusual and emerging transaction behavior** in SME relationship customers using historical behavioral patterns.

The project combines **SQL data modelling, Python/Pandas, robust statistics, percentile-based detection, correlation analysis, behavioral dimensions, emergence signals, and multidimensional anomaly scoring**.

> **Portfolio Note:** This repository presents a sanitized representation of the analytical methodology and technical approach. It does not contain proprietary banking data, customer information, internal systems, confidential business rules, or production SQL.

---

## 1. Business Problem

SME customers can exhibit highly diverse transaction behavior. Fixed thresholds or single-variable rules may identify unusually large transactions, but may not capture whether the behavior is actually unusual **for that relationship**.

The objective was therefore to build a framework that could identify relationships showing:

* Significant deviation from historical behavior
* Extreme activity across key behavioral factors
* Unusual behavior across multiple dimensions
* Newly emerging behavioral patterns
* Combinations of signals that could support investigation prioritization

The framework focuses on **behavioral anomaly detection**, not definitive fraud or AML classification.

---

## 2. Analytical Approach

```text
SQL Data Modelling
        ↓
Monthly Behavioral Features
        ↓
Historical Baselines
        ↓
Robust Statistical Analysis
        ↓
99th Percentile Signals
        ↓
Correlation-Aware Themes
        ↓
Emergence Signals
        ↓
Multidimensional Anomaly Score
        ↓
Behavioral Segmentation
        ↓
Investigation Prioritization
```

### Core analytical principles

**Magnitude** — How unusual is the observed behavior?

**Historical deviation** — How different is current behavior from the relationship's established pattern?

**Behavioral breadth** — How many distinct behavioral dimensions are affected?

**Emergence** — Is the unusual behavior newly developing?

---

## 3. Data & Analytical Grain

The analytical population consisted of SME relationship customers observed across a six-month historical period.

The primary SQL analytical grain was:

```text
relationship × account × month × year
```

This preserved account-level behavioral information while retaining the relationship identifier for downstream analysis.

Where required, account-level observations were subsequently aggregated to the **relationship level in Python/Pandas** before statistical modelling.

### Key behavioral features

**Activity**

* Transaction count
* Credit/debit transaction counts
* Active days
* Transaction frequency

**Funds Movement**

* Credit amount
* Debit amount
* Net flow

**Transaction Characteristics**

* Median transaction amount
* Average transaction amount
* Maximum transaction amount
* Transaction volatility

**Context**

* Relationship/account identifiers
* Account status
* Balance
* Currency indicators

---

## 4. SQL Data Pipeline

The SQL layer was used to create a consistent analytical dataset.

Key processing included:

1. Defining the relevant SME population
2. Extracting transaction data
3. Normalizing supported currencies
4. Aggregating transaction behavior by account-month
5. Engineering behavioral features
6. Selecting the latest account status records
7. Selecting the latest monthly balance records
8. Producing the final analytical dataset

Window functions were used to select the latest applicable snapshots and avoid duplicate observations.

The resulting data was extracted in controlled batches and consolidated in Python/Pandas.

A sanitized representation of the pipeline is available in:

```text
sql/analytical_pipeline.sql
```

---

## 5. Statistical Framework

### Historical Baselines

Historical monthly behavior was used to establish a baseline for each relationship.

The **median** was preferred for key behavioral measures because several transaction variables exhibited substantial right-skewness and extreme values.

This allowed the analysis to ask:

> **How unusual is the current behavior relative to the relationship's own historical pattern?**

### Robust Z-Scores

To reduce sensitivity to extreme observations, robust statistical measures based on the median and Median Absolute Deviation (MAD) were used.

```text
Robust Z = (x - Median) / (1.4826 × MAD)
```

This provided a continuous measure of behavioral deviation while being less sensitive to extreme observations than a conventional mean/std-based Z-score.

### 99th Percentile Detection

For selected behavioral factors, the 99th percentile was used to identify extreme-tail observations.

```text
value > 99th percentile → anomaly signal
```

The percentile approach complemented the continuous robust Z-score by providing an interpretable threshold for the most extreme observations.

---

## 6. Correlation-Aware Behavioral Dimensions

Correlation analysis was used to avoid treating strongly related variables as completely independent evidence.

For example, credit and debit transaction amounts showed a correlation of approximately **0.98** in the analyzed data.

Rather than simply adding every factor independently, related variables were grouped into three broader behavioral dimensions:

| Dimension                       | Representative Signals                     |
| ------------------------------- | ------------------------------------------ |
| **Activity Intensity**          | Transaction count, active days, frequency  |
| **Funds Movement**              | Credit amount, debit amount, net flow      |
| **Transaction Characteristics** | Average amount, maximum amount, volatility |

Each dimension was converted into an interpretable theme-level anomaly signal.

The number of anomalous themes was represented as:

```text
anomaly_theme_count = 0 → 3
```

This provided a measure of **behavioral breadth**.

---

## 7. Emergence Detection

The framework also evaluated whether unusual behavior represented a **newly developing pattern** rather than simply consistently high historical activity.

Examples included:

* New credit activity
* Newly elevated transaction activity
* Sudden increases relative to historical behavior

These signals were aggregated into an:

```text
emergence_signal_count
```

This added a temporal perspective to the anomaly framework.

A customer could therefore be:

* Historically high but stable
* Newly changing
* Multidimensionally unusual
* Both multidimensionally unusual and newly emerging

---

## 8. Multidimensional Anomaly Score

The three behavioral dimensions were combined into a weighted multidimensional anomaly score.

```text
Multidimensional Score
=
Activity Score × Weight
+
Funds Movement Score × Weight
+
Transaction Characteristics Score × Weight
```

The calibrated dimension weights totaled **100%**.

The score was evaluated alongside:

* `anomaly_theme_count`
* `emergence_signal_count`

This produced an interpretable combination of:

**anomaly strength + behavioral breadth + behavioral emergence**

The score was designed for **investigation prioritization**, not as a probability of fraud or a definitive AML classification.

---

## 9. Final Behavioral Segmentation

The anomaly themes, emergence signals, and multidimensional analysis were translated into five relationship-level behavioral segments.

| Segment                           | Relationships |
| --------------------------------- | ------------: |
| Normal                            |        28,130 |
| Emerging Behaviour                |           997 |
| Significant Anomaly               |           231 |
| Critical Multidimensional Anomaly |            77 |
| High Multidimensional Anomaly     |            10 |
| **Total**                         |    **29,445** |

The segmentation rules considered combinations of anomalous behavioral themes and emergence signals.

For example, the most differentiated category required anomalous behavior across all three dimensions together with emerging behavior.

These categories represent **behavioral anomaly segments**, not confirmed suspicious activity.

---

## 10. Key Insights

The analysis demonstrated several important principles for behavioral anomaly detection:

### 1. Absolute size is not enough

A large transaction does not automatically represent unusual behavior. Historical context provides a more meaningful reference point.

### 2. Financial data requires robust statistics

Strong right-skewness and extreme values make median/MAD-based approaches useful for behavioral analysis.

### 3. Correlated variables can exaggerate evidence

Highly correlated variables should not automatically be counted as independent anomaly dimensions.

### 4. Behavioral breadth matters

Anomaly signals across multiple distinct dimensions can provide more context than an isolated extreme factor.

### 5. Change matters alongside magnitude

A newly emerging behavioral pattern can provide information that a static threshold cannot capture.

---

## 11. Business Interpretation

The framework can be used as an analytical prioritization layer:

```text
Large SME Population
        ↓
Behavioral Anomaly Detection
        ↓
Prioritized Relationship Segments
        ↓
Analyst Review
        ↓
Business Context Validation
        ↓
Further Investigation
```

The framework does **not** replace human investigation or existing risk controls.

Unusual behavior may have legitimate explanations such as business growth, seasonality, new contracts, large commercial transactions, or changes in operating patterns.

---

## 12. Technology Stack

* **SQL** — data extraction, aggregation, feature engineering, window functions
* **Python**
* **Pandas**
* **Robust Statistics**
* **Statistical Anomaly Detection**
* **Correlation Analysis**
* **Feature Engineering**
* **Behavioral Scoring**

---

## 13. Repository Structure

```text
sme-behavioral-anomaly-detection/
│
├── README.md
│
├── sql/
│   └── analytical_pipeline.sql
│
├── visuals/
│   └── README.md
│
└── .gitignore
```

The repository intentionally excludes production banking data and implementation details.

---

## 14. Architecture

```text
Customer / Transaction / Account / Balance Data
                       │
                       ▼
              SQL Data Pipeline
                       │
                       ▼
       relationship × account × month × year
                       │
                       ▼
                Python / Pandas
                       │
                       ▼
          Historical Behavioral Baselines
                       │
                       ▼
       Robust Statistics + Percentile Signals
                       │
                       ▼
       Correlation-Aware Behavioral Themes
                       │
                       ▼
             Emergence Detection
                       │
                       ▼
        Multidimensional Anomaly Score
                       │
                       ▼
          Behavioral Anomaly Segments
                       │
                       ▼
           Investigation Prioritization
```

---

## Disclaimer

This repository is a **sanitized portfolio representation** of an analytical methodology developed in a banking risk analytics context.

No confidential customer information, proprietary datasets, internal systems, production SQL, credentials, internal URLs, or confidential business rules are included.

The anomaly segments are analytical outputs intended for **behavioral investigation prioritization** and should not be interpreted as definitive fraud, AML, regulatory, or misconduct determinations.
