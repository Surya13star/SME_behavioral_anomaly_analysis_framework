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



