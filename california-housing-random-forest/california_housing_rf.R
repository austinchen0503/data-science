#UCLA Extension
#Introduction to Data Science COM SCI X 450.1 Instructor: Daniel D. Gutierrez

#Class Project
#YUN-CHIEH CHEN

# ============================================================
# Step 1: Access the Data Set
# ============================================================

housing <- read.csv("/Users/titan09205030/Desktop/2026 summer extension/introduction to data science/Hw/housing.csv")

dim(housing)
# [1] 20640    10

head(housing)
#   longitude latitude housing_median_age total_rooms total_bedrooms population households median_income
# 1   -122.23    37.88                 41         880            129        322        126        8.3252
# 2   -122.22    37.86                 21        7099           1106       2401       1138        8.3014
# 3   -122.24    37.85                 52        1467            190        496        177        7.2574
# 4   -122.25    37.85                 52        1274            235        558        219        5.6431
# 5   -122.25    37.85                 52        1627            280        565        259        3.8462
# 6   -122.25    37.85                 52         919            213        413        193        4.0368
#   median_house_value ocean_proximity
# 1             452600        NEAR BAY
# 2             358500        NEAR BAY
# 3             352100        NEAR BAY
# 4             341300        NEAR BAY
# 5             342200        NEAR BAY
# 6             269700        NEAR BAY

housing$ocean_proximity <- as.factor(housing$ocean_proximity)
levels(housing$ocean_proximity)
# [1] "<1H OCEAN"  "INLAND"     "ISLAND"     "NEAR BAY"   "NEAR OCEAN"


# ============================================================
# Step 2: EDA and Data Visualization
# ============================================================

# 2a) head() and tail()
head(housing)
tail(housing)
#       longitude latitude housing_median_age total_rooms total_bedrooms population households median_income
# 20635   -121.56    39.27                 28        2332            395       1041        344        3.7125
# 20636   -121.09    39.48                 25        1665            374        845        330        1.5603
# 20637   -121.21    39.49                 18         697            150        356        114        2.5568
# 20638   -121.22    39.43                 17        2254            485       1007        433        1.7000
# 20639   -121.32    39.43                 18        1860            409        741        349        1.8672
# 20640   -121.24    39.37                 16        2785            616       1387        530        2.3886
#       median_house_value ocean_proximity
# 20635             116800          INLAND
# 20636              78100          INLAND
# 20637              77100          INLAND
# 20638              92300          INLAND
# 20639              84700          INLAND
# 20640              89400          INLAND

# 2b) summary()
summary(housing)
#    longitude         latitude     housing_median_age  total_rooms    total_bedrooms     population      households    
#  Min.   :-124.3   Min.   :32.54   Min.   : 1.00      Min.   :    2   Min.   :   1.0   Min.   :    3   Min.   :   1.0  
#  1st Qu.:-121.8   1st Qu.:33.93   1st Qu.:18.00      1st Qu.: 1448   1st Qu.: 296.0   1st Qu.:  787   1st Qu.: 280.0  
#  Median :-118.5   Median :34.26   Median :29.00      Median : 2127   Median : 435.0   Median : 1166   Median : 409.0  
#  Mean   :-119.6   Mean   :35.63   Mean   :28.64      Mean   : 2636   Mean   : 537.9   Mean   : 1425   Mean   : 499.5  
#  3rd Qu.:-118.0   3rd Qu.:37.71   3rd Qu.:37.00      3rd Qu.: 3148   3rd Qu.: 647.0   3rd Qu.: 1725   3rd Qu.: 605.0  
#  Max.   :-114.3   Max.   :41.95   Max.   :52.00      Max.   :39320   Max.   :6445.0   Max.   :35682   Max.   :6082.0  
#                                                                      NAs    :207                                      
#  median_income     median_house_value   ocean_proximity
#  Min.   : 0.4999   Min.   : 14999     <1H OCEAN :9136  
#  1st Qu.: 2.5634   1st Qu.:119600     INLAND    :6551  
#  Median : 3.5348   Median :179700     ISLAND    :   5  
#  Mean   : 3.8707   Mean   :206856     NEAR BAY  :2290  
#  3rd Qu.: 4.7432   3rd Qu.:264725     NEAR OCEAN:2658  
#  Max.   :15.0001   Max.   :500001                      

# Commentary:
# From the summary(), total_bedrooms is the only variable with
# missing values - 207 NAs. I'll need to fill those in with
# imputation before doing anything else with that column.
#
# One thing I noticed: median_house_value tops out at exactly
# 500001, which is suspicious - it's probably not a coincidence.
# This looks like the original census data just capped anything
# over $500k into one bucket instead of recording the real value,
# so that's something to keep in mind when interpreting results
# later.
#
# The numeric variables are also on really different scales -
# total_rooms goes up to almost 40,000 while median_income only
# goes up to 15. That's going to be a problem for a lot of models,
# so I'll need to scale these later in the pipeline.
#
# Also, ocean_proximity is pretty imbalanced - ISLAND only has 5
# observations compared to over 9,000 for <1H OCEAN, so that
# category probably won't contribute much useful signal to the
# model.

# 2c) Correlation analysis
cor(housing[, sapply(housing, is.numeric)], use = "complete.obs")
#                      longitude    latitude housing_median_age total_rooms total_bedrooms   population  households
# longitude           1.00000000 -0.92461611        -0.10935655  0.04548017     0.06960802  0.100270301  0.05651277
# latitude           -0.92461611  1.00000000         0.01189907 -0.03666681    -0.06698283 -0.108997344 -0.07177419
# housing_median_age -0.10935655  0.01189907         1.00000000 -0.36062830    -0.32045104 -0.295787297 -0.30276797
# total_rooms          0.04548017 -0.03666681        -0.36062830  1.00000000     0.93037950  0.857281251  0.91899153
# total_bedrooms       0.06960802 -0.06698283        -0.32045104  0.93037950     1.00000000  0.877746743  0.97972827
# population           0.10027030 -0.10899734        -0.29578730  0.85728125     0.87774674  1.000000000  0.90718590
# households           0.05651277 -0.07177419        -0.30276797  0.91899153     0.97972827  0.907185900  1.00000000
# median_income       -0.01555015 -0.07962632        -0.11827772  0.19788152    -0.00772285  0.005086624  0.01343389
# median_house_value  -0.04539822 -0.14463821         0.10643205  0.13329413     0.04968618 -0.025299732  0.06489355
#                    median_income median_house_value
# longitude           -0.015550150        -0.04539822
# latitude             -0.079626319        -0.14463821
# housing_median_age  -0.118277723         0.10643205
# total_rooms           0.197881519         0.13329413
# total_bedrooms       -0.007722850         0.04968618
# population            0.005086624        -0.02529973
# households            0.013433892         0.06489355
# median_income         1.000000000         0.68835548
# median_house_value    0.688355475         1.00000000

# Commentary:
# median_income has by far the strongest correlation with
# median_house_value (0.688) - everything else is pretty weak,
# mostly under 0.15. This makes sense intuitively - richer areas
# tend to have more expensive houses.
#
# I also see a clear multicollinearity problem: total_rooms,
# total_bedrooms, population, and households are all highly
# correlated with each other (mostly above 0.85-0.98), which makes
# sense since they're all basically measuring "how big is this
# neighborhood." This is exactly why the assignment has us combine
# total_bedrooms and total_rooms with households into
# mean_bedrooms and mean_rooms later - it should cut down on this
# redundancy.
#
# One more thing I noticed: longitude and latitude are strongly
# negatively correlated (-0.925), but that's just because of
# California's geographic shape, not really a data issue.

# 2d) Histograms
numeric_vars <- housing[, sapply(housing, is.numeric)]

par(mfrow = c(3, 3))

for (col_name in names(numeric_vars)) {
  hist(numeric_vars[[col_name]],
       main = col_name,
       xlab = col_name,
       col = "steelblue")
}

par(mfrow = c(1, 1))

# Commentary:
# longitude and latitude are both bimodal, which makes sense given
# California's geography - one cluster is probably the Bay Area,
# the other is LA/Southern California.
#
# total_rooms, total_bedrooms, population, and households are all
# heavily right-skewed - most neighborhoods have relatively small
# values, but a few outliers stretch the tail way out. This lines
# up with what I saw in the correlation matrix - these four are
# highly correlated and clearly measuring similar things.
#
# median_income is also right-skewed, mostly clustered between 2-6
# with a long tail toward higher incomes.
#
# median_house_value is right-skewed too, but there's a weird small
# spike at the very top of the range - this is the censoring effect
# I noticed earlier where anything above $500,000 got capped into
# one bucket instead of being recorded as its actual value.

# 2e) Boxplots
par(mfrow = c(3, 3))

for (col_name in names(numeric_vars)) {
  boxplot(numeric_vars[[col_name]],
          main = col_name,
          col = "steelblue")
}

par(mfrow = c(1, 1))

# Commentary:
# longitude, latitude, and housing_median_age look pretty clean -
# no major outliers, boxes look reasonably normal.
#
# total_rooms, total_bedrooms, population, and households all show
# a ton of outlier points and really compressed boxes - this
# matches what I saw in the histograms, these four variables are
# heavily right-skewed with a handful of extreme values pulling
# the tail way out.
#
# median_income has some outliers on the high end too, but not as
# extreme as the room/population variables.
#
# median_house_value's box looks fairly normal, but there's a
# clear cluster of points stacked right at the top - that's the
# $500,000 censoring effect again, showing up here as a pile-up of
# values at the ceiling instead of a natural spread.

# 2f) Boxplots by ocean_proximity
par(mfrow = c(1, 3))

boxplot(housing_median_age ~ ocean_proximity, data = housing,
        main = "Housing Age by Ocean Proximity",
        col = "steelblue",
        las = 2)

boxplot(median_income ~ ocean_proximity, data = housing,
        main = "Median Income by Ocean Proximity",
        col = "steelblue",
        las = 2)

boxplot(median_house_value ~ ocean_proximity, data = housing,
        main = "Median House Value by Ocean Proximity",
        col = "steelblue",
        las = 2)

par(mfrow = c(1, 1))

# Commentary:
# housing_median_age really depends on ocean_proximity - ISLAND
# and NEAR BAY have the oldest houses (median around 40), and
# INLAND has the newest (median around 25). Makes sense if coastal
# areas were just developed earlier than inland areas.
#
# median_income for ISLAND is kind of meaningless since there's
# only 5 data points there (saw this earlier in summary()). INLAND
# clearly has lower income than the coastal categories - NEAR BAY,
# <1H OCEAN, and NEAR OCEAN all look pretty similar to each other
# and higher than INLAND.
#
# median_house_value is the one that stands out the most though -
# INLAND is way cheaper than everything else, while ISLAND, NEAR
# BAY, and <1H OCEAN are all more expensive. So there's clearly a
# real relationship between distance from the ocean and how
# expensive houses are, which is a good sign that ocean_proximity
# will actually be a useful predictor once I one-hot encode it in
# the next step.


# ============================================================
# Step 3: Data Transformation
# ============================================================

# 3a) Impute missing total_bedrooms values with the median
median_bedrooms <- median(housing$total_bedrooms, na.rm = TRUE)
median_bedrooms
# [1] 435

housing$total_bedrooms[is.na(housing$total_bedrooms)] <- median_bedrooms

sum(is.na(housing$total_bedrooms))
# [1] 0

# 3b) One-hot encode ocean_proximity
ocean_dummies <- model.matrix(~ ocean_proximity - 1, data = housing)
head(ocean_dummies)
#   ocean_proximity<1H OCEAN ocean_proximityINLAND ocean_proximityISLAND ocean_proximityNEAR BAY
# 1                        0                     0                     0                       1
# 2                        0                     0                     0                       1
# 3                        0                     0                     0                       1
# 4                        0                     0                     0                       1
# 5                        0                     0                     0                       1
# 6                        0                     0                     0                       1
#   ocean_proximityNEAR OCEAN
# 1                         0
# 2                         0
# 3                         0
# 4                         0
# 5                         0
# 6                         0

colnames(ocean_dummies) <- sub("ocean_proximity", "", colnames(ocean_dummies))
head(ocean_dummies)
#   <1H OCEAN INLAND ISLAND NEAR BAY NEAR OCEAN
# 1         0      0      0        1          0
# 2         0      0      0        1          0
# 3         0      0      0        1          0
# 4         0      0      0        1          0
# 5         0      0      0        1          0
# 6         0      0      0        1          0

housing <- cbind(housing, ocean_dummies)

housing$ocean_proximity <- NULL

names(housing)
#  [1] "longitude"          "latitude"           "housing_median_age" "total_rooms"        "total_bedrooms"    
#  [6] "population"         "households"         "median_income"      "median_house_value" "<1H OCEAN"         
# [11] "INLAND"             "ISLAND"             "NEAR BAY"           "NEAR OCEAN"        

# 3c) Create mean_bedrooms and mean_rooms; remove raw totals
housing$mean_bedrooms <- housing$total_bedrooms / housing$households
housing$mean_rooms <- housing$total_rooms / housing$households

housing$total_bedrooms <- NULL
housing$total_rooms <- NULL

names(housing)
#  [1] "longitude"          "latitude"           "housing_median_age" "population"         "households"        
#  [6] "median_income"      "median_house_value" "<1H OCEAN"          "INLAND"             "ISLAND"            
# [11] "NEAR BAY"           "NEAR OCEAN"         "mean_bedrooms"      "mean_rooms"        

head(housing[, c("mean_bedrooms", "mean_rooms")])
#   mean_bedrooms mean_rooms
# 1     1.0238095   6.984127
# 2     0.9718805   6.238137
# 3     1.0734463   8.288136
# 4     1.0730594   5.817352
# 5     1.0810811   6.281853
# 6     1.1036269   4.761658

# 3d) Feature scaling
names(housing)

vars_to_scale <- c("longitude", "latitude", "housing_median_age",
                   "population", "households", "median_income",
                   "mean_bedrooms", "mean_rooms")

housing[vars_to_scale] <- scale(housing[vars_to_scale])

summary(housing[vars_to_scale])
#    longitude          latitude       housing_median_age   population        households      median_income    
#  Min.   :-2.3859   Min.   :-1.4475   Min.   :-2.19613   Min.   :-1.2561   Min.   :-1.3040   Min.   :-1.7743  
#  1st Qu.:-1.1132   1st Qu.:-0.7968   1st Qu.:-0.84537   1st Qu.:-0.5638   1st Qu.:-0.5742   1st Qu.:-0.6881  
#  Median : 0.5389   Median :-0.6423   Median : 0.02865   Median :-0.2291   Median :-0.2368   Median :-0.1768  
#  Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.00000   Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.0000  
#  3rd Qu.: 0.7785   3rd Qu.: 0.9729   3rd Qu.: 0.66429   3rd Qu.: 0.2645   3rd Qu.: 0.2758   3rd Qu.: 0.4593  
#  Max.   : 2.6252   Max.   : 2.9580   Max.   : 1.85614   Max.   :30.2496   Max.   :14.6012   Max.   : 5.8581  
#  mean_bedrooms         mean_rooms      
#  Min.   :-1.887103   Min.   :-1.85227  
#  1st Qu.:-0.183730   1st Qu.:-0.39944  
#  Median :-0.100259   Median :-0.08078  
#  Mean   : 0.000000   Mean   : 0.00000  
#  3rd Qu.:-0.001725   3rd Qu.: 0.25195  
#  Max.   :63.498369   Max.   :55.16190  

# Commentary:
# After scaling, all the numeric predictors have mean 0, which
# confirms the scaling worked correctly. But I noticed something
# interesting - population, households, mean_bedrooms, and
# mean_rooms all have really extreme max values (like 63 standard
# deviations for mean_bedrooms). This is basically the outliers I
# saw earlier in the boxplots showing up again - scaling doesn't
# get rid of outliers, it just re-centers everything, so those
# extreme values are still there, just expressed in standard
# deviation units now instead of raw numbers.

# 3e) Final cleaned data frame
cleaned_housing <- housing

names(cleaned_housing)
#  [1] "longitude"          "latitude"           "housing_median_age" "population"         "households"        
#  [6] "median_income"      "median_house_value" "<1H OCEAN"          "INLAND"             "ISLAND"            
# [11] "NEAR BAY"           "NEAR OCEAN"         "mean_bedrooms"      "mean_rooms"        

dim(cleaned_housing)
# [1] 20640    14


# ============================================================
# Step 4: Create Training and Test Sets
# ============================================================

set.seed(8)
n <- nrow(cleaned_housing)
train_index <- sample(1:n, size = 0.7 * n)

train <- cleaned_housing[train_index, ]
test <- cleaned_housing[-train_index, ]

nrow(train)
# [1] 14447
nrow(test)
# [1] 6193


# ============================================================
# Step 5: Supervised Machine Learning - Regression
# ============================================================

train_x <- train[, names(train) != "median_house_value"]
train_y <- train$median_house_value

class(train_x)
# [1] "data.frame"
class(train_y)
# [1] "numeric"

library(randomForest)

set.seed(8)
rf <- randomForest(x = train_x, y = train_y, ntree = 500, importance = TRUE)

rf
# Call:
#  randomForest(x = train_x, y = train_y, ntree = 500, importance = TRUE) 
#                Type of random forest: regression
#                      Number of trees: 500
# No. of variables tried at each split: 4
#           Mean of squared residuals: 2409760778
#                     % Var explained: 81.9


# ============================================================
# Step 6: Evaluating Model Performance
# ============================================================

# 6a) Training set RMSE
length(rf$mse)
# [1] 500

final_mse <- rf$mse[length(rf$mse)]
final_mse
# [1] 2409760778

train_rmse <- sqrt(final_mse)
train_rmse
# [1] 49089.31

# 6b) Predict on the test set
test_x <- test[, names(test) != "median_house_value"]
test_y <- test$median_house_value

predictions <- predict(rf, newdata = test_x)

head(predictions)
#        2        3       14       21       25       26 
# 408737.6 400412.6 187405.9 116582.5 170468.5 122270.4 
head(test_y)
# [1] 358500 352100 191300 147500 132600 107500

# 6c) Test set RMSE
rmse <- function(y_hat, y) {
  return(sqrt(mean((y_hat - y)^2)))
}

test_rmse <- rmse(predictions, test_y)
test_rmse
# [1] 49893.74

# Commentary (6d):
# Train RMSE was about $49,089 and test RMSE was about $49,894 -
# these are really close, only about 1.6% apart. If the model was
# overfit, I'd expect to see the test RMSE be a lot higher than
# train RMSE, since that would mean the model just memorized the
# training data instead of learning patterns that generalize. Since
# both numbers are so similar, this suggests the random forest
# model is generalizing well and isn't overfit - it performs about
# the same on data it hasn't seen before as it does on the data it
# was trained on.

# 6e) Variable importance plot
varImpPlot(rf)

# Commentary (6e):
# median_income is by far the most important variable in both
# metrics, no contest - this matches what I found in the
# correlation analysis earlier (0.688 correlation with
# median_house_value), so it's good to see two different methods
# agree. Location variables (longitude, latitude) and
# housing_median_age also rank fairly high.
#
# Interestingly, most of the one-hot encoded ocean_proximity
# categories rank pretty low in importance, even though I saw a
# clear relationship in the boxplots earlier - except for INLAND,
# which ranks fairly high on IncNodePurity. ISLAND is basically
# useless here, which makes sense since it only had 5 observations
# in the entire dataset, so there's just not enough data for the
# model to learn anything meaningful from it.
#
# If I wanted to simplify the model, I could probably drop ISLAND,
# NEAR BAY, and NEAR OCEAN without losing much predictive power,
# since they contribute very little according to both importance
# metrics.

