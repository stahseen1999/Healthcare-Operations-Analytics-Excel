# Data Audit

## Healthcare Operations Analytics

The data audit was performed before analytical modeling to identify missing values, duplicates, formatting inconsistencies, invalid values, and relationship risks in the synthetic healthcare dataset.

---

## 1. Audit Scope

The audit covered four source tables:

- `Raw_Patients`
- `Raw_Doctors`
- `Raw_Visits`
- `Raw_Billing`

The objective was to establish whether the source data was suitable for Power Query transformation and Power Pivot/DAX analysis.

---

## 2. Record-Level Summary

| Table | Records | Duplicate Rows | Primary-Key Duplicate Count |
|---|---:|---:|---:|
| `Raw_Patients` | 1,200 | 0 | `Patient_ID`: 0 |
| `Raw_Doctors` | 35 | 0 | `Doctor_ID`: 0 |
| `Raw_Visits` | 5,000 | 0 | `Visit_ID`: 0 |
| `Raw_Billing` | 5,000 | 0 | `Bill_ID`: 0 |

No complete duplicate rows were identified in the four source tables.

---

## 3. Missing-Value Audit

### Raw_Patients

No missing values were identified across the seven patient fields.

### Raw_Doctors

No missing values were identified across the five doctor fields.

### Raw_Visits

| Field | Missing Values |
|---|---:|
| `Visit_ID` | 0 |
| `Patient_ID` | 0 |
| `Doctor_ID` | 0 |
| `Visit_Date` | 0 |
| `Visit_Type` | 0 |
| `Department` | 0 |
| `Diagnosis` | 0 |
| `Appointment_Status` | 0 |
| `Wait_Time_Minutes` | 0 |
| `Consultation_Fee` | 0 |
| `Patient_Satisfaction` | 245 |

The 245 missing satisfaction values were retained as missing rather than converted to a score. The DAX average satisfaction measure excludes blanks.

### Raw_Billing

| Field | Missing Values |
|---|---:|
| `Bill_ID` | 0 |
| `Visit_ID` | 0 |
| `Patient_ID` | 0 |
| `Bill_Date` | 0 |
| `Consultation_Amount` | 0 |
| `Lab_Amount` | 0 |
| `Medicine_Amount` | 0 |
| `Gross_Amount` | 0 |
| `Discount` | 0 |
| `Net_Revenue` | 0 |
| `Payment_Mode` | 245 |
| `Payment_Status` | 0 |

Missing payment modes were retained as missing because a payment method should not be invented during cleaning.

---

## 4. Text-Quality Issues

### Patients

One city value contained unnecessary whitespace:

```text
" bengaluru "
```

Power Query trims the value so it becomes the standardized city label.

### Visits

One department value contained unnecessary whitespace and inconsistent casing:

```text
" general medicine "
```

One appointment status contained trailing whitespace:

```text
"Completed "
```

These are standardized using trimming and proper-case transformations.

### Billing

One payment-mode value contained unnecessary whitespace:

```text
" upi "
```

Power Query trims and standardizes payment-mode labels.

---

## 5. Numeric-Value Validation

### Visit waiting time

- Records: 5,000
- Minimum raw value: `-5` minutes
- Maximum raw value: `70` minutes
- Negative values: `1`

The negative waiting time is invalid for an operational waiting-time measure. Power Query changes negative values to `0`.

### Patient satisfaction

- Non-blank observations: 4,755
- Raw minimum: `1.8`
- Raw maximum: `7.0`
- Values above 5: `1`

The single value above the expected 1–5 scale is capped at `5` in the cleaned analytical table.

### Billing discount

- Minimum raw discount: `-50`
- Maximum raw discount: `150`
- Negative discounts: `1`

The negative discount is invalid. Power Query changes negative discounts to `0` before calculating clean revenue.

---

## 6. Billing Revenue Validation

The source `Net_Revenue` value is not blindly trusted for the analytical revenue calculation.

The clean revenue calculation is:

```text
Net_Revenue_Clean = Gross_Amount - Validated_Discount
```

The identified negative-discount record had:

```text
Gross Amount = ₹2,650
Raw Discount = -₹50
Raw Net Revenue = ₹2,550
Validated Discount = ₹0
Clean Revenue = ₹2,650
```

Therefore, the cleaned revenue model reflects the validated discount logic.

- Raw supplied `Net_Revenue` total: **₹73,97,150**
- Clean calculated revenue total: **₹73,97,250**

The ₹100 difference is caused by the identified anomalous billing record.

---

## 7. Referential-Integrity Checks

The transactional data was checked against the dimension identifiers.

### Patients

- Patient dimension records: 1,200
- Unique patients appearing in visits: 1,174
- No visit was found with a missing `Patient_ID`.

### Doctors

- Doctor dimension records: 35
- Unique doctors appearing in visits: 35
- No visit was found with a missing `Doctor_ID`.

### Billing-to-Visits

- Billing records: 5,000
- Unique billing `Visit_ID` values: 5,000
- Visit-to-billing linkage is one-to-one in the supplied dataset.

---

## 8. Appointment Status Validation

After trimming the raw status values, the visit status distribution is:

| Status | Records |
|---|---:|
| Completed | 4,755 |
| No Show | 150 |
| Cancelled | 95 |
| **Total** | **5,000** |

The raw dataset contained one `Completed ` value with trailing whitespace. After standardization it becomes `Completed`.

---

## 9. Audit Findings & Treatment

| Issue | Count | Treatment |
|---|---:|---|
| Missing patient fields | 0 | No treatment required |
| Missing doctor fields | 0 | No treatment required |
| Missing visit satisfaction | 245 | Preserve as blank; exclude blanks from average |
| Missing billing payment mode | 245 | Preserve as blank |
| Department whitespace/casing issue | 1 | Trim + standardize |
| Appointment status whitespace | 1 | Trim + standardize |
| Payment mode whitespace | 1 | Trim + standardize |
| Negative wait time | 1 | Replace with 0 |
| Satisfaction above 5 | 1 | Cap at 5 |
| Negative discount | 1 | Replace with 0 |
| Complete duplicate rows | 0 | No removal required |
| Primary-key duplicates | 0 | No removal required |

---

## 10. Audit Conclusion

The raw dataset is suitable for analysis after controlled transformation.

The main quality issues are small in volume but important because they can distort KPI calculations if ignored. Power Query is therefore used as the controlled cleaning layer before the data enters the analytical model.

The audit supports the following workflow:

```text
Raw Data
   ↓
Data Audit
   ↓
Power Query Cleaning
   ↓
Clean Analytical Tables
   ↓
Power Pivot Data Model
   ↓
DAX Measures
   ↓
Dashboard
```

> All findings are based on the synthetic portfolio dataset and should not be interpreted as real healthcare operational findings.
