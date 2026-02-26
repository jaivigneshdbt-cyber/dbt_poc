-- models/marts/daily_order_summary.sql
{{ config(
    materialized='table',
    cluster_by=['order_date']
) }}

select
    -- Using dbt_utils.date_trunc to normalize order_date_at to the start of the day
    {{ date_trunc('day', 'order_at') }} as order_date,
    status,
    count(distinct user_id) as distinct_users_placed_orders,
    count(order_id) as total_orders,
    sum(total_amount) as total_revenue
from {{ ref('stg_orders_ephemeral') }}
group by 1, 2
order by 1, 2