# Business Questions & Findings

## Healthcare Operations Analytics

This document translates the healthcare dataset into business questions and summarizes the analytical findings from the cleaned data model and dashboard.

> **Important:** The dataset is synthetic. Findings are portfolio-analysis examples and do not represent the performance of a real healthcare organization.

---

## 1. Business Problem

Hospital management wants to understand:

- Patient and appointment volume
- Appointment completion and no-show behavior
- Cancellation patterns
- Waiting-time performance
- Patient satisfaction
- Doctor performance
- Department performance
- Insurance-level patterns
- Revenue contribution
- Monthly operational trends

The dashboard is designed to help management move from raw operational records to a concise view of performance and areas requiring investigation.

---

# 2. Executive KPI Snapshot

| KPI | Result |
|---|---:|
| Total Visits | 5,000 |
| Completed Visits | 4,755 |
| No Show Rate | 3.0% |
| Cancellation Rate | 1.90% |
| Average Wait Time | ~23.64 minutes |
| Average Satisfaction | ~4.07 / 5 |
| Total Revenue | ₹73,97,250 |
| Unique Patients | 1,174 |
| Revenue per Completed Visit | ~₹1,554 |

---

# 3. Business Question 1 — What is the overall appointment volume and outcome?

### Analysis

There are **5,000 visits** in the dataset.

After standardizing appointment status:

| Appointment Status | Visits | Share |
|---|---:|---:|
| Completed | 4,755 | 95.1% |
| No Show | 150 | 3.0% |
| Cancelled | 95 | 1.9% |
| **Total** | **5,000** | **100%** |

### Finding

The majority of appointments are completed, while no-shows and cancellations represent a smaller but operationally relevant portion of appointment activity.

### Business implication

No-show and cancellation patterns should be monitored because even relatively small percentages can create unused appointment capacity and affect provider utilization.

---

# 4. Business Question 2 — Which departments generate the most revenue?

### Finding

Based on the cleaned revenue model:

| Department | Revenue |
|---|---:|
| Orthopedics | ₹10,48,700 |
| Cardiology | ₹10,31,900 |
| Neurology | ₹9,99,550 |
| Pediatrics | ₹9,87,950 |
| ENT | ₹8,63,050 |
| General Medicine | ₹8,53,800 |
| Gynecology | ₹8,40,200 |
| Dermatology | ₹7,72,000 |

### Finding

**Orthopedics** is the highest-revenue department, followed by **Cardiology**. **Dermatology** has the lowest revenue among the departments in this dataset.

### Business implication

Revenue contribution varies materially across departments. Management could investigate whether differences are driven by visit volume, service mix, consultation fees, or billing composition.

Revenue differences alone should not be interpreted as profitability differences because the dataset does not contain a complete cost model.

---

# 5. Business Question 3 — Which departments have the highest no-show risk?

### Finding

The department-level analysis identifies **Gynecology** as having the highest no-show rate at approximately **3.74%**.

Dermatology has the lowest department no-show rate at approximately **2.35%** in the cleaned analysis.

### Business implication

Gynecology may warrant a deeper investigation into appointment scheduling, reminder effectiveness, lead time, or patient-specific operational factors.

The dataset is descriptive, so it cannot establish why no-shows occur.

---

# 6. Business Question 4 — Which departments have the strongest waiting-time performance?

### Finding

The department analysis shows average completed-visit waiting times broadly around the low-to-mid 20-minute range.

- **General Medicine** has the lowest average wait at approximately **23.04 minutes**.
- **Pediatrics** has the highest average wait at approximately **24.17 minutes**.

### Business implication

The relatively small difference between departments suggests that waiting-time performance is fairly consistent overall, but Pediatrics may be worth monitoring for operational bottlenecks.

Further analysis would be required before deciding on staffing or scheduling changes.

---

# 7. Business Question 5 — Which departments show stronger patient satisfaction?

### Finding

Average satisfaction is consistently high across departments, with values around 4 out of 5.

- **General Medicine** has the strongest average satisfaction at approximately **4.11/5**.
- Dermatology is among the lower-performing departments at approximately **4.02/5**.

### Business implication

Overall satisfaction is positive, but small differences between departments can be used as a starting point for deeper investigation into waiting time, visit type, doctor experience, or patient-service factors.

---

# 8. Business Question 6 — Which doctors contribute the most revenue?

### Top 10 Doctors by Revenue

| Rank | Doctor | Department | Revenue |
|---:|---|---|---:|
| 1 | Dr. Reyansh Rao | Neurology | ₹2,86,400 |
| 2 | Dr. Meera Khan | Neurology | ₹2,77,700 |
| 3 | Dr. Nisha Das | Pediatrics | ₹2,74,200 |
| 4 | Dr. Diya Nair | ENT | ₹2,73,800 |
| 5 | Dr. Rohan Sharma | Pediatrics | ₹2,61,900 |
| 6 | Dr. Vivaan Singh | Neurology | ₹2,43,800 |
| 7 | Dr. Reyansh Joshi | Cardiology | ₹2,39,150 |
| 8 | Dr. Diya Malhotra | Pediatrics | ₹2,34,450 |
| 9 | Dr. Myra Joshi | Gynecology | ₹2,33,600 |
| 10 | Dr. Anaya Mehta | Cardiology | ₹2,30,400 |

### Finding

The highest individual revenue contribution in the dashboard is from **Dr. Reyansh Rao**, followed by **Dr. Meera Khan**.

Neurology and Pediatrics are strongly represented among the top revenue-generating doctors.

### Business implication

Doctor-level revenue can be used alongside completed visits, waiting time, and satisfaction to avoid evaluating provider performance using revenue alone.

---

# 9. Business Question 7 — How does performance change month by month?

### Monthly Visit Trend

| Month | Visits | Completed | Revenue |
|---|---:|---:|---:|
| Jan 2025 | 451 | 435 | ₹6,92,950 |
| Feb 2025 | 408 | 385 | ₹5,91,000 |
| Mar 2025 | 418 | 397 | ₹6,27,050 |
| Apr 2025 | 375 | 356 | ₹5,53,900 |
| May 2025 | 414 | 401 | ₹6,16,100 |
| Jun 2025 | 429 | 398 | ₹6,08,900 |
| Jul 2025 | 418 | 403 | ₹6,13,550 |
| Aug 2025 | 419 | 398 | ₹6,26,850 |
| Sep 2025 | 399 | 381 | ₹5,86,950 |
| Oct 2025 | 429 | 407 | ₹6,42,450 |
| Nov 2025 | 408 | 385 | ₹5,96,100 |
| Dec 2025 | 432 | 409 | ₹6,41,350 |

### Finding

- January has the highest monthly visit volume at **451 visits**.
- April has the lowest monthly visit volume at **375 visits**.
- January also has the highest monthly revenue in the supplied analysis.
- April has the lowest monthly revenue.

### Business implication

Monthly trends can support staffing and capacity planning. Before making operational decisions, management should investigate whether monthly changes are seasonal, scheduling-related, or driven by the synthetic dataset design.

---

# 10. Business Question 8 — How do insurance groups differ?

The insurance segmentation provides another way to compare appointment behavior and patient experience.

| Insurance Type | Visits | Completed | No Shows | No-Show Rate | Avg Satisfaction |
|---|---:|---:|---:|---:|---:|
| Corporate Insurance | 1,224 | 1,171 | 33 | 2.70% | 4.06 |
| Government Scheme | 1,253 | 1,182 | 44 | 3.51% | 4.06 |
| Private Insurance | 1,217 | 1,154 | 42 | 3.45% | 4.09 |
| Self Pay | 1,306 | 1,248 | 31 | 2.37% | 4.10 |

### Finding

Self Pay has the highest visit volume and the lowest no-show rate among the four insurance categories in this analysis.

Government Scheme has the highest no-show rate.

### Business implication

Insurance-level patterns may help management identify segments where appointment adherence differs. However, the analysis does not establish the cause of the differences.

---

# 11. Business Question 9 — Is patient satisfaction generally positive?

### Finding

The overall average satisfaction is approximately **4.07/5** after validation.

This indicates generally positive reported satisfaction within the synthetic dataset.

### Business implication

Satisfaction should be monitored alongside waiting time and appointment outcomes rather than treated as an isolated KPI.

---

# 12. Business Question 10 — How can revenue be interpreted safely?

### Finding

The final cleaned revenue total is **₹73,97,250**.

The project specifically validates the discount field before calculating clean revenue.

### Important limitation

Revenue should not be interpreted as profit. The dataset does not provide a complete cost structure, so the project does not make profitability claims.

---

# 13. Key Management Takeaways

### 1. Appointment completion is strong

Approximately 95% of visits are completed, while no-shows and cancellations account for a smaller share of activity.

### 2. Revenue is concentrated across several departments

Orthopedics and Cardiology are the two highest-revenue departments in the analysis.

### 3. No-show behavior differs by department and insurance segment

Gynecology has the highest department no-show rate, while Government Scheme has the highest insurance-level no-show rate.

### 4. Waiting times are relatively consistent

Department-level averages are all around the low-to-mid 20-minute range, with Pediatrics showing the highest average wait in the analysis.

### 5. Patient satisfaction is generally strong

Average satisfaction is above 4/5 overall.

### 6. Provider revenue should not be evaluated in isolation

The dashboard combines revenue with completed visits, waiting time, and satisfaction so provider performance can be viewed more holistically.

---

# 14. Recommended Follow-Up Analysis

If this were connected to a real healthcare operations environment, the next analytical steps could include:

- Analyze no-shows by lead time and visit type.
- Compare waiting time by hour/day of week.
- Analyze satisfaction against waiting time.
- Compare doctor revenue against completed visit volume.
- Investigate department capacity and appointment utilization.
- Analyze payment-status patterns.
- Identify repeat-patient behavior over time.
- Add cost data to calculate actual profitability.

These are proposed next analyses, not conclusions supported by the current synthetic dataset.

---

# 15. Decision-Support Principle

The dashboard is intended to answer **what is happening** and **where management should investigate further**.

It does not claim to establish causation.

The analytical workflow is therefore:

```text
KPI
 ↓
Pattern
 ↓
Business Question
 ↓
Investigation
 ↓
Validated Explanation
 ↓
Business Action
```
