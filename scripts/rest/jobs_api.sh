#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${DATABRICKS_HOST:-}" || -z "${DATABRICKS_TOKEN:-}" ]]; then
  echo "DATABRICKS_HOST and DATABRICKS_TOKEN must be set." >&2
  exit 1
fi

api_call() {
  local method="$1"
  local endpoint="$2"
  local payload="${3:-}"

  if [[ -n "$payload" ]]; then
    curl --silent --show-error --fail \
      --request "$method" \
      --url "$DATABRICKS_HOST$endpoint" \
      --header "Authorization: Bearer $DATABRICKS_TOKEN" \
      --header "Content-Type: application/json" \
      --data "$payload"
  else
    curl --silent --show-error --fail \
      --request "$method" \
      --url "$DATABRICKS_HOST$endpoint" \
      --header "Authorization: Bearer $DATABRICKS_TOKEN"
  fi
}

create_job() {
  local payload='{
    "name": "orders_daily_pipeline",
    "max_concurrent_runs": 1,
    "tasks": [
      {
        "task_key": "ingest_orders",
        "notebook_task": {
          "notebook_path": "/Workspace/Shared/notebooks/ingest_orders",
          "base_parameters": {
            "run_date": "2026-04-04",
            "run_mode": "incremental"
          }
        },
        "new_cluster": {
          "spark_version": "15.4.x-scala2.12",
          "node_type_id": "Standard_DS3_v2",
          "num_workers": 2
        }
      }
    ]
  }'

  api_call POST "/api/2.1/jobs/create" "$payload"
}

list_jobs() {
  api_call GET "/api/2.1/jobs/list"
}

run_job() {
  local job_id="$1"
  local payload
  payload=$(cat <<EOF
{
  "job_id": ${job_id},
  "job_parameters": {
    "run_date": "2026-04-04"
  }
}
EOF
)

  api_call POST "/api/2.1/jobs/run-now" "$payload"
}

usage() {
  cat <<EOF
Usage:
  $(basename "$0") create
  $(basename "$0") list
  $(basename "$0") run <job_id>
EOF
}

case "${1:-}" in
  create)
    create_job
    ;;
  list)
    list_jobs
    ;;
  run)
    if [[ $# -lt 2 ]]; then
      echo "run requires a job_id" >&2
      usage
      exit 1
    fi
    run_job "$2"
    ;;
  *)
    usage
    exit 1
    ;;
esac