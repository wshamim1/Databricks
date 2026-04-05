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

create_cluster() {
  local payload='{
    "cluster_name": "demo-api-cluster",
    "spark_version": "15.4.x-scala2.12",
    "node_type_id": "Standard_DS3_v2",
    "autotermination_minutes": 20,
    "num_workers": 2
  }'

  api_call POST "/api/2.0/clusters/create" "$payload"
}

list_clusters() {
  api_call GET "/api/2.0/clusters/list"
}

delete_cluster() {
  local cluster_id="$1"
  local payload
  payload=$(cat <<EOF
{
  "cluster_id": "${cluster_id}"
}
EOF
)

  api_call POST "/api/2.0/clusters/delete" "$payload"
}

usage() {
  cat <<EOF
Usage:
  $(basename "$0") create
  $(basename "$0") list
  $(basename "$0") delete <cluster_id>
EOF
}

case "${1:-}" in
  create)
    create_cluster
    ;;
  list)
    list_clusters
    ;;
  delete)
    if [[ $# -lt 2 ]]; then
      echo "delete requires a cluster_id" >&2
      usage
      exit 1
    fi
    delete_cluster "$2"
    ;;
  *)
    usage
    exit 1
    ;;
esac