-- Business: cleansed and standardised daily_hotel_performance.
-- Incremental: only rows with ingested_at beyond the last run's high-water mark are
-- read; they MERGE on performance_id. Nothing is deleted or truncated.
with source as (

    select * from {{ source('raw', 'daily_hotel_performance') }}
    {% if is_incremental() %} where ingested_at > (select coalesce(max(ingested_at), '1900-01-01'::timestamp) from {{ this }}) {% endif %}

)

select
        performance_id,
        hotel_id,
        business_date,
        rooms_available,
        rooms_sold,
        rooms_out_of_order,
        arrivals,
        departures,
        source_system,
        ingested_at,
        batch_id,
        other_revenue,
        room_revenue
from source
