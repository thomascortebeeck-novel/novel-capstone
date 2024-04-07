select
    {{ dbt_utils.star(from=ref('fact_order'), relation_alias='fact_order') }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='dim_date', except=["date_day"]) }},
    {{ dbt_utils.star(from=ref('dim_novel'), relation_alias='dim_novel', except=["novel_key"]) }},
    {{ dbt_utils.star(from=ref('dim_interest'), relation_alias='dim_interest', except=["interest_key"]) }},
    {{ dbt_utils.star(from=ref('dim_user'), relation_alias='dim_user', except=["customer_key","user_key"]) }}
from {{ ref('fact_order') }} as fact_order
left join {{ ref('dim_date') }} as dim_date on fact_order.order_created_date = dim_date.date_day
left join {{ ref('dim_novel') }} as dim_novel on fact_order.novel_key = dim_novel.novel_key
left join {{ ref('dim_interest') }} as dim_interest on dim_novel.interest_key = dim_interest.interest_key
left join {{ ref('dim_user') }} as dim_user on fact_order.customer_key = dim_user.customer_key
