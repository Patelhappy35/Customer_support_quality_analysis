# Customer Support Quality Analysis – Data Analysis Set B

**Student Name:** Happy Patel
**Student ID:** 10853
**Assigned Set:** Set B

## 1. Project Overview

This project analyzes customer support quality using four data analysis tools:

* Excel
* SQL
* Python
* Power BI

### Business Objective

The objective is to analyze customer support resolution performance and service quality across support teams and channels.

### Business Questions

1. Which support team should improve resolution performance?
2. How does service quality vary by channel?

---

## 2. Dataset

Two CSV files are used:

### `tickets.csv`

* `ticket_id` – Ticket identifier
* `month` – Ticket month (Jan, Feb, Mar)
* `team_id` – Support team identifier
* `channel` – Support channel
* `resolution_hours` – Time taken to resolve the ticket
* `satisfaction` – Customer satisfaction score from 1 to 5

### `teams.csv`

* `team_id` – Support team identifier
* `team` – Support team name
* `department` – Department name

### Data Relationship

`teams.team_id` → `tickets.team_id`

One team can have many tickets.

---

## 3. Data Cleaning

The original tickets file contains **13 rows**, including one intentional exact duplicate.

The duplicate record was removed, leaving **12 unique records**.

### Cleaning Rule

* Original records: 13
* Duplicate records removed: 1
* Final clean records: 12

### SLA Rule

A ticket is considered an SLA breach when:

`resolution_hours > 24`

Exactly **24 hours meets the SLA**.

### Breach Flag

`breach_flag = 1` when `resolution_hours > 24`, otherwise `0`.

### SLA Breach Rate

`SLA Breach Rate = Breached Tickets / Total Tickets`

---

## 4. Excel Analysis

Excel workbook:

`excel/analysis.xlsx`

The workbook contains four sheets:

1. **Raw** – Original 13-row ticket data
2. **Lookup** – Team and department lookup data
3. **Clean** – Cleaned 12-row data with department and breach flag
4. **Summary** – Channel breach summary and PivotTable

### Excel Operations

* Removed the exact duplicate.
* Used `XLOOKUP` to retrieve department using `team_id`.
* Created `breach_flag` using:

```excel
=IF(resolution_hours>24,1,0)
```

* Used `COUNTIFS` for channel-wise breach counts.
* Created a PivotTable for average resolution hours by department and month.
* Created a column chart from the PivotTable.

---

## 5. SQL Analysis

### SQL Dialect

**MySQL 8.0**

### SQL Files

* `sql/setup.sql`
* `sql/queries.sql`

### Setup

`setup.sql` creates the `tickets` and `teams` tables, defines keys and the relationship between them, and loads:

* 12 clean ticket records
* 4 team records

The duplicate ticket is excluded during loading.

### Analytical Queries

#### S2a – Average Resolution Time by Department

Joins tickets with teams and calculates average resolution hours by department, ordered from highest to lowest average.

#### S2b – Teams Breaching SLA

Groups tickets by team and returns teams whose average resolution time exceeds 24 hours.

#### S2c – Top Two Channels by Breach Count

Counts tickets with `resolution_hours > 24` and returns the top two channels. Alphabetical order is used to break ties.

### Data Integrity Check

A LEFT JOIN from `teams` to `tickets` is used to verify that every team ID in the fact data matches a lookup record.

Expected unmatched keys: **0**

### SQL Execution Order

1. Run `sql/setup.sql`
2. Run `sql/queries.sql`
3. Save the three query results in `outputs/sql/`

---

## 6. Python Analysis

Python file:

`python/analysis.py`

Libraries used:

* pandas
* matplotlib

### Python Steps

1. Load `tickets.csv` and `teams.csv`.
2. Confirm numeric types for `resolution_hours` and `satisfaction`.
3. Remove the exact duplicate.
4. Merge tickets and teams using a left join on `team_id`.
5. Verify that the merged dataset contains exactly 12 rows.
6. Verify that there are no unmatched departments.
7. Create `breach_flag`.
8. Calculate department-wise ticket count, breach count and SLA breach rate.
9. Identify the team with the highest breach rate.
10. Create a monthly average resolution-hours chart.
11. Export the clean merged data and department summary.

### Python Outputs

* `outputs/clean_data.csv`
* `outputs/python_summary.csv`
* `outputs/python_chart.png`

---

## 7. Power BI Dashboard

Power BI file:

`powerbi/dashboard.pbix`

### Power Query

* Loaded both CSV files.
* Set correct data types.
* Removed the exact duplicate.
* Final ticket count: 12.

### Data Model

Created an active one-to-many relationship:

`teams[team_id]` → `tickets[team_id]`

Filtering direction:

`teams` filters `tickets`.

### DAX Measures

#### Ticket Count

```DAX
Ticket Count = COUNTROWS(tickets)
```

#### Average Satisfaction

```DAX
Avg Satisfaction = AVERAGE(tickets[satisfaction])
```

#### SLA Breach Rate

```DAX
SLA Breach Rate =
DIVIDE(
    COUNTROWS(
        FILTER(
            tickets,
            tickets[resolution_hours] > 24
        )
    ),
    COUNTROWS(tickets),
    0
)
```

The SLA Breach Rate measure is formatted as a percentage.

### Dashboard Elements

The report page contains:

* Ticket Count KPI card
* Average Satisfaction KPI card
* SLA Breach Rate KPI card
* Department-wise comparison chart
* Monthly average resolution-hours trend
* Channel slicer

The channel slicer filters the report visuals simultaneously.

---

## 8. Key Findings

Based on the 12 clean ticket records:

### Finding 1 – SLA Breaches

There are **5 SLA-breached tickets out of 12**, giving an overall SLA breach rate of:

**41.67%**

### Finding 2 – Department Performance

The **Technical department** has:

* 6 total tickets
* 3 breached tickets
* **50.00% SLA breach rate**
* Average resolution time: **27.67 hours**

The Service department has:

* 6 total tickets
* 2 breached tickets
* **33.33% SLA breach rate**
* Average resolution time: **20.00 hours**

### Channel Observation

Breach counts by channel are:

* Email: **0**
* Chat: **3**
* Phone: **2**

---

## 9. Recommendation

Based on the analysis, the support process for the Technical department and high-breach channels should be reviewed to improve SLA resolution performance.

Possible areas for review include resolution workflow, escalation handling and response processes.

### Limitation

The dataset is small and synthetic, containing only 12 unique ticket records. Therefore, the findings should not be treated as a complete representation of real-world customer support performance.

---

## 10. Cross-Tool Reconciliation

The same underlying 12 clean ticket records are used across Excel, SQL, Python and Power BI.

A key aggregate used for reconciliation is the overall SLA breach rate:

* Breached tickets: **5**
* Total tickets: **12**
* SLA breach rate: **41.67%**

This value should reconcile across the four tools, subject to any display rounding.

Another reconciliation is the Technical department average resolution time:

* Technical tickets: 6
* Technical average resolution time: **27.67 hours**

---

## 11. Repository Structure

```text
data-analysis-set-e-YOUR-STUDENT-ID/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── data/
│   └── raw/
│       ├── tickets.csv
│       └── teams.csv
│
├── excel/
│   └── analysis.xlsx
│
├── sql/
│   ├── setup.sql
│   └── queries.sql
│
├── python/
│   └── analysis.py
│
├── powerbi/
│   └── dashboard.pbix
│
└── outputs/
    ├── clean_data.csv
    ├── python_summary.csv
    ├── python_chart.png
    ├── powerbi_dashboard.png
```

---

## 12. How to Run the Project

### SQL

Run in this order:

```text
1. sql/setup.sql
2. sql/queries.sql
```

### Python

Install the required packages:

```bash
pip install -r requirements.txt
```

Run:

```bash
python/python_analysis.py
```

### Excel

Open:

```text
excel/analysis.xlsx
```

### Power BI

Open:

```text
powerbi/dashboard.pbix
```

If the project is cloned to another computer, update the CSV source paths in Power BI and refresh the data.

---

## 13. Requirements

The Python analysis requires:

```text
pandas
matplotlib
```

Other tools required:

* Microsoft Excel
* Power BI Desktop
* MySQL 9.5.0
* Jupyter Notebook
* GitHub

---

## 14. Video Explanation

**Video Duration:** 5–10 minutes

**Video Link:** 

The video demonstrates:

1. Self-introduction, Student ID and Set B
2. Business objective
3. Dataset structure
4. Duplicate removal and validation
5. Excel XLOOKUP, breach flag and PivotTable
6. One SQL query and its result
7. Python merge, assertion and breach flag
8. Python chart output
9. Power BI DAX measure
10. Channel slicer and KPI value
11. Two numerical findings
12. One recommendation
13. One limitation
14. GitHub repository structure

The video is recorded with both face and screen visible throughout.

---

## 15. Video Script

### Introduction

“नमस्ते सर/मैम। मेरा नाम ______ है, मेरी Student ID ______ है और मेरा assigned set Set B है। मेरा project Customer Support Quality Analysis पर है। इसका main objective support team की resolution performance और अलग-अलग channels की service quality को analyze करना है।”

### Dataset and Cleaning

“इस project में tickets और teams नाम की दो CSV files हैं। Tickets file में 13 rows थीं, जिसमें एक exact duplicate था। मैंने duplicate remove करके 12 unique records रखे हैं। SLA breach तब माना गया है जब resolution time 24 hours से ज्यादा हो।”

### Excel

“Excel में मैंने Raw, Lookup, Clean और Summary sheets बनाई हैं। XLOOKUP से department निकाला, IF formula से breach flag बनाया और COUNTIFS तथा PivotTable से summary analysis किया।”

### SQL

“SQL में मैंने teams और tickets tables बनाई हैं और team_id के basis पर relationship बनाया है। इसके बाद department-wise average resolution time, SLA-breaching teams और top two breach channels के लिए analytical queries बनाई हैं।”

### Python

“Python में pandas से data load किया, duplicate remove किया और teams के साथ left merge किया। मैंने 12 rows और zero unmatched departments verify किए। इसके बाद breach flag और department-wise SLA summary calculate करके monthly resolution-hours chart बनाया।”

### Power BI

“Power BI में Power Query से duplicate remove किया और teams तथा tickets के बीच one-to-many relationship बनाया। Dashboard में Ticket Count, Average Satisfaction और SLA Breach Rate के KPI cards, department chart, monthly trend और channel slicer हैं।”

### Findings

“मेरे analysis में 12 tickets में से 5 SLA breaches हैं, यानी overall breach rate 41.67% है। Technical department का breach rate 50% है और उसका average resolution time 27.67 hours है।”

### Recommendation and Limitation

“Recommendation के रूप में high-breach Technical department और channels की resolution process को review करना चाहिए। Limitation यह है कि dataset छोटा और synthetic है, इसलिए इसे complete real-world performance नहीं माना जा सकता।”

### Conclusion

“इस तरह मैंने Excel, SQL, Python और Power BI में same cleaned data का analysis किया और results को cross-check किया। Thank you.”
