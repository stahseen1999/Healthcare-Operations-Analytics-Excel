# Healthcare Operations Analytics — Excel Portfolio Project

> **An end-to-end Excel analytics project focused on patient flow, appointment performance, operational efficiency, satisfaction, and revenue.**

## Project Overview

Healthcare organizations need to understand where operational bottlenecks occur, how appointment outcomes affect capacity, which departments and doctors perform best, and how patient experience connects with operations and revenue.

This project uses a **synthetic healthcare operations dataset** to build a reusable analytics solution in Excel using **Power Query, Power Pivot, DAX, PivotTables, PivotCharts, Slicers, and VBA automation**.

### Business Objectives

- Monitor patient and appointment volume
- Identify no-show and cancellation patterns
- Analyze waiting time and patient satisfaction
- Compare department and doctor performance
- Understand revenue performance
- Provide an interactive management dashboard
- Automate refresh and dashboard PDF export

## Key Results

| KPI | Result |
|---|---:|
| Total Visits | **5,000** |
| Completed Visits | **4,755** |
| No-Show Rate | **3.0%** |
| Cancellation Rate | **1.9%** |
| Avg. Wait Time | **23.6 min** |
| Avg. Satisfaction | **4.1 / 5** |
| Total Revenue | **₹73.97 Lakh** |
| Unique Patients | **1,174** |

## Analytics Solution

**Raw Data → Power Query → Data Model → DAX → Pivot Analysis → Interactive Dashboard → VBA Automation**

### Tools & Techniques

- **Excel** — analysis, PivotTables, PivotCharts and dashboard
- **Power Query** — data cleaning, standardization and validation
- **Power Pivot / Data Model** — relational analytical model
- **DAX** — reusable business measures and KPIs
- **Slicers** — interactive filtering
- **VBA** — refresh automation, filter reset and PDF export

## Data Model

The project follows a **star-schema-style analytical model** with:

- `Dim_Date`
- `Dim_Patient`
- `Dim_Doctor`
- `Fact_Visits`
- `Fact_Billing`

Relationships are used to support analysis across date, patient, doctor, department and billing dimensions.

## Dashboard

The final dashboard provides:

- KPI cards for operational performance
- Monthly visit trends
- Revenue by department
- Top doctors by revenue
- Appointment status distribution
- Interactive slicers for department, insurance type, gender, visit type and appointment status

### Dashboard Preview
<img width="940" height="648" alt="image" src="https://github.com/user-attachments/assets/5f7b3954-64ef-4e4a-9f87-03b82e6bac7c" />

## Automation

A VBA automation layer allows the user to:

- Refresh workbook data and PivotTables
- Update the dashboard refresh timestamp
- Export the dashboard directly to PDF
- Reset dashboard slicer filters

## Project Structure

```text
Healthcare-Operations-Analytics/
│
├── Healthcare_Operations_Analytics.xlsm
├── README.md
│
├── Documentation/
│   ├── Data_Dictionary.md
│   ├── Data_Audit.md
│   ├── Data_Model.md
│   ├── Business_Questions_and_Findings.md
│   └── Power_Query_Transformations.md
│
├── DAX/
│   └── DAX_Measures.txt
│
└── VBA/
    └── VBA_Automation.bas
```

## Important Note

The dataset is **synthetic and contains no real patient information**. It was created specifically for portfolio and demonstration purposes.

## Project Summary

**I built an end-to-end healthcare operations analytics solution in Excel, starting from raw data auditing and Power Query transformations through Power Pivot data modeling and DAX-based KPI development. I then built an interactive dashboard with slicers and added VBA automation for refresh, filter reset, and PDF export. The project demonstrates both technical Excel capabilities and business-focused analytical thinking.**
