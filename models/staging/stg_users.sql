{{ config(materialized='table') }}

SELECT
    user_id,
    name,
    email,
    gender,
    city,
    signup_date
FROM {{ source('ecommerce', 'users') }}