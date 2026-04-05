# Databricks Tutorials

This repository is a compact learning path for Databricks fundamentals.

## What you will learn

- What Databricks is and where it fits in a modern data platform
- What Delta Lake is and why it matters for reliable analytics
- How lakehouse architecture combines data lake and warehouse patterns
- How Unity Catalog differs from a catalog and why that distinction matters
- How workspaces, compute, and the Databricks architecture fit together
- How notebooks, jobs, and schedulers are used in day-to-day delivery
- Which Spark parameters matter most in practice
- How to write simple Databricks notebook code with PySpark

## Learning path

1. [01 - What Is Databricks](tutorials/01-what-is-databricks.md)
2. [02 - Delta Lake and Lakehouse Architecture](tutorials/02-delta-lake-and-lakehouse-architecture.md)
3. [03 - Unity Catalog vs Catalogs](tutorials/03-unity-catalog-vs-catalogs.md)
4. [04 - Architecture, Workspace, and Compute](tutorials/04-architecture-workspace-compute.md)
5. [05 - Notebooks, Jobs, and Scheduling](tutorials/05-notebooks-jobs-scheduling.md)
6. [06 - Databricks Architecture Diagram](tutorials/06-databricks-architecture-diagram.md)
7. [07 - Databricks Glossary](tutorials/07-databricks-glossary.md)
8. [08 - Databricks FAQ and Interview Prep](tutorials/08-databricks-faq-and-interview-prep.md)
9. [09 - Databricks APIs and SDK](tutorials/09-databricks-apis-and-sdk.md)
10. [10 - Scheduler Comparison](tutorials/10-scheduler-comparison.md)
11. [11 - Scheduler Architecture Diagram](tutorials/11-scheduler-architecture-diagram.md)
12. [12 - Medallion Architecture End-to-End](tutorials/12-medallion-architecture-end-to-end.md)
13. [13 - Observability and Troubleshooting](tutorials/13-observability-and-troubleshooting.md)
14. [14 - External Integrations](tutorials/14-external-integrations.md)
15. [15 - Real-World Ingestion Use Cases](tutorials/15-real-world-ingestion-use-cases.md)
16. [16 - Hive Metastore vs Catalog vs Unity Catalog](tutorials/16-hive-metastore-vs-catalog-vs-unity-catalog.md)
17. [17 - What Is a Delta Table](tutorials/17-what-is-delta-table.md)
18. [18 - Managed Table vs External Table](tutorials/18-managed-table-vs-external-table.md)
19. [19 - External Tables, External Locations, and Storage Credentials](tutorials/19-external-tables-external-locations-and-storage-credentials.md)
20. [20 - DBFS vs Volumes vs External Storage](tutorials/20-dbfs-vs-volumes-vs-external-storage.md)
21. [Fundamentals Notebook](notebooks/databricks_fundamentals_examples.ipynb)
22. [Delta Lake Operations Notebook](notebooks/delta_lake_operations_examples.ipynb)
23. [Delta Table Basics Notebook](notebooks/delta_table_basics_examples.ipynb)
24. [Managed vs External Table Notebook](notebooks/managed_vs_external_table_examples.ipynb)
25. [Unity Catalog Hands-On Notebook](notebooks/unity_catalog_hands_on_examples.ipynb)
26. [Jobs and Workflows Notebook](notebooks/jobs_and_workflows_examples.ipynb)
27. [Databricks SQL Notebook](notebooks/databricks_sql_examples.ipynb)
28. [Streaming and Auto Loader Notebook](notebooks/streaming_and_autoloader_examples.ipynb)
29. [Machine Learning and MLflow Notebook](notebooks/machine_learning_and_mlflow_examples.ipynb)
30. [APIs and SDK Notebook](notebooks/databricks_apis_and_sdk_examples.ipynb)
31. [Scheduler Patterns Notebook](notebooks/scheduler_patterns_examples.ipynb)
32. [Medallion Architecture End-to-End Notebook](notebooks/medallion_architecture_end_to_end_examples.ipynb)
33. [Observability and Troubleshooting Notebook](notebooks/observability_and_troubleshooting_examples.ipynb)
34. [Real-World Ingestion Patterns Notebook](notebooks/real_world_ingestion_patterns_examples.ipynb)
35. [Kafka End-to-End Ingestion Notebook](notebooks/kafka_end_to_end_ingestion_examples.ipynb)
36. [IoT Monitoring and Anomaly Notebook](notebooks/iot_monitoring_and_anomaly_examples.ipynb)

## Suggested order

Start with the platform overview, then move into governance, then infrastructure, and finish with notebook and job orchestration patterns.


## Topics covered

### Databricks at a glance

Databricks is a unified analytics platform built around the lakehouse model. It combines data engineering, analytics, machine learning, governance, and orchestration in one environment.

### Delta Lake and lakehouse

Delta Lake is the table format and transaction layer that makes lakehouse-style data management practical. The lakehouse architecture combines low-cost cloud storage with warehouse-style reliability, performance features, and governance.

### Delta tables

The Delta table tutorial explains what a Delta table actually is, how it differs from plain parquet tables, and why `_delta_log`, table history, merge support, and time travel matter in practice.

The managed vs external table tutorial explains the separate question of who controls the table storage path and lifecycle.

The external tables tutorial explains how external tables relate to external locations and storage credentials in Unity Catalog.

The DBFS vs volumes vs external storage tutorial explains the separate file-storage question of where non-tabular files live and how governance changes across those options.

### Medallion architecture

The medallion guide and notebook show how raw records move from bronze to silver to gold, with examples of ingestion metadata, data quality filtering, deduplication, and business-level aggregates.

### Observability and troubleshooting

The observability guide and notebook show how to inspect run metrics, row-count changes, rejected records, freshness, and common failure patterns across Databricks jobs and tables.

### External integrations

The external integrations guide and examples show how Databricks fits into Airflow, Azure Data Factory, GitHub Actions, AWS Step Functions, and dbt-driven delivery patterns.

### Real-world ingestion

The real-world ingestion guide and notebook show practical source patterns such as Kafka events, IoT sensor telemetry, file-based landing, API extraction, and CDC-style ingestion into bronze, silver, and gold layers.

The dedicated Kafka and IoT notebooks go deeper into end-to-end event ingestion, device heartbeat checks, and anomaly candidate generation.

### Governance distinctions

The governance tutorials explain the difference between Hive metastore, catalogs, and Unity Catalog so older Spark or Hive terminology does not get mixed up with the modern Databricks governance model.

### Key terms

- Lakehouse: data architecture that combines data lake flexibility with data warehouse management features
- Workspace: the user-facing collaboration area for notebooks, jobs, dashboards, repos, and assets
- Compute: the processing layer used to run notebooks, jobs, SQL, and machine learning workloads
- Unity Catalog: the governance layer for data and AI assets across workspaces
- Catalog: a namespace inside Unity Catalog, used to organize schemas and tables

### Quick reference

The glossary page provides short definitions for the main Databricks platform, storage, governance, SQL, and streaming terms used across these tutorials.

### Interview prep

The FAQ page collects common Databricks questions and short, direct answers for revision, onboarding, and interview preparation.

### Automation

The APIs and SDK guide shows how to automate jobs, compute, DBFS file operations, and cluster dependency installation with Databricks REST APIs and the Python SDK.

### Orchestration choices

The scheduler comparison and scheduler architecture pages explain how Databricks Jobs compare with Airflow, Azure Data Factory, and Step Functions, plus how internal and external schedulers fit together.

## Common role mapping

- Data engineers build ingestion and transformation pipelines
- Analysts query curated data and build dashboards
- Data scientists explore data and train models
- Platform teams manage governance, security, compute policies, and cost controls

## How to use this repo

- Read the markdown guides for concepts and terminology
- Open the notebooks for working examples of Spark code, Delta operations, Delta table basics, medallion layering, observability checks, real-world ingestion patterns, Kafka pipelines, IoT monitoring patterns, Unity Catalog usage, Databricks SQL, streaming patterns, machine learning workflows, API automation, scheduler design, job orchestration, and notebook patterns
- Use the scripts in `scripts/` as starting points for Databricks REST API and Python SDK automation, including DBFS operations and installing Python packages or JARs on clusters
- Use the scripts in `scripts/` as starting points for external scheduler automation and Kafka or Event Hubs ingestion trigger examples
- Use the examples in `integrations/` as starting points for Airflow, Azure Data Factory, GitHub Actions, and Step Functions integration patterns
- Use the examples in `integrations/dbt/` as a starting point for dbt on Databricks model projects
- Extend the examples with your own datasets, Delta tables, or job definitions