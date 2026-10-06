# Power Query Transformations

## Healthcare Operations Analytics

Power Query is used as the controlled transformation layer between the raw source tables and the Power Pivot analytical model.

The goal is to preserve the raw data while creating standardized, validated tables for reporting.

---

## 1. Transformation Architecture

```text
Raw Excel Tables
      ↓
Power Query
      ↓
Clean / Standardized Tables
      ↓
Power Pivot Data Model
      ↓
DAX Measures
      ↓
Dashboard
```

The raw tables remain available for audit and traceability.

---

## 2. Visits_Clean

### Source

`tblVisitsRaw`

### Purpose

Prepare visit-level operational data for KPI and dashboard analysis.

### Transformations

1. Set appropriate data types for IDs, dates, text, integers, and numeric fields.
2. Trim `Department`.
3. Trim `Appointment_Status`.
4. Trim `Visit_Type`.
5. Standardize department text using proper case.
6. Standardize appointment status using proper case.
7. Replace negative `Wait_Time_Minutes` values with `0`.
8. Validate `Patient_Satisfaction` against the expected 1–5 scale.
9. Preserve missing satisfaction as null.
10. Cap values above 5 at 5.
11. Add `Month`.
12. Add `YearMonth` in `yyyy-MM` format.

### Business result

The resulting table supports:

- Visit volume
- Completed visits
- No-show rate
- Cancellation rate
- Waiting-time analysis
- Satisfaction analysis
- Monthly trend analysis

### M logic

```text
Wait_Time_Minutes:
if value < 0 then 0 else value

Patient_Satisfaction:
if null then null
else if value > 5 then 5
else if value < 1 then 1
else value

YearMonth:
Date.ToText([Visit_Date], "yyyy-MM")
```

---

## 3. Billing_Clean

### Source

`tblBillingRaw`

### Purpose

Prepare billing data for revenue analysis.

### Transformations

1. Set appropriate data types.
2. Trim `Payment_Mode`.
3. Trim `Payment_Status`.
4. Standardize `Payment_Mode` to uppercase.
5. Replace negative discounts with `0`.
6. Recalculate clean revenue.
7. Merge with `Visits_Clean` using `Visit_ID` to bring `Doctor_ID` into the billing table.

### Clean revenue logic

```text
Net_Revenue_Clean = Gross_Amount - Validated_Discount
```

### Why recalculate revenue?

The source data contains one anomalous negative discount and a corresponding inconsistency in the supplied net revenue value.

Using the validated discount field ensures the analytical revenue measure follows a transparent business rule.

### Why merge billing with visits?

Billing needs provider context for revenue analysis by doctor and department.

```text
Billing
  ↓ Visit_ID
Visits
  ↓ Doctor_ID
Doctor
  ↓ Department
Department Revenue
```

---

## 4. Patients_Clean

### Source

`tblPatientsRaw`

### Purpose

Prepare the patient dimension.

### Transformations

- Standardize city labels.
- Remove unnecessary whitespace.
- Standardize insurance labels.
- Preserve `Patient_ID` as the unique patient key.
- Preserve demographic fields needed for dashboard filtering.

### Business result

The cleaned patient dimension supports:

- Unique patient analysis
- Gender filtering
- Insurance analysis
- Patient segmentation

---

## 5. Doctors_Clean

### Source

`tblDoctorsRaw`

### Purpose

Prepare the doctor dimension.

### Transformations

- Standardize doctor identifiers.
- Standardize doctor names.
- Standardize department labels.
- Standardize fee-related fields.
- Preserve `Doctor_ID` as the unique doctor key.

### Business result

The cleaned doctor dimension supports:

- Doctor performance
- Department analysis
- Revenue by doctor
- Revenue by department

---

## 6. Dim_Date

### Purpose

Provide a consistent calendar dimension for time-based analysis.

The date dimension supports:

- Year analysis
- Month analysis
- YearMonth sorting
- Monthly visit trends
- Monthly revenue trends

The date dimension is related to both visit dates and billing dates.

---

## 7. Cleaning Rules Summary

| Issue | Source Problem | Power Query Treatment |
|---|---|---|
| Department whitespace | ` general medicine ` | Trim |
| Department casing | Inconsistent text | Proper case |
| Appointment status whitespace | `Completed ` | Trim |
| Payment mode whitespace | ` upi ` | Trim |
| Payment mode casing | Inconsistent text | Uppercase |
| Negative wait time | `-5` | Replace with 0 |
| Satisfaction above scale | `7.0` | Cap at 5 |
| Negative discount | `-50` | Replace with 0 |
| Date fields | Source date values | Explicit date typing |
| Numeric fields | Source numeric values | Explicit number/integer typing |

---

## 8. Analytical Outputs

The transformation layer prepares the tables used by the Data Model:

```text
Visits_Clean
      ↓
Fact_Visits

Billing_Clean
      ↓
Fact_Billing

Patients_Clean
      ↓
Dim_Patient

Doctors_Clean
      ↓
Dim_Doctor

Dim_Date
      ↓
Dim_Date
```

---

## 9. Power Query Design Principles

### Preserve raw data

Raw tables are not overwritten by cleaning logic.

### Make transformations repeatable

Cleaning is implemented as query steps so the process can be repeated after refreshing the source data.

### Validate before calculating

Invalid values are handled before they enter KPI calculations.

### Keep business logic transparent

Important calculations such as clean revenue are explicitly defined rather than hidden inside dashboard formulas.

### Separate transformation from reporting

Power Query handles preparation; Power Pivot/DAX handles reusable analytical measures; the dashboard handles presentation.

---

## 10. Relationship to the DAX Layer

Power Query prepares reliable analytical columns and tables.

DAX then calculates reusable measures such as:

- Total Visits
- Completed Visits
- No Show Rate
- Cancellation Rate
- Average Wait Time
- Average Satisfaction
- Total Revenue
- Revenue per Completed Visit
- Unique Patients

This separation keeps the overall BI workflow maintainable.

---

## 11. Detailed M Code

The exact Power Query M scripts are maintained separately in:

`Power_Query/Power_Query_M_Code.txt`

This documentation explains the business purpose and transformation logic, while the separate code file preserves the implementation.
