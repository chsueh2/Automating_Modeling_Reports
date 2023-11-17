# Automating Machine Learning Reports

Train supervised learning models with cross validation and automate report generation for summaries and predictions. 

Key features:

- Automation of Report Generation using R Markdown with YAML Parameters
- Supervised Learning
  - Linear Regression
  - Random Forests
  - Boosted Tree
- Cross Validation
- Model Selection


R packages used:

- `here`: enables easy file referencing and builds file paths in a OS-independent way
- `stats`: loads this before loading `tidyverse` to avoid masking some `tidyverse` functions
- `tidyverse`: includes collections of useful packages like `dplyr` (data manipulation), `tidyr` (tidying data), `ggplots` (creating graphs), etc.
- `lubridate`: handle date and datetime data type
- `glue`: offers interpreted string literals for easy creation of dynamic messages and labels
- `scales`: formats and labels scales nicely for better visualization
- `skimr`: summary statistics about variables in data frames
- `ggcorrplot`: correlation plot matrix
- `caret`: training and plotting classification and regression models
- `randomForest`: random forest algorithm for classification and regression.
- `ranger`: a fast implementation of random forests
- `gbm`: generalized boosted regression models

## Project Report

- [Introduction and Data Preparation](./output/Introduction_and_Data.md)
- [Analysis on Entertainment News Channel](./output/Analysis_on_Entertainment.md)
- [Analysis on Businiss News Channel](./output/Analysis_on_Bus.md)
- [Analysis on Lifestyle News Channel](./output/Analysis_on_Lifestyle.md)
- [Analysis on Misc News Channel](./output/Analysis_on_Misc.md)
- [Analysis on Social Media News Channel](./output/Analysis_on_Socmed.md)
- [Analysis on Technology News Channel](./output/Analysis_on_Tech.md)
- [Analysis on World News Channel](./output/Analysis_on_World.md)

The analysis results with all theoretical backgrounds and math derivations are included.

Chien-Lan Hsueh (chienlan.hsueh at gmail.com)

## Overview and Project Goal

The purpose of this study is to summarize the data and to predict the number of shares based on chosen aspects of interest. Several selected supervised learning algorithms are then used for prediction. The reports for each new channle are gernerated automatically.

## Data Source: Online News Popularity
This project is to study the [Online News Popularity data set](https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity) and create model for the predictions of the number of shares on a new article.

## Workflow

The workflow includes:

-   Load data and split training/test set (70%/30%)
-   For each news channel:
    -   EDA on train set
    -   Train and select model with cross validation
    -   Compare model performance

The supervised learning algorithms we use to create models are linear regression and ensemble models (random forests and boosted tree). We also automate the generation of the analysis reports.

## Automation of Report

The script used to automate the process of generating the reports: "render markdown.R".

### Introduction and Data

For the introduction and data preparation:
```
rmarkdown::render(
  here("_Rmd", "Introduction_and_Data.Rmd"), 
  output_format = github_document(html_preview = FALSE), 
  output_dir = here::here("output")
)
```


The body of Rmarkdown template for report "Introduction_and_Data.md":
````
```{r include=FALSE}
path <- here::here("images", "intro") %&% "/"
if(!file.exists(path)) dir.create(path)
knitr::opts_chunk$set(fig.path = path)
```

# Introduction
```{r, child="part 1 - introduction.Rmd"}
```

# Data
```{r, child="part 2 - data.Rmd"}
```

````


### Analysis Reports

For the analysis reports on each news channel:
```
# render analysis reports for each news channel
for(i in unique(df_train$channel)){
  filename <- "Analysis_on_" %&% str_to_title(i)

  rmarkdown::render(
    here("_Rmd", "Analysis.Rmd"), 
    output_format = github_document(html_preview = FALSE), 
    output_file = filename,
    output_dir = here::here("output"),
    params = list(channel = i, load_data = FALSE)
  )
}
```


The body of Rmarkdown template for report "Analysis_on_*.md":
````
```{r include=FALSE}
path <- here::here("images", params$channel) %&% "/"
if(!file.exists(path)) dir.create(path)

knitr::opts_chunk$set(fig.path = path)
```

This analysis report focuses on new channel: ``r params$channel``:
```{r}
# subset by channel
if(params$channel != "all"){
  df_train_x <- df_train %>% filter(channel == params$channel)
  df_test_x <- df_test %>% filter(channel == params$channel)
}
```

# Summarizations

```{r, child="part 3 - eda v2.Rmd"}
```

# Modeling

```{r, child="part 4 - model.Rmd"}
```
````