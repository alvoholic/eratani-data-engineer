select
    cast(farm_id as integer) as farm_id,
    initcap(crop_type) as crop_type,
    cast(farm_area as numeric) as farm_area,
    initcap(irrigation_type) as irrigation_type,
    cast(fertilizer_used as numeric) as fertilizer_used,
    cast(pesticide_used as numeric) as pesticide_used,
    cast(yield as numeric) as yield,
    initcap(soil_type) as soil_type,
    initcap(season) as season,
    cast(water_usage as numeric) as water_usage
from {{ source('public', 'stg_agriculture_raw') }}
where farm_id is not null