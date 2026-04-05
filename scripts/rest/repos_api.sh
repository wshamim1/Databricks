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

list_repos() {
  api_call GET "/api/2.0/repos"
}

create_repo() {
  local path="$1"
  local url="$2"
  local provider="$3"
  local payload
  payload=$(cat <<EOF
{
  "path": "${path}",
  "url": "${url}",
  "provider": "${provider}"
}
EOF
)

  api_call POST "/api/2.0/repos" "$payload"
}

update_repo_branch() {
  local repo_id="$1"
  local branch="$2"
  local payload
  payload=$(cat <<EOF
{
  "branch": "${branch}"
}
EOF
)

  api_call PATCH "/api/2.0/repos/${repo_id}" "$payload"
}

usage() {
  cat <<EOF
Usage:
  $(basename "$0") list
  $(basename "$0") create <workspace_path> <git_url> <provider>
  $(basename "$0") update-branch <repo_id> <branch>

Example provider values depend on your Git integration, such as gitHub or azureDevOpsServices.
EOF
}

case "${1:-}" in
  list)
    list_repos
    ;;
  create)
    [[ $# -eq 4 ]] || { usage; exit 1; }
    create_repo "$2" "$3" "$4"
    ;;
  update-branch)
    [[ $# -eq 3 ]] || { usage; exit 1; }
    update_repo_branch "$2" "$3"
    ;;
  *)
    usage
    exit 1
    ;;
esac