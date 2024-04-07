with novel_interest as (
    select
        n.novel_key,
        i.interest_key,
        n.price,
        n.title,
        i.interest_name,
        n.created_timestamp as novel_created_timestamp,
        n.modified_timestamp as novel_updated_timetamp
    from 
        {{ ref('novel') }} as n
    inner join
        {{ ref('dim_interest') }} as i on i.interest_key = n.interest_key
)
select *
from novel_interest
