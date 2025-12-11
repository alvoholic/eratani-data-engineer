select
    farm_id,
    crop_type,
    farm_area,
    irrigation_type,
    fertilizer_used,
    pesticide_used,
    yield,
    soil_type,
    season,
    water_usage
from {{ ref('stg_agriculture') }}
