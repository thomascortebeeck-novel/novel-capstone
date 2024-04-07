select 
    c.customer_key,
    u.user_key,
    c.country,
    u.gender,
    u.last_name,
    u.first_name,
    u.created_timestamp,
    u.modified_timestamp
from
    {{ ref('user') }} as u
inner join 
    {{ ref('customer') }} as c 
on c.customer_key = u.customer_key