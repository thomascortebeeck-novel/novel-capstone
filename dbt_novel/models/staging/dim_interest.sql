select
    interest_key,
    interest_name, 
    created_timestamp as interest_created_timestamp,
    modified_timestamp as interest_modified_timestamp
from
    {{ ref('interest') }}