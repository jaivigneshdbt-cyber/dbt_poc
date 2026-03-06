{% snapshot orders_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='ORDER_ID',

        strategy='check',
        check_cols=['ORDER_STATUS', 'TOTAL_AMOUNT'],
        invalidate_hard_deletes=True
    )
}}

SELECT
    ORDER_DATE,
    ORDER_ID,
    ORDER_STATUS,
    TOTAL_AMOUNT,
    USER_ID
FROM
    {{ source('ecommerce', 'orders') }} -- Assuming 'raw_db' is your source and 'orders' is the table

{% endsnapshot %}