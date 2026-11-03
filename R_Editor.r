## Load Packages
library(tidyverse)

## Access Data
df_raw <- read_csv("https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv")

## Helper: most frequent non-missing value (ties go to the first alphabetically, like pandas)
get_mode <- function(x) names(which.max(table(x)))

## Prepare Data
df <- df_raw %>% 
    mutate(across(where(is.numeric), ~ replace_na(.x, mean(.x, na.rm = TRUE))), 
        across(where(is.character), ~ replace_na(.x, get_mode(.x))), 
        DIFF = MORTDUE - VALUE, 
        LOAN_STATUS = case_match(BAD, 1 ~ "Default", 0 ~ "Repaid") ) %>% 
    rename_with(~ str_remove_all(tolower(.x), "_")) 


## Preview the data frame
print(head(df, 5))


## Write the data frame as a SAS data set in the WORK library
df2sd(df, 'work.homeequity_r')

# Create a string containing SAS code to connect to CAS,
# drop the global table if it exists, and load data to CAS

LoadToCAS <- "
* Connect to the CAS Server *;
cas mySession;

* Drop and load data to the CAS server *;
proc casutil;

    * Drop the global scope CAS table if it exists *;
    droptable casdata='homeequity_r' incaslib='casuser' quiet;

    * Send the SAS data set to CAS and promote the table *;
    load data=work.homeequity_r casout='homeequity_r' outcaslib='casuser' promote;

    * View in-memory CAS tables *;
    list tables;

quit;
"

# Submit the SAS code
submit(LoadToCAS)