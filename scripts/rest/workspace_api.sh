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

list_workspace() {
  local path="${1:-/Workspace}"
  local payload
  payload=$(cat <<EOF
{
  "path": "${path}"
}
EOF
)

  api_call GET "/api/2.0/workspace/list?path=${path}"
}

mkdirs_workspace() {
  local path="$1"
  local payload
  payload=$(cat <<EOF
{
  "path": "${path}"
}
EOF
)

  api_call POST "/api/2.0/workspace/mkdirs" "$payload"
}

delete_workspace() {
  local path="$1"
  local payload
  payload=$(cat <<EOF
{
  "path": "${path}",
  "recursive": true
}
EOF
)

  api_call POST "/api/2.0/workspace/delete" "$payload"
}

usage() {
  cat <<EOF
Usage:
  $(basename "$0") list [path]
  $(basename "$0") mkdirs <path>
  $(basename "$0") delete <path>
EOF
}

case "${1:-}" in
  list)
    list_workspace "${2:-/Workspace}"
    ;;
  mkdirs)
    if [[ $# -lt 2 ]]; then
      echo "mkdirs requires a path" >&2
      usage
      exit 1
    fi
    mkdirs_workspace "$2"
    ;;
  delete)
    if [[ $# -lt 2 ]]; then
      echo "delete requires a path" >&2
      usage
      exit 1
    fi
    delete_workspace "$2"
    ;;
  *)
    usage
    exit 1
    ;;
esac