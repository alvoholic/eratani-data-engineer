{{ config(
    materialized='table',
    alias='agriculture_metrics_daily'
) }}

with base as (
    select * from {{ ref('fact_farm_production') }}
),

metrics as (
    select
        crop_type,
        season,
		irrigation_type,
        sum(yield) as total_yield,
        avg(yield / farm_area) as yield_per_acre,
        avg(yield / fertilizer_used) as fertilizer_efficiency,
        avg(yield / water_usage) as water_productivity
    from base
    group by crop_type, season, irrigation_type
),

top_crops as (
    select 
        crop_type,
        avg(yield / farm_area) as yield_per_acre,
        row_number() over (order by avg(yield / farm_area) desc) as rank
    from base
    group by crop_type
    limit 3
),

top_irrigation as (
    select
        irrigation_type,
        avg(yield) as avg_yield,
        row_number() over (order by avg(yield) desc) as rank
    from base
    group by irrigation_type
    limit 3
)

select
    m.*,
    tc.crop_type as top_crop_type,
    tc.yield_per_acre as top_crop_yield_per_acre,
    ti.irrigation_type as top_irrigation_type,
    ti.avg_yield as top_irrigation_avg_yield
from metrics m
left join top_crops tc on m.crop_type = tc.crop_type
left join top_irrigation ti on m.irrigation_type = ti.irrigation_type
