# retirement-plan-analytics

**[▶ View Live Dashboard](https://htmlpreview.github.io/?https://github.com/divyarajchavda73-cmyk/retirement-plan-analytics/blob/main/retirement_dashboard.html)**

A data analytics project built around retirement plan participant data — defined benefit pensions, 401(k)s, and annuities. Built to match the kind of work an actuarial technology team does: mining large retirement datasets and turning them into dashboards and reporting.

The dataset is synthetic — generated in Python — but modeled on how real multiemployer and public retirement plan records are structured. 12,000 participants across 3 plan types, 5 regions, and 7 industries.

---

## what this project does

Takes raw participant-level retirement data and answers questions like:

- which plan types leave participants on track for retirement vs falling short
- how account balances accumulate across the participant lifecycle
- whether contribution rate is the real lever for retirement readiness
- which plans carry underfunded-status risk
- how assets and readiness vary by region

The dashboard filters by plan type — all KPIs and charts update live.

---

## files

| file | what it is |
|---|---|
| `retirement_data.csv` | raw data — 12,000 rows, 15 columns |
| `retirement_analysis.sql` | SQL analysis in 6 sections |
| `retirement_dashboard.html` | the dashboard — open via the live link above |

---

## SQL sections

1. **Overview** — total participants, assets, contribution rate, funded ratio, readiness
2. **Plan type performance** — core metrics and readiness tier breakdown per plan
3. **Readiness deep dive** — what separates on-track from off-track; contribution-bucket analysis
4. **Regional & industry view** — assets and behavior across geography and sector
5. **Funded status risk** — exposure from plans below 80% funded
6. **Projected shortfall** — composite metric comparing projected income replacement to a 70% target

---

## key findings

- Pension participants are 72% retirement-ready vs 22% for 401(k) and 10% for annuity holders
- The gap exists despite all three plan types sitting near 86% funded
- Driver is structural: account-based plans push longevity risk onto the individual
- Participants contributing under 4% of salary have the worst readiness outcomes (21.5% on track)

---

## the readiness metric

Built from three income sources: projected account drawdown at 4%, defined-benefit accrual where applicable, and a Social Security floor. On Track = ≥70% income replacement; At Risk = 55–70%; Off Track = below 55%.

---

## tech

Python (data generation), SQL (analysis), Chart.js + vanilla JS (dashboard). CSV loads directly into Power BI or Tableau.

---

*Divyarajsinh Chavda · [LinkedIn](https://linkedin.com/in/divyaraj-chavda) · [GitHub](https://github.com/divyarajchavda73-cmyk)*
