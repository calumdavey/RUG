#**********************************************************************************************************
# WORKFLOW AND NOTES:
## 1. Inspect and save the raw data in a raw_data_excel

## 2. Transform each of the excel tabs I will use in CSV and file them. 
##    I normally file these under subdirectory calles raw_data_csv, but for now will save them in the working directory (note file location for csv)
##    I prefer changing to csv before importing because it is pretty easy and ensures consistency in the way characters are entered.  
##    I do this by clincking 'save as' and then chaning the format as CSV. Each tab or each file needs to be saved separately.

## 3. I dont' know how this data will be used... so I show two options
### a. Import and 'clean' for one file, and this can be repeated for the others. 
### b. Import and clean (as above and merge all at the end) - I do this with a function.

## Note: Although I use a functions, for these kind of tasks, I normally first load and clean each data separately
## or at least a larg proportion of the files, to see werhe the problesm could be. 

#**********************************************************************************************************
# MAIN CONCLUSIONS AFTER INSPECITON OF RAW DATA
## Files are all cross-tabulations. 
## for each file, the number of variables/categories should be equal to the number of rows, plus one row for 'Totals'. (so no column for totals)
## No missing data. Each cell with data has a numerical value. 
## Plenty of empty rows and columns
## The number of variables and/or catgories si not consitent accorss all the files/loctions. 

#**********************************************************************************************************
# LIBRARIES
library(tidyverse)
# Will use janitor once and will call it then. 

#**********************************************************************************************************
# LOAD A SINGLE FILE ####
#**********************************************************************************************************

# Load data
(data <- read_csv("location1.csv",
                 # skip the first rows and keep the column names
                 skip = 3, col_names = TRUE,
                 # make all the variables character
                 # I like to import everythign char unless I know there will be no typos
                 col_types = cols(.default = "c"))
)

# STEP 1
# Fix the vbl names and remove the column for propotions as those can be calculated later. 
# I prefer to use the given names and change them at the end after data merging if that is needed. 
(data1 <- data %>% 
  # This removes the proportion columns. 
  select(-starts_with("X")) %>% 
  # This is a quick fix for the names starting with numbers
  # I chose to remove the first col (X1) because I know after first inspection that the variable names should equate the row 'names'
  # I use janitor here because is less labour intensive.
  janitor::clean_names() %>% 
  # shortens the names a bit while keeping enough characters so there are no 2 cols with the same name (e.g. missing)
  set_names(., ~str_sub(.x, 1,7))
)

# STEP 2
# Now I Fix the rows that were imported with NA as those were empty. 
# Here need to be careful. could use 'complete.cases' (or janitor:: remove_empty) but in some cases the NA is displaced (cells merged) and replaced by '0'. 
# this means that I can't just remove rows that are not-complete. 
(data2 <- data1 %>% 
  mutate(na.per.row = rowSums(is.na(data1))) %>%
  # I could filter only those with one NA, but want to be conservative in case other daset have more problems here.
  # so, I keep onl those where the total na is half of the numbere of variables. 
  filter(na.per.row <= ncol(data1)/2) %>% 
  select(-na.per.row)
)

# STEP 3
# Add the column with the variables/categories. 
(data3 <- bind_cols(row.name = c("Count", names(data2), "total"), data2)
)

# ADDITIONAL 
# Here you can remove the 'count' and 'total' rows. and also change the NA for transgender from NA to '0'. 
# Here you can also change the names 
# If you do this for all 3 files and ensure names are consistent (even if you don't have the same columns for all files),
# you can use dplyr::bind_rows() to merge them all (assuming you want them stacked / long format).
#  When using bind_row  or bind_cols for this, I like to use the option '.id' so I get a variable indicating the dataset the data comes from.


#**********************************************************************************************************
# LOAD 3 FILES ####
#**********************************************************************************************************

# Using the same process I generate a function. 
# Note I did the above for al the individual files bu show only one. 
rm(list = ls())

# Store the name of the csv files to load. (change the path if you put them in a folder. For now they are in my wd)
files_list <- c("location1.csv",
                "location2.csv",
                "location3.csv")

# The function
load_data <- function(file) {
  data <- read_csv(file,
                   skip = 3, col_names = TRUE,
                   col_types = cols(.default = "c")) 
  
  data1 <- data %>% 
    select(-starts_with("X")) %>% 
    janitor::clean_names()
  
  data2 <- data1 %>% 
    mutate(na.per.row = rowSums(is.na(data1))) %>%
    filter(na.per.row <= ncol(data1)/2) %>% 
    select(-na.per.row)
  
  data3 <- bind_cols(row.name = c("count", names(data2), "total"), data2)
}

# This merges everyting in one dataset. the argumnt '.id' will indicate whre the data is comming from
data_all <- map_df(files_list, load_data, .id = "location")
# alternativelyy merge as a list and then see them with 'pluck'
data_all_l <- map(files_list, load_data)
# to see location 3, for example:
data_all_l %>% pluck(3) 


#**********************************************************************************************************
# HOUSEKEEPING? ####
#**********************************************************************************************************

# So, at this point, I rename the variables by column and row. 
# By inspection I know where the two variables named 'missing' and 'missing_1'  / just need to be careful there. 
# I'll work from the rectangular dta created in the prvious step

# Note: The following steps can be reduced but I prefer to 'see' them step by step at first. 

# STEP 1
# First I want to get rid of the 'count' and 'total' rows
data_all1 <- data_all %>% 
  filter(row.name!= "count" & row.name!= "total")

# STEP 2 ROW NAMES
# I normally want to work with establishin my vbl name sin a codebook. but also I find this an easier way... 
# I extract the names of all the variables form the variable 'row.name' because this will have all the variables even if it is repeated. 
# I want the unique values because I will use join and need unique 'keys' (key will be vbl name in this case)
row.vbls <- as.data.frame(unique(data_all1$row.name))
# Save this in an CSV
write_csv(row.vbls, path = "vbls_all.csv")
# Open the csv generated before put the new name next to each old name, then save as csv [not shown here]
# Load and print so 
row.vbls <- read_csv("vbls_all_new2.csv")
row.vbls
# Now that I have the old and the nw name I will merge this with my data
# I do a right_join instead of left because I want the first two rows to be printed on the left of the screen
(data_all2 <- right_join(row.vbls, data_all1, by = c("old.name" = "row.name")))
# I use 'view' and check that the match is ok
# I also check I still have 32 rows (no duplication occurred)

# STEP 2 COL NAMES
# Now that I checked that the re-name is OK I delet the col for old name. 
data_all3 <- data_all2 %>% select(-old.name)
# Extract the variable names and matche them with the new names
# Check that the number and the name is correct. See it preserved the order. 
(col.vbls <- as.data.frame(names(data_all3)) %>% 
  rename(old.name = "names(data_all3)") %>% 
  left_join(row.vbls)
)  
# Pull the names out as vector
col.vbls <- col.vbls %>% 
  filter(!is.na(new.name)) %>% 
  pull(new.name)
# Re-names
names(data_all3) <- c("new.name", "location", col.vbls)
(data_all4 <- data_all3 %>% 
  select(location, new.name,
         starts_with("age_"), 
         starts_with("sex"), 
         starts_with("ms"), 
         starts_with("wk"))
)
# Pending 1: fix the NA value for non-binary gender
# Pending 2: format the variable as numerical (not char)

#*****************************************************


