WITH flattened_categories AS (
    SELECT
        f.value::STRING AS category_id
    FROM
        {{ source('novel', 'bubble_order') }} AS bo
    INNER JOIN
        {{ source('novel', 'bubble_novel') }} AS bn
    ON
        bo.novel = bn._id,
    LATERAL FLATTEN(input => bn.category) AS f
)

SELECT
    category_id,
    COUNT(*) AS category_count
FROM
    flattened_categories
GROUP BY
    category_id
ORDER BY
    category_count DESC
