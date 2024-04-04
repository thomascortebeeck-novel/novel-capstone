#!/usr/bin/env bash
set -euo pipefail

main() {
    export TOP_DIR=$(git rev-parse --show-toplevel)

    # Setup dbt
    dbt deps --project-dir "${TOP_DIR}/dbt_novel"

    # Lint SQL
    sqlfluff fix --force --dialect snowflake "${TOP_DIR}"/dbt_novel

    # If the linter produces diffs, fail the linter
    if [ -z "$(git status --porcelain)" ]; then 
        echo "Working directory clean, linting passed"
        exit 0
    else
        echo "Linting failed. Please commit these changes:"
        git --no-pager diff HEAD
        exit 1
    fi
}

main
