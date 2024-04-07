with order_surprise_me as (
    SELECT
        novel,
        _id as order_id,
        "CREATED BY" as created_by
    FROM
        {{ source('novel', 'bubble_order') }}
    WHERE 
        novel = '1711283442816x164632984869928960'
), -- filter the orders with surprise me novel 
join_user_interest as (
    SELECT 
        bu._ID as user_id,
        bu.interest,
        osm.order_id
    FROM 
        {{ source('novel', 'bubble_user') }} as bu
    INNER JOIN 
        order_surprise_me as osm
    ON osm.created_by = bu._id
), -- join with the user to discover his/her user interest 
flatten_user_interest as (
    SELECT
        jui.user_id,
        jui.order_id,
        f.value::STRING AS interest_id
    FROM 
        join_user_interest AS jui,
        LATERAL FLATTEN(input => jui.interest) AS f
), -- flatten the user interest so you get a row per interest 
user_category_score as(
    SELECT 
        fui.*,
        foc.category_count
    FROM 
        flatten_user_interest as fui
    INNER JOIN
        {{ ref('fact_order_category') }} as foc
    ON foc.category_id = fui.interest_id
), -- which interest the most popular
ranked_user_interests AS (
    SELECT
        user_id,
        order_id,
        interest_id,
        category_count,
        ROW_NUMBER() OVER(PARTITION BY user_id, order_id ORDER BY category_count DESC) AS rn
    FROM user_category_score
) -- filter most popular interest
SELECT
    user_id,
    order_id,
    interest_id as recommended_interest,
    category_count
FROM ranked_user_interests
WHERE rn = 1

-- instead of interest recommendation, it would even be better to provide a novel recommendation in the interest/category of the user.