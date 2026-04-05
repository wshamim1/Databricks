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
3. [03 - Unity Catalog vs Catalogs](tutorials/02-unity-catalog-vs-catalogs.md)
4. [04 - Architecture, Workspace, and Compute](tutorials/03-architecture-workspace-compute.md)
5. [05 - Notebooks, Jobs, and Scheduling](tutorials/04-notebooks-jobs-scheduling.md)
6. [Fundamentals Notebook](notebooks/databricks_fundamentals_examples.ipynb)
7. [Delta Lake Operations Notebook](notebooks/delta_lake_operations_examples.ipynb)
8. [Unity Catalog Hands-On Notebook](notebooks/unity_catalog_hands_on_examples.ipynb)
9. [Jobs and Workflows Notebook](notebooks/jobs_and_workflows_examples.ipynb)

## Suggested order

Start with the platform overview, then move into governance, then infrastructure, and finish with notebook and job orchestration patterns.

## Topics covered

### Databricks at a glance

Databricks is a unified analytics platform built around the lakehouse model. It combines data engineering, analytics, machine learning, governance, and orchestration in one environment.

### Delta Lake and lakehouse

Delta Lake is the table format and transaction layer that makes lakehouse-style data management practical. The lakehouse architecture combines low-cost cloud storage with warehouse-style reliability, performance features, and governance.

### Key terms

- Lakehouse: data architecture that combines data lake flexibility with data warehouse management features
- Workspace: the user-facing collaboration area for notebooks, jobs, dashboards, repos, and assets
- Compute: the processing layer used to run notebooks, jobs, SQL, and machine learning workloads
- Unity Catalog: the governance layer for data and AI assets across workspaces
- Catalog: a namespace inside Unity Catalog, used to organize schemas and tables

## Common role mapping

- Data engineers build ingestion and transformation pipelines
- Analysts query curated data and build dashboards
- Data scientists explore data and train models
- Platform teams manage governance, security, compute policies, and cost controls

## How to use this repo

- Read the markdown guides for concepts and terminology
- Open the notebooks for working examples of Spark code, Delta operations, Unity Catalog usage, job orchestration, and notebook patterns
- Extend the examples with your own datasets, Delta tables, or job definitions