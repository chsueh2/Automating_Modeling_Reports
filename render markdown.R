# render markdown

# load packages
library(here)
library(rmarkdown)
library(knitr)
library(stringr)

# helper function: string concatenation (ex: "act" %&% "5")
'%&%' <- function(x, y) paste0(x, y)

knitr::opts_chunk$set(fig.path = "../images/")
str(knitr::opts_chunk$get())

# render 2: eda and modeling reports

# load data
knitr::knit(here("_Rmd", "part 2 - data.Rmd"), output = tempfile())

# render analysis report for each news channel
for(i in unique(df_train$channel)){
  filename <- "Analysis_on_" %&% str_to_title(i)
  print(filename)

  rmarkdown::render(
    here("_Rmd", "Analysis.Rmd"), 
    output_format = github_document(html_preview = FALSE), 
    output_file = filename,
    output_dir = here::here("output"),
    params = list(channel = i, load_data = FALSE)
  )
}



# render 1: introduction and data
rmarkdown::render(
  here("_Rmd", "Introduction_and_Data.Rmd"), 
  output_format = github_document(html_preview = FALSE), 
  output_dir = here::here("output")
)




# render 0: Readme
rmarkdown::render(
  here("_Rmd", "z plot.Rmd"), 
  output_format = github_document(html_preview = T), 
  #output_format = html_document(), 
  output_dir = here(output)
)
