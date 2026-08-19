
# SupplyChainDWH

> **An end-to-end supply chain data engineering and business intelligence platform built with SQL Server, T-SQL, Medallion Architecture, Kimball dimensional modeling, and Power BI.**

**Author:** Ibrahim Khalil

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![T-SQL](https://img.shields.io/badge/T--SQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/sql/t-sql/)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![DAX](https://img.shields.io/badge/DAX-Analytics-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)](https://learn.microsoft.com/dax/)
[![Data Engineering](https://img.shields.io/badge/Data%20Engineering-Medallion%20Architecture-2F80ED?style=for-the-badge)](#)

---

## 📌 Table of Contents

- [Executive Summary](#-executive-summary)
- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Medallion Architecture](#-medallion-architecture)
  - [Bronze Layer](#1-bronze-layer--ingestion--profiling)
  - [Silver Layer](#2-silver-layer--cleansing--standardization)
  - [Gold Layer](#3-gold-layer--dimensional-modeling)
- [Kimball Star Schema](#-kimball-star-schema)
- [Data Quality Engineering](#-data-quality-engineering)
- [Advanced DAX & Modeling Solutions](#-advanced-dax--modeling-solutions)
  - [Time Intelligence](#1-time-intelligence--previous-year-bypass)
  - [Customer Granularity](#2-customer-granularity--name-skew)
  - [Analytical Measures](#3-custom-analytical-measures)
- [Power BI Application](#-power-bi-application)
- [Dashboard Pages](#-dashboard-pages)
  - [Executive Overview](#1-executive-overview)
  - [Customer & Regional Insights](#2-customer--regional-insights)
  - [Product Profitability](#3-product-profitability--margins)
  - [Sales Team Performance](#4-sales-team-performance)
  - [Logistics Operations](#5-logistics--delivery-operations)
- [Tech Stack](#-tech-stack)
- [Project Execution](#-project-execution)
- [Repository Structure](#-repository-structure)
- [Code Highlights](#-code-highlights)
- [Business Insights](#-business-insights)
- [Engineering & Analytical Value](#-engineering--analytical-value)
- [Future Enhancements](#-future-enhancements)
- [Key Takeaways](#-key-takeaways)
- [Author](#-author)

---

# 🚀 Executive Summary

**SupplyChainDWH** is an end-to-end data engineering and business intelligence platform designed to transform raw, inconsistent global supply chain and retail flat files into a structured analytical environment capable of supporting executive-level decision making.

The project implements a **Medallion Architecture entirely within SQL Server using pure T-SQL**, separating raw ingestion, data profiling, quality engineering, transformation, and analytical modeling into dedicated **Bronze, Silver, and Gold layers**.

The cleansed data is subsequently modeled using a **Kimball Star Schema**, consisting of a central `gold.fact_orders` table surrounded by analytical dimensions for dates, customers, products, and sales representatives.

The Gold warehouse is then consumed by **Power BI**, where a five-page interactive analytical application transforms the curated warehouse into a decision-support platform covering:

- Financial performance
- Customer value
- Geographic markets
- Product profitability
- Sales-team effectiveness
- Discount and margin behavior
- Delivery reliability
- Shipping performance
- Operational bottlenecks

The project goes beyond conventional dashboard development by addressing real-world analytical engineering challenges including:

- Dirty categorical data
- Hidden whitespace
- Inconsistent business classifications
- Missing values
- Orphan records
- Duplicate category representations
- Data-type inconsistencies
- Customer-level granularity problems
- Power BI time-intelligence limitations
- Filter-context challenges

The complete analytical lifecycle can be summarized as:

```text
RAW DATA
    │
    ▼
DATA PROFILING
    │
    ▼
DATA QUALITY ENGINEERING
    │
    ▼
MEDALLION ARCHITECTURE
    │
    ▼
KIMBALL STAR SCHEMA
    │
    ▼
SEMANTIC MODEL
    │
    ▼
ADVANCED DAX
    │
    ▼
POWER BI APPLICATION
    │
    ▼
BUSINESS INSIGHTS
````

---

# 📊 Project Overview

Supply chain analytics requires more than simply aggregating transactional data.

Operational datasets frequently contain structural and semantic problems that can compromise downstream analytics:

* Inconsistent categorical values
* Duplicate representations of the same business concept
* Missing values
* Incorrect data types
* Orphaned records
* Hidden whitespace
* Inconsistent capitalization
* Referential integrity issues
* Non-unique descriptive attributes
* Granularity mismatches

If these problems reach the reporting layer, they can produce misleading KPIs, incorrect aggregations, broken relationships, and unreliable business conclusions.

**SupplyChainDWH** addresses these problems through a structured data engineering pipeline.

### Core Objective

> **Build a reliable analytical foundation that converts messy operational data into trusted, business-ready insights.**

The architecture separates responsibilities into four major stages:

| Layer        | Primary Responsibility                                 |
| ------------ | ------------------------------------------------------ |
| **Bronze**   | Preserve and profile raw source data                   |
| **Silver**   | Clean, standardize, validate, and transform data       |
| **Gold**     | Build the analytical Kimball Star Schema               |
| **Power BI** | Consume the Gold layer and deliver actionable insights |

---

# 🏗️ Architecture

## End-to-End Architecture

```text
┌─────────────────────────────────────────────────────┐
│           RAW SUPPLY CHAIN / RETAIL FILES           │
│                                                     │
│      Flat Files • Operational Records • CSVs       │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                    BRONZE LAYER                     │
│                                                     │
│  Raw Ingestion                                      │
│  Data Profiling                                     │
│  Null Detection                                     │
│  Data-Type Inspection                               │
│  Anomaly Detection                                  │
│  Orphan Identification                              │
│  Source Preservation                                │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                    SILVER LAYER                     │
│                                                     │
│  TRIM / REPLACE / UPPER                              │
│  Missing-Value Handling                             │
│  Data-Type Casting                                  │
│  Category Standardization                           │
│  Duplicate Resolution                               │
│  Referential Integrity                              │
│  Business Rules                                    │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                     GOLD LAYER                      │
│                                                     │
│                KIMBALL STAR SCHEMA                  │
│                                                     │
│                  ┌──────────────┐                   │
│                  │ FACT ORDERS  │                   │
│                  └──────┬───────┘                   │
│                         │                           │
│          ┌──────────────┼──────────────┐            │
│          ▼              ▼              ▼            │
│     DIM DATE       DIM CUSTOMERS   DIM PRODUCTS     │
│                         │                           │
│                         ▼                           │
│                   DIM SALESMAN                      │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                     POWER BI                        │
│                                                     │
│  Semantic Model • DAX • KPIs • Visual Analytics    │
│  Interactive Navigation • Business Insights        │
└─────────────────────────────────────────────────────┘
```

## Architectural Philosophy

The architecture deliberately separates four concerns:

| Concern                 | Responsibility                                                   |
| ----------------------- | ---------------------------------------------------------------- |
| **Ingestion**           | Preserve source fidelity and establish a raw landing zone        |
| **Quality Engineering** | Identify and resolve structural and semantic data problems       |
| **Business Modeling**   | Convert trusted data into an analytical dimensional model        |
| **Consumption**         | Expose curated information through an interactive BI application |

This separation provides a clear path for tracing analytical results backward through the transformation pipeline.

A KPI displayed in Power BI can therefore be conceptually traced through:

```text
Power BI Visual
      ↓
DAX Measure
      ↓
Gold Fact / Dimensions
      ↓
Silver Transformation
      ↓
Bronze Source
      ↓
Original Operational Data
```

---

# 🏛️ Medallion Architecture

The warehouse implements a **Medallion Architecture entirely inside SQL Server using pure T-SQL**.

The three layers represent progressively increasing levels of trust and business readiness:

```text
Bronze
  │
  │ Raw + Observable
  ▼
Silver
  │
  │ Clean + Standardized
  ▼
Gold
  │
  │ Business-Ready + Analytical
  ▼
Power BI
```

---

# 1. Bronze Layer — Ingestion & Profiling

The Bronze layer acts as the **raw landing zone** for the supply chain and retail source data.

Raw flat files were loaded into SQL Server with minimal transformation to preserve source fidelity.

The objective at this stage was **observation rather than correction**.

## Data Profiling

The raw dataset was investigated for:

* Null and missing values
* Data-type mismatches
* Categorical anomalies
* Duplicate category representations
* Orphaned records
* Hidden trailing spaces
* Internal double-spaces
* Inconsistent capitalization
* Market naming inconsistencies
* Referential integrity issues
* Structural anomalies

For example, multiple source values could represent the same business concept:

```text
Europe
EUROPE
EU
EU 
```

Although visually similar, these are technically different string values and can therefore produce separate categories during aggregation.

## Why Preserve Raw Data?

The Bronze layer provides:

### Traceability

Transformations can be traced back to the original source representation.

### Reproducibility

Cleansing logic can be rerun without requiring the external source file to be manually reconstructed.

### Auditability

Original source values remain available when investigating unexpected results.

### Debugging

Unexpected Gold-layer results can be traced through the transformation pipeline.

### Separation of Concerns

Source ingestion is isolated from business transformation logic.

The Bronze layer therefore serves as the controlled boundary between external operational data and the analytical warehouse.

---

# 2. Silver Layer — Cleansing & Standardization

The Silver layer transforms raw source records into a **trusted and standardized analytical dataset**.

This is where the primary data quality engineering rules are applied.

## Core Transformations

| Data Quality Problem        | Transformation                   |
| --------------------------- | -------------------------------- |
| Leading/trailing whitespace | `TRIM()`                         |
| Internal double-spaces      | `REPLACE()`                      |
| Inconsistent capitalization | `UPPER()`                        |
| Missing values              | Business-specific handling       |
| Incorrect data types        | `CAST()` / `CONVERT()`           |
| Duplicate categories        | Canonical mappings               |
| Inconsistent market values  | Standardized business categories |
| Orphan records              | Referential integrity handling   |

## Whitespace Normalization

Hidden whitespace can create subtle analytical problems.

For example:

```text
"Europe"
"Europe "
"Europe  "
```

are different values to the database even though they may appear identical to a human.

A representative transformation is:

```sql
SELECT
    UPPER(
        REPLACE(
            TRIM(market),
            '  ',
            ' '
        )
    ) AS normalized_market
FROM silver_source;
```

This performs three distinct normalization operations:

* `TRIM()` removes leading and trailing whitespace.
* `REPLACE()` removes internal repeated spaces.
* `UPPER()` normalizes capitalization.

## Market Standardization

Inconsistent source representations such as:

```text
EU
EUROPE
EU 
```

were consolidated into the canonical reporting category:

```text
Europe
```

This prevents Power BI and SQL aggregations from treating logically identical markets as separate business entities.

## Missing Values

Missing data was treated according to field semantics rather than applying a universal replacement strategy.

The objective was to distinguish between:

* Genuinely unknown values
* Optional attributes
* Missing operational information
* Invalid records
* Values requiring business-standard defaults

This prevents the cleansing process from introducing artificial information.

## Data-Type Standardization

Explicit data-type casting was performed before loading the Gold layer.

Consistent data types are essential for:

* Arithmetic calculations
* Aggregations
* Date filtering
* Relationships
* DAX calculations
* Power BI semantic modeling

## Referential Integrity

Orphaned records were identified during profiling and addressed before the Gold model was populated.

This prevents invalid relationships from propagating into the analytical layer.

---

# 3. Gold Layer — Dimensional Modeling

The Gold layer represents the **business-ready analytical warehouse**.

Rather than exposing operational structures directly to Power BI, the cleansed Silver data is transformed into a **Kimball Star Schema**.

## Gold Tables

```text
gold.fact_orders
gold.dim_date
gold.dim_customers
gold.dim_products
gold.dim_salesman
```

The model follows a classic dimensional architecture:

```text
                         ┌─────────────────┐
                         │    dim_date     │
                         └────────┬────────┘
                                  │
                                  ▼
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  dim_customers  │─────►│   fact_orders   │◄─────│   dim_products  │
└─────────────────┘      └────────┬────────┘      └─────────────────┘
                                  ▲
                                  │
                         ┌────────┴────────┐
                         │  dim_salesman   │
                         └─────────────────┘
```

---

# ⭐ Kimball Star Schema

The Gold model follows the principles of **Kimball dimensional modeling**.

## Fact Table

`gold.fact_orders` represents the central transactional fact table.

Its grain is centered around the order-level business event represented by the source data.

The fact table provides the measurable values and foreign keys required to analyze orders across multiple dimensions.

## Dimensions

### `gold.dim_date`

Provides the temporal context required for:

* Yearly analysis
* Monthly analysis
* Trend analysis
* Previous-year comparisons
* Time-based filtering

The dimension is configured as a proper Power BI date table to provide a reliable foundation for time intelligence.

### `gold.dim_customers`

Contains customer-level descriptive attributes supporting:

* Customer value analysis
* Segmentation
* Geography
* Customer rankings
* VIP identification

### `gold.dim_products`

Contains product attributes supporting:

* Product analysis
* Department analysis
* Profitability analysis
* Discount analysis
* Portfolio analysis

### `gold.dim_salesman`

Contains sales representative attributes supporting:

* Sales performance
* Commission analysis
* Regional coverage
* Incentive efficiency

## Relationship Strategy

The Gold semantic structure follows:

* `1-to-Many` relationships
* Single-direction filter propagation
* Dimension-to-fact filtering
* Surrogate dimension keys
* Clear separation between descriptive and measurable attributes

This reduces ambiguity and provides predictable behavior inside Power BI.

---

# 🧹 Data Quality Engineering

Data quality was treated as a core engineering responsibility rather than a final visualization step.

## Hidden Whitespace

Source values such as:

```text
"Europe"
"Europe "
"Europe  "
```

can become separate categories.

**Solution:** `TRIM()` + `REPLACE()`.

---

## Inconsistent Categorization

Source values such as:

```text
EU
EUROPE
EU 
```

were consolidated into:

```text
Europe
```

---

## Duplicate Category Representations

Logically identical categories were identified during profiling and consolidated into canonical business values during Silver-layer transformation.

---

## Orphan Records

Records without valid parent entities were identified before populating the dimensional model.

This protects the Gold layer from broken analytical relationships.

---

## Data-Type Inconsistencies

Explicit casting was performed before loading the Gold model.

This ensures predictable behavior during:

* Joins
* Aggregations
* Relationship creation
* DAX calculations
* Power BI modeling

---

# 🧠 Advanced DAX & Modeling Solutions

The Power BI layer required more than standard measures.

Several analytical problems required understanding:

* Filter context
* Row context
* Granularity
* Relationship behavior
* Time intelligence
* Dynamic calculations

---

# 1. Time Intelligence — Previous Year Bypass

## The Problem

Standard Power BI functions such as:

```text
SAMEPERIODLASTYEAR()
DATEADD()
```

did not produce the required Previous Year comparison under the encountered filtering/schema conditions.

The issue involved the date context and Power BI's requirements for interpreting date selections for standard time-intelligence operations.

Instead of forcing standard functions into an unsuitable context, a custom DAX solution was developed.

## Solution Strategy

The custom approach:

1. Captures the currently selected year.
2. Calculates the previous year.
3. Removes the existing date filter.
4. Explicitly applies the previous-year filter.
5. Recalculates revenue under that context.

Representative implementation:

```DAX
Revenue PY =
VAR SelectedYear =
    SELECTEDVALUE ( dim_date[Year] )

VAR PreviousYear =
    SelectedYear - 1

RETURN
CALCULATE (
    [Total Revenue],
    REMOVEFILTERS ( dim_date ),
    dim_date[Year] = PreviousYear
)
```

The important engineering concept is **explicit filter-context manipulation**.

Rather than relying entirely on implicit time-intelligence behavior, the measure explicitly defines the temporal context under which revenue must be calculated.

This enabled accurate PY trend comparisons for the Executive Overview page.

---

# 2. Customer Granularity & Name Skew

## The Problem

Customer names are not unique identifiers.

For example:

```text
Mary Smith
```

could represent multiple independent customer records.

If a visual groups only by:

```text
customer_fname + customer_lname
```

Power BI can aggregate multiple customers into a single displayed category.

This creates false analytical outliers.

For example, a leaderboard might incorrectly suggest:

```text
Mary Smith = Extremely High Revenue
```

when the revenue actually belongs to several different customers sharing the same name.

## Solution

The unique customer identifier was incorporated into the display label:

```DAX
Customer Display Name =
    dim_customers[customer_fname]
        & " "
        & dim_customers[customer_lname]
        & " ["
        & FORMAT ( dim_customers[customer_id], "0" )
        & "]"
```

The result becomes:

```text
Mary Smith [1024]
Mary Smith [1847]
Mary Smith [2315]
```

Each customer remains human-readable while retaining analytical uniqueness.

## Why This Is a Granularity Problem

This was fundamentally a **data-grain problem**, not merely a visualization formatting problem.

The model operates at the customer-record level, while the original visual grouped by a non-unique descriptive attribute.

The solution restores the intended analytical grain by incorporating the unique customer identifier into the reporting dimension.

---

# 3. Custom Analytical Measures

The semantic model includes analytical measures using:

* `DIVIDE()`
* `SUMX()`
* Variables
* Filter-context manipulation
* Dynamic calculations

Representative measures include:

## Average Order Value

```DAX
Average Order Value =
DIVIDE (
    [Total Revenue],
    [Total Orders]
)
```

## Profit Margin

```DAX
Profit Margin =
DIVIDE (
    [Total Profit],
    [Total Revenue]
)
```

## Total Commission

Commission calculations use aggregation logic such as `SUMX()` when commission must be evaluated at the appropriate row-level granularity before aggregation.

These measures form the analytical foundation of the five dashboard pages.

---

# 📊 Power BI Application

Power BI serves as the **analytical consumption layer** on top of the SQL Server Gold warehouse.

The application contains **five interactive dashboard pages**, each designed around a specific business domain.

The objective was not simply to display charts, but to build an analytical application capable of answering practical business questions.

---

# 🎨 UI/UX Design System

The dashboard follows a custom visual design language built around:

* Modern flat design
* Abstract coastal gradient background
* Navy
* Azure
* Sage Green
* Transparent visual containers
* Minimalist visual hierarchy
* Persistent left-hand navigation ribbon
* Custom transparent PNG navigation element
* Functional Home button
* Consistent page-to-page navigation
* Executive-oriented KPI presentation

## Design Philosophy

The interface separates:

```text
Navigation
     ↓
KPI Hierarchy
     ↓
Primary Analytics
     ↓
Supporting Context
```

This creates a consistent application-like experience rather than five disconnected dashboard pages.

The design balances:

* Readability
* Information density
* Visual hierarchy
* Consistency
* Navigation
* Executive interpretation
* Analytical exploration

---

# 📈 Dashboard Pages

# 1. Executive Overview

The Executive Overview provides the highest-level view of organizational performance.

## Key Components

* Revenue KPI
* Profit KPI
* Profit Margin KPI
* Late Delivery Rate KPI
* Total Revenue trend
* Previous Year Revenue trend
* Executive performance indicators

## Revenue vs. Previous Year

A wide line chart compares:

```text
Total Revenue
      vs.
Revenue PY
```

The custom Previous Year DAX logic ensures that both time series are evaluated using the intended year context.

## Business Purpose

> **How is the business performing overall, financially and operationally?**

The page provides executives with a rapid overview before deeper analysis of customers, products, sales teams, or logistics.

---

# 🌍 2. Customer & Regional Insights

This page focuses on **who the customers are, where they operate, and how much value they generate**.

## Key Components

* Global geographic map
* Revenue by customer state
* Customer segment analysis
* Total Orders vs. Total Revenue combination chart
* VIP Customer Leaderboard
* Unique customer-ID display logic

## Volume vs. Value

The combination chart compares:

```text
Total Orders
      vs.
Total Revenue
```

This distinguishes high-volume customer segments from high-value segments.

A segment can generate many transactions without necessarily producing proportionally high revenue.

## VIP Customer Analysis

The customer uniqueness solution prevents identical names from being aggregated into false high-value customers.

## Business Purpose

> **Who are our most valuable customers, and where is our revenue coming from?**

---

# 💰 3. Product Profitability & Margins

This page focuses on product portfolio economics.

## Key Components

* Department-level Treemap
* Product portfolio analysis
* Average Discount vs. Profit Margin scatter plot
* Top 5 profitable products
* Bottom 5 bleeding/loss-making products
* Divergent conditional formatting

## Discount vs. Margin Analysis

The scatter plot addresses:

> **Are heavy discounts burning margins?**

The visual compares:

```text
Average Discount
        vs.
Profit Margin
```

This allows products to be investigated according to their discounting behavior and resulting profitability.

## Top vs. Bottom Products

Conditional formatting highlights:

* Top 5 profitable products
* Bottom 5 bleeding/loss-making products

This provides an immediate visual distinction between products contributing positively to profitability and products requiring further investigation.

## Business Purpose

> **Which products create economic value, and where is discounting potentially eroding profitability?**

---

# 👥 4. Sales Team Performance

This page evaluates sales representatives beyond simple revenue rankings.

## Key Components

* Active sales representatives
* Total commission
* Regional market coverage
* Commission Rate vs. Total Revenue scatter plot
* Sales representative leaderboard
* Dynamic color coding
* Margin contribution analysis

## Commission Efficiency

The scatter plot evaluates:

```text
Commission Rate
        vs.
Total Revenue
```

This helps assess whether higher incentive costs are translating into meaningful commercial performance.

## Dynamic Leaderboard

Sales representatives are dynamically ranked and visually differentiated according to their contribution.

The objective is to avoid treating gross sales as the only definition of sales success.

## Business Purpose

> **Which sales representatives are generating efficient and profitable commercial performance?**

---

# 🚚 5. Logistics & Delivery Operations

The Logistics Operations page focuses on supply chain reliability and delivery execution.

## Key Components

* Average Real Shipping Days
* Average Scheduled Shipping Days
* Actual vs. planned delivery performance
* Late Delivery Rate
* Custom donut charts
* Historical shipping bottleneck analysis
* Overlapping trend lines
* Shipping mode efficiency
* Global market logistics performance

## 54.82% Late Delivery Rate

One of the most significant operational findings is the identified:

> **54.82% late delivery rate**

This indicates a substantial gap between expected and actual delivery performance.

## Actual vs. Scheduled Shipping

The distinction between:

```text
Average Scheduled Shipping Days
```

and:

```text
Average Real Shipping Days
```

is operationally important.

Tracking only average shipping duration can hide whether the organization is actually meeting its planned delivery commitments.

Comparing actual performance against scheduled performance exposes operational reliability.

## Historical Bottlenecks

Overlapping trend lines allow operational teams to investigate whether delays are:

* Persistent
* Seasonal
* Market-specific
* Shipping-mode-specific
* Associated with specific operational periods

## Business Purpose

> **Where is the logistics network failing to meet delivery expectations?**

---

# 🛠️ Tech Stack

| Technology                 | Role                                                                      |
| -------------------------- | ------------------------------------------------------------------------- |
| **SQL Server**             | Central data warehouse and database platform                              |
| **T-SQL**                  | Ingestion, profiling, cleansing, transformation, validation, and modeling |
| **Medallion Architecture** | Bronze/Silver/Gold pipeline architecture                                  |
| **Kimball Star Schema**    | Dimensional analytical modeling                                           |
| **Surrogate Keys**         | Stable dimension identity and relationship management                     |
| **Power BI**               | Interactive BI and analytical consumption layer                           |
| **DAX**                    | Measures, calculations, filter context, and time intelligence             |
| **Data Modeling**          | Semantic model and relationship design                                    |

## Why These Technologies?

### SQL Server

Provides the centralized relational platform hosting the warehouse layers.

### T-SQL

Allows ingestion, data quality engineering, transformation, and dimensional modeling to be implemented close to the data.

### Medallion Architecture

Separates raw ingestion from quality engineering and business-ready analytical data.

### Kimball Star Schema

Provides a clear and BI-friendly dimensional structure optimized for analytical workloads.

### Surrogate Keys

Provide stable dimension identifiers independent of potentially unreliable source identifiers.

### Power BI

Provides interactive exploration, dashboarding, and executive reporting.

### DAX

Enables context-aware calculations, dynamic measures, time comparisons, and analytical logic that complements the SQL warehouse.

---

# 🔄 Project Execution

The implementation followed a complete analytical engineering lifecycle.

## Phase 1 — Source Ingestion

```text
Raw Flat Files
      ↓
SQL Server
      ↓
Bronze Tables
```

Source records were loaded with minimal transformation to preserve source fidelity.

---

## Phase 2 — Data Profiling

The Bronze layer was investigated for:

* Nulls
* Data types
* Categorical anomalies
* Hidden whitespace
* Duplicate representations
* Orphan records
* Referential integrity problems

The objective was to understand the source before applying transformation rules.

---

## Phase 3 — Silver Transformation

Data quality rules were implemented using T-SQL.

```text
Raw Values
    ↓
Whitespace Normalization
    ↓
Category Standardization
    ↓
Missing-Value Handling
    ↓
Data-Type Casting
    ↓
Integrity Validation
    ↓
Silver Data
```

---

## Phase 4 — Dimensional Modeling

The standardized Silver data was transformed into:

```text
gold.fact_orders
gold.dim_date
gold.dim_customers
gold.dim_products
gold.dim_salesman
```

Surrogate keys and dimensional relationships were established to create the analytical Star Schema.

---

## Phase 5 — Power BI Connection

Power BI was connected to the Gold layer rather than directly to the raw operational structures.

```text
SQL Server
    │
    └── Gold Warehouse
            │
            ▼
         Power BI
```

This maintains a clean separation between data engineering and analytical consumption.

---

## Phase 6 — Semantic Modeling

The Power BI model was configured with:

* Dimension-to-fact relationships
* Single-direction filtering
* Dedicated date table
* Analytical measures
* KPI logic
* Business calculations

---

## Phase 7 — Advanced DAX

Specialized DAX logic was developed to solve:

* Previous Year comparison
* Non-standard time filtering
* Customer-name aggregation skew
* Dynamic profitability calculations
* Commission calculations
* Late-delivery metrics

---

## Phase 8 — Dashboard Engineering

Five analytical pages were developed:

```text
01  Executive Overview
02  Customer & Regional Insights
03  Product Profitability
04  Sales Team Performance
05  Logistics Operations
```

The pages share a consistent design language and navigation framework.

---

## Phase 9 — Validation

The final model and dashboards were validated across:

* KPI totals
* Aggregations
* Relationships
* Filtering behavior
* Time-based calculations
* Customer-level granularity
* Business logic
* Visual consistency

The objective was to ensure that Power BI results remain consistent with the underlying Gold warehouse.

---

# 📁 Repository Structure

```text
SupplyChainDWH/
│
├── sql_scripts/
│   │
│   ├── bronze/
│   │   ├── 01_create_bronze_tables.sql
│   │   └── 02_load_raw_data.sql
│   │
│   ├── silver/
│   │   ├── 01_data_cleaning.sql
│   │   ├── 02_standardization.sql
│   │   └── 03_data_quality_checks.sql
│   │
│   └── gold/
│       ├── 01_create_dimensions.sql
│       ├── 02_create_fact.sql
│       └── 03_load_gold_layer.sql
│
├── pbix_file/
│   └── SupplyChainDWH.pbix
│
├── docs/
│   ├── architecture/
│   ├── data_dictionary/
│   └── screenshots/
│
├── README.md
└── LICENSE
```

The repository structure demonstrates separation of concerns between:

```text
Ingestion
    ↓
Transformation
    ↓
Dimensional Modeling
    ↓
Business Intelligence
    ↓
Documentation
```

---

# 💻 Code Highlights

## T-SQL — Data Cleansing & Standardization

A representative transformation for normalizing dirty categorical fields:

```sql
SELECT
    CASE
        WHEN UPPER(
            REPLACE(
                TRIM(market),
                '  ',
                ' '
            )
        ) IN ('EU', 'EUROPE')
        THEN 'Europe'

        ELSE
            UPPER(
                REPLACE(
                    TRIM(market),
                    '  ',
                    ' '
                )
            )
    END AS standardized_market
FROM silver_source;
```

This combines:

* `TRIM()` → removes leading and trailing whitespace
* `REPLACE()` → normalizes repeated internal spaces
* `UPPER()` → normalizes capitalization
* `CASE` → applies business-specific canonical mapping

The result is a consistent analytical category rather than multiple technically different representations of the same market.

---

## DAX — Previous Year Revenue

A representative custom Previous Year calculation:

```DAX
Revenue PY =
VAR SelectedYear =
    SELECTEDVALUE ( dim_date[Year] )

VAR PreviousYear =
    SelectedYear - 1

RETURN
CALCULATE (
    [Total Revenue],
    REMOVEFILTERS ( dim_date ),
    dim_date[Year] = PreviousYear
)
```

The key design principle is **explicit filter-context control**.

Rather than relying entirely on standard time-intelligence functions, the measure explicitly establishes the desired temporal context.

---

## DAX — Unique Customer Display Name

```DAX
Customer Display Name =
    dim_customers[customer_fname]
        & " "
        & dim_customers[customer_lname]
        & " ["
        & FORMAT ( dim_customers[customer_id], "0" )
        & "]"
```

This preserves human-readable names while preventing identical names from collapsing into a single analytical category.

---

## DAX — Profit Margin

```DAX
Profit Margin =
DIVIDE (
    [Total Profit],
    [Total Revenue]
)
```

Using `DIVIDE()` provides safer handling of zero or blank denominators than direct division.

---

## DAX — Average Order Value

```DAX
Average Order Value =
DIVIDE (
    [Total Revenue],
    [Total Orders]
)
```

This metric allows revenue performance to be evaluated independently from transaction volume.

---

# 💡 Business Insights

The purpose of the platform is not merely to produce charts.

The analytical model enables stakeholders to move from **observations to decisions**.

---

## 1. 🚚 Significant Logistics Risk

The dashboard identifies a:

> **54.82% late delivery rate**

### Observation

More than half of the analyzed deliveries are classified as late according to the modeled delivery logic.

### Recommended Action

Management can investigate:

* Shipping modes
* Markets
* Regions
* Historical periods
* Scheduled-vs-actual shipping gaps

The next analytical step would be to isolate the dimensions contributing most heavily to late deliveries.

---

## 2. 👑 More Accurate VIP Customer Identification

Customer names are not reliable unique identifiers.

The customer-ID solution prevents:

```text
Mary Smith
```

from becoming an artificial high-value customer created by aggregating several independent records.

### Business Value

Stakeholders can identify actual individual VIP customers and make better decisions regarding:

* Retention
* Account management
* Customer segmentation
* Targeted promotions
* Revenue concentration

---

## 3. 💸 Potential Margin Erosion from Discounting

The Product Profitability page evaluates:

```text
Average Discount
        vs.
Profit Margin
```

### Business Question

> **Are aggressive discounts generating enough additional revenue to compensate for the margin they destroy?**

Products showing high discount levels alongside weak margins should be candidates for:

* Pricing review
* Promotional review
* Margin investigation
* Product portfolio optimization

---

## 4. 🎯 Sales Incentive Efficiency

Commission rates are evaluated against revenue rather than looking only at sales volume.

This helps identify cases where:

* High commission costs generate strong revenue
* High commission costs generate weak revenue
* High revenue is achieved efficiently
* Sales representatives contribute meaningfully to profitability

The analytical perspective therefore moves from:

> **"Who sold the most?"**

toward:

> **"Who generated the most efficient commercial value?"**

---

# 🧠 Engineering & Analytical Value

SupplyChainDWH demonstrates a complete transition from raw operational data to business decision support.

## End-to-End Engineering

The project covers:

* Raw data ingestion
* Data profiling
* Data quality engineering
* SQL-based ETL
* Medallion Architecture
* Dimensional modeling
* Surrogate keys
* Referential integrity
* Semantic modeling
* Advanced DAX
* Filter-context manipulation
* Time-intelligence troubleshooting
* Granularity management
* Dashboard engineering
* Business analytics

## Multi-Layer Problem Solving

### Data Layer

```text
Dirty Data
    ↓
Profiling
    ↓
Cleansing
    ↓
Standardization
```

### Warehouse Layer

```text
Cleansed Data
    ↓
Dimensional Modeling
    ↓
Surrogate Keys
    ↓
Fact + Dimensions
```

### Semantic Layer

```text
Star Schema
    ↓
Relationships
    ↓
Measures
    ↓
Filter Context
```

### BI Layer

```text
Semantic Model
    ↓
DAX
    ↓
Visual Analytics
    ↓
Business Insights
```

This demonstrates that the project is not simply a collection of SQL queries or Power BI charts.

It represents an integrated analytical platform:

> **Raw Data → Data Quality → Data Warehouse → Semantic Model → Analytics → Business Decision**

---

# 🔮 Future Enhancements

The current implementation provides the core analytical architecture.

The following are **future enhancements**, not features claimed as part of the current implementation.

## ⚙️ ETL & Orchestration

* Automated ETL orchestration
* SQL Server Agent scheduling
* Metadata-driven pipelines
* Incremental loading
* Automated refresh monitoring

## 🧪 Data Quality

* Automated data-quality testing
* Data-quality scorecards
* Schema validation
* Automated anomaly detection
* Data observability

## 🏛️ Dimensional Modeling

* Slowly Changing Dimensions
* Historical attribute tracking
* Expanded conformed dimensions
* Advanced warehouse auditing

## ☁️ Cloud Architecture

A potential future architecture could evolve toward:

```text
SQL Server
    ↓
Azure Data Factory
    ↓
Azure SQL / Synapse
    ↓
Power BI
```

## 🚀 BI Engineering

* Power BI deployment pipelines
* CI/CD for SQL and BI assets
* Automated semantic-model validation
* Centralized workspace governance
* Refresh monitoring
* Automated deployment processes

---

# 🏆 Key Takeaways

SupplyChainDWH demonstrates how an analytical system can be engineered as a complete pipeline rather than as an isolated reporting solution.

The project demonstrates:

```text
┌──────────────────────────────┐
│          RAW DATA            │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│       DATA PROFILING         │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│   DATA QUALITY ENGINEERING   │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│   MEDALLION ARCHITECTURE     │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│    KIMBALL STAR SCHEMA       │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│       SEMANTIC MODEL         │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│         ADVANCED DAX         │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│        POWER BI APP          │
└──────────────┬───────────────┘
               ↓
┌──────────────────────────────┐
│      BUSINESS INSIGHTS       │
└──────────────────────────────┘
```

The strongest aspect of the project is the connection between **engineering correctness and analytical usefulness**.

The warehouse is not built merely to store data.

The DAX is not written merely to produce numbers.

The dashboard is not designed merely to look attractive.

Each layer exists to ensure that the final business insight is:

**Traceable → Standardized → Modeled → Calculated → Visualized → Actionable**

---

# 👤 Author

## Ibrahim Khalil

**Data Engineering • Data Analytics • Business Intelligence • Artificial Intelligence**

SupplyChainDWH represents an end-to-end portfolio implementation focused on building reliable data pipelines, dimensional warehouses, analytical semantic models, and decision-oriented BI applications.

---

