{{ config(
    materialized='ephemeral',
    tags=['finance', 'orders']
) }}

SELECT
    -- Primary Key
    order_id,
    
    -- Foreign Key
    user_id,
    
    -- Timestamps (using our macro)
    {{ to_timestamp('order_date') }} as order_at,
    {{ to_timestamp('CURRENT_TIMESTAMP()') }} as loaded_at,
    
    -- Categorical Data (using our cleaning macro)
    {{ standardize_case('order_status', case_type='lower') }} as status,
    
    -- Metrics (using our null-handling macro)
    {{ coalesce_nulls('total_amount') }} as total_amount,

    -- Transformation: Flagging high-value orders (Example of business logic)
    CASE 
        WHEN total_amount > 500 THEN TRUE 
        ELSE FALSE 
    END as is_high_value_order

FROM {{ source('ecommerce', 'orders') }}