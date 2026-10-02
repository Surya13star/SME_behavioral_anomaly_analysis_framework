# SME_behavioral_anomaly_analysis_framework
Statistical framework for detecting anomalous SME transaction behaviour using historical baselines, robust statistics, behavioural dimensions, emergence signals, and multidimensional anomaly scoring.

# SME Behavioral Anomaly Detection

### Statistical Detection of Unusual Transaction Behavior in SME Relationships

A statistical anomaly detection framework designed to identify **unusual and emerging behavioral patterns** in SME relationship customers using historical transaction behavior.

The framework combines **SQL-based analytical data modelling, Python/Pandas, robust statistical methods, correlation-aware behavioral dimensions, percentile-based anomaly detection, and multidimensional scoring** to identify relationships that may warrant further investigation.

> **Portfolio Note:** This repository presents a sanitized representation of the analytical methodology and technical approach. It does not contain proprietary banking data, customer information, internal systems, confidential business rules, or production SQL.


## Project Overview

### Problem

SME customers can exhibit complex transaction behavior that varies significantly across businesses and over time. Simple fixed thresholds or single-variable rules may not adequately capture unusual changes in customer behavior.

The challenge was to identify relationships exhibiting **statistically unusual, multidimensional, or newly emerging transaction behavior** that could be prioritized for further investigation.

### Objective

Develop a data-driven statistical framework to:

* Establish historical behavioral baselines for SME relationships
* Measure current behavior relative to historical patterns
* Detect statistically extreme behavioral observations
* Identify anomalies across multiple behavioral dimensions
* Detect newly emerging activity
* Produce an interpretable anomaly-based segmentation for investigation prioritization

### Analytical Approach

The solution followed an end-to-end analytical pipeline:

**SQL Data Modelling**
→ Customer population definition
→ Transaction normalization
→ Monthly behavioral aggregation
→ Feature engineering
→ Account and balance enrichment

**Python / Statistical Analysis**
→ Historical behavioral baselines
→ Behavioral deviation measures
→ Robust Z-scores
→ 99th-percentile anomaly detection
→ Correlation analysis
→ Behavioral anomaly themes
→ Emergence detection
→ Multidimensional anomaly scoring
→ Anomaly-based segmentation

### Key Outcome

The framework analyzed **29,445 SME relationship records** and classified behavioral patterns into five analytical segments:

| Segment                           | Relationships |
| --------------------------------- | ------------: |
| Normal                            |        28,130 |
| Emerging Behaviour                |           997 |
| Significant Anomaly               |           231 |
| Critical Multidimensional Anomaly |            77 |
| High Multidimensional Anomaly     |            10 |

The resulting framework was designed to support **investigation prioritization by combining statistical extremeness, behavioral breadth, and changes from historical patterns**.

### Technology

**SQL · Python · Pandas · Statistical Analysis · Robust Statistics · Anomaly Detection · Feature Engineering · Correlation Analysis**


## Business Context & Analytical Objective

### Why Traditional Thresholds Can Be Insufficient

Transaction behavior can vary substantially across SME relationships because different businesses naturally operate at different scales and frequencies.

For example, a high transaction volume may be completely normal for one relationship but highly unusual for another.

Therefore, using only absolute thresholds such as:

* Transaction amount > X
* Transaction count > Y
* Maximum transaction > Z

can produce a large number of false signals and may fail to identify meaningful changes in an individual relationship's behavior.

### Behavioral Baseline Approach

The framework instead established a **historical behavioral baseline for each relationship** and evaluated subsequent behavior relative to that baseline.

Conceptually:

```text
Historical Behavior
        ↓
Customer-specific Baseline
        ↓
Current Behavior
        ↓
Deviation from Historical Pattern
        ↓
Statistical Anomaly Signal
```

This changes the analytical question from:

> "Is this customer large or highly active?"

to:

> **"Is this customer's current behavior unusually different from its established historical pattern?"**

### Multidimensional Analysis

A second objective was to avoid relying on a single transaction metric.

An unusual transaction count, high monetary flow, or large individual transaction may each have legitimate explanations when considered independently.

The framework therefore grouped related variables into three broader behavioral dimensions:

1. **Activity Intensity** — how actively the relationship is transacting
2. **Funds Movement** — the magnitude of credit and debit flows
3. **Transaction Characteristics** — transaction size and volatility patterns

The framework also incorporated **emergence signals** to distinguish established high activity from newly elevated behavior.

### Analytical Objective

The overall objective was therefore to build an interpretable framework that evaluates:

**Magnitude + Historical Deviation + Behavioral Breadth + Emergence**

rather than relying on a single threshold or isolated anomaly.

## Data & Data Model

### Analytical Population

The analysis focused on a defined population of **SME relationship customers** observed over a six-month historical period.

The underlying data was extracted through SQL in **two controlled batches**, covering the required six-month analytical window, and subsequently consolidated in Python/Pandas for statistical analysis.

### Data Sources

The analytical dataset was constructed by combining information conceptually representing:

* **Customer / Relationship data** — relationship identifiers and customer attributes
* **Transaction data** — transaction-level activity, amounts, dates, currencies and credit/debit indicators
* **Account data** — monthly account status information
* **Balance data** — monthly ledger balance and currency information

Internal banking table names and proprietary identifiers are intentionally excluded from this repository.

### Analytical Data Flow

```text
Customer / Relationship Data
            │
            ├──────────────┐
            │              │
            ▼              ▼
     Transaction Data   Account Data
            │              │
            ▼              │
   Currency Normalization  │
            │              │
            ▼              │
     Monthly Aggregation   │
            │              │
            └───────┬──────┘
                    │
                    ▼
             Balance Data
                    │
                    ▼
          Final Analytical Dataset
                    │
                    ▼
             Python / Pandas
                    │
                    ▼
          Statistical Analysis
```

### Analytical Grain

The transaction data was initially aggregated into a **monthly account-level behavioural structure**, with relationship information retained for downstream relationship-level analysis.

The monthly structure allowed the framework to compare behavioral patterns across time and establish historical baselines.

### Core Behavioral Features

The analytical dataset contained features representing four major aspects of SME behavior:

#### 1. Transaction Activity

* Transaction count
* Credit transaction count
* Debit transaction count
* Active transaction days
* Transaction frequency

#### 2. Funds Movement

* Credit transaction amount
* Debit transaction amount
* Net flow amount

$$
Net\ Flow = Credit\ Amount - Debit\ Amount
$$

#### 3. Transaction Characteristics

* Median transaction amount
* Average transaction amount
* Maximum transaction amount
* Transaction volatility

#### 4. Account / Customer Context

* Relationship identifier
* Account identifier
* Customer incorporation/date-of-birth attribute
* Account status
* Ledger balance
* Currency
* Unconverted currency count

### Data Quality & Preparation Considerations

The SQL preparation layer incorporated several data-quality considerations:

* Standardization of transaction indicators
* Trimming of join keys
* Currency normalization
* Handling of unsupported/unconverted currencies
* Monthly aggregation
* Latest-record selection from snapshot-style account and balance data
* Prevention of duplicate monthly snapshots using window functions

The resulting analytical dataset was then passed to Python/Pandas for statistical modelling.


## 5. SQL Data Pipeline

The analytical dataset was built through a modular SQL pipeline before being transferred to Python/Pandas for statistical analysis.

The SQL layer focused on creating a consistent, analysis-ready dataset while preserving account-level behavioral information.

### Pipeline Architecture

```text
Customer Population
        ↓
Transaction Extraction
        ↓
Currency Normalization
        ↓
Monthly Account-Level Aggregation
        ↓
Behavioral Feature Engineering
        ↓
Latest Account Status
        ↓
Latest Monthly Balance
        ↓
Final Analytical Dataset
        ↓
Python / Pandas
```

### 5.1 Customer Population

The first stage defined the SME relationship population within the analysis period.

Customer-level information was used to establish the relevant relationship population and provide contextual attributes for downstream analysis.

The production population logic and internal source systems are intentionally excluded from this public repository.

### 5.2 Transaction Normalization

Transaction records were transformed into a consistent analytical format.

Key processing included:

* Standardizing relationship and account identifiers
* Converting transaction dates into monthly analytical periods
* Separating credit and debit activity
* Normalizing supported currencies into a common monetary basis
* Tracking transactions where currency conversion was unavailable
* Removing inconsistencies in join keys through data standardization

This created a consistent transaction-level foundation for subsequent aggregation.

### 5.3 Monthly Behavioral Aggregation

Transactions were aggregated to the primary SQL analytical grain:

```text
relationship × account × month × year
```

This preserved account-level behavioral information while retaining the relationship identifier required for downstream relationship-level analysis.

The aggregation generated behavioural measures including:

* Transaction count
* Credit transaction count
* Debit transaction count
* Credit transaction amount
* Debit transaction amount
* Active days
* Transaction frequency
* Median transaction amount
* Average transaction amount
* Maximum transaction amount
* Transaction volatility
* Net flow
* Unconverted currency count

### 5.4 Latest Snapshot Selection

Account status and balance information can contain multiple records for the same account and monthly period.

To avoid duplicate or outdated observations, window functions were used to identify the latest available record for each account-month combination.

Conceptually:

```sql
ROW_NUMBER() OVER (
    PARTITION BY accountno, year, month
    ORDER BY snapshot_timestamp DESC
)
```

Only the latest applicable observation was retained for enrichment of the analytical dataset.

### 5.5 Dataset Enrichment

The monthly transaction features were then enriched with:

* Customer/relationship attributes
* Account status
* Monthly balance information
* Currency-related indicators

The resulting dataset provided both behavioural and contextual information for each account-month observation.

### 5.6 Extraction to Python

The SQL extraction was performed in two controlled batches covering the required historical period.

The resulting datasets were consolidated in Python/Pandas.

Where relationship-level behavioural analysis was required, the account-level observations were subsequently aggregated to the relationship level in Python before statistical modelling.

This separation between **SQL data modelling** and **Python statistical analysis** allowed the data preparation layer and analytical modelling layer to remain independently interpretable.

> **Public Repository Note:** The SQL structure shown here represents the analytical methodology used in the project. Production table names, internal schemas, business-specific filters, proprietary mappings, and other confidential implementation details have been intentionally excluded.


## 6. Python/Pandas Analytical Preparation

After the SQL extraction, the analytical datasets were loaded into Python/Pandas for statistical analysis.

The objective at this stage was to transform the account-level monthly observations into a consistent structure suitable for relationship-level behavioral analysis.

### 6.1 Data Consolidation

The two SQL extraction batches were loaded into Pandas and consolidated into a single analytical dataset covering the complete historical period.

The preparation process included:

* Combining the extracted datasets
* Standardizing data types
* Validating analytical columns
* Handling missing or non-applicable values
* Ensuring monthly observations were correctly represented
* Preparing relationship and account identifiers for aggregation

### 6.2 Relationship-Level Analytical View

The SQL dataset preserved the analytical grain:

```text
relationship × account × month × year
```

For statistical analysis, the required account-level observations were subsequently aggregated to the **relationship level**.

This allowed the framework to evaluate behavioral patterns across the customer's accounts rather than treating every account as an independent customer.

The relationship-level analytical view was then used for:

* Historical behavioral baselines
* Current-vs-historical comparisons
* Statistical deviation analysis
* Correlation analysis
* Behavioral theme construction
* Emergence detection
* Multidimensional anomaly scoring

### 6.3 Historical Behavioral Baselines

For each relationship and behavioral factor, historical observations were used to establish a baseline representing the customer's typical behavior.

The baseline was primarily based on the **historical median**.

The median was selected because several important transaction variables exhibited substantial right-skewness and extreme values.

Using the median reduced the influence of unusually large transactions and provided a more robust representation of typical historical behavior.

### 6.4 Behavioral Deviation

Current-period behavior was compared against the corresponding historical baseline.

Conceptually:

```text
Historical Behavior
        ↓
Customer-Specific Baseline
        ↓
Current Behavior
        ↓
Behavioral Deviation
        ↓
Statistical Anomaly Analysis
```

Examples of behavioral measures included:

* Transaction count relative to historical activity
* Credit amount relative to historical behavior
* Debit amount relative to historical behavior
* Average transaction amount relative to historical behavior
* Transaction volatility relative to historical behavior

This transformed the analysis from simply asking:

> "Is this customer large?"

to asking:

> "Is this customer's current behavior unusual relative to its own historical pattern?"

### 6.5 Preparation for Multidimensional Analysis

The resulting relationship-level dataset provided the foundation for the subsequent anomaly framework.

The analysis then combined:

1. **Magnitude** — how large the behavioral deviation was
2. **Historical deviation** — how unusual it was relative to the customer's baseline
3. **Behavioral breadth** — how many behavioral dimensions were affected
4. **Emergence** — whether the behavior represented a newly developing pattern

These components were subsequently combined into an interpretable multidimensional anomaly framework.


