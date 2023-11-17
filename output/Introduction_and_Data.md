ST558 Porject 2 - Introduction and Data
================
Bridget Knapp and Chien-Lan Hsueh
2022-07-10

# Introduction

## Online News Popularity

In this project, we study the [Online News Popularity Data
Set](https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity) and
model the number of shares of a new articles by the attributes including

-   Type, or channel, of news (Lifestyle, Entertainment, Business,
    Social Media, Tech, or World)
-   Number of links, images, and videos
-   Minimum, maximum, and average number of shares for the worst, best,
    and average keyword
-   When the article was published (Monday, Tuesday, Wednesday,
    Thursday, Friday, Saturday, Sunday, or a weekend)?
-   Minimum, maximum, and average polarity of positive and negative
    words in the article
-   Number of words in the title and in the content

## Purpose

The purpose of this study is to summarize the data and to predict the
number of shares based on chosen aspects of interest.

## Workflow

The workflow includes:

-   Load data and split training/test set (70%/30%)
-   For each news channel:
    -   EDA on train set
    -   Train and select model with cross validation
    -   Compare model performance

The supervised learning algorithms we use to create models are linear
regression and ensemble models (random forests and boosted tree). We
also automate the generation of the analysis reports.

# Data

## Set up

### Packages

We will use the following packages in this project:

-   `here`: enables easy file referencing and builds file paths in a
    OS-independent way
-   `stats`: loads this before loading `tidyverse` to avoid masking some
    `tidyverse` functions
-   `tidyverse`: includes collections of useful packages like `dplyr`
    (data manipulation), `tidyr` (tidying data), `ggplots` (creating
    graphs), etc.
-   `lubridate`: handle date and datetime data type
-   `glue`: offers interpreted string literals for easy creation of
    dynamic messages and labels
-   `scales`: formats and labels scales nicely for better visualization
-   `skimr`: summary statistics about variables in data frames
-   `ggcorrplot`: correlation plot matrix
-   `caret`: training and plotting classification and regression models
-   `randomForest`: random forest algorithm for classification and
    regression.
-   `ranger`: a fast implementation of random forests
-   `gbm`: generalized boosted regression models

In addition, the `pacman` package provides handy tools to manage R
packages (install, update, load and unload). We use its `p_laod()`
instead of `libarary()` to load the packages listed above.

``` r
if (!require("pacman")) utils::install.packages("pacman", dependencies = TRUE)

pacman::p_load(
  here,
  stats,
  tidyverse,
  lubridate,
  glue, scales, skimr,
  ggcorrplot,
  caret, randomForest, ranger, gbm
)
```

### Helper Functions

We define a helper function `fit_model()` wrapping `caret::train()`.
This function trains models on training data set and test the model
performance on test data set.

> Arguments:
>
> -   `formula`: formula
> -   `df_train`: training set
> -   `df_test`: test set
> -   `method`: classification or regression model to use
> -   `preProcess`: pre-processing of the predictors
> -   `trControl`: a list of values that define how train acts
> -   `tuneGrid`: a data frame with possible tuning values
> -   `plot`: whether to plot parameter and metric
> -   `...`: arguments passed to the classification or regression
>     routine
>
> Returned Value: a performance metric (for a numeric response) or
> confusion matrix (for a categorical response)

In case a tuning parameter plot is needed, this function calls a helper
function `plot_modelinfo()` (defined below) to extract model information
including the tuning parameter and the corresponded metric to produce a
scatter plot.

``` r
# a wrapper function to train a model with train set and calculate the model performance on test set
fit_model <- function(
    formula, df_train, df_test, method, 
    preProcess = c("center", "scale"),
    trControl = trainControl(), 
    tuneGrid = NULL, 
    plot = FALSE, ... ){
  
  # timer - start
  proc_timer <- proc.time()
  
  # train model
  fit <- train(
    form = formula,
    data = df_train,
    method = method,
    preProcess = c("center", "scale"),
    trControl = trControl,
    tuneGrid = tuneGrid, ...)
  
  # timer - report time used
  print(proc.time() - proc_timer)
  
  # print the best tune if there is a tuning parameter
  if(is.null(tuneGrid)){
    print("No tuning parameter")
  } else {
    # print the best tune 
    print("The best tune is found with:")
    print(glue("\t{names(fit$bestTune)} = {fit$bestTune[1,]}"))
    if(plot) plot_modelinfo(fit)
  }
  
  # make prediction on test set
  pred <- predict(fit, newdata = df_test)
  
  # return performance metric or confusion matrix depending on response type
  if(is.numeric(pred)){
    # numeric response
    performance <- postResample(pred, obs = df_test[,1] %>% as_vector())
    # print performance metrics
    print("Performance metrics:")
    print(performance)
    
    # return the performance metric
    return(performance)
    
  } else if(is.factor(pred)){
    # categorical response
    cfm <- confusionMatrix(pred, df_test[,1] %>% as_vector())
    # print confusion matrix and accuracy
    print("Confusion table:")
    print(cfm$table)
    print(glue("Accuracy = {cfm$overall['Accuracy']}"))
    
    # return the confusion matrix
    return(cfm)
  }
}

# a helper function to plot the metric vs. the tuning parameter
plot_modelinfo <- function(fit){
  # get model info
  model <- fit$modelInfo$label
  parameter <- fit$modelInfo$parameters$parameter
  description <- fit$modelInfo$parameters$label
  
  # plot parameter vs metrics
  p <- fit$results %>% 
    rename_at(1, ~"x") %>% 
    pivot_longer(cols = -1, names_to = "Metric") %>% 
    ggplot(aes(x, value, color = Metric)) +
    geom_point() +
    geom_line() +
    facet_grid(rows = vars(Metric), scales = "free_y") +
    labs(
      title = glue("{model}: Hyperparameter Tuning"),
      x = glue("{parameter} ({description})")
    )
  print(p)
  return(p)
}
```

## Load and Prep Data

The data file is saved in the `data` folder. After reading the raw data,
we first check what variables it contains and if there is any missing or
NA data.

``` r
df_raw <- read_csv(here("data", "OnlineNewsPopularity.csv"))
```

    ## Rows: 39644 Columns: 61
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (1): url
    ## dbl (60): timedelta, n_tokens_title, n_tokens_content, n_unique_tokens, n_non_stop_words, n_non_stop_unique_tokens, num_hrefs...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# show the raw data
head(df_raw)
```

    ## # A tibble: 6 × 61
    ##   url        timedelta n_tokens_title n_tokens_content n_unique_tokens n_non_stop_words n_non_stop_uniq… num_hrefs num_self_hrefs
    ##   <chr>          <dbl>          <dbl>            <dbl>           <dbl>            <dbl>            <dbl>     <dbl>          <dbl>
    ## 1 http://ma…       731             12              219           0.664             1.00            0.815         4              2
    ## 2 http://ma…       731              9              255           0.605             1.00            0.792         3              1
    ## 3 http://ma…       731              9              211           0.575             1.00            0.664         3              1
    ## 4 http://ma…       731              9              531           0.504             1.00            0.666         9              0
    ## 5 http://ma…       731             13             1072           0.416             1.00            0.541        19             19
    ## 6 http://ma…       731             10              370           0.560             1.00            0.698         2              2
    ## # … with 52 more variables: num_imgs <dbl>, num_videos <dbl>, average_token_length <dbl>, num_keywords <dbl>,
    ## #   data_channel_is_lifestyle <dbl>, data_channel_is_entertainment <dbl>, data_channel_is_bus <dbl>,
    ## #   data_channel_is_socmed <dbl>, data_channel_is_tech <dbl>, data_channel_is_world <dbl>, kw_min_min <dbl>, kw_max_min <dbl>,
    ## #   kw_avg_min <dbl>, kw_min_max <dbl>, kw_max_max <dbl>, kw_avg_max <dbl>, kw_min_avg <dbl>, kw_max_avg <dbl>,
    ## #   kw_avg_avg <dbl>, self_reference_min_shares <dbl>, self_reference_max_shares <dbl>, self_reference_avg_sharess <dbl>,
    ## #   weekday_is_monday <dbl>, weekday_is_tuesday <dbl>, weekday_is_wednesday <dbl>, weekday_is_thursday <dbl>,
    ## #   weekday_is_friday <dbl>, weekday_is_saturday <dbl>, weekday_is_sunday <dbl>, is_weekend <dbl>, LDA_00 <dbl>, LDA_01 <dbl>, …

``` r
# check structure
str(df_raw)
```

    ## spec_tbl_df [39,644 × 61] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
    ##  $ url                          : chr [1:39644] "http://mashable.com/2013/01/07/amazon-instant-video-browser/" "http://mashable.com/2013/01/07/ap-samsung-sponsored-tweets/" "http://mashable.com/2013/01/07/apple-40-billion-app-downloads/" "http://mashable.com/2013/01/07/astronaut-notre-dame-bcs/" ...
    ##  $ timedelta                    : num [1:39644] 731 731 731 731 731 731 731 731 731 731 ...
    ##  $ n_tokens_title               : num [1:39644] 12 9 9 9 13 10 8 12 11 10 ...
    ##  $ n_tokens_content             : num [1:39644] 219 255 211 531 1072 ...
    ##  $ n_unique_tokens              : num [1:39644] 0.664 0.605 0.575 0.504 0.416 ...
    ##  $ n_non_stop_words             : num [1:39644] 1 1 1 1 1 ...
    ##  $ n_non_stop_unique_tokens     : num [1:39644] 0.815 0.792 0.664 0.666 0.541 ...
    ##  $ num_hrefs                    : num [1:39644] 4 3 3 9 19 2 21 20 2 4 ...
    ##  $ num_self_hrefs               : num [1:39644] 2 1 1 0 19 2 20 20 0 1 ...
    ##  $ num_imgs                     : num [1:39644] 1 1 1 1 20 0 20 20 0 1 ...
    ##  $ num_videos                   : num [1:39644] 0 0 0 0 0 0 0 0 0 1 ...
    ##  $ average_token_length         : num [1:39644] 4.68 4.91 4.39 4.4 4.68 ...
    ##  $ num_keywords                 : num [1:39644] 5 4 6 7 7 9 10 9 7 5 ...
    ##  $ data_channel_is_lifestyle    : num [1:39644] 0 0 0 0 0 0 1 0 0 0 ...
    ##  $ data_channel_is_entertainment: num [1:39644] 1 0 0 1 0 0 0 0 0 0 ...
    ##  $ data_channel_is_bus          : num [1:39644] 0 1 1 0 0 0 0 0 0 0 ...
    ##  $ data_channel_is_socmed       : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ data_channel_is_tech         : num [1:39644] 0 0 0 0 1 1 0 1 1 0 ...
    ##  $ data_channel_is_world        : num [1:39644] 0 0 0 0 0 0 0 0 0 1 ...
    ##  $ kw_min_min                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_max_min                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_avg_min                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_min_max                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_max_max                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_avg_max                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_min_avg                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_max_avg                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_avg_avg                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ self_reference_min_shares    : num [1:39644] 496 0 918 0 545 8500 545 545 0 0 ...
    ##  $ self_reference_max_shares    : num [1:39644] 496 0 918 0 16000 8500 16000 16000 0 0 ...
    ##  $ self_reference_avg_sharess   : num [1:39644] 496 0 918 0 3151 ...
    ##  $ weekday_is_monday            : num [1:39644] 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ weekday_is_tuesday           : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_wednesday         : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_thursday          : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_friday            : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_saturday          : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_sunday            : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_weekend                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ LDA_00                       : num [1:39644] 0.5003 0.7998 0.2178 0.0286 0.0286 ...
    ##  $ LDA_01                       : num [1:39644] 0.3783 0.05 0.0333 0.4193 0.0288 ...
    ##  $ LDA_02                       : num [1:39644] 0.04 0.0501 0.0334 0.4947 0.0286 ...
    ##  $ LDA_03                       : num [1:39644] 0.0413 0.0501 0.0333 0.0289 0.0286 ...
    ##  $ LDA_04                       : num [1:39644] 0.0401 0.05 0.6822 0.0286 0.8854 ...
    ##  $ global_subjectivity          : num [1:39644] 0.522 0.341 0.702 0.43 0.514 ...
    ##  $ global_sentiment_polarity    : num [1:39644] 0.0926 0.1489 0.3233 0.1007 0.281 ...
    ##  $ global_rate_positive_words   : num [1:39644] 0.0457 0.0431 0.0569 0.0414 0.0746 ...
    ##  $ global_rate_negative_words   : num [1:39644] 0.0137 0.01569 0.00948 0.02072 0.01213 ...
    ##  $ rate_positive_words          : num [1:39644] 0.769 0.733 0.857 0.667 0.86 ...
    ##  $ rate_negative_words          : num [1:39644] 0.231 0.267 0.143 0.333 0.14 ...
    ##  $ avg_positive_polarity        : num [1:39644] 0.379 0.287 0.496 0.386 0.411 ...
    ##  $ min_positive_polarity        : num [1:39644] 0.1 0.0333 0.1 0.1364 0.0333 ...
    ##  $ max_positive_polarity        : num [1:39644] 0.7 0.7 1 0.8 1 0.6 1 1 0.8 0.5 ...
    ##  $ avg_negative_polarity        : num [1:39644] -0.35 -0.119 -0.467 -0.37 -0.22 ...
    ##  $ min_negative_polarity        : num [1:39644] -0.6 -0.125 -0.8 -0.6 -0.5 -0.4 -0.5 -0.5 -0.125 -0.5 ...
    ##  $ max_negative_polarity        : num [1:39644] -0.2 -0.1 -0.133 -0.167 -0.05 ...
    ##  $ title_subjectivity           : num [1:39644] 0.5 0 0 0 0.455 ...
    ##  $ title_sentiment_polarity     : num [1:39644] -0.188 0 0 0 0.136 ...
    ##  $ abs_title_subjectivity       : num [1:39644] 0 0.5 0.5 0.5 0.0455 ...
    ##  $ abs_title_sentiment_polarity : num [1:39644] 0.188 0 0 0 0.136 ...
    ##  $ shares                       : num [1:39644] 593 711 1500 1200 505 855 556 891 3600 710 ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   url = col_character(),
    ##   ..   timedelta = col_double(),
    ##   ..   n_tokens_title = col_double(),
    ##   ..   n_tokens_content = col_double(),
    ##   ..   n_unique_tokens = col_double(),
    ##   ..   n_non_stop_words = col_double(),
    ##   ..   n_non_stop_unique_tokens = col_double(),
    ##   ..   num_hrefs = col_double(),
    ##   ..   num_self_hrefs = col_double(),
    ##   ..   num_imgs = col_double(),
    ##   ..   num_videos = col_double(),
    ##   ..   average_token_length = col_double(),
    ##   ..   num_keywords = col_double(),
    ##   ..   data_channel_is_lifestyle = col_double(),
    ##   ..   data_channel_is_entertainment = col_double(),
    ##   ..   data_channel_is_bus = col_double(),
    ##   ..   data_channel_is_socmed = col_double(),
    ##   ..   data_channel_is_tech = col_double(),
    ##   ..   data_channel_is_world = col_double(),
    ##   ..   kw_min_min = col_double(),
    ##   ..   kw_max_min = col_double(),
    ##   ..   kw_avg_min = col_double(),
    ##   ..   kw_min_max = col_double(),
    ##   ..   kw_max_max = col_double(),
    ##   ..   kw_avg_max = col_double(),
    ##   ..   kw_min_avg = col_double(),
    ##   ..   kw_max_avg = col_double(),
    ##   ..   kw_avg_avg = col_double(),
    ##   ..   self_reference_min_shares = col_double(),
    ##   ..   self_reference_max_shares = col_double(),
    ##   ..   self_reference_avg_sharess = col_double(),
    ##   ..   weekday_is_monday = col_double(),
    ##   ..   weekday_is_tuesday = col_double(),
    ##   ..   weekday_is_wednesday = col_double(),
    ##   ..   weekday_is_thursday = col_double(),
    ##   ..   weekday_is_friday = col_double(),
    ##   ..   weekday_is_saturday = col_double(),
    ##   ..   weekday_is_sunday = col_double(),
    ##   ..   is_weekend = col_double(),
    ##   ..   LDA_00 = col_double(),
    ##   ..   LDA_01 = col_double(),
    ##   ..   LDA_02 = col_double(),
    ##   ..   LDA_03 = col_double(),
    ##   ..   LDA_04 = col_double(),
    ##   ..   global_subjectivity = col_double(),
    ##   ..   global_sentiment_polarity = col_double(),
    ##   ..   global_rate_positive_words = col_double(),
    ##   ..   global_rate_negative_words = col_double(),
    ##   ..   rate_positive_words = col_double(),
    ##   ..   rate_negative_words = col_double(),
    ##   ..   avg_positive_polarity = col_double(),
    ##   ..   min_positive_polarity = col_double(),
    ##   ..   max_positive_polarity = col_double(),
    ##   ..   avg_negative_polarity = col_double(),
    ##   ..   min_negative_polarity = col_double(),
    ##   ..   max_negative_polarity = col_double(),
    ##   ..   title_subjectivity = col_double(),
    ##   ..   title_sentiment_polarity = col_double(),
    ##   ..   abs_title_subjectivity = col_double(),
    ##   ..   abs_title_sentiment_polarity = col_double(),
    ##   ..   shares = col_double()
    ##   .. )
    ##  - attr(*, "problems")=<externalptr>

``` r
# check if any missing values
anyNA(df_raw)
```

    ## [1] FALSE

First we check on the six `data_channel_is_*` columns with an one-way
table on the sum of their values for each row (record):

``` r
# create a count table on the sum of the six `data_channel_is_*` columns
tbl_channel_raw <- df_raw %>% 
  # deal with columns of interest only for computing efficiency
  select(starts_with("data_channel_is_")) %>% 
  mutate(sum_of_channels = rowSums(across(everything()))) %>% 
  select(sum_of_channels) %>% 
  # create an one-way table for counts
  table()

tbl_channel_raw
```

    ## sum_of_channels
    ##     0     1 
    ##  6134 33510

Among the 39644 record, 33510 records are from one of the 6 channels
(`lifestyle`, `entertainment`, `bus` for business, `socmed` for social
media, `tech` and `world`) and the other 6134 are from the other channel
(not included in these 6 channels). Therefore, we can create a new data
channel `misc` to label the.

Next, we will prepare the data with the following steps:

-   remove `url` and `timedelta` since we are not using them as
    predictors (non-predictive)
-   create a new column `data_channel_is_misc` for those records not
    from the 6 channels
-   convert the 7 `data_channel_is_*` columns (original 6 + newly
    created 1 in the last step) into a long-form column `channel`
-   convert the 7 `weekday_is_*` columns into a long-column `weekday`
-   remove the columns created in the intermediate steps
-   convert categorical variables `channel`, `weekday` and `is_weekend`
    to factors
-   move the response variable `shares` and the categorical predictors
    `channel`, `weekday` and `is_weekend` to the first columns for easy
    handling when analyzing models

``` r
df <- df_raw %>% 
  select(-url, -timedelta) %>% 
  mutate(
    sum_of_channels = rowSums(across(starts_with("data_channel_is_"))),
    # label records not from the 6 channels
    data_channel_is_misc = as.integer(sum_of_channels == 0)
  ) %>% 
  # pivot the channel columns (to a long form)
  pivot_longer(
    cols = starts_with("data_channel_is_"),
    names_to = "channel",
    names_prefix = "data_channel_is_",
    values_to = "channel_indicator"
  ) %>% 
  # pivot the channel columns (to a long form)
  pivot_longer(
    cols = starts_with("weekday_is_"),
    names_to = "weekday",
    names_prefix = "weekday_is_",
    values_to = "weekday_indicator"
  ) %>% 
  # remove redundant records
  filter(
    channel_indicator == 1,
    weekday_indicator == 1
  ) %>% 
  # remove redundant columns
  select(-sum_of_channels, -channel_indicator, -weekday_indicator) %>% 
  # convert categorical variables to factors
  mutate(
    channel = factor(channel),
    weekday = factor(weekday, levels = levels(wday(Sys.Date(), label = T, abbr = F)) %>% str_to_lower()),
    is_weekend = if_else(is_weekend == 1, "Y", "N") %>% factor()
  ) %>% 
  relocate(shares, channel, weekday, is_weekend)

# check numer of rows
nrow(df_raw) == nrow(df)
```

    ## [1] TRUE

``` r
# 2-way contingency table
table(df$channel, df$weekday)
```

    ##                
    ##                 sunday monday tuesday wednesday thursday friday saturday
    ##   bus              343   1153    1182      1271     1234    832      243
    ##   entertainment    536   1358    1285      1295     1231    972      380
    ##   lifestyle        210    322     334       388      358    305      182
    ##   misc             548    900    1111      1083     1102    966      424
    ##   socmed           137    337     458       416      463    332      180
    ##   tech             396   1235    1474      1417     1310    989      525
    ##   world            567   1356    1546      1565     1569   1305      519

Note that the data frame has the same number of rows with the raw data
frame, and it has 7 channels.

## Split the Data

We use `caret::createDataPartition()` to create a 70/30 split of
training and test sets. This is done with `set.seed()` to make this
analysis reproducible.

``` r
set.seed(2022)

# split data
trainIndex <- createDataPartition(df$shares, p = 0.7, list = F)
df_train <- df[trainIndex, ]
df_test <- df[-trainIndex, ]
```

Check if both train and test sets have similar cdf:

``` r
# check balance - compare ecdf of train and test sets
plot(ecdf(df_train$shares), col = "blue", main = "Empirical Cumulative Distribution", xlab = "shares")
plot(ecdf(df_test$shares), col = "red", add = T)
```

![](NCSU%20MS/ST558%20R%20Programming/Homework/ST558-Project2/images/intro/unnamed-chunk-10-1.png)<!-- -->
