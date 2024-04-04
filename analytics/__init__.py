from dagster import Definitions, EnvVar, load_assets_from_package_module, define_asset_job, AssetSelection

from analytics.assets.airbyte.airbyte import airbyte_assets
from analytics.assets.dbt.dbt import dbt_warehouse, dbt_warehouse_resource
from analytics.jobs import airbyte_assets_job
from analytics.schedules import daily_airbyte_assets_job_schedule


# airbyte_assets_job = define_asset_job(
#    name="airbyte_asset_job",
#    selection=AssetSelection.keys("novel/bubble_user").required_multi_asset_neighbors()
#     selection=AssetSelection.keys("novel/bubble_user", "novel/bigquery_events", "novel/stripe_charges")
# )

defs = Definitions(
   assets=[airbyte_assets, dbt_warehouse],
   schedules=[daily_airbyte_assets_job_schedule],
   resources={
       "dbt_warehouse_resource": dbt_warehouse_resource
   },
   jobs=[airbyte_assets_job]
)

