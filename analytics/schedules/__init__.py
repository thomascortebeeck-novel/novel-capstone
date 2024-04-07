from dagster import schedule
from analytics.jobs import airbyte_assets_job

@schedule(cron_schedule="0 3 * * *", job=airbyte_assets_job, execution_timezone="UTC")
def daily_airbyte_assets_job_schedule(_context):
    return {}  # Return an empty dictionary if no run config is needed