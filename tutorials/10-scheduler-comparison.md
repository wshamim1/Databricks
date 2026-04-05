# 10 - Scheduler Comparison

This page compares common orchestration options used with Databricks.

## Tools compared

- Databricks Jobs and Workflows
- Apache Airflow
- Azure Data Factory
- AWS Step Functions

## Short summary

- Use Databricks Jobs when Databricks is the center of the pipeline
- Use Airflow when you need flexible DAG-based orchestration across many systems
- Use Azure Data Factory when you want Azure-native integration and pipeline management
- Use AWS Step Functions when your workflow is centered around AWS service orchestration with Databricks as one step

```mermaid
flowchart TD
	start[Choose an Orchestrator] --> scope{Is the workflow mostly inside Databricks?}
	scope -->|Yes| dbx[Databricks Jobs]
	scope -->|No| cloud{Which platform standard dominates?}
	cloud -->|Azure| adf[Azure Data Factory]
	cloud -->|AWS| step[AWS Step Functions]
	cloud -->|Cross-platform DAGs| airflow[Apache Airflow]
```

## Side-by-side comparison

| Topic | Databricks Jobs | Airflow | Azure Data Factory | AWS Step Functions |
| --- | --- | --- | --- | --- |
| Best fit | Databricks-centric pipelines | Cross-platform DAG orchestration | Azure-native enterprise integration | AWS-native service orchestration |
| Main strength | Native Databricks execution and workflow support | Flexible orchestration logic | Strong integration with Azure data services | Tight orchestration of AWS services |
| Complexity | Lower | Medium to high | Medium | Medium |
| External system orchestration | Limited compared to external orchestrators | Strong | Strong in Azure ecosystem | Strong in AWS ecosystem |
| Operational ownership | Databricks teams | Data platform or orchestration teams | Integration and platform teams | AWS platform teams |
| Native Databricks awareness | Highest | Good via operators and APIs | Good via activities and linked services | Usually API-driven |

## Databricks Jobs and Workflows

Best when:

- Most processing happens inside Databricks
- The workflow can be modeled as tasks, dependencies, retries, and schedules within Databricks
- You want low setup overhead

Tradeoffs:

- Less suitable as the enterprise-wide orchestrator for many different platforms
- Cross-system dependency management is narrower than Airflow or enterprise schedulers

## Apache Airflow

Best when:

- You need Python-based DAG logic
- Many systems must be orchestrated together
- Databricks is one processing engine among many

Tradeoffs:

- More operational overhead
- Requires maintaining Airflow infrastructure and DAG lifecycle

## Azure Data Factory

Best when:

- Your data platform is heavily Azure-oriented
- You want Azure-native activities and linked services
- Databricks is part of broader ingestion and integration pipelines

Tradeoffs:

- Less flexible than Airflow for highly custom orchestration logic
- Best results usually come when the overall estate is already Azure-centered

## AWS Step Functions

Best when:

- The workflow is centered on AWS-native services
- Databricks is triggered as part of broader AWS application or data orchestration

Tradeoffs:

- Usually more API-centric for Databricks integration
- Less naturally centered on Databricks development patterns than native Jobs or Airflow operators

## Practical decision guide

Choose Databricks Jobs when:

- The pipeline is mainly notebooks, Spark jobs, SQL tasks, and Delta outputs in Databricks

Choose Airflow when:

- You need one orchestrator for Databricks, APIs, file transfers, data warehouses, and many custom dependencies

Choose Azure Data Factory when:

- Your organization prefers Azure-native data integration and operational patterns

Choose AWS Step Functions when:

- Your orchestration standard is AWS service composition and Databricks is one invoked component

## Practical rule

Pick the scheduler based on orchestration scope and enterprise standards, not just team familiarity.