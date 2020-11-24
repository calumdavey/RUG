# I first transform each of the excel files/tabs I will use in CSV and file them. 
# I normally file these under subdirectory calles raw_data_csv, but for now will save them in the working directory (note file location for csv)
# I prefer changing to csv before importing because it is pretty easy and ensures consistency in the way characters are entered.  
# I do this by clincking 'save as' and then chaning the format as CSV. Each tab or each file needs to be saved separately.

# Load libraries
library(tidyverse)
library(janitor)

# Load the csv
data1 <- read_csv("referencetablesworkbook2.csv",
                 # skip the first rows and keep the column names
                 skip = 4, col_names = TRUE,
                 # make all the variables character or remove the code below for R to 'guess' though risky - in my view
                 col_types = cols(.default = "c")
                 # the code below selects the columns you wanted. 
                 )[ ,c(1:5,31:35)] %>% 
  janitor::clean_names() %>% 
  rename(cause     = "x1",
         sex       = "x2",
         geo.type  = "x3", 
         area.code = "x4",
         area.name = "x5") %>% 
  select(-x33)

head(data1)
# Then use filter or slice to get different subsets of info. 

