# Data Science Portfolio

Hi, I'm Austin. I have a background in Geography (GIS) from National Taiwan
University and am currently building a stronger foundation in data science
through UCLA Extension, working toward an MSDS application (Fall 2027).

My current focus is statistical modeling, machine learning, and working with
large and spatial datasets.

👉 **Start here:** [Air Pollution Prediction](./air-pollution-prediction) — my
final project, combining regression modeling with a spatial perspective from my
GIS background.

---

## Featured Project

### 🌍 [Air Pollution Prediction — NO₂ AQI](./air-pollution-prediction)

Predicted NO₂ Air Quality Index from co-pollutant readings (O₃, SO₂, CO) across
73,516 station-days in four states (EPA data, 2010–2015). Used a **time-based**
train/test split rather than a random one to avoid leakage between adjacent days,
then tested whether adding geographic location improves prediction.

It does — R² rose from 0.408 (pollutants only) to 0.550 (Random Forest + state) —
but the gain concentrated almost entirely in California rather than spreading
evenly across states. CO AQI dominated feature importance at roughly 75%.

**Skills:** regression, Random Forest, time-aware validation, residual analysis,
feature importance

---

## Other Projects

### 🏠 [California Housing: Random Forest (R)](./california-housing-random-forest)

Regression analysis of California housing prices using Random Forest in R, with
a written report covering model selection and interpretation.

**Skills:** R, Random Forest, regression, model evaluation

### 🎯 [Logistic Regression: Customer Churn](./logistic-regression-churn)

Logistic regression model predicting customer churn with scikit-learn. Includes
one-hot encoding, train/test split, coefficient interpretation, and evaluation
via accuracy and ROC/AUC.

**Skills:** scikit-learn, logistic regression, classification metrics, feature encoding

### 📊 [EDA: Online Learning Platform](./eda-online-learning)

Exploratory analysis of a 500-student online learning dataset — missing-value
handling, univariate and bivariate analysis, and visualization to identify what
drives student performance.

**Skills:** pandas, seaborn, matplotlib, data cleaning, groupby analysis

### 🔤 [Introduction to Data Science (R)](./intro-data-science-r)

Parallel coursework covering core data science workflows in R — SQL querying,
data reshaping, grouped operations, and visualization — complementing the
Python-focused work in my main program.

**Skills:** R, sqldf, dplyr, data reshaping, data visualization

---

## GIS Background — NTU Coursework

### 🗺️ [Taiwan Air Quality Analysis](./taiwan-air-quality)

GIS programming coursework at National Taiwan University — nearest-station
spatial search, SQL analysis against a SQLite database, and geospatial
visualization (geopandas/folium) of monitoring data. Includes a custom `AirObj`
class in `MyLib.py`. Directly connects to my current EPA pollution work.

**Skills:** Python, SQL, geopandas, folium, object-oriented programming

### 📐 [Spatial Analysis (R)](./spatial-analysis-r)

Formal spatial statistics — distance calculations, population-weighted centroids,
and point pattern analysis (Quadrat Analysis with chi-square testing for spatial
clustering) — using R's `sf` and `spatstat`.

**Skills:** R, sf, spatstat, spatial statistics, hypothesis testing

### 📈 [Social Statistics (Stata)](./social-statistics-stata)

Statistical inference — confidence intervals, one-sample and two-sample
hypothesis testing — using Stata on the Taiwan Social Change Survey.

**Skills:** Stata, statistical inference, hypothesis testing, confidence intervals

---

## Setup

```bash
pip install -r requirements.txt
```

R projects additionally require: `sf`, `spatstat`, `dplyr`, `sqldf`, `randomForest`

---

## Background

B.A. in Geography (GIS focus), National Taiwan University. Currently studying
data science, Python, SQL, and machine learning fundamentals.
