-- SME Behavioral Anomaly Detection
-- Sanitized portfolio representation
-- This is a conceptual reconstruction of the analytical pipeline.
-- Proprietary banking tables, schemas, business rules and mappings
-- have been intentionally excluded.

WITH customer_list AS (

    SELECT
        relationship_id,
        MAX(customer_reference_date) AS customer_reference_date
    FROM customer_source
    WHERE customer_reference_date BETWEEN <analysis_start> AND <analysis_end>
    GROUP BY relationship_id

),

txn_normalized AS (

    SELECT
        relationship_id,
        account_id,
        transaction_date,
        transaction_year,
        transaction_month,

        CASE
            WHEN transaction_type = 'CREDIT'
                THEN transaction_amount * <conversion_rate>
            ELSE 0
        END AS credit_amount,

        CASE
            WHEN transaction_type = 'DEBIT'
                THEN transaction_amount * <conversion_rate>
            ELSE 0
        END AS debit_amount

    FROM transaction_source
    WHERE transaction_date BETWEEN <analysis_start> AND <analysis_end>

),

monthly_transactions AS (

    SELECT
        relationship_id,
        account_id,
        transaction_year,
        transaction_month,

        COUNT(*) AS transaction_count,

        SUM(CASE
            WHEN credit_amount > 0 THEN 1
            ELSE 0
        END) AS credit_transaction_count,

        SUM(CASE
            WHEN debit_amount > 0 THEN 1
            ELSE 0
        END) AS debit_transaction_count,

        SUM(credit_amount) AS credit_amount,
        SUM(debit_amount) AS debit_amount,

        COUNT(DISTINCT transaction_date) AS active_days,

        AVG(transaction_amount) AS average_transaction_amount,

        MAX(transaction_amount) AS maximum_transaction_amount,

        PERCENTILE_APPROX(
            transaction_amount,
            0.50
        ) AS median_transaction_amount,

        STDDEV(transaction_amount) AS transaction_volatility

    FROM txn_normalized
    GROUP BY
        relationship_id,
        account_id,
        transaction_year,
        transaction_month

),

latest_account_status AS (

    SELECT *
    FROM (
        SELECT
            account_id,
            transaction_year,
            transaction_month,
            account_status,

            ROW_NUMBER() OVER (
                PARTITION BY
                    account_id,
                    transaction_year,
                    transaction_month
                ORDER BY snapshot_timestamp DESC
            ) AS rn

        FROM account_status_source
    ) s
    WHERE rn = 1

),

latest_balance AS (

    SELECT *
    FROM (
        SELECT
            account_id,
            transaction_year,
            transaction_month,
            ledger_balance,

            ROW_NUMBER() OVER (
                PARTITION BY
                    account_id,
                    transaction_year,
                    transaction_month
                ORDER BY snapshot_timestamp DESC
            ) AS rn

        FROM balance_source
    ) b
    WHERE rn = 1

)

SELECT
    t.relationship_id,
    t.account_id,
    t.transaction_year,
    t.transaction_month,

    t.transaction_count,
    t.credit_transaction_count,
    t.debit_transaction_count,

    t.credit_amount,
    t.debit_amount,

    t.credit_amount - t.debit_amount AS net_flow,

    t.active_days,
    t.average_transaction_amount,
    t.maximum_transaction_amount,
    t.median_transaction_amount,
    t.transaction_volatility,

    a.account_status,
    b.ledger_balance

FROM monthly_transactions t

LEFT JOIN customer_list c
    ON t.relationship_id = c.relationship_id

LEFT JOIN latest_account_status a
    ON t.account_id = a.account_id
    AND t.transaction_year = a.transaction_year
    AND t.transaction_month = a.transaction_month

LEFT JOIN latest_balance b
    ON t.account_id = b.account_id
    AND t.transaction_year = b.transaction_year
    AND t.transaction_month = b.transaction_month;
