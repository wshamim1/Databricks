# 02 - Unity Catalog vs Catalogs

## Short answer

- Unity Catalog is the governance system
- A catalog is one namespace inside that system

These two terms are related, but they are not interchangeable.

## Unity Catalog

Unity Catalog is Databricks' centralized governance layer for data and AI assets.

It provides:

- Centralized access control
- Data discovery
- Lineage
- Auditing
- Standardized object organization across workspaces

Unity Catalog governs objects such as:

- Catalogs
- Schemas
- Tables and views
- Volumes
- Functions
- Models and other AI assets, depending on platform features

## What is a catalog

A catalog is the top-level container used to organize data objects.

Inside a catalog, you usually create:

- Schemas
- Tables
- Views
- Functions

The hierarchy usually looks like this:

`metastore -> catalog -> schema -> table`

## Example hierarchy

- Metastore: company-wide governance boundary for a region
- Catalog: `finance`
- Schema: `curated`
- Table: `monthly_revenue`

Fully qualified name:

`finance.curated.monthly_revenue`

## Difference between Unity Catalog and catalog

| Topic | Unity Catalog | Catalog |
| --- | --- | --- |
| Type | Governance framework | Namespace container |
| Scope | Platform-wide governance | One logical grouping of data objects |
| Purpose | Security, lineage, discovery, control | Organize schemas and tables |
| Count | Usually one governance setup per environment or region | Many catalogs can exist |
| Example | Grants, lineage, audit controls | `main`, `sales`, `finance`, `sandbox` |

## What people often confuse

### Confusion 1: "Unity Catalog is the same as main"

Not correct. `main` is usually a catalog. Unity Catalog is the broader governance framework that manages it.

### Confusion 2: "Catalog means schema"

Not correct. A catalog sits above a schema in the object hierarchy.

### Confusion 3: "Workspace permissions are enough"

Not always. Workspace access controls govern the workspace experience. Unity Catalog governs data object access.

## Example SQL commands

```sql
CREATE CATALOG IF NOT EXISTS finance;

CREATE SCHEMA IF NOT EXISTS finance.curated;

CREATE TABLE IF NOT EXISTS finance.curated.monthly_revenue (
  month STRING,
  revenue DECIMAL(18,2)
);

GRANT SELECT ON TABLE finance.curated.monthly_revenue TO `analyst_group`;
```

## Recommended catalog patterns

- Use catalogs to separate business domains such as `finance`, `sales`, and `marketing`
- Use schemas to separate layers such as `raw`, `silver`, and `gold`, or `staging`, `curated`, and `serving`
- Avoid creating too many catalogs for purely technical reasons unless governance boundaries require it

## Practical rule

If you are talking about security, lineage, or centralized governance, you are talking about Unity Catalog.

If you are talking about a named container like `main.sales.orders`, you are talking about a catalog inside Unity Catalog.