# 09 - Databricks APIs and SDK

This page explains how to automate Databricks using REST APIs and the Databricks SDK.

## Why use APIs or SDKs

APIs and SDKs are useful when you want to:

- Create jobs programmatically
- Provision or manage compute
- Trigger job runs from external systems
- Update schedules and parameters
- Integrate Databricks into CI/CD or platform automation

## Main automation options

### 1. REST APIs

Databricks exposes REST endpoints for jobs, compute, clusters, workspace objects, permissions, and more.

Typical use cases:

- Call Databricks from Jenkins, GitHub Actions, Azure DevOps, or another orchestrator
- Use language-agnostic HTTP requests
- Manage resources with raw JSON payloads

### 2. Databricks SDK for Python

The Python SDK provides a more structured way to work with the same platform APIs.

Typical use cases:

- Platform automation written in Python
- Less manual JSON handling
- Cleaner access to jobs, clusters, workspace, and account operations

## Companion assets in this repo

Combined examples:

- Shell script: `scripts/databricks_rest_api_examples.sh`
- Python SDK script: `scripts/databricks_sdk_examples.py`
- Notebook walkthrough: `notebooks/databricks_apis_and_sdk_examples.ipynb`

Separated examples:

- REST jobs script: `scripts/rest/jobs_api.sh`
- REST clusters script: `scripts/rest/clusters_api.sh`
- REST workspace script: `scripts/rest/workspace_api.sh`
- SDK jobs script: `scripts/sdk/jobs_api.py`
- SDK clusters script: `scripts/sdk/clusters_api.py`
- SDK workspace script: `scripts/sdk/workspace_api.py`

Use these as templates rather than production-ready deployment code.

## Authentication basics

Common authentication inputs:

- `DATABRICKS_HOST`
- `DATABRICKS_TOKEN`

Example:

```bash
export DATABRICKS_HOST="https://<your-workspace-url>"
export DATABRICKS_TOKEN="<personal-access-token>"
```

In production automation, prefer managed credentials, service principals, or secret-backed auth instead of hardcoded tokens.

## Create a job with the REST API

Common endpoint:

`POST /api/2.1/jobs/create`

Example request:

```bash
curl --request POST "$DATABRICKS_HOST/api/2.1/jobs/create" \
  --header "Authorization: Bearer $DATABRICKS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
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
```

## Run an existing job with the REST API

Common endpoint:

`POST /api/2.1/jobs/run-now`

Example:

```bash
curl --request POST "$DATABRICKS_HOST/api/2.1/jobs/run-now" \
  --header "Authorization: Bearer $DATABRICKS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
    "job_id": 12345,
    "job_parameters": {
      "run_date": "2026-04-04"
    }
  }'
```

## Create compute with the REST API

Depending on your environment and terminology, you may work with cluster or compute endpoints.

Common cluster creation endpoint:

`POST /api/2.0/clusters/create`

Example:

```bash
curl --request POST "$DATABRICKS_HOST/api/2.0/clusters/create" \
  --header "Authorization: Bearer $DATABRICKS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
    "cluster_name": "demo-api-cluster",
    "spark_version": "15.4.x-scala2.12",
    "node_type_id": "Standard_DS3_v2",
    "autotermination_minutes": 20,
    "num_workers": 2
  }'
```

## List jobs or clusters with the REST API

Examples:

```bash
curl --request GET "$DATABRICKS_HOST/api/2.1/jobs/list" \
  --header "Authorization: Bearer $DATABRICKS_TOKEN"

curl --request GET "$DATABRICKS_HOST/api/2.0/clusters/list" \
  --header "Authorization: Bearer $DATABRICKS_TOKEN"
```

## Other useful Databricks APIs

Beyond jobs and clusters, the most common APIs teams usually automate are:

- Workspace APIs: import, export, list, and create folders or notebook assets
- Permissions APIs: manage access control on jobs, clusters, notebooks, and other objects
- Repos APIs: sync Git-backed repos in the workspace
- Cluster policies APIs: enforce standardized compute rules
- SQL warehouses APIs: create and manage SQL warehouses for analysts and BI
- Unity Catalog and permissions APIs: catalogs, schemas, tables, grants, and governance metadata
- Secret management APIs: manage secret scopes and secrets, depending on platform setup
- Files and DBFS related APIs: move or inspect files where applicable
- Serving or model APIs: manage model serving or inference endpoints in ML workflows

If you are automating platform administration, workspace, permissions, cluster policies, and SQL warehouse APIs are usually the next places to look after jobs and compute.

## Python SDK setup

Install the SDK:

```bash
pip install databricks-sdk
```

Simple client setup:

```python
from databricks.sdk import WorkspaceClient

w = WorkspaceClient()
```

The client reads standard Databricks authentication settings from the environment or configured profile.

## Create a job with the Python SDK

```python
from databricks.sdk import WorkspaceClient

w = WorkspaceClient()

job = w.jobs.create(
    name="orders_daily_pipeline",
    max_concurrent_runs=1,
    tasks=[
        {
            "task_key": "ingest_orders",
            "notebook_task": {
                "notebook_path": "/Workspace/Shared/notebooks/ingest_orders",
                "base_parameters": {
                    "run_date": "2026-04-04",
                    "run_mode": "incremental",
                },
            },
            "new_cluster": {
                "spark_version": "15.4.x-scala2.12",
                "node_type_id": "Standard_DS3_v2",
                "num_workers": 2,
            },
        }
    ],
)

print(job.job_id)
```

## Trigger a job run with the Python SDK

```python
run = w.jobs.run_now(
    job_id=12345,
    job_parameters={"run_date": "2026-04-04"},
)

print(run.run_id)
```

## Create a cluster with the Python SDK

```python
cluster = w.clusters.create(
    cluster_name="demo-sdk-cluster",
    spark_version="15.4.x-scala2.12",
    node_type_id="Standard_DS3_v2",
    num_workers=2,
    autotermination_minutes=20,
)

print(cluster.cluster_id)
```

## Wait for operations or inspect resources

Examples:

```python
for job in w.jobs.list():
    print(job.job_id, job.settings.name)

for cluster in w.clusters.list():
    print(cluster.cluster_id, cluster.cluster_name)
```

## Practical guidance

- Use the REST API when you need raw HTTP-based automation from any platform
- Use the Python SDK when your automation is written in Python and you want cleaner resource handling
- Prefer job clusters or managed compute patterns for production automation
- Avoid hardcoding tokens in scripts or notebooks
- Keep job definitions versioned in source control
- Use service principals and secret management for production deployments

## Important note on terminology

Older examples and some APIs still use the term `clusters`. In many Databricks materials, the broader operational term is now `compute`. Both often refer to the runtime resources used to execute workloads, but the exact API naming depends on the endpoint and product surface.