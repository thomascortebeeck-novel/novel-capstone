{{ dbt_date.get_date_dimension(
        start_date="2024-01-01",
        end_date=run_started_at.strftime("%Y-%m-%d")
)}}
