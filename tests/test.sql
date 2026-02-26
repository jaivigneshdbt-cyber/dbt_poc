
select
    -- Using dbt_utils.date_trunc to get the start of the day
    {{ dbt_utils.date_trunc('day', 'order_timestamp') }} as order_date,
    count(distinct customer_id) as distinct_customers,
    count(order_id) as total_orders,
    sum(order_value) as total_revenue
from {{ ref('stg_orders') }} -- Referencing the ephemeral model
group by 1
order by 1