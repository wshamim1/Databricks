# 01 - What Is Databricks

## Definition

Databricks is a cloud-native data and AI platform that helps teams ingest, process, analyze, govern, and operationalize data at scale.

It is built around the lakehouse concept, which aims to provide:

- Low-cost scalable storage like a data lake
- Data management and reliability features like a data warehouse
- A single platform for batch, streaming, SQL, machine learning, and governance

## Why teams use Databricks

- One platform instead of separate tools for ETL, analytics, and ML
- Native support for Apache Spark for distributed processing
- Delta Lake support for reliable tables on object storage
- Shared collaboration through notebooks, repos, jobs, and workflows
- Central governance through Unity Catalog

## Core building blocks

### 1. Storage layer

Your data usually lives in cloud object storage such as S3, ADLS, or GCS.

### 2. Delta Lake tables

Databricks commonly stores curated datasets in Delta format. Delta adds:

- ACID transactions
- Schema enforcement
- Time travel
- Efficient merge, update, and delete operations

### 3. Compute

Compute executes your code and queries. Common types include:

- All-purpose compute for interactive development
- Job compute for scheduled or automated runs
- SQL warehouses for BI and SQL workloads

### 4. Workspace

The workspace is where users collaborate on notebooks, jobs, repos, dashboards, and experiments.

### 5. Governance

Unity Catalog governs access to catalogs, schemas, tables, files, models, and more.

## Typical workflow

1. Ingest raw data from source systems or streaming feeds
2. Store raw data in cloud storage
3. Use Spark or SQL in Databricks to transform and validate data
4. Write curated data into Delta tables
5. Govern data access with Unity Catalog
6. Schedule pipelines with jobs
7. Consume the output through notebooks, dashboards, SQL, or downstream applications

## Common use cases

- Batch ETL pipelines
- Streaming pipelines with Structured Streaming
- Data warehouse style transformations
- Interactive analytics with SQL and notebooks
- Machine learning feature engineering and training
- Governance and lineage across data products

## Databricks in one sentence

Databricks is the execution, collaboration, and governance platform that sits on top of cloud storage and lets data teams build end-to-end data and AI workflows.