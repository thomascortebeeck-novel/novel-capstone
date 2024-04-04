
SELECT 
    c.charge_key,
    c.customer_key,
    c.amount,
    c.currency,
    c.is_paid,
    c.is_refunded,
    c.status,
    g.event_timestamp,
    g.event_name,
    g.traffc_medium,
    g.traffc_source,
    g.traffc_campaign
FROM
  {{ ref('charges') }} as c
  inner join {{ ref('ga4_purchase_utm') }} as g on c.charge_key = g.charge_key
