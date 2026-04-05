# 04 - Notebooks, Jobs, and Scheduling

## Notebooks

Databricks notebooks are interactive documents that combine:

- Code
- Markdown documentation
- Query results
- Visualizations

They are commonly used for:

- Exploration and prototyping
- Data analysis
- ETL development
- Demonstrations and training

## Why notebooks are useful

- Fast iteration with live results
- Easy collaboration across teams
- Good for combining explanation and code in one place

## Notebook example pattern

A common notebook flow looks like this:

1. Define input parameters
2. Read source data
3. Transform and validate data
4. Write results to a managed table or path
5. Log counts or metrics

## Parameterizing notebooks

In Databricks, notebook parameters are often implemented with widgets.

Example:

```python
dbutils.widgets.text("load_date", "2026-04-01", "Load Date")
dbutils.widgets.dropdown("run_mode", "incremental", ["incremental", "full"], "Run Mode")

load_date = dbutils.widgets.get("load_date")
run_mode = dbutils.widgets.get("run_mode")
```

This makes the same notebook reusable for both interactive runs and scheduled jobs.

## Jobs and workflows

Jobs are used to run notebooks, Python scripts, SQL tasks, or multi-step workflows in a repeatable and automated way.

Common job features:

- Task dependencies
- Retries
- Scheduling
- Notifications
- Parameters
- Job clusters or shared compute

## Typical workflow design

Example pipeline:

1. Ingest raw files
2. Validate and standardize records
3. Load curated Delta tables
4. Run quality checks
5. Publish downstream tables or alerts

Each step can be implemented as a separate task within a Databricks workflow.

## Schedulers

Schedulers automate when a job runs.

Typical options:

- Cron-based schedule
- Triggered by an upstream system
- Event-based or file-arrival orchestration through adjacent platform tooling

## Cron example

Run every day at 6:00 AM:

```text
0 0 6 * * ?
```

Always verify the cron format expected by the scheduler configuration in your Databricks environment.

## Notebooks vs jobs

| Topic | Notebook | Job |
| --- | --- | --- |
| Purpose | Interactive development and documentation | Production execution and orchestration |
| User pattern | Human-driven | Automated |
| State | Often iterative and exploratory | Repeatable and versioned |
| Scheduling | Manual or indirect | Native scheduling support |

## Practical best practices

- Keep notebooks modular and readable
- Move complex reusable logic into Python modules or repos when notebooks get large
- Use widgets or task parameters instead of hardcoded dates and paths
- Separate development compute from production job compute
- Add retries and alerting for scheduled workloads
- Use Unity Catalog tables and consistent naming standards for outputs