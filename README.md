# retirement-plan-analytics

A data analytics project built around retirement plan participant data  defined benefit pensions, 401(k)s, and annuities. I built this to match the kind of work an actuarial technology team does: mining large retirement datasets and turning them into dashboards and reporting.

The dataset is synthetic  I generated it in Python  but it's modeled on how real multiemployer and public retirement plan records are structured. 12,000 participants across 3 plan types, 5 regions, and 7 industries.

----

## what this project does

Takes raw participant-level retirement data and answers questions like:

- which plan types leave participants on track for retirement vs falling short
- how much account balances accumulate across the participant lifecycle
- whether contribution rate is the real lever for retirement readiness
- which plans carry underfunded-status risk
- how assets and readiness vary by region

The dashboard lets you filter by plan type so the KPIs and charts update live.

---

## files

| file | what it is |
|---|---|
| `retirement_data.csv` | the raw data  12,000 rows, 15 columns |
| `retirement_analysis.sql` | all the SQL queries, in 6 sections |
| `retirement_dashboard.html` | the dashboard  just open it in a browser |

---

## running it

For the dashboard: double-click `retirement_dashboard.html`. It opens in any browser, no install or server needed.

For the SQL queries (using SQLite):

```bash
sqlite3 retirement.db
.mode csv
.import retirement_data.csv retirement_data
.read retirement_analysis.sql
```

The same queries also run in DuckDB or any standard SQL engine. The CSV column names are clean, so it also loads straight into Power BI or Tableau.

---

## SQL sections (retirement_analysis.sql)

Written in the order I'd actually investigate the data:

1. **overview**  total participants, assets, contribution rate, funded ratio, readiness
2. **plan type performance**  core metrics and the readiness tier breakdown per plan
3. **readiness deep dive**  what separates on-track from off-track, and a contribution-bucket cut
4. **regional & industry view**  assets and behavior across geography and sector
5. **funded status risk**  exposure from plans below 80% funded
6. **projected shortfall**  a composite metric comparing projected income replacement to a 70% target

---

## what the data shows

- Defined benefit pension participants are 72% retirement-ready, versus 22% for 401(k) and only 10% for annuity holders — a large gap despite all three sitting near 86% funded.
- The driver is structural: account-based plans (401k, annuity) push longevity and market risk onto the individual, while DB pensions guarantee income.
- Contribution rate matters, but it isn't a clean straight line — the under-4% group is clearly the worst off, while the middle buckets do well partly because pension participants cluster there.
- Account balances rise steadily with age band, from about $41k (22-30) to $67k (71-80) median.
- Assets are fairly even across regions, with the West holding the most.

---

## the readiness metric

The readiness tier (On Track / At Risk / Off Track) is based on projected income replacement at retirement. I combined three income sources: projected account drawdown at 4%, defined-benefit accrual where applicable, and a Social Security floor. On Track means projected replacement is at or above 70% of pre-retirement salary; At Risk is 55-70%; Off Track is below 55%.

---

## tech

Python for data generation, SQL for analysis, Chart.js and plain JavaScript for the dashboard. The CSV is clean enough to rebuild the same dashboard in Power BI or Tableau.

---

## what I'd add with more time

- a Power BI version of the dashboard with DAX measures (in progress)
- month-over-month contribution trend tracking
- a participant-level shortfall flag based on age, tenure, and contribution rate
- sensitivity analysis on the 4% drawdown assumption

---

*Divyarajsinh Chavda*
