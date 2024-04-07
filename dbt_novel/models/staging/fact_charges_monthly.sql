select 
    d.month_start_date as month_start_date,
    sum(amount) as revenue
from {{ ref('charges') }} as c
inner join {{ ref('dim_date') }} as d on d.date_day = DATE(c.created_timestamp) -- ensure created_timestamp is a date field in order to join correctly
where -- filter the succeeded charges
    c.is_paid = TRUE and 
    c.status = 'succeeded' and
    is_refunded = FALSE
group by
    month_start_date
