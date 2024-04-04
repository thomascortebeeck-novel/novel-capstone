from dagster import define_asset_job, AssetSelection

# Define your asset job
airbyte_assets_job = define_asset_job(
    name="airbyte_asset_job",
    selection=AssetSelection.keys(
        "novel/bubble_user",
        "novel/bubble_category",
        "novel/bubble_novel",
        "novel/bubble_order",
        "novel/ga4_bigquery_events",
        "novel/stripe_charges",
        "novel/stripe_customers",
        "novel/stripe_refunds",
    ).required_multi_asset_neighbors()
)
