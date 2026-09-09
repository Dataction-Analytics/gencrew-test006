-- Business: cleansed and standardised reservations.
-- Incremental: only rows with booked_at beyond the last run's high-water mark are
-- read; they MERGE on reservation_id. Nothing is deleted or truncated.
with source as (

    select * from {{ source('raw', 'reservations') }}
    {% if is_incremental() %} where booked_at > (select coalesce(max(booked_at), '1900-01-01'::timestamp) from {{ this }}) {% endif %}

)

select
        reservation_id,
        confirmation_no,
        hotel_id,
        guest_id,
        booked_at,
        check_in_date,
        check_out_date,
        nights,
        status,
        total_amount,
        channel_id,
        segment_id,
        rate_plan_id,
        adults,
        children,
        rooms_booked,
        currency,
        is_repeat_guest,
        source_system,
        ingested_at,
        batch_id
from source
