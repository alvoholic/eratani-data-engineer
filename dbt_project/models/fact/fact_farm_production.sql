with cleaned as (
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
        water_usage,

        -- Metric baru: hasil panen per hektar
        case 
            when farm_area > 0 then yield / farm_area 
            else null 
        end as yield_per_hectare,

        -- Metric baru: efisiensi penggunaan air per hektar
        case 
            when farm_area > 0 then water_usage / farm_area 
            else null 
        end as water_efficiency,

        -- Normalisasi nilai null atau negatif (opsional)
        greatest(fertilizer_used, 0) as fertilizer_used_clean,
        greatest(pesticide_used, 0) as pesticide_used_clean

    from {{ ref('stg_agriculture') }}
)

select *
from cleaned
order by farm_id