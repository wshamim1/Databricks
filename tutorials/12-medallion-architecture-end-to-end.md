# 12 - Medallion Architecture End-to-End

## What medallion architecture means

Medallion architecture is a practical way to organize data processing in Databricks using layered Delta tables.

The three most common layers are:

- Bronze for raw or near-raw ingestion
- Silver for cleaned and standardized data
- Gold for business-ready outputs

The point is not just naming tables bronze, silver, and gold. The point is to separate responsibilities so each layer has a clear purpose.

## Why teams use the pattern

Teams use medallion architecture because it helps with:

- replaying data from a raw source of truth
- isolating data quality fixes in the right layer
- making curated tables easier to trust and reuse
- supporting both analytics and machine learning from shared intermediate data
- reducing the risk of mixing ingestion logic with reporting logic

## End-to-end flow

Typical Databricks flow:

```mermaid
flowchart LR
    source[Source Systems] --> bronze[Bronze Delta Tables]
    bronze --> silver[Silver Delta Tables]
    silver --> gold[Gold Delta Tables]
    gold --> dashboards[SQL Dashboards]
    gold --> notebooks[Notebooks and Jobs]
    silver --> ml[ML Features]
    gold --> apis[Downstream APIs]
```

In Databricks, each layer is usually stored as Delta tables under governed Unity Catalog schemas.

Example naming pattern:

- `main.bronze.orders_raw`
- `main.silver.orders_clean`
- `main.gold.daily_sales_by_region`

## Bronze layer

Bronze is the landing layer.

Bronze tables usually contain:

- source records with minimal transformation
- ingestion metadata such as load timestamps, file names, or batch IDs
- source column names that still look close to the original system
- duplicate or imperfect records that have not been fully resolved yet

Bronze design goals:

- keep enough fidelity to replay the pipeline
- avoid aggressive business logic
- preserve source traceability

Common bronze operations:

- ingest files with Auto Loader
- append event streams
- capture raw API responses
- add `ingest_ts`, `source_file`, or `batch_id`

## Silver layer

Silver is the standardization and data quality layer.

Silver tables usually contain:

- renamed and typed columns
- deduplicated records
- validated business keys
- standardized timestamps and reference values
- joins to reference or master data when needed

Silver design goals:

- produce reusable datasets for many downstream consumers
- apply data quality rules consistently
- make the data easier to query and trust

Common silver operations:

- cast strings into typed columns
- filter bad records or send them to quarantine tables
- deduplicate by business key and event time
- merge incremental changes into Delta tables
- standardize dimensions such as region, status, or product codes

## Gold layer

Gold is the serving layer.

Gold tables usually contain:

- KPI tables
- curated marts
- dimensional models
- aggregates for dashboards and reporting
- feature-ready data products for specific use cases

Gold design goals:

- serve a clear business question
- optimize for consumption, not raw flexibility
- keep transformations easy to explain to analysts and stakeholders

Common gold operations:

- daily sales aggregates
- customer segmentation tables
- finance-ready reporting outputs
- service-level metrics and operational summaries

## Example pipeline

Imagine an orders pipeline.

```mermaid
flowchart LR
    raw[Raw Orders] --> ordersRaw[orders_raw Bronze]
    ordersRaw --> ordersClean[orders_clean Silver]
    ordersClean --> dailySales[daily_sales_by_region Gold]
    dailySales --> analysts[Analysts and Reporting]
```

### Bronze table

`orders_raw` stores source records from a transactional system.

Example columns:

- `order_id`
- `customer_id`
- `order_ts_raw`
- `region_raw`
- `amount_raw`
- `order_status_raw`
- `ingest_ts`

### Silver table

`orders_clean` standardizes the records.

Example transformations:

- parse `order_ts_raw` into a timestamp
- cast `amount_raw` to decimal or double
- uppercase or normalize region values
- filter null order IDs
- keep the latest record per `order_id`

### Gold table

`daily_sales_by_region` produces a business-ready output.

Example transformations:

- group by `order_date` and `region`
- sum revenue
- count orders
- filter to completed or billable statuses only

## What belongs in each layer

| Question | Bronze | Silver | Gold |
| --- | --- | --- | --- |
| Raw replay available? | Yes | Usually not the main goal | No |
| Data quality fixes applied? | Minimal | Yes | Yes |
| Consumer-ready for dashboards? | No | Sometimes | Yes |
| Business logic applied? | Minimal | Moderate | Strong |
| Aggregated data? | Rare | Sometimes | Common |

## Incremental processing pattern

In production, medallion pipelines are usually incremental.

A common pattern is:

1. Append new source records into bronze
2. Read only the new or changed bronze data
3. Upsert cleaned records into silver with `MERGE`
4. Rebuild or incrementally update gold aggregates

Delta Lake is important here because it supports:

- ACID transactions
- `MERGE`
- schema enforcement and evolution
- history and rollback

## Data quality pattern

A simple and effective pattern is:

1. Bronze stores the input as received
2. Silver applies validation rules
3. Invalid records go to a quarantine table
4. Gold uses only trusted silver data

Example silver validation rules:

- `order_id` must not be null
- `amount` must be greater than zero
- `order_ts` must parse correctly
- `region` must map to an approved value

## Orchestration pattern in Databricks

An end-to-end medallion workflow often maps cleanly to Databricks Jobs tasks:

1. Ingest source data into bronze
2. Validate and merge into silver
3. Publish gold tables
4. Run quality checks
5. Notify downstream consumers or refresh dashboards

Each step can be a notebook, Python file, or SQL task.

## Governance pattern with Unity Catalog

A common approach is to separate schemas by layer.

Example:

- `main.bronze`
- `main.silver`
- `main.gold`

Benefits:

- clearer permissions by layer
- easier object discovery
- consistent naming for platform teams and analysts
- better lineage visibility across curated assets

## Common mistakes

- putting dashboard logic directly in bronze
- applying heavy business rules during raw ingestion
- skipping silver and sending every consumer to raw data
- mixing many unrelated business outputs into one gold table
- failing to store ingestion metadata in bronze
- rebuilding everything full-refresh when incremental logic is sufficient

## Practical design guidance

- keep bronze append-friendly and traceable
- make silver the reusable contract layer
- make gold purpose-built for a small set of consumers
- use Delta `MERGE` for incremental corrections and CDC
- add expectations or validation checks before publishing gold
- keep table names and schemas consistent across environments

## One-line summary

Bronze preserves what arrived, silver makes it trustworthy, and gold makes it useful.