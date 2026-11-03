/*******************************************************************************/
/*  Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/*  SPDX-License-Identifier: Apache-2.0                                        */
/*******************************************************************************/


* R code to access and prepare the data *;
proc r;
submit;

## Load Packages
library(tidyverse)

## Access Data
df_raw <- read_csv("https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv")

## Helper: most frequent non-missing value
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
df2sd(df, 'work.homeequity_procr')

endsubmit;
quit;


* Connect to the CAS Server *;
cas mySession;

* Drop and then load data to the CAS server *;
proc casutil;
	* Drop the global scope CAS table if it exists *;
	droptable casdata='homeequity_procr' incaslib="casuser" quiet;

	* Send the SAS data set to the CAS server and promote the table *;
	load data=work.homeequity_procr casout="homeequity_procr" outcaslib="casuser" promote;

	* View in-memory CAS tables *;
	list tables;
quit;

* Terminate the CAS connection *;
cas mySession terminate;
