ST558 Porject 2 - Analysis on News Channel: world
================
Bridget Knapp and Chien-Lan Hsueh
2022-07-10

This analysis report focuses on new channel: `world`:

``` r
# subset by channel
if(params$channel != "all"){
  df_train_x <- df_train %>% filter(channel == params$channel)
  df_test_x <- df_test %>% filter(channel == params$channel)
}
```

# Summarizations

## News Channel: `world`

In this section, a quick EDA will be done on the **training set** for
news channel `world`:

-   Overlook of the data set
-   Response variable
-   Categorical Predictors
-   Numeric Predictors

### Overlook of the data set

Verify the data sets only has data from `world` channel:

``` r
table(df_train_x$channel, df_train_x$weekday)
```

    ##                
    ##                 sunday monday tuesday wednesday thursday friday saturday
    ##   bus                0      0       0         0        0      0        0
    ##   entertainment      0      0       0         0        0      0        0
    ##   lifestyle          0      0       0         0        0      0        0
    ##   misc               0      0       0         0        0      0        0
    ##   socmed             0      0       0         0        0      0        0
    ##   tech               0      0       0         0        0      0        0
    ##   world            382    912    1093      1115     1121    910      341

``` r
table(df_test_x$channel, df_test_x$weekday)
```

    ##                
    ##                 sunday monday tuesday wednesday thursday friday saturday
    ##   bus                0      0       0         0        0      0        0
    ##   entertainment      0      0       0         0        0      0        0
    ##   lifestyle          0      0       0         0        0      0        0
    ##   misc               0      0       0         0        0      0        0
    ##   socmed             0      0       0         0        0      0        0
    ##   tech               0      0       0         0        0      0        0
    ##   world            185    444     453       450      448    395      178

The tables below give quick summaries of all the numeric and categorical
variables:

``` r
# quick summaries of numeric and categorical variables
skim(df_train_x)
```

|                                                  |            |
|:-------------------------------------------------|:-----------|
| Name                                             | df_train_x |
| Number of rows                                   | 5874       |
| Number of columns                                | 48         |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| factor                                           | 3          |
| numeric                                          | 45         |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | None       |

Data summary

**Variable type: factor**

| skim_variable | n_missing | complete_rate | ordered | n_unique | top_counts                                |
|:--------------|----------:|--------------:|:--------|---------:|:------------------------------------------|
| channel       |         0 |             1 | FALSE   |        1 | wor: 5874, bus: 0, ent: 0, lif: 0         |
| weekday       |         0 |             1 | FALSE   |        7 | thu: 1121, wed: 1115, tue: 1093, mon: 912 |
| is_weekend    |         0 |             1 | FALSE   |        2 | N: 5151, Y: 723                           |

**Variable type: numeric**

| skim_variable                | n_missing | complete_rate |      mean |        sd |    p0 |       p25 |       p50 |       p75 |      p100 | hist  |
|:-----------------------------|----------:|--------------:|----------:|----------:|------:|----------:|----------:|----------:|----------:|:------|
| shares                       |         0 |             1 |   2379.37 |   6873.63 | 35.00 |    823.00 |   1100.00 |   1800.00 | 284700.00 | ▇▁▁▁▁ |
| n_tokens_title               |         0 |             1 |     10.60 |      2.08 |  4.00 |      9.00 |     11.00 |     12.00 |     23.00 | ▁▇▃▁▁ |
| n_tokens_content             |         0 |             1 |    593.13 |    411.08 |  0.00 |    329.00 |    506.00 |    763.75 |   4661.00 | ▇▂▁▁▁ |
| n_unique_tokens              |         0 |             1 |      0.51 |      0.12 |  0.00 |      0.47 |      0.52 |      0.58 |      0.98 | ▁▁▇▂▁ |
| n_non_stop_words             |         0 |             1 |      0.97 |      0.17 |  0.00 |      1.00 |      1.00 |      1.00 |      1.00 | ▁▁▁▁▇ |
| n_non_stop_unique_tokens     |         0 |             1 |      0.67 |      0.15 |  0.00 |      0.63 |      0.68 |      0.74 |      1.00 | ▁▁▁▇▁ |
| num_hrefs                    |         0 |             1 |     10.25 |      9.37 |  0.00 |      5.00 |      8.00 |     13.00 |    161.00 | ▇▁▁▁▁ |
| num_self_hrefs               |         0 |             1 |      2.40 |      2.58 |  0.00 |      1.00 |      2.00 |      3.00 |     38.00 | ▇▁▁▁▁ |
| num_imgs                     |         0 |             1 |      2.82 |      5.15 |  0.00 |      1.00 |      1.00 |      2.00 |    100.00 | ▇▁▁▁▁ |
| num_videos                   |         0 |             1 |      0.55 |      1.54 |  0.00 |      0.00 |      0.00 |      1.00 |     51.00 | ▇▁▁▁▁ |
| average_token_length         |         0 |             1 |      4.68 |      0.87 |  0.00 |      4.65 |      4.82 |      4.98 |      5.84 | ▁▁▁▂▇ |
| num_keywords                 |         0 |             1 |      7.30 |      1.88 |  3.00 |      6.00 |      7.00 |      9.00 |     10.00 | ▂▂▇▃▆ |
| kw_min_min                   |         0 |             1 |     15.50 |     55.72 | -1.00 |     -1.00 |     -1.00 |      4.00 |    217.00 | ▇▁▁▁▁ |
| kw_max_min                   |         0 |             1 |   1032.45 |   2928.56 |  0.00 |    430.00 |    633.00 |    936.50 | 111300.00 | ▇▁▁▁▁ |
| kw_avg_min                   |         0 |             1 |    268.39 |    453.99 | -1.00 |    117.00 |    204.05 |    322.28 |  18687.83 | ▇▁▁▁▁ |
| kw_min_max                   |         0 |             1 |   6796.65 |  18090.11 |  0.00 |      0.00 |   1000.00 |   5000.00 | 208300.00 | ▇▁▁▁▁ |
| kw_max_max                   |         0 |             1 | 786792.37 | 174142.66 |  0.00 | 843300.00 | 843300.00 | 843300.00 | 843300.00 | ▁▁▁▁▇ |
| kw_avg_max                   |         0 |             1 | 228863.69 |  89024.79 |  0.00 | 179584.75 | 221237.50 | 275153.57 | 685260.00 | ▂▇▃▁▁ |
| kw_min_avg                   |         0 |             1 |    834.49 |    847.81 | -1.00 |      0.00 |    837.40 |   1574.54 |   2922.97 | ▇▂▃▃▁ |
| kw_max_avg                   |         0 |             1 |   4764.73 |   4412.57 |  0.00 |   3453.34 |   3585.67 |   4706.46 | 112787.17 | ▇▁▁▁▁ |
| kw_avg_avg                   |         0 |             1 |   2526.00 |    857.36 |  0.00 |   2068.26 |   2403.73 |   2782.21 |  15742.74 | ▇▁▁▁▁ |
| self_reference_min_shares    |         0 |             1 |   2814.89 |  16272.81 |  0.00 |    462.00 |    973.00 |   1800.00 | 690400.00 | ▇▁▁▁▁ |
| self_reference_max_shares    |         0 |             1 |   6335.97 |  30752.96 |  0.00 |    673.00 |   1700.00 |   4500.00 | 690400.00 | ▇▁▁▁▁ |
| self_reference_avg_sharess   |         0 |             1 |   4161.51 |  19255.79 |  0.00 |    656.00 |   1400.00 |   3200.00 | 690400.00 | ▇▁▁▁▁ |
| LDA_00                       |         0 |             1 |      0.07 |      0.10 |  0.02 |      0.03 |      0.03 |      0.04 |      0.82 | ▇▁▁▁▁ |
| LDA_01                       |         0 |             1 |      0.05 |      0.08 |  0.02 |      0.02 |      0.03 |      0.04 |      0.79 | ▇▁▁▁▁ |
| LDA_02                       |         0 |             1 |      0.67 |      0.21 |  0.02 |      0.53 |      0.73 |      0.86 |      0.92 | ▁▂▃▃▇ |
| LDA_03                       |         0 |             1 |      0.07 |      0.11 |  0.02 |      0.03 |      0.03 |      0.04 |      0.82 | ▇▁▁▁▁ |
| LDA_04                       |         0 |             1 |      0.13 |      0.17 |  0.02 |      0.03 |      0.04 |      0.20 |      0.92 | ▇▂▁▁▁ |
| global_subjectivity          |         0 |             1 |      0.40 |      0.11 |  0.00 |      0.36 |      0.41 |      0.47 |      0.95 | ▁▃▇▁▁ |
| global_sentiment_polarity    |         0 |             1 |      0.08 |      0.08 | -0.31 |      0.02 |      0.07 |      0.12 |      0.52 | ▁▃▇▁▁ |
| global_rate_positive_words   |         0 |             1 |      0.03 |      0.01 |  0.00 |      0.02 |      0.03 |      0.04 |      0.11 | ▃▇▂▁▁ |
| global_rate_negative_words   |         0 |             1 |      0.02 |      0.01 |  0.00 |      0.01 |      0.02 |      0.02 |      0.07 | ▆▇▂▁▁ |
| rate_positive_words          |         0 |             1 |      0.62 |      0.19 |  0.00 |      0.54 |      0.64 |      0.74 |      1.00 | ▁▁▅▇▂ |
| rate_negative_words          |         0 |             1 |      0.35 |      0.16 |  0.00 |      0.25 |      0.35 |      0.45 |      1.00 | ▃▇▅▁▁ |
| avg_positive_polarity        |         0 |             1 |      0.32 |      0.09 |  0.00 |      0.28 |      0.33 |      0.38 |      0.87 | ▁▇▆▁▁ |
| min_positive_polarity        |         0 |             1 |      0.09 |      0.06 |  0.00 |      0.05 |      0.10 |      0.10 |      0.80 | ▇▁▁▁▁ |
| max_positive_polarity        |         0 |             1 |      0.70 |      0.24 |  0.00 |      0.50 |      0.70 |      0.90 |      1.00 | ▁▁▇▆▆ |
| avg_negative_polarity        |         0 |             1 |     -0.25 |      0.11 | -1.00 |     -0.31 |     -0.25 |     -0.19 |      0.00 | ▁▁▁▇▃ |
| min_negative_polarity        |         0 |             1 |     -0.56 |      0.28 | -1.00 |     -0.80 |     -0.50 |     -0.40 |      0.00 | ▇▆▇▃▃ |
| max_negative_polarity        |         0 |             1 |     -0.09 |      0.07 | -1.00 |     -0.10 |     -0.10 |     -0.05 |      0.00 | ▁▁▁▁▇ |
| title_subjectivity           |         0 |             1 |      0.24 |      0.31 |  0.00 |      0.00 |      0.03 |      0.45 |      1.00 | ▇▂▂▁▁ |
| title_sentiment_polarity     |         0 |             1 |      0.03 |      0.24 | -1.00 |      0.00 |      0.00 |      0.07 |      1.00 | ▁▁▇▁▁ |
| abs_title_subjectivity       |         0 |             1 |      0.36 |      0.18 |  0.00 |      0.20 |      0.50 |      0.50 |      0.50 | ▂▂▁▁▇ |
| abs_title_sentiment_polarity |         0 |             1 |      0.13 |      0.20 |  0.00 |      0.00 |      0.00 |      0.20 |      1.00 | ▇▁▁▁▁ |

### Response Variable

Next, let’s learn more about our response variable: `shares` with a
5-number summary. With a histogram, we can visually see it’s
distribution and determine if it is symmetric, skewed left, or skewed
right.

``` r
# 5-number summary on shares
summary(df_train_x$shares)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##      35     823    1100    2379    1800  284700

``` r
# histogram on shares
df_train_x %>% 
  ggplot(aes(x = shares)) + 
  geom_histogram(binwidth = 1000) +
  coord_cartesian(xlim = c(0, 100000)) +
  labs(
    title = paste0("Histogram: Distribution of Shares for News Channel ", params$channel),
    x="Shares",
    y="Frequency")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/histogram-1.png)<!-- -->

### Categorical Predictors

Despite the `channel` variable, there are two categorical variables
`weekday`, `is_weekend`. A one-way contigency table shows how many
articles were published on each weekday.

``` r
df_train_x %>% 
  select(weekday, is_weekend) %>% 
  summary()
```

    ##       weekday     is_weekend
    ##  sunday   : 382   N:5151    
    ##  monday   : 912   Y: 723    
    ##  tuesday  :1093             
    ##  wednesday:1115             
    ##  thursday :1121             
    ##  friday   : 910             
    ##  saturday : 341

The following side-by-side box plots help us visualize the distributions
of `shares` on each weekday.

``` r
df_train_x %>% 
  ggplot(aes(weekday, shares)) +
  geom_boxplot() +
  scale_y_log10() +
  geom_jitter(width = 0.05) +
  labs(
    title = paste0("Boxplots: Distribution of Shares in News Channel ", params$channel, " for Each Weekday"),
    x = "Weekday")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/boxplot-1.png)<!-- -->

### Numeric Predictors

We have 45 numeric variables. To further investigate the relationship
among these numeric variables, we check their correlation by making
pair-wise correlation plots.

``` r
ggcorrplot(
  cor(select_if(df_train_x, is.numeric), use = "complete.obs"), 
  hc.order = TRUE, 
  type = "lower",
  tl.cex = 6,
  title = paste0("Correlation Plot for News Channel ", params$channel))
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/cor-1.png)<!-- -->

Below, we use scatter plots to inspect the relationship between the
response variable `shares` and various numeric variables in related
groups:

-   `shares` vs. token-related variables
-   `shares` vs. numbers of links, keyword, images, videos
-   `shares` vs. keyword-related metrics
-   `shares` vs. tone polarity metrics
-   `shares` vs. title-related metrics

#### `shares` vs. Token-related Variables

``` r
# scatter plots: shares vs. token-related variables
df_train_x %>% 
  select(shares, starts_with("n_"), contains("token")) %>% 
  pivot_longer(
    cols = -c(shares),
    names_to = "token_metric",
    values_to = "number_of_tokens") %>% 
  ggplot(aes(number_of_tokens, shares)) +
  geom_point() +
  facet_wrap(vars(token_metric), scales = "free") +
  ggtitle("Shares vs. Token-related Variables")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/scatter1-1.png)<!-- -->

#### `shares` vs. numbers of links, keywords, images and videos

``` r
# scatter plots: shares vs. numbers of links, keywords, images and videos
df_train_x %>% 
  select(shares, starts_with("num_"), starts_with("self_reference")) %>% 
  pivot_longer(
    cols = -c(shares),
    names_to = "number_metric",
    values_to = "number_of_links_keywords_images_videos") %>% 
  ggplot(aes(number_of_links_keywords_images_videos, shares)) +
  geom_point() +
  facet_wrap(vars(number_metric), scales = "free") +
  ggtitle("Shares vs. Numbers of Links, Keywords, Images and Videos")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/scatter2-1.png)<!-- -->

#### `shares` vs. Keyword-related Metrics

``` r
# scatter plots: shares vs. numbers of links, keywords, images and videos
df_train_x %>% 
  select(shares, starts_with("kw_")) %>% 
  pivot_longer(
    cols = -c(shares),
    names_to = "number_metric",
    values_to = "keyword_related_metric") %>% 
  ggplot(aes(keyword_related_metric, shares)) +
  geom_point() +
  facet_wrap(vars(number_metric), scales = "free") +
  ggtitle("Shares vs. Keyword-related Metrics")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/scatter3-1.png)<!-- -->

#### `shares` vs. Word Polarity Metrics

``` r
# scatter plots: shares vs. numbers of links, keywords, images and videos
df_train_x %>% 
  select(
    shares, 
    contains("subjectivity"), 
    contains("polarity"), 
    contains("positive"), 
    contains("negative"),
    -contains("title")) %>% 
  pivot_longer(
    cols = -c(shares),
    names_to = "number_metric",
    values_to = "tone_polarity") %>% 
  ggplot(aes(tone_polarity, shares)) +
  geom_point() +
  facet_wrap(vars(number_metric), scales = "free") +
  ggtitle("Shares vs. Word Polarity Metrics")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/scatter4-1.png)<!-- -->

#### `shares` vs. Title-related Metrics

``` r
# scatter plots: shares vs. numbers of links, keywords, images and videos
df_train_x %>% 
  select(shares, contains("title")) %>% 
  pivot_longer(
    cols = -c(shares),
    names_to = "number_metric",
    values_to = "title_related_metric") %>% 
  ggplot(aes(title_related_metric, shares)) +
  geom_point() +
  facet_wrap(vars(number_metric), scales = "free") +
  ggtitle("Shares vs. Title-related Metrics")
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/world/scatter5-1.png)<!-- -->

# Modeling

## Modeling Formula

In this project, we model the response `shares` using supervised
learning including linear regression, random forests and boosted tree
models. Based on the EDA, we decide to use the following subsets of
predictors in each learning method:

-   Model A: `shares` \~ `weekday` (categorical) + numbers of various
    tokens, words, links, images and video (numeric)
-   Model B: `shares` \~ `is_weekend` (categorical) + all numeric
    predictors (numeric)

``` r
# Model A: `weekday` (categorical) + selected numeric predictors
vars_A <- c(1, 3, 5:15)
names(df_train_x)[vars_A]
```

    ##  [1] "shares"                   "weekday"                  "n_tokens_title"           "n_tokens_content"        
    ##  [5] "n_unique_tokens"          "n_non_stop_words"         "n_non_stop_unique_tokens" "num_hrefs"               
    ##  [9] "num_self_hrefs"           "num_imgs"                 "num_videos"               "average_token_length"    
    ## [13] "num_keywords"

``` r
# Model B: `is_weekend` (categorical) + all numeric predictors
vars_B <- c(1, 4, 5:48)
names(df_train_x)[vars_B]
```

    ##  [1] "shares"                       "is_weekend"                   "n_tokens_title"               "n_tokens_content"            
    ##  [5] "n_unique_tokens"              "n_non_stop_words"             "n_non_stop_unique_tokens"     "num_hrefs"                   
    ##  [9] "num_self_hrefs"               "num_imgs"                     "num_videos"                   "average_token_length"        
    ## [13] "num_keywords"                 "kw_min_min"                   "kw_max_min"                   "kw_avg_min"                  
    ## [17] "kw_min_max"                   "kw_max_max"                   "kw_avg_max"                   "kw_min_avg"                  
    ## [21] "kw_max_avg"                   "kw_avg_avg"                   "self_reference_min_shares"    "self_reference_max_shares"   
    ## [25] "self_reference_avg_sharess"   "LDA_00"                       "LDA_01"                       "LDA_02"                      
    ## [29] "LDA_03"                       "LDA_04"                       "global_subjectivity"          "global_sentiment_polarity"   
    ## [33] "global_rate_positive_words"   "global_rate_negative_words"   "rate_positive_words"          "rate_negative_words"         
    ## [37] "avg_positive_polarity"        "min_positive_polarity"        "max_positive_polarity"        "avg_negative_polarity"       
    ## [41] "min_negative_polarity"        "max_negative_polarity"        "title_subjectivity"           "title_sentiment_polarity"    
    ## [45] "abs_title_subjectivity"       "abs_title_sentiment_polarity"

The learning methods we use in this project include linger regression,
random forests and boosted tree models. For each, we will use a 5-fold
cross validation without repeats (for computational ease) to choose the
best model. By default in `caret package`, the metric is RMSE.

### Linear Regression Model

A linear regression models the relationship between a response and
predictors with a linear predictor functions. The model parameters are
estimated from the data by minimizing a loss function. One of the common
loss function is root mean squared error (RMSE) which is the standard
deviation of the prediction errors (residuals).

We fit both model A and B using the training data and compare their
performance on the training set using 5-fold cross-validation. The best
model is then used to predict on the test set to evaluate the model
performance.

``` r
# linear regression models

# Model A: `weekday` (categorical) + selected numeric predictors
fit_lm_A <- fit_model(
  shares ~ ., df_train_x[, vars_A], df_test_x[, vars_A], method = "lm",
  trControl = trainControl(method = "cv", number = 5))
```

    ##    user  system elapsed 
    ##    0.52    0.04    0.96 
    ## [1] "No tuning parameter"
    ## [1] "Performance metrics:"
    ##         RMSE     Rsquared          MAE 
    ## 3.697256e+03 2.424664e-02 1.787926e+03

``` r
# Model B: `is_weekend` (categorical) + all numeric predictors
fit_lm_B <- fit_model(
  shares ~ ., df_train_x[, vars_B], df_test_x[, vars_B], method = "lm",
  trControl = trainControl(method = "cv", number = 5))
```

    ##    user  system elapsed 
    ##    0.92    0.01    0.94 
    ## [1] "No tuning parameter"
    ## [1] "Performance metrics:"
    ##         RMSE     Rsquared          MAE 
    ## 3.674696e+03 3.954691e-02 1.801379e+03

### Random Forests Model

Random forests is also known as random decision forests model. It is an
ensemble method based on decision trees. It uses bagging to create
multiple trees from bootstrap samples and aggregate the results to make
decisions. However, instead of all predictors, only a subset of the
predictors are used to grow trees. This effectively prevents highly
correlated trees if there exists a strong predictor. Again, 5-fold cross
validation is used to choose the best model.

``` r
# random forest models
# Model A: `weekday` (categorical) + selected numeric predictors
fit_rf_A <- fit_model(
  shares ~ ., df_train_x[, vars_A], df_test_x[, vars_A], method = "rf",
  trControl = trainControl(method = "cv", number = 5))
```

    ##    user  system elapsed 
    ##  356.50    0.81  357.36 
    ## [1] "No tuning parameter"
    ## [1] "Performance metrics:"
    ##         RMSE     Rsquared          MAE 
    ## 3.728444e+03 2.793491e-02 1.774997e+03

``` r
# Model B: `is_weekend` (categorical) + all numeric predictors
fit_rf_B <- fit_model(
  shares ~ ., df_train_x[, vars_B], df_test_x[, vars_B], method = "rf",
  trControl = trainControl(method = "cv", number = 5))
```

    ##    user  system elapsed 
    ##  991.83    0.86  993.34 
    ## [1] "No tuning parameter"
    ## [1] "Performance metrics:"
    ##         RMSE     Rsquared          MAE 
    ## 3.612659e+03 6.329568e-02 1.759654e+03

### Boosted Tree Model

Last, we try boosted tree models in which trees are grown sequentially.
Each subsequent tree is grown on a modified version of the original tree
and thus the prediction is updated as the tree grown. We use 5-fold
cross validation to determine the best parameters:

-   `n.trees`: total number of trees to fit
-   `interaction.depth`: maximum depth of each tree
-   `shrinkage`: learning rate (set to 0.1)
-   `n.minobsinnode`: minimum number of observations in the terminal
    nodes (set to 10)

``` r
# boosted tree models

# Model A: `weekday` (categorical) + selected numeric predictors
fit_boosted_A <- fit_model(
  shares ~ ., df_train_x[, vars_A], df_test_x[, vars_A], method = "gbm",
  trControl = trainControl(method = "cv", number = 5),
  tuneGrid = expand.grid(
    n.trees = seq(5, 200, 5),
    interaction.depth = 1:4,
    shrinkage = 0.1,
    n.minobsinnode = 10),
  verbose = FALSE)
```

    ##    user  system elapsed 
    ##    9.30    0.13    9.55 
    ## [1] "The best tune is found with:"
    ##  n.trees = 140
    ##  interaction.depth = 1
    ##  shrinkage = 0.1
    ##  n.minobsinnode = 10
    ## [1] "Performance metrics:"
    ##         RMSE     Rsquared          MAE 
    ## 3.738883e+03 1.609579e-02 1.754122e+03

``` r
# Model B: `is_weekend` (categorical) + all numeric predictors
fit_boosted_B <- fit_model(
  shares ~ ., df_train_x[, vars_B], df_test_x[, vars_B], method = "gbm",
  trControl = trainControl(method = "cv", number = 5),
  tuneGrid = expand.grid(
    n.trees = seq(5, 200, 5),
    interaction.depth = 1:4,
    shrinkage = 0.1,
    n.minobsinnode = 10),
  verbose = FALSE)
```

    ##    user  system elapsed 
    ##   22.71    0.18   23.02 
    ## [1] "The best tune is found with:"
    ##  n.trees = 10
    ##  interaction.depth = 1
    ##  shrinkage = 0.1
    ##  n.minobsinnode = 10
    ## [1] "Performance metrics:"
    ##         RMSE     Rsquared          MAE 
    ## 3.651708e+03 3.414571e-02 1.752689e+03

## Comparison

We use RMSE to compare the model performance on the test set:

``` r
df_comparison <- tibble(
    Linear_Regression = c(fit_lm_A["RMSE"], fit_lm_B["RMSE"]),
    #Random_Forests = c(fit_rf_A["RMSE"], fit_rf_B["RMSE"]),
    Boosted_Tree = c(fit_boosted_A["RMSE"], fit_boosted_B["RMSE"])
  ) %>%
  bind_cols(model = c("A: shares ~ weekday + selected numeric vars", "B: shares ~ is_weekend + all numeric vars")) %>%
  pivot_longer(
    cols = !model,
    names_to = "learning_method",
    values_to = "RMSE"
  ) %>%
  mutate(
    datetime = now(),
    channel = params$channel
  ) %>%
  relocate(datetime, channel) %>%
  arrange(RMSE)

df_comparison[, -1]
```

    ## # A tibble: 4 × 4
    ##   channel model                                       learning_method    RMSE
    ##   <chr>   <chr>                                       <chr>             <dbl>
    ## 1 world   B: shares ~ is_weekend + all numeric vars   Boosted_Tree      3652.
    ## 2 world   B: shares ~ is_weekend + all numeric vars   Linear_Regression 3675.
    ## 3 world   A: shares ~ weekday + selected numeric vars Linear_Regression 3697.
    ## 4 world   A: shares ~ weekday + selected numeric vars Boosted_Tree      3739.

For the news data in `world` category, we found that the model
`B: shares ~ is_weekend + all numeric vars` using supervised learning
method `Boosted_Tree` has the lowest RMSE of 3651.7080163.

``` r
# save the results
write_csv(
  df_comparison, 
  here("output", "learnings.csv"), 
  append = T)
```
