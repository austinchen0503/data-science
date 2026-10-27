# Reservoir Water Quality Database (NTU Coursework)

Coursework from **Programming for Geographic Data Science**, Department of Geography,
National Taiwan University (Spring 2023).

Taiwan's reservoir water quality readings are loaded into SQLite, each record flagged for
completeness, and three questions answered in SQL.

## Contents

- **`water_quality_sql.ipynb`** — the whole project: loader, data profile, and the three
  queries, with outputs saved so the notebook reads without being run.
- **`reservoir_water_quality.csv`** — the data. 5,775 readings from 85 monitoring stations
  across 26 reservoirs, 25 parameters, sampled 2026-01-06 to 2026-07-01.

## The three questions

- `warning_site(ItemEng, threshold)` — stations whose reading for a parameter exceeds a
  threshold.
- `query_wq(Site, ItemEng)` — station count, parameter name, mean (3 dp) and unit for one
  reservoir. The mean is `None` when nothing was recorded, while the station count and
  unit still report.
- `check_data(Site, ItemEng)` — the share of a reservoir's stations with no reading at all
  for that parameter, between 0 and 1.

## How it works

Readings arrive as text. `'-'` means not recorded and is stored as `NULL`; a `'<'` prefix
(as in `'<4.0'`, below the detection limit) is stripped and the value stored as a number.
Each row carries a `chk` flag — `'T'` when a value was recorded, `'F'` when not — so
completeness is queryable rather than inferred.

The questions are answered in SQL rather than by pulling the table into Python:

```sql
-- stations with no reading at all, counted as stations rather than rows
SELECT COUNT(DISTINCT sitename),
       COUNT(DISTINCT sitename)
       - COUNT(DISTINCT CASE WHEN chk = 'T' THEN sitename END)
FROM Flow
WHERE damname = ? AND itemengabbreviation = ?
```

A station can be sampled more than once for the same parameter, so counting rows would
overstate the missing share. `COUNT` ignores the `NULL` that `CASE WHEN` returns when its
condition fails, which makes the subtraction count stations.

The division that turns those two numbers into a share is done in Python: in SQLite,
`SUM(...) / COUNT(...)` on two integers is integer division and returns 0 for every
reservoir.

## Running it

```bash
pip install jupyter
jupyter notebook water_quality_sql.ipynb
```

No API key and no network access needed — the notebook reads the bundled CSV and builds
`WQ.db` locally. `WQ.db` is rebuilt on every run and is not tracked here.

## Notes

The assignment specified the database and table names, the method signatures and the
cleaning rules for `'-'` and `'<'`. The SQL, the data model and the handling of the edge
cases above are my own.

The original assignment read this dataset from an API on `data.epa.gov.tw`. That platform
moved to `data.moenv.gov.tw` when the Environmental Protection Administration was
reorganised into the Ministry of Environment in 2023, so this version reads a downloaded
snapshot instead — which also means the notebook runs without a key and its outputs stay
reproducible.
