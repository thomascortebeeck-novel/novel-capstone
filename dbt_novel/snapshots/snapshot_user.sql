{% snapshot snapshot_user %}

{{
    config(
      target_schema='historical',
      unique_key='user_key',
      strategy='timestamp',
      updated_at='modified_timestamp'
    )
}}

SELECT *
FROM {{ ref('user') }}

{% endsnapshot %}
