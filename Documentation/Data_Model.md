# Data Model

## Healthcare Operations Analytics

The project uses a fact-and-dimension model in Excel Power Pivot. The objective is to keep transactional activity in fact tables and descriptive business attributes in dimension tables.

---

## 1. Modeling Approach

The model follows a star-schema design:

```text
                    Dim_Date
                       │
                       │
Dim_Patient ─────── Fact_Visits ─────── Dim_Doctor
                       │
                       │
                       └────── Fact_Billing
                                  │
                                  │
                             Dim_Patient
                             Dim_Doctor
```

The dimensions provide filtering and descriptive context, while facts contain measurable business activity.

---

## 2. Dimension Tables

### Dim_Date

**Purpose:** Provides a consistent calendar for visit and billing time analysis.

**Key:** `Date`

Used for:

- Monthly visit trends
- Monthly revenue trends
- Year/month filtering
- Time-based dashboard analysis

Expected analytical attributes include:

- Date
- Year
- Month
- Month Number
- YearMonth

---

### Dim_Patient

**Purpose:** Patient demographic and insurance attributes.

**Key:** `Patient_ID`

Source:

`Patients_Clean`

Used for:

- Patient counts
- Insurance analysis
- Gender analysis
- Patient-level filtering

---

### Dim_Doctor

**Purpose:** Provider and department attributes.

**Key:** `Doctor_ID`

Source:

`Doctors_Clean`

Used for:

- Doctor performance
- Department performance
- Revenue by doctor
- Revenue by department
- Provider-level filtering

---

## 3. Fact Tables

### Fact_Visits

**Grain:** One row per patient visit.

Primary key:

`Visit_ID`

Important fields:

- Visit_ID
- Patient_ID
- Doctor_ID
- Visit_Date
- Visit_Type
- Department
- Diagnosis
- Appointment_Status
- Wait_Time_Minutes
- Consultation_Fee
- Patient_Satisfaction

Used for:

- Total Visits
- Completed Visits
- No Show Rate
- Cancellation Rate
- Average Wait Time
- Average Satisfaction

---

### Fact_Billing

**Grain:** One row per bill.

Primary key:

`Bill_ID`

Important fields:

- Bill_ID
- Visit_ID
- Patient_ID
- Bill_Date
- Consultation_Amount
- Lab_Amount
- Medicine_Amount
- Gross_Amount
- Discount
- Net_Revenue_Clean
- Payment_Mode
- Payment_Status
- Doctor_ID

`Doctor_ID` is brought into the cleaned billing table by merging billing with visit data using `Visit_ID`. This allows revenue to be correctly attributed to doctors and departments.

---

## 4. Relationships

The final analytical model uses these relationships:

| From | To | Purpose |
|---|---|---|
| `Dim_Date[Date]` | `Fact_Visits[Visit_Date]` | Visit time analysis |
| `Dim_Date[Date]` | `Fact_Billing[Bill_Date]` | Billing time analysis |
| `Dim_Doctor[Doctor_ID]` | `Fact_Visits[Doctor_ID]` | Provider analysis |
| `Dim_Doctor[Doctor_ID]` | `Fact_Billing[Doctor_ID]` | Revenue by provider/department |
| `Dim_Patient[Patient_ID]` | `Fact_Visits[Patient_ID]` | Patient analysis |
| `Dim_Patient[Patient_ID]` | `Fact_Billing[Patient_ID]` | Patient billing analysis |
| `Fact_Visits[Visit_ID]` | `Fact_Billing[Visit_ID]` | Visit-to-billing linkage |

The intended relationship direction is from dimensions toward the corresponding facts wherever applicable.

---

## 5. Why Billing Was Linked to Doctor

The billing source contains `Visit_ID` and `Patient_ID`, but department-level revenue analysis requires provider/department context.

The solution was:

```text
Fact_Billing
     │
     │ Visit_ID
     ▼
Fact_Visits
     │
     │ Doctor_ID
     ▼
Dim_Doctor
     │
     ▼
Department
```

For the cleaned billing query, `Doctor_ID` is explicitly brought into billing through a merge with `Visits_Clean`.

This prevents the total billing amount from being incorrectly repeated for every department.

---

## 6. Model Grain

Maintaining the correct grain is important for accurate measures.

| Table | Grain |
|---|---|
| Dim_Date | One row per date |
| Dim_Patient | One row per patient |
| Dim_Doctor | One row per doctor |
| Fact_Visits | One row per visit |
| Fact_Billing | One row per bill |

The visit and billing facts are transactional tables. Dimensions should contain one row per business entity at their defined grain.

---

## 7. KPI Layer

The Data Model supports reusable DAX measures rather than hard-coded dashboard calculations.

Core measures include:

```text
Total Visits
Completed Visits
No Show Rate
Cancellation Rate
Avg Wait Time
Avg Satisfaction
Total Revenue
Revenue per Completed Visit
Unique Patients
```

This makes the dashboard responsive to slicers and PivotTable/PivotChart filter context.

---

## 8. Dashboard Filter Dimensions

The dashboard provides interactive filters for:

- Department
- Insurance Type
- Gender
- Visit Type
- Appointment Status

These filters allow management users to investigate the same KPIs from different operational perspectives.

---

## 9. Model Validation

The model was validated against the expected portfolio KPIs:

| Measure | Validated Result |
|---|---:|
| Total Visits | 5,000 |
| Completed Visits | 4,755 |
| No Show Rate | 3.0% |
| Cancellation Rate | 1.90% |
| Average Wait Time | ~23.64 minutes |
| Average Satisfaction | ~4.07 / 5 |
| Total Revenue | ₹73,97,250 |
| Unique Patients | 1,174 |

The dashboard displays the validated outputs after Power Query cleaning and Data Model calculations.

---

## 10. Design Principles

The model was designed around the following BI principles:

- Separate raw data from cleaned data.
- Separate dimensions from transactional facts.
- Preserve meaningful business keys.
- Use relationships instead of manually repeating attributes.
- Centralize reusable calculations in DAX measures.
- Use Power Query for data preparation.
- Use the Data Model for cross-dimensional analysis.
- Validate analytical outputs against source data and expected business logic.

---

## 11. Model Outcome

The resulting model supports a single dashboard across four major analytical perspectives:

1. Department performance
2. Monthly performance
3. Doctor performance
4. Insurance performance

This provides a reusable BI structure rather than a collection of disconnected Excel charts.
