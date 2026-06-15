# Enterprise Extraction Patterns: Oracle EBS to OIC & AI

## Overview
This repository defines the canonical architectural patterns for extracting, shaping, and routing data from Oracle E-Business Suite (EBS) to modern cloud ecosystems, specifically Oracle Integration Cloud (OIC) and Oracle AI pipelines.

At the enterprise level, integration bottlenecks are rarely caused by network latency; they are caused by **payload complexity and misplaced compute**. 

The patterns in this repository demonstrate a **"Push-Down Architecture"**—a design philosophy that enforces strict compute delegation. By pushing heavy analytical processing, data joins, and feature derivation down to the Oracle Database layer, we ensure that our middleware acts purely as an orchestrator, and our AI models receive clean, pre-calculated matrices.

## 🏛 Core Architectural Pillars

### 1. Compute Delegation
The Oracle Database optimizer is purpose-built for high-volume analytical processing. Pushing calculations (like window functions and complex aggregations) to the data layer reduces OIC memory consumption, improves execution efficiency, and allows integrations to scale predictably. 

### 2. Payload Flattening
Pre-joined and pre-aggregated datasets eliminate unnecessary transformation logic in the middleware. OIC is designed for orchestration, routing, monitoring, and governance. It should never be used as a pseudo-reporting or data transformation engine.

### 3. Canonical Business Logic
When analytical calculations are centralized at the source, every downstream consumer—integrations, APIs, reports, and AI services—operates from the exact same business definitions. This approach eliminates transformation drift and guarantees enterprise-wide data consistency.

### 4. AI & Analytics Readiness
Features such as departmental averages, performance classifications, and temporal ranks are generated at extraction time. This produces structured, flattened datasets that can be consumed immediately by Oracle AI, machine learning pipelines, or workforce predictive models with zero downstream data wrangling.

---

## 📂 Repository Structure

This repository is organized by business domain to support scalable, modular enterprise adoption.

```text
ebs-to-oic-extraction-patterns/
│
├── architecture_diagrams/
│   └── push_down_architecture.png         # High-level system interaction diagram
│
├── hcm/                                   # Human Capital Management Domain
│   ├── queries/
│      └── dept_salary_benchmarking.sql   # Source-level compute and feature extraction
│ 
│
├── fin/                                   # Financials Domain (Patterns Incoming)
└── scm/                                   # Supply Chain Domain (Patterns Incoming)
