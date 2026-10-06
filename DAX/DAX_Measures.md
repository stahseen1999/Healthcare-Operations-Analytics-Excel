# DAX Measures — Healthcare Operations Analytics

## Overview

This document contains the DAX measures used in the Healthcare Operations Analytics Excel Data Model.

The measures provide reusable, filter-aware KPIs for the healthcare operations dashboard and PivotTable/PivotChart analysis.

Model fact tables:
- `Fact_Visits`
- `Fact_Billing`

Model dimensions:
- `Dim_Date`
- `Dim_Patient`
- `Dim_Doctor`

---

## 1. Total Visits

### DAX

```DAX
Total Visits :=
COUNTROWS(Fact_Visits)
```

### Purpose
Counts the total number of visit records in `Fact_Visits`.

### Business Meaning
Represents total appointment/visit volume.

### Dashboard Result
**5,000 visits**

---

## 2. Completed Visits

### DAX

```DAX
Completed Visits :=
CALCULATE(
    [Total Visits],
    Fact_Visits[Appointment_Status] = "Completed"
)
```

### Purpose
Counts visits where the appointment status is `Completed`.

### Business Meaning
Measures the number of appointments successfully completed.

### Dashboard Result
**4,755 completed visits**

---

## 3. No Show Rate

### DAX

```DAX
No Show Rate :=
DIVIDE(
    CALCULATE(
        [Total Visits],
        Fact_Visits[Appointment_Status] = "No Show"
    ),
    [Total Visits]
)
```

### Purpose
Calculates the proportion of total visits that resulted in a no-show.

### Business Meaning
Helps management monitor missed appointments and potential capacity loss.

### Dashboard Result
**3.0%**

---

## 4. Cancellation Rate

### DAX

```DAX
Cancellation Rate :=
DIVIDE(
    CALCULATE(
        [Total Visits],
        Fact_Visits[Appointment_Status] = "Cancelled"
    ),
    [Total Visits]
)
```

### Purpose
Calculates the proportion of total visits that were cancelled.

### Business Meaning
Provides visibility into appointment cancellations and potential operational disruption.

### Dashboard Result
**1.90%**

---

## 5. Average Wait Time

### DAX

```DAX
Avg Wait Time :=
AVERAGEX(
    FILTER(
        Fact_Visits,
        Fact_Visits[Appointment_Status] = "Completed"
    ),
    Fact_Visits[Wait_Time_Minutes]
)
```

### Purpose
Calculates the average waiting time for completed visits.

### Business Meaning
Measures operational efficiency from the patient's perspective.

Only completed visits are included because no-show and cancelled appointments do not represent an actual completed patient flow.

### Dashboard Result
**23.6 minutes**

---

## 6. Average Patient Satisfaction

### DAX

```DAX
Avg Satisfaction :=
AVERAGEX(
    FILTER(
        Fact_Visits,
        NOT ISBLANK(Fact_Visits[Patient_Satisfaction])
    ),
    Fact_Visits[Patient_Satisfaction]
)
```

### Purpose
Calculates the average patient satisfaction score while excluding blank satisfaction values.

### Business Meaning
Provides an overall indicator of patient experience.

### Dashboard Result
**4.1 / 5**

---

## 7. Total Revenue

### DAX

```DAX
Total Revenue :=
SUM(Fact_Billing[Net_Revenue_Clean])
```

### Purpose
Sums the cleaned net revenue from the billing fact table.

### Business Meaning
Represents the total recorded net revenue available in the analytical billing dataset.

### Dashboard Result
**₹73,97,250**

---

## 8. Revenue per Completed Visit

### DAX

```DAX
Revenue per Completed Visit :=
DIVIDE(
    [Total Revenue],
    [Completed Visits]
)
```

### Purpose
Calculates average recorded revenue per completed visit.

### Business Meaning
Provides a simple efficiency/revenue indicator by relating total recorded revenue to completed visit volume.

### Approximate Result
**₹1,554 per completed visit**

---

## 9. Unique Patients

### DAX

```DAX
Unique Patients :=
DISTINCTCOUNT(Fact_Visits[Patient_ID])
```

### Purpose
Counts distinct patients represented in the visit fact table.

### Business Meaning
Measures the number of unique patients who generated visit records.

### Dashboard Result
**1,174 unique patients**

---

# DAX Concepts Demonstrated

## COUNTROWS

Used to count records in the visit fact table.

```DAX
COUNTROWS(Fact_Visits)
```

Used by:
- `Total Visits`

## CALCULATE

Used to modify filter context and calculate metrics for a specific appointment status.

```DAX
CALCULATE(
    [Total Visits],
    Fact_Visits[Appointment_Status] = "Completed"
)
```

Used by:
- `Completed Visits`
- `No Show Rate`
- `Cancellation Rate`

## DIVIDE

Used instead of direct division to safely handle zero denominators.

```DAX
DIVIDE(
    [Total Revenue],
    [Completed Visits]
)
```

Used by:
- `No Show Rate`
- `Cancellation Rate`
- `Revenue per Completed Visit`

## AVERAGEX

Used to calculate averages over a filtered table.

Used by:
- `Avg Wait Time`
- `Avg Satisfaction`

## FILTER

Used to create filtered table expressions before applying an iterator such as `AVERAGEX`.

## DISTINCTCOUNT

Used to count unique patient identifiers rather than visit records.

```DAX
DISTINCTCOUNT(Fact_Visits[Patient_ID])
```

Used by:
- `Unique Patients`

---

# Measure Design Approach

The project follows a reusable-measure approach rather than embedding calculations directly into individual PivotTables.

For example:

```text
Total Visits
     ↓
Completed Visits
     ↓
No Show Rate / Cancellation Rate
```

This makes the analytical model easier to maintain because base measures can be reused by multiple dependent measures.

---

# KPI Summary

| Measure | Result | Business Purpose |
|---|---:|---|
| Total Visits | 5,000 | Overall visit volume |
| Completed Visits | 4,755 | Completed appointment volume |
| No Show Rate | 3.0% | Missed appointment rate |
| Cancellation Rate | 1.90% | Cancelled appointment rate |
| Avg Wait Time | 23.6 min | Operational efficiency |
| Avg Satisfaction | 4.1 / 5 | Patient experience |
| Total Revenue | ₹73,97,250 | Recorded net revenue |
| Revenue per Completed Visit | ~₹1,554 | Revenue relative to completed visits |
| Unique Patients | 1,174 | Distinct patient population |

---

# How the Measures Support the Dashboard

## Department Performance

Uses:
- Total Visits
- Completed Visits
- No Show Rate
- Avg Wait Time
- Avg Satisfaction
- Total Revenue

## Monthly Performance

Uses:
- Total Visits
- Completed Visits
- Avg Wait Time
- Total Revenue

## Doctor Performance

Uses:
- Completed Visits
- Avg Wait Time
- Avg Satisfaction
- Total Revenue

## Insurance Performance

Uses:
- Total Visits
- Completed Visits
- No Show Rate
- Avg Satisfaction
- Total Revenue

---

# Important Modeling Note

`Total Revenue` is sourced from the cleaned billing fact table.

To support department and doctor revenue analysis, `Billing_Clean` was merged with `Visits_Clean` using `Visit_ID` so that `Doctor_ID` was available in the billing fact table.

This allows revenue to be analyzed through the doctor and department dimensions without repeating the full revenue amount for every department.

---

# Validation

The measures were validated against the project dashboard and analytical outputs.

Key validated outputs include:

- Total Visits = 5,000
- Completed Visits = 4,755
- No Show Rate = 3.0%
- Cancellation Rate = 1.90%
- Avg Wait Time ≈ 23.6 minutes
- Avg Satisfaction ≈ 4.1
- Total Revenue = ₹73,97,250
- Unique Patients = 1,174

---

# DAX Learning Coverage

This project demonstrates practical use of:

- Measures
- Filter context
- `CALCULATE`
- `FILTER`
- `COUNTROWS`
- `SUM`
- `AVERAGEX`
- `DISTINCTCOUNT`
- `DIVIDE`
- Reusable measure dependencies
- KPI development
- Fact-table aggregation
- Dimension-driven analysis

The DAX was developed specifically to support business questions rather than as isolated formula exercises.
