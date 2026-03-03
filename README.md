🏥 Healthcare Claims Cost & Utilization Analysis

📌 Project Overview

This project analyzes a synthetic healthcare insurance claims dataset to identify key drivers of medical spending across claim types, procedures (CPT), diagnoses (ICD), providers, and members.
The goal is to understand where healthcare dollars are being spent, how efficiently claims are reimbursed, and which members and services contribute disproportionately to overall costs.

🎯 Business Questions Answered

Which claim types are the most expensive?
Which CPT and ICD codes drive the highest spending?
Which members account for the largest share of total healthcare costs?
How do billed amounts compare to paid amounts across services and providers?

🗂 Dataset Description

The dataset contains synthetic healthcare claims data with the following fields:

claim_id
member_id
provider_id
claim_type (Inpatient, Emergency, Outpatient, Lab, Pharmacy)
cpt_code
icd_code
billed_amount
paid_amount
service_date

Total records: 449 claims

🛠 Tools & Technologies

Excel – Data cleaning and quality checks
SQL – Data validation, aggregation, and analysis
Tableau – Interactive dashboards and visual storytelling

🧹 Data Cleaning & Validation
Excel

Standardized date formats
Removed duplicate records
Checked and handled null values

Verified numeric consistency of billed and paid amounts

SQL

Validated total billed vs paid amounts
Verified claim counts and averages
Confirmed aggregation accuracy before visualization

📊 Key Metrics & Calculations

Paid Ratio (%)
Paid Ratio = (Total Paid Amount / Total Billed Amount) × 100

Average Paid per Claim
Average Paid per Claim = Total Paid Amount / Number of Claims

To avoid distortion from rare events:
CPT codes and providers are filtered to ≥ 5 claims

🔍 Key Insights
1️. Claim Type Cost Drivers

Inpatient claims dominate total spending
Highest average paid per claim (~$11K)
Lowest paid ratio (~74%), indicating heavier adjustments and negotiations

2️. CPT Code Analysis

High total spend CPTs include 67890, 23456, 123
Some CPTs are high-cost per occurrence, even with average reimbursement rates
Cost risk comes from procedure price, not overpayment

3️. ICD Code Analysis

Chronic and complex diagnoses (e.g., Hypertension, HIV-related conditions) drive the highest total costs
These conditions are strongly associated with inpatient utilization

4️. High-Cost Members

A small subset of members accounts for a large share of total spending
70–90% of costs for high-cost members come from inpatient services

5️. Billed vs Paid Comparison

Lab and Pharmacy claims have the highest reimbursement efficiency
Inpatient claims show the largest gap between billed and paid amounts
Provider paid ratios vary significantly (~66% to ~92%)

Tableau Dashboards

The Tableau dashboards visualize:

Billed vs Paid Amounts by Claim Type

<img width="1887" height="891" alt="image" src="https://github.com/user-attachments/assets/1091f272-335b-4ef2-90ae-42b4905ae4a5" />

Paid Ratio by Claim Type and Provider

<img width="1821" height="931" alt="image" src="https://github.com/user-attachments/assets/36dad16b-b895-4fff-84f4-890bd63409ca" />

Top CPT & ICD Codes by Cost and CPT Codes with Highest Average Cost per Claim

<img width="1833" height="953" alt="image" src="https://github.com/user-attachments/assets/e0fbefcd-a260-4e3b-8987-7e15a144a724" />

High-Cost Member Analysis

<img width="1833" height="934" alt="image" src="https://github.com/user-attachments/assets/f5aa0fe0-9916-4d84-89c2-2f35dc3b0c99" />

💼 Business Value

This analysis helps healthcare insurers:

Identify high-risk members for early intervention.
Focus utilization controls on inpatient services.
Monitor high-cost procedures for pre-authorization.
Support provider contract optimization.
Improve reimbursement efficiency tracking.

⚠ Assumptions & Limitations

Dataset is synthetic and does not represent real patient data.
Clinical severity and appropriateness are not evaluated.
Rare procedures excluded using a ≥5-claim threshold.

🚀 How to Use This Project

Review the SQL scripts for analysis logic.
Explore Tableau dashboards for interactive insights.
Read the final PDF report for executive-level findings.
