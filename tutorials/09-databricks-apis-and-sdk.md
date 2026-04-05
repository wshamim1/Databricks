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
- REST permissions script: `scripts/rest/permissions_api.sh`
- REST repos script: `scripts/rest/repos_api.sh`
- REST cluster policies script: `scripts/rest/cluster_policies_api.sh`
- REST SQL warehouses script: `scripts/rest/sql_warehouses_api.sh`
- REST Unity Catalog script: `scripts/rest/unity_catalog_api.sh`
- REST secrets script: `scripts/rest/secrets_api.sh`
- REST serving endpoints script: `scripts/rest/serving_endpoints_api.sh`
- SDK jobs script: `scripts/sdk/jobs_api.py`
- SDK clusters script: `scripts/sdk/clusters_api.py`
- SDK workspace script: `scripts/sdk/workspace_api.py`
- SDK permissions script: `scripts/sdk/permissions_api.py`
- SDK repos script: `scripts/sdk/repos_api.py`
- SDK cluster policies script: `scripts/sdk/cluster_policies_api.py`
- SDK SQL warehouses script: `scripts/sdk/sql_warehouses_api.py`
- SDK Unity Catalog script: `scripts/sdk/unity_catalog_api.py`
- SDK secrets script: `scripts/sdk/secrets_api.py`
- SDK serving endpoints script: `scripts/sdk/serving_endpoints_api.py`

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

## Which "other" APIs matter most

For most platform teams, the next practical sequence after jobs and clusters is:

1. Workspace APIs
2. Permissions APIs
3. Repos APIs
4. Cluster policies APIs
5. SQL warehouses APIs
6. Unity Catalog APIs

That order usually gives the most value for day-to-day automation.

## What are cluster policies

Cluster policies let platform teams enforce compute standards such as allowed node types, runtime versions, autotermination settings, worker counts, and other guardrails.

They are useful when you want to:

- Control cost and prevent oversized clusters
- Standardize approved Spark runtimes
- Enforce security-related compute settings
- Reduce manual configuration drift across teams

## What are SQL warehouses

SQL warehouses are Databricks compute resources optimized for SQL analytics, dashboards, and BI workloads.

They are useful when you want to:

- Serve analyst queries efficiently
- Power dashboards and reporting tools
- Separate SQL workloads from Spark engineering compute

## What Unity Catalog APIs usually cover

Unity Catalog automation commonly includes:

- Catalog creation and listing
- Schema creation and listing
- Table and view metadata operations
- Grants and privilege management
- Governed object discovery across environments

## What secret management APIs usually cover

Secret management automation commonly includes:

- Creating secret scopes
- Listing secret scopes
- Storing secrets in scopes
- Listing secrets or ACLs depending on the environment

These APIs are useful for keeping credentials and tokens out of notebooks and scripts.

## What serving endpoint APIs usually cover

Serving automation commonly includes:

- Creating model serving endpoints
- Listing or inspecting endpoints
- Updating served model configurations
- Deleting endpoints when no longer needed

These APIs are useful when you want to operationalize ML models behind managed inference endpoints.

## Airflow example for triggering Databricks jobs

Airflow is commonly used as an external scheduler when Databricks is only one step in a broader workflow.

Typical pattern:

1. Wait for upstream files, APIs, or database conditions
2. Trigger a Databricks job
3. Monitor run status
4. Continue to downstream systems only if the Databricks run succeeds

Example using an Airflow Databricks operator pattern:

```python
from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from datetime import datetime

with DAG(
    dag_id="orders_databricks_pipeline",
    start_date=datetime(2026, 4, 1),
    schedule="0 6 * * *",
    catchup=False,
) as dag:
    run_orders_job = DatabricksRunNowOperator(
        task_id="run_orders_job",
        databricks_conn_id="databricks_default",
        job_id=12345,
        job_parameters={"run_date": "{{ ds }}"},
    )
```

If you are not using a provider operator, Airflow can also call the Databricks Jobs REST API directly through an HTTP operator or custom Python task.

## Azure Data Factory example for triggering Databricks

ADF is commonly used when Databricks is part of a larger Azure data integration flow.

Typical pattern:

1. Copy or validate source data
2. Run a Databricks notebook or job activity
3. Capture success or failure state
4. Continue to storage, SQL, or reporting steps

Example ADF-style activity concept:

```json
{
  "name": "Run_Databricks_Orders_Notebook",
  "type": "DatabricksNotebook",
  "typeProperties": {
    "notebookPath": "/Workspace/Shared/notebooks/ingest_orders",
    "baseParameters": {
      "run_date": "@{pipeline().TriggerTime}",
      "run_mode": "incremental"
    }
  },
  "linkedServiceName": {
    "referenceName": "AzureDatabricksLinkedService",
    "type": "LinkedServiceReference"
  }
}
```

In ADF, you can either call notebooks directly through a Databricks activity or call Databricks jobs through web or orchestration patterns depending on your platform design.

## Choosing between Airflow and ADF for Databricks orchestration

| Topic | Airflow | Azure Data Factory |
| --- | --- | --- |
| Best fit | Python-centric orchestration and complex DAG logic | Azure-native integration workflows |
| Databricks integration style | Operators or REST calls | Native Databricks activities or web calls |
| Typical users | Data platform and data engineering teams | Integration and enterprise ETL teams |
| Strength | Flexible DAG control | Strong Azure ecosystem integration |

The right choice depends more on your enterprise orchestration standard than on Databricks itself.

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