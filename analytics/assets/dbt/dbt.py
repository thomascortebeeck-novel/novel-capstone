import os
from pathlib import Path

from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

# configure dbt project resource
dbt_project_dir = Path(__file__).joinpath("..", "..", "..", "..", "dbt_novel").resolve() # get out from dbt.py => DBR
# print(f"DBT Project Directory: {dbt_project_dir}")
dbt_warehouse_resource = DbtCliResource(project_dir=os.fspath(dbt_project_dir)) # how Dagster talks to DBT for example DBT run ... 

# generate manifest
dbt_manifest_path = (
    dbt_warehouse_resource.cli(
        ["--quiet", "parse"], # dbt --quiet parse 
        target_path=Path("target"), # wheren is the folder wiht target path (target folder) => you can change directory in DBT 
    )
    .wait()
    .target_path.joinpath("manifest.json")
)

# load manifest to produce asset defintion
@dbt_assets(manifest=dbt_manifest_path)
def dbt_warehouse(context: AssetExecutionContext, dbt_warehouse_resource: DbtCliResource):
    yield from dbt_warehouse_resource.cli(["build"], context=context).stream() # can also do DBT build

# where to add the chrone jobs?
