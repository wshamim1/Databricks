# 08 - Databricks FAQ and Interview Prep

This page collects common Databricks questions with short, direct answers.

## Core platform questions

### What is Databricks?

Databricks is a cloud platform for data engineering, analytics, SQL, machine learning, governance, and workflow orchestration.

### What problem does Databricks solve?

It reduces the need to stitch together separate tools for storage, distributed processing, governance, notebooks, SQL analytics, and job scheduling.

### What is the lakehouse?

The lakehouse is an architecture that combines low-cost data lake storage with warehouse-style reliability, governance, and analytics features.

### What is Delta Lake?

Delta Lake is the table and transaction layer that adds ACID transactions, schema control, update and delete support, and time travel on top of cloud storage.

### What is a Delta table?

A Delta table is a table stored in Delta format, which means it combines data files with a transaction log for reliable reads, writes, history, and time travel.

### What is the difference between a managed table and an external table?

Managed vs external describes who controls the storage path and lifecycle. It does not by itself tell you whether the table format is Delta.

### What is the difference between Databricks and Delta Lake?

Databricks is the platform. Delta Lake is one of the core technologies used on that platform for reliable table storage.

## Governance questions

### What is Unity Catalog?

Unity Catalog is Databricks' centralized governance layer for catalogs, schemas, tables, views, volumes, models, and related assets.

### What is Hive metastore?

Hive metastore is an older metadata repository used to store information about databases, tables, schemas, partitions, and table locations.

### What is the difference between Hive metastore and Unity Catalog?

Hive metastore is the older metadata model. Unity Catalog is the modern Databricks governance system with stronger centralized permissions, lineage, auditing, and cross-workspace governance.

### What is the difference between Unity Catalog and a catalog?

Unity Catalog is the governance system. A catalog is one namespace inside that system.

### What is the difference between Hive metastore naming and Unity Catalog naming?

Hive metastore patterns often use `database.table`. Unity Catalog patterns usually use `catalog.schema.table`.

### What is the hierarchy in Unity Catalog?

The common hierarchy is: `metastore -> catalog -> schema -> table`.

### What is the difference between DBFS and volumes?

DBFS is a Databricks file access pattern commonly used for workspace-level files and compatibility paths such as `dbfs:/`. Volumes are Unity Catalog-governed file locations for non-tabular data with clearer centralized permissions and governance.

### Why use fully qualified names?

They make data references explicit and reduce ambiguity across environments and workspaces.

## Compute and Spark questions

### What is the difference between all-purpose compute and job compute?

All-purpose compute is mainly for interactive development. Job compute is mainly for automated and scheduled execution.

### What is a SQL warehouse?

A SQL warehouse is compute optimized for SQL analytics, dashboards, and BI workloads.

### What is the Spark driver?

The driver coordinates planning and execution of Spark jobs.

### What are executors?

Executors are the distributed processes that perform work on partitions of data.

### What is shuffle in Spark?

Shuffle is data movement between partitions, typically during joins, aggregations, and sorts.

### Why does `spark.sql.shuffle.partitions` matter?

It affects parallelism for shuffle-heavy operations and can influence performance, skew behavior, and resource use.

## Notebook and workflow questions

### Why use notebooks in Databricks?

Notebooks combine code, markdown, outputs, and visuals, making them effective for exploration, learning, and development.

### How do you pass parameters to a notebook?

The most common pattern is to use widgets and retrieve values with `dbutils.widgets.get`.

### What is a Databricks job?

A job is an automated execution unit that runs notebooks, scripts, SQL, or workflows.

### What is a workflow?

A workflow is a multi-task job with dependencies, retries, parameters, and scheduling.

### What is a task value?

A task value is a value emitted by one task so a downstream task can consume it.

## Streaming questions

### What is Structured Streaming?

Structured Streaming is Spark's streaming model for incremental processing of continuously arriving data.

### What is Auto Loader?

Auto Loader is a Databricks feature for scalable incremental file ingestion from cloud storage.

### Why are checkpoints important?

They preserve streaming state and progress so jobs can recover reliably after interruption or restart.

## SQL and analytics questions

### Why use Databricks SQL?

It provides a governed SQL experience for analysts, dashboards, BI tools, and reporting workloads.

### What is a view?

A view is a saved SQL query that acts like a virtual table.

### What is a window function?

A window function performs calculations across related rows without collapsing them into one grouped row.

## Scenario questions

### How would you design a simple batch pipeline in Databricks?

Ingest raw data into cloud storage, load it into Bronze Delta tables, clean and standardize it into Silver tables, publish aggregates into Gold tables, govern access with Unity Catalog, and schedule the pipeline with jobs.

### How would you design a simple streaming pipeline in Databricks?

Use Auto Loader or another streaming source for ingestion, apply Structured Streaming transformations, write to Delta with checkpoints, then expose curated tables for downstream analytics.

### How do Databricks notebooks move to production?

Parameterize them, reduce inline business logic, move reusable code into modules or repos, run them through jobs, and attach monitoring and retries.

## Short answer revision set

- Databricks: the platform
- Lakehouse: the architecture pattern
- Delta Lake: the table and transaction layer
- Delta table: one concrete table stored in Delta format
- Hive metastore: older metadata model
- Unity Catalog: the governance layer
- Catalog: a namespace inside Unity Catalog
- Workspace: collaboration surface
- Compute: execution layer
- SQL warehouse: SQL-focused compute
- Job: automated execution
- Workflow: multi-task orchestration

## Interview tip

When answering Databricks questions, separate platform, architecture, governance, storage, and compute concerns clearly. That distinction is where many weak answers become vague or incorrect.