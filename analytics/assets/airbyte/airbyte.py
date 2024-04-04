from dagster import EnvVar, AutoMaterializePolicy, FreshnessPolicy, AssetKey, define_asset_job
from dagster_airbyte import AirbyteResource, load_assets_from_airbyte_instance

airbyte_resource = AirbyteResource(
    host=EnvVar("airbyte_host"), # later on EC2 instance
    port="8000",
    username="airbyte",
    password=EnvVar("airbyte_password"),
)

# auto materialize policy issue: https://github.com/dagster-io/dagster/issues/18266
# loading connections
airbyte_assets = load_assets_from_airbyte_instance(
    airbyte_resource,
    key_prefix="novel",
#    connection_to_freshness_policy_fn=lambda _: FreshnessPolicy(maximum_lag_minutes=5),
#    connection_to_auto_materialize_policy_fn=lambda _: AutoMaterializePolicy.eager(),
    connection_filter=lambda connection: "Novel" in connection.name,
    connection_to_asset_key_fn=lambda _, table: AssetKey(table.lower())
)