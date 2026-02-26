-- snapshots/product_snapshot.sql
{% snapshot product_history %}

{{
    config(target_schema='analytics_snapshots',
      unique_key='PRODUCT_ID',
      strategy='check' ,
      check_cols=['CATEGORY', 'PRICE']    
    )
}}

select
    PRODUCT_ID,
    PRODUCT_NAME,
    BRAND,
    CATEGORY,
    PRICE,
    RATING
    -- If there was an 'UPDATED_AT' column in your source, you would include it here:
    -- , UPDATED_AT
from {{ source('ecommerce', 'products') }}

{% endsnapshot %}