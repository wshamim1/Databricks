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

get_permissions() {
  local object_type="$1"
  local object_id="$2"
  api_call GET "/api/2.0/permissions/${object_type}/${object_id}"
}

set_permissions() {
  local object_type="$1"
  local object_id="$2"
  local principal="$3"
  local permission_level="$4"
  local payload
  payload=$(cat <<EOF
{
  "access_control_list": [
    {
      "group_name": "${principal}",
      "permission_level": "${permission_level}"
    }
  ]
}
EOF
)

  api_call PATCH "/api/2.0/permissions/${object_type}/${object_id}" "$payload"
}

usage() {
  cat <<EOF
Usage:
  $(basename "$0") get <object_type> <object_id>
  $(basename "$0") set <object_type> <object_id> <principal_group> <permission_level>

Examples:
  $(basename "$0") get jobs 12345
  $(basename "$0") set jobs 12345 data_engineers CAN_MANAGE
EOF
}

case "${1:-}" in
  get)
    [[ $# -eq 3 ]] || { usage; exit 1; }
    get_permissions "$2" "$3"
    ;;
  set)
    [[ $# -eq 5 ]] || { usage; exit 1; }
    set_permissions "$2" "$3" "$4" "$5"
    ;;
  *)
    usage
    exit 1
    ;;
esac