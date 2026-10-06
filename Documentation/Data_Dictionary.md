# Data Dictionary

## Healthcare Operations Analytics

This document defines the source fields used in the Healthcare Operations Analytics Excel project and explains their role in the analytical model.

> **Dataset:** Synthetic healthcare operations data created for portfolio demonstration. No real patient information is used.

---

## 1. Dataset Overview

| Source Table | Records | Analytical Role | Grain |
|---|---:|---|---|
| `Raw_Patients` | 1,200 | Patient dimension | One row per patient |
| `Raw_Doctors` | 35 | Doctor dimension | One row per doctor |
| `Raw_Visits` | 5,000 | Visit fact | One row per visit |
| `Raw_Billing` | 5,000 | Billing fact | One row per bill |

---

## 2. Raw_Patients

**Grain:** One row per patient.

| Field | Data Type | Definition | Model Role |
|---|---|---|---|
| `Patient_ID` | Text | Unique patient identifier. | Primary Key / Dimension |
| `Patient_Name` | Text | Patient name in the synthetic dataset. | Descriptive attribute |
| `Gender` | Text | Patient gender category. | Dimension attribute |
| `Date_of_Birth` | Date | Patient date of birth. | Dimension attribute |
| `City` | Text | Patient city/location. | Dimension attribute |
| `Insurance_Type` | Text | Patient insurance/payment category. | Dimension attribute |
| `Registration_Date` | Date | Date the patient registered. | Dimension attribute |

### Key field

`Patient_ID` uniquely identifies a patient and is used to connect patient information with visit and billing activity.

---

## 3. Raw_Doctors

**Grain:** One row per doctor.

| Field | Data Type | Definition | Model Role |
|---|---|---|---|
| `Doctor_ID` | Text | Unique doctor identifier. | Primary Key / Dimension |
| `Doctor_Name` | Text | Doctor name. | Descriptive attribute |
| `Department` | Text | Doctor's department/specialty. | Dimension attribute |
| `Experience_Years` | Integer | Doctor's years of experience. | Dimension attribute |
| `Consultation_Fee` | Number | Standard consultation fee associated with the doctor. | Dimension attribute |

### Key field

`Doctor_ID` uniquely identifies a doctor and is used to analyze visit and billing activity by provider.

---

## 4. Raw_Visits

**Grain:** One row per patient visit/appointment.

| Field | Data Type | Definition | Model Role |
|---|---|---|---|
| `Visit_ID` | Text | Unique visit identifier. | Primary Key / Fact |
| `Patient_ID` | Text | Patient associated with the visit. | Foreign Key |
| `Doctor_ID` | Text | Doctor associated with the visit. | Foreign Key |
| `Visit_Date` | Date | Date of the visit. | Fact / Date relationship |
| `Visit_Type` | Text | Type of visit such as Consultation, Diagnostic, Emergency, or Follow-up. | Fact attribute |
| `Department` | Text | Department associated with the visit. | Fact attribute |
| `Diagnosis` | Text | Recorded diagnosis/reason for visit in the synthetic dataset. | Fact attribute |
| `Appointment_Status` | Text | Appointment outcome: Completed, No Show, or Cancelled. | Fact attribute |
| `Wait_Time_Minutes` | Integer | Patient waiting time in minutes. | Fact measure |
| `Consultation_Fee` | Number | Consultation fee recorded for the visit. | Fact measure |
| `Patient_Satisfaction` | Number | Post-visit patient satisfaction score. | Fact measure |

### Key field

`Visit_ID` uniquely identifies the visit and provides the transactional link to billing.

---

## 5. Raw_Billing

**Grain:** One row per bill.

| Field | Data Type | Definition | Model Role |
|---|---|---|---|
| `Bill_ID` | Text | Unique billing identifier. | Primary Key / Fact |
| `Visit_ID` | Text | Visit associated with the bill. | Foreign Key |
| `Patient_ID` | Text | Patient associated with the bill. | Foreign Key |
| `Bill_Date` | Date | Date of billing. | Fact / Date relationship |
| `Consultation_Amount` | Number | Amount attributed to consultation. | Fact measure |
| `Lab_Amount` | Number | Amount attributed to laboratory services. | Fact measure |
| `Medicine_Amount` | Number | Amount attributed to medicines. | Fact measure |
| `Gross_Amount` | Number | Total amount before discount. | Fact measure |
| `Discount` | Number | Discount applied to the bill. | Fact measure |
| `Net_Revenue` | Number | Source net-revenue value. | Raw financial field |
| `Payment_Mode` | Text | Payment method such as Card, Cash, UPI, or Insurance. | Fact attribute |
| `Payment_Status` | Text | Payment state, such as Paid or Pending. | Fact attribute |

### Clean revenue field

The analytical model uses `Net_Revenue_Clean`, calculated in Power Query as:

```text
Net_Revenue_Clean = Gross_Amount - Validated_Discount
```

where negative discounts are corrected to zero.

---

## 6. Analytical Tables

The cleaned/model layer contains:

### Dimensions

- `Dim_Date`
- `Dim_Patient`
- `Dim_Doctor`

### Facts

- `Fact_Visits`
- `Fact_Billing`

The model is designed around a star-schema approach so dimensions provide descriptive context while fact tables provide transactional measures.

---

## 7. Important Business Fields

| Business Area | Main Fields |
|---|---|
| Patient volume | `Visit_ID`, `Patient_ID` |
| Appointment outcome | `Appointment_Status` |
| Waiting time | `Wait_Time_Minutes` |
| Patient experience | `Patient_Satisfaction` |
| Provider performance | `Doctor_ID`, `Doctor_Name`, `Department` |
| Department performance | `Department` |
| Revenue | `Gross_Amount`, `Discount`, `Net_Revenue_Clean` |
| Payment analysis | `Payment_Mode`, `Payment_Status` |
| Time analysis | `Visit_Date`, `Bill_Date`, `Dim_Date` |

---

## 8. Data Interpretation Notes

- `Patient_Satisfaction` is treated as a 1–5 analytical scale after validation.
- `Wait_Time_Minutes` is treated as a non-negative operational measure after validation.
- `Appointment_Status` is standardized before KPI calculation.
- `Department`, city, insurance, and payment labels are standardized in Power Query.
- Revenue analysis uses the cleaned revenue field rather than blindly trusting the raw revenue value.
- The dataset is synthetic and should not be interpreted as actual hospital performance.
