# Diabetes Progression: Regression Model Comparison

Comparing linear regression, k-nearest neighbors, and LASSO on scikit-learn's
diabetes dataset, with a focus on honest hyperparameter selection.

## Problem

Given ten baseline measurements taken from a diabetes patient, how well can we
predict how much their disease progresses over the following year? And does a
more flexible model (KNN) or a regularized one (LASSO) beat plain linear
regression on data this small?

## Data

442 patients, 10 features: age, sex, BMI, average blood pressure, and six blood
serum measurements (total cholesterol, LDL, HDL, total/HDL ratio, log
triglycerides, blood glucose). Target is a quantitative measure of disease
progression one year after baseline. All features are already mean-centered and
scaled, so no further standardization was needed. Split 80/20 (353 train / 89
test), `random_state=42`.

## Approach

- Scatter plots and correlation coefficients for all 10 features against the
  target, to see which ones carry signal on their own
- Four models, all scored on the same held-out test set:
  1. Linear regression on `bmi` alone (the most correlated single feature)
  2. Linear regression on all 10 features
  3. KNN regression, with `k` chosen by 5-fold cross-validation
  4. LASSO, with `alpha` chosen by 5-fold cross-validation (`LassoCV`)
- **Every hyperparameter is selected by cross-validation on the training set
  only.** The test set is touched once, at the end. Choosing `alpha` by looking
  at test R² — which is tempting, since the sweep is right there — would leak
  the test set into model selection and make the reported score optimistic.

## Results

| Model | Test MSE | Test RMSE | Test R² | Train R² | Features |
|---|---|---|---|---|---|
| Linear (bmi only) | 4061.8 | 63.7 | 0.233 | 0.366 | 1 |
| Linear (all 10) | 2900.2 | 53.9 | 0.453 | 0.528 | 10 |
| KNN (k=18) | 3083.9 | 55.5 | 0.418 | 0.501 | 10 |
| LASSO (alpha=0.0775, CV) | **2800.4** | **52.9** | **0.471** | 0.519 | **7** |

The test target has a standard deviation of 73.2, which is the error you would
get by predicting the mean for everyone. The best model's RMSE of 52.9 is about
72% of that, so roughly a quarter of the uncertainty in progression is explained
by these ten baseline measurements. That is a real improvement, but it is nowhere
near enough to use on an individual patient.

## Key Findings

**LASSO wins on both accuracy and simplicity.** It gets the best test R² while
dropping three features (`age`, `s2`, `s4`) entirely. The gap between train R²
(0.528) and test R² (0.453) for unregularized linear regression shows mild
overfitting, and shrinking the coefficients is what closes part of it.

**KNN loses to linear regression here.** With 353 training points spread over 10
dimensions, "nearest" neighbors aren't actually very near, so the local average
KNN relies on gets noisy. The CV curve picks `k=18` — heavy smoothing — which is
itself a sign the data is too sparse for a local method. As a sanity check: at
`k` equal to the full training set, KNN predicts the global mean and R² goes to 0.

**A zeroed coefficient does not mean the feature is medically irrelevant.** `s1`
through `s4` are all cholesterol measurements, and `s4` is the total/HDL ratio —
computed from `s1` and `s3`, so redundant by construction. When features are
this collinear, LASSO keeps one of the group and drops the rest, because paying
the penalty twice buys almost no extra information. Dropping `s2` (LDL) says LDL
adds nothing *given the other serum measurements*, not that LDL is unrelated to
diabetes.

**Which collinear feature survives is unstable.** Change the train/test split
and a different cholesterol variable can be the one kept. So this feature
selection should be read as a statement about the model, not a claim about which
variables matter clinically.

## Tools

Python, scikit-learn (LinearRegression, KNeighborsRegressor, Lasso, LassoCV,
cross_val_score), pandas, numpy, matplotlib

See [`diabetes_regression.ipynb`](./diabetes_regression.ipynb) for the full
analysis, including the LASSO coefficient path and the alpha sweep.
