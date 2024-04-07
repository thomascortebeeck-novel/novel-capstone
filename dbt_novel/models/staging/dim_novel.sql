select
    novel_key,
    image_url, 
    price as novel_price,
    title,
    interest_key,
    description,
    user_key,
    created_timestamp as novel_created_timestamp,
    modified_timestamp as novel_modified_timestamp
from
    {{ ref('novel') }}