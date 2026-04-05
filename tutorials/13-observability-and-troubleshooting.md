# 13 - Observability and Troubleshooting

## What observability means in Databricks

Observability is the ability to understand what a pipeline, job, query, or cluster is doing without guessing.

In Databricks, observability usually means being able to answer questions like:

- Did the job run on time?
- Which task failed?
- Was the failure caused by code, data, permissions, or compute?
- Did row counts change unexpectedly?
- Did a table or query become slower than normal?

Troubleshooting is the follow-up activity: identifying the root cause and fixing it.

## Why this matters

Databricks workflows often combine:

- notebooks or Python code
- Delta Lake tables
- job orchestration
- streaming or incremental processing
- SQL warehouses and dashboards
- permissions and governance controls

When one piece fails, teams need a structured way to inspect the run instead of checking random logs.

## Core observability areas

The most useful Databricks observability signals usually come from five places:

1. Job and task run status
2. Cluster or compute behavior
3. Data quality and table health
4. SQL and query performance
5. Audit, lineage, and access behavior

## Job and workflow observability

For scheduled pipelines, start with the workflow run itself.

Important run information includes:

- job run state
- task-level state
- start and end timestamps
- retry counts
- parameters passed into the run
- error messages and stack traces

Common questions:

- Did the workflow fail before code execution started?
- Did one task fail while upstream tasks succeeded?
- Was the task retried and did a retry succeed?
- Did the failure begin after a recent code or configuration change?

Typical job failure categories:

- notebook or Python code errors
- cluster startup failures
- dependency or library problems
- source data missing or malformed
- permission or credential failures
- timeout or resource pressure issues

## Cluster and compute observability

If the job definition looks correct, inspect compute next.

Useful signals include:

- cluster event logs
- driver logs and executor logs
- autoscaling behavior
- out-of-memory symptoms
- long startup times
- terminated cluster reasons

Common compute-related issues:

- cluster failed to start because of policy or capacity restrictions
- library installation failed during startup
- driver ran out of memory during a wide transformation
- shuffle-heavy jobs became slow because of skew or undersized compute
- SQL warehouse was paused, overloaded, or sized too small for concurrency

## Data quality observability

Not every failure shows up as a thrown exception.

Many production issues are data quality issues, such as:

- row counts suddenly dropping
- duplicate business keys increasing
- null values appearing in required columns
- unexpected schema changes
- stale data not arriving on time

Useful checks include:

- source-to-target row count comparisons
- null-rate checks on critical fields
- distinct count checks for business keys
- freshness checks using latest event or load timestamp
- schema validation before publishing downstream tables

## SQL and query observability

For analyst and BI workloads, performance and correctness issues often show up in SQL warehouses and query history.

Useful signals include:

- query duration trends
- queue time and warehouse concurrency pressure
- scan volume and expensive joins
- dashboard refresh failures
- warehouse sizing or auto-stop behavior

Troubleshooting questions:

- Did query latency change after new data volume arrived?
- Did a dashboard fail because a dependent table changed?
- Is the issue query logic, warehouse sizing, or table design?

## Audit, lineage, and governance observability

Some failures are operational, not computational.

Examples:

- a user lost access to a table
- a service principal cannot run a job anymore
- a schema grant changed unexpectedly
- a downstream table consumed the wrong upstream object

Useful governance signals include:

- audit logs for access and change events
- Unity Catalog lineage views
- permissions on catalogs, schemas, tables, jobs, and secrets
- workspace or repo change history where applicable

## A practical troubleshooting order

When a Databricks pipeline fails, use a fixed order instead of jumping around.

### 1. Confirm the scope of failure

Ask:

- Is this one task, one pipeline, one table, or a platform-wide issue?
- Did the issue happen once or repeatedly?
- Did anything change just before the problem started?

### 2. Check the job run or query history

Look for:

- exact failure state
- failing task name
- input parameters
- error message and stack trace

### 3. Separate code failures from platform failures

Code and data failures often look different from infrastructure failures.

Examples:

- syntax, import, and logic problems usually point to code
- permission denied, cluster policy, startup, and capacity messages usually point to platform or security issues

### 4. Validate the input data

Ask:

- Did the expected file or records arrive?
- Did the schema drift?
- Are key columns null or malformed?
- Is the dataset stale?

### 5. Inspect the output layer

Ask:

- Was bronze written but silver failed?
- Did silver succeed but gold counts look wrong?
- Were downstream dashboards or consumers reading stale tables?

### 6. Check permissions and environment assumptions

Ask:

- Did the runtime identity change?
- Are secrets available to the job?
- Does the compute still satisfy policy and library requirements?

## Common failure patterns

### Pattern 1: Job succeeded but data is wrong

Possible causes:

- business logic regression
- silent schema drift
- duplicate source data
- incorrect filters on incremental loads

Best checks:

- compare row counts to prior runs
- inspect source and target timestamps
- validate key uniqueness in silver
- validate aggregate totals in gold

### Pattern 2: Notebook failed with a Spark error

Possible causes:

- missing columns after schema change
- bad casts
- skewed joins
- memory pressure

Best checks:

- inspect the exact transformation step
- check schemas before the failing operation
- review execution plan and partitioning assumptions
- review driver and executor logs if the error is resource-related

### Pattern 3: Workflow failed before code ran

Possible causes:

- compute could not start
- cluster policy rejection
- bad library configuration
- permissions on workspace assets or secrets

Best checks:

- task setup state
- cluster event log
- attached libraries and init configuration
- access to referenced notebooks, repos, and secrets

### Pattern 4: Dashboard or SQL query is slow

Possible causes:

- warehouse undersized for concurrency
- tables not optimized for the access pattern
- very large scans caused by poor filters
- expensive joins on uncurated data

Best checks:

- query history
- warehouse load and concurrency
- table size and layout
- whether the workload should read gold instead of silver or bronze

## What to record for each run

A simple run-observability pattern is to record:

- pipeline name
- run ID
- start and end timestamps
- input parameters
- input row counts
- output row counts
- rejected record counts
- status
- error summary if failed

These metrics can be written to a Delta table so they are queryable across runs.

## Job-run metadata to inspect

When troubleshooting a failed or suspicious workflow, job metadata often narrows the problem faster than raw logs.

Useful fields include:

- `job_id`
- `run_id`
- `task_key`
- `life_cycle_state`
- `result_state`
- `trigger_type`
- `attempt_number`
- `start_time`
- `end_time`
- `error_message`

These fields help answer practical questions such as:

- Did the task actually start or fail during setup?
- Was the run manual, scheduled, or triggered externally?
- Did the retry succeed after a transient failure?
- Did only one task fail while the rest of the workflow completed?

If you store or pull this metadata regularly, you can compare failure trends across runs instead of debugging one run at a time.

## Delta history as a troubleshooting signal

Delta table history is useful when a table changed unexpectedly but the workflow itself did not obviously fail.

`DESCRIBE HISTORY` helps answer questions such as:

- When was the table last written?
- Was the change an append, overwrite, merge, update, or delete?
- Which operation likely introduced the issue?
- Did a row-count drop happen after a particular pipeline run?

This is especially useful when:

- the job succeeded but downstream data looks wrong
- a table was overwritten unexpectedly
- a merge introduced too many or too few records
- you need to line up a table change with a job run time

In practice, job metadata tells you what the workflow did, and Delta history helps confirm what actually changed in the table.

## Example operational metrics table

Useful columns:

- `pipeline_name`
- `run_id`
- `layer_name`
- `records_in`
- `records_out`
- `records_rejected`
- `started_at`
- `finished_at`
- `run_status`

This makes it much easier to answer trend questions such as:

- Which pipeline is failing most often?
- Which run introduced a row-count drop?
- Which layer is taking the longest?

## Databricks-specific troubleshooting habits

- separate bronze, silver, and gold checks so you know where the problem starts
- inspect the workflow UI before diving into code
- use Delta history when table changes are suspicious
- log parameters and counts explicitly in jobs
- keep notebooks parameterized and deterministic for reruns
- use Unity Catalog permissions and lineage to understand governance-related failures

## One-line summary

Good Databricks troubleshooting starts by narrowing the failure to the exact run, layer, and signal before changing code or compute.