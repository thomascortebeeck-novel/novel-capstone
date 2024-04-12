with orders as (
    select
        o.order_key,
        c.customer_key,
        o.novel_key,
        o.status as order_status,
        c.amount,
        c.is_paid,
        c.status as payment_status,
        c.currency,
        c.is_refunded,
        d.date_day as order_created_date,
        c.created_timestamp as order_created_timestamp,
        c.updated_timestamp as order_updated_timetamp
    from 
        {{ ref('orders') }} as o
    inner join 
        {{ ref('charges') }} as c on c.transaction_key = o.order_key
    inner join  
        {{ ref('novel') }} as n on n.novel_key = o.novel_key
    inner join
        {{ ref('dim_user') }} as u on u.customer_key = c.customer_key
    inner join 
        {{ ref('dim_date') }} as d on d.date_day = DATE(c.created_timestamp)
)
select *
from orders
group by
        order_key,
        customer_key,
        novel_key,
        order_status,
        amount,
        is_paid,
        payment_status,
        currency,
        is_refunded,
        order_created_timestamp,
        order_updated_timetamp,
        order_created_date
-- group by for deduplication
-- other methods: distinct and window row number = 1 fitlered
-- source: https://thinketl.com/how-to-remove-duplicates-in-snowflakes/

s
-- don't add interest here, because this would lead to duplicate rows which isn't required for fact_order table
-- ask teacher about this